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

