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
