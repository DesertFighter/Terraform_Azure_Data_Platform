data "azurerm_client_config" "current" {

}
data "azuread_client_config" "current" {

}
data "azuread_domains" "tenant" {
  only_initial = true
}
