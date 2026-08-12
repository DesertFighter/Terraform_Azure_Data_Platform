terraform {
  required_version = ">= 1.12.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
  backend "azurerm" {
    use_cli          = true
    use_azuread_auth = true

    storage_account_name = "sttfdataso30emil"
    container_name       = "tfstate"
    key                  = "data-platform-dev.tfstate"
  }
}
