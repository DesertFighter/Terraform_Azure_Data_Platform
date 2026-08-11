resource "random_string" "storage_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "terraform_backend" {
  name     = var.backend_resource_group_name
  location = var.backend_location

  tags = {
    purpose    = "terraform-remote-state"
    managed_by = "Terraform"
  }
}

resource "azurerm_storage_account" "terraform_backend" {
  name = "${var.backend_storage_account_prefix}${random_string.storage_suffix.result}"

  resource_group_name      = azurerm_resource_group.terraform_backend.name
  location                 = azurerm_resource_group.terraform_backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version            = "TLS1_2"
  https_traffic_only_enabled = true

  tags = {
    purpose    = "terraform-remote-state"
    managed_by = "Terraform"
  }
}

resource "azurerm_storage_container" "terraform_backend" {
  name                  = var.backend_container_name
  storage_account_id    = azurerm_storage_account.terraform_backend.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "terraform_backend" {
  scope                = azurerm_storage_container.terraform_backend.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "User"
}
