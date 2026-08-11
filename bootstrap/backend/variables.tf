variable "subscription_id" {
  description = "Azure subscription where Terraform backend infrastructure will be created."
  type        = string
}

variable "backend_resource_group_name" {
  description = "Resource group dedicated to Terraform remote state."
  type        = string
}

variable "backend_location" {
  description = "Azure region for the Terraform backend."
  type        = string
}

variable "backend_storage_account_prefix" {
  description = "Prefix used to construct the globally unique backend storage account name."
  type        = string
}

variable "backend_container_name" {
  description = "Blob container used to store Terraform state."
  type        = string
}
