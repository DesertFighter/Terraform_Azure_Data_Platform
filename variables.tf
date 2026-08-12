variable "subscription_id" {
  type = string

}

variable "location" {
  description = "Azure region where resources will be deployed."

  type = string
}
variable "application_name" {
  description = "Short danme of the application/platform"
  type        = string
  validation {
    condition     = length(trimspace(var.application_name)) >= 3
    error_message = "application_name must contain at least 3 characters."
  }
}
variable "environment_name" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], lower(var.environment_name))
    error_message = "environment_name must be dev, test, or prod."
  }

}
variable "owner" {
  description = "Owner value used for the variable precedence lab."
  type        = string
  default     = "data-engineering"
}
variable "entra_groups" {
  description = "Microsoft Entra ID security groups used by the data platform."
  type = map(object({
    display_name = string
    description  = string
  }))
}

variable "entra_users" {
  description = "Microsoft Entra ID lab users and their group assignments."

  type = map(object({
    display_name  = string
    mail_nickname = string
    group_key     = string
  }))
}
variable "entra_user_password" {
  description = "Initial password used when creating the Terraform lab Entra ID users."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.entra_user_password) >= 12
    error_message = "entra_user_password must contain at least 12 characters."
  }
}
variable "rbac_assignments" {
  description = "Azure RBAC assignments for the current environment."

  type = map(object({
    group_key            = string
    role_definition_name = string
  }))
}
# Phase 8 - Azure Key Vault

variable "key_vault_name_prefix" {
  description = "Prefix used to construct the environment-specific Azure Key Vault name."
  type        = string
}
variable "demo_secret_value" {
  description = "Demo secret used to learn Terraform sensitive data handling."
  type        = string
  sensitive   = true
}
resource "azurerm_key_vault_secret" "demo" {
  name         = "demo-secret"
  value        = var.demo_secret_value
  key_vault_id = azurerm_key_vault.data_platform.id
  depends_on = [
    azurerm_role_assignment.current_user_key_vault_secrets_officer
  ]
}
# ============================================================
# Phase 9 - Azure Data Lake Storage Gen2
# ============================================================

variable "adls_storage_account_prefix" {
  description = "Prefix used to create the ADLS Gen2 storage account name."
  type        = string
}

variable "adls_containers" {
  description = "ADLS Gen2 filesystems used by the data platform."
  type        = set(string)
}
