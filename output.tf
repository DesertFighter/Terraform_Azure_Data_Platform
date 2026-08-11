output "resource_group_name" {
  value = azurerm_resource_group.data_platform.name
}
output "resource_group_location" {
  value = azurerm_resource_group.data_platform.location
}
output "resource_group_id" {
  value = azurerm_resource_group.data_platform.id

}
output "environment_name" {
  value = var.environment_name
}

output "calculated_resource_group_name" {
  value = local.resource_group_name
}

output "owner" {
  value = var.owner
}
output "entra_group_ids" {
  value = {
    for key, group in azuread_group.data_platform :
    key => group.object_id
  }
}
output "entra_user_upns" {
  value = {
    for key, user in azuread_user.data_platform :
    key => user.user_principal_name
  }
}
output "entra_user_ids" {
  value = {
    for key, user in azuread_user.data_platform :
    key => user.object_id
  }
}
//Phase 6
output "rbac_assignments" {
  value = {
    for key, assignment in azurerm_role_assignment.data_platform :
    key => {
      principal_id       = assignment.principal_id
      role_definition_id = assignment.role_definition_id
      scope              = assignment.scope
    }
  }
}
