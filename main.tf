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

  role_definition_id = data.azurerm_role_definition.rbac[each.key].id

  principal_id = azuread_group.data_platform[
    each.value.group_key
  ].object_id

  principal_type = "Group"

  description = "Terraform ${each.value.role_definition_name} access for ${each.value.group_key} in ${var.environment_name}."
}
