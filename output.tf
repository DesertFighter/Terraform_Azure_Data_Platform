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
