locals {
  resource_group_name = "rg-${var.application_name}-${var.environment_name}"
  common_tags = {
    project     = "Terraform Azure Data Paltform"
    environment = var.environment_name
    managed_by  = "Terraform"
  }
}
