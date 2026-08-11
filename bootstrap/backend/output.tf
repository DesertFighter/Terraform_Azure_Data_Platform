output "backend_resource_group_name" {
  value = azurerm_resource_group.terraform_backend.name
}

output "backend_storage_account_name" {
  value = azurerm_storage_account.terraform_backend.name
}

output "backend_container_name" {
  value = azurerm_storage_container.terraform_backend.name
}
