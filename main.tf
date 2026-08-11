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
