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
