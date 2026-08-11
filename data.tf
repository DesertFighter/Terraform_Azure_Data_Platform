data "azurerm_client_config" "current" {

}
data "azuread_client_config" "current" {

}
data "azuread_domains" "tenant" {
  only_initial = true
}
data "azurerm_role_definition" "rbac" {
  for_each = var.rbac_assignments

  name = each.value.role_definition_name
}
