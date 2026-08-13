/* Phase 3 

resource "azurerm_resource_group" "data_platform" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    project     = "Terraform Azure Data Platform"
    environment = "dev"
    managed_by  = "Terraform"
  }
}

*/

// Phase 4
resource "azurerm_resource_group" "data_platform" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}
//Phase 5

resource "azuread_group" "data_platform" {
  for_each = var.entra_groups

  display_name     = each.value.display_name
  description      = each.value.description
  security_enabled = true

  owners = [
    data.azuread_client_config.current.object_id
  ]
}
resource "azuread_user" "data_platform" {
  for_each = var.entra_users

  user_principal_name = "${each.value.mail_nickname}@${data.azuread_domains.tenant.domains[0].domain_name}"

  display_name  = each.value.display_name
  mail_nickname = each.value.mail_nickname

  password              = var.entra_user_password
  force_password_change = true
}
resource "azuread_group_member" "data_platform" {
  for_each = var.entra_users

  group_object_id = azuread_group.data_platform[
    each.value.group_key
  ].object_id

  member_object_id = azuread_user.data_platform[
    each.key
  ].object_id
}
# Phase 6 - Azure RBAC

resource "azurerm_role_assignment" "data_platform" {
  for_each = var.rbac_assignments

  scope = azurerm_resource_group.data_platform.id

  role_definition_name = each.value.role_definition_name

  principal_id = azuread_group.data_platform[
    each.value.group_key
  ].object_id

  principal_type = "Group"

  description = "Terraform ${each.value.role_definition_name} access for ${each.value.group_key} in ${var.environment_name}."
}
# ============================================================
# Phase 8 - Azure Key Vault and Sensitive Data
# ============================================================

resource "random_string" "key_vault_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}
resource "azurerm_key_vault" "data_platform" {
  name                       = "${var.key_vault_name_prefix}-${random_string.key_vault_suffix.result}"
  location                   = azurerm_resource_group.data_platform.location
  resource_group_name        = azurerm_resource_group.data_platform.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  tags                       = local.common_tags
}

# Phase 8 - Key Vault RBAC

resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_key_vault.data_platform.id
  role_definition_name = "Key Vault Secrets Officer"

  principal_id = azuread_group.data_platform[
    "platform_admins"
  ].object_id

  principal_type = "Group"
}
# Allow the identity running Terraform to manage Key Vault secrets

resource "azurerm_role_assignment" "current_user_key_vault_secrets_officer" {
  scope                = azurerm_key_vault.data_platform.id
  role_definition_name = "Key Vault Secrets Officer"

  principal_id   = data.azurerm_client_config.current.object_id
  principal_type = "User"
}
# ============================================================
# Phase 9 - Azure Data Lake Storage Gen2
# ============================================================

resource "random_string" "adls_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_storage_account" "data_lake" {
  name                = "${var.adls_storage_account_prefix}${random_string.adls_suffix.result}"
  resource_group_name = azurerm_resource_group.data_platform.name
  location            = azurerm_resource_group.data_platform.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  is_hns_enabled = true

  tags = local.common_tags
}
resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake" {
  for_each = var.adls_containers

  name               = each.value
  storage_account_id = azurerm_storage_account.data_lake.id
}
# ============================================================
# Phase 10 - Azure Data Factory
# ============================================================

resource "random_string" "adf_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}
resource "azurerm_data_factory" "data_platform" {
  name                = "${var.data_factory_name_prefix}-${random_string.adf_suffix.result}"
  location            = azurerm_resource_group.data_platform.location
  resource_group_name = azurerm_resource_group.data_platform.name
  # ============================================================
  # Phase 11 - ADF Managed Networking
  managed_virtual_network_enabled = true
  # ============================================================

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}
# Give ADF access to the ADLS account
resource "azurerm_role_assignment" "adf_adls_blob_contributor" {
  scope                = azurerm_storage_account.data_lake.id
  role_definition_name = "Storage Blob Data Contributor"

  principal_id   = azurerm_data_factory.data_platform.identity[0].principal_id
  principal_type = "ServicePrincipal"
}
# ============================================================
# Phase 11 - ADF Managed Networking
# ============================================================

resource "azurerm_data_factory_integration_runtime_azure" "managed_vnet" {
  name            = var.data_factory_integration_runtime_name
  data_factory_id = azurerm_data_factory.data_platform.id
  location        = "AutoResolve"

  virtual_network_enabled = true
}
resource "azurerm_data_factory_managed_private_endpoint" "adls_dfs" {
  name = var.adf_adls_private_endpoint_name

  data_factory_id = azurerm_data_factory.data_platform.id

  target_resource_id = azurerm_storage_account.data_lake.id

  subresource_name = "dfs"
}

# ============================================================
# Phase 12 - Azure SQL Database
# ============================================================

resource "random_string" "sql_suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_mssql_server" "data_platform" {
  name                = "${var.sql_server_name_prefix}-${random_string.sql_suffix.result}"
  resource_group_name = azurerm_resource_group.data_platform.name
  location            = azurerm_resource_group.data_platform.location

  version             = "12.0"
  minimum_tls_version = "1.2"

  public_network_access_enabled = true

  azuread_administrator {
    login_username              = azuread_group.data_platform["platform_admins"].display_name
    object_id                   = azuread_group.data_platform["platform_admins"].object_id
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = true
  }

  tags = local.common_tags
}

resource "azurerm_mssql_database" "data_platform" {
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.data_platform.id

  sku_name = "Basic"

  tags = local.common_tags
}

resource "azurerm_data_factory_managed_private_endpoint" "azure_sql" {
  name = var.adf_sql_private_endpoint_name

  data_factory_id = azurerm_data_factory.data_platform.id

  target_resource_id = azurerm_mssql_server.data_platform.id
  subresource_name   = "sqlServer"
}
