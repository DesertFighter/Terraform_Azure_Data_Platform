subscription_id  = "976fc750-3dbd-4d0d-916a-729e0f4d6845"
application_name = "data-platform"
environment_name = "dev"
location         = "West US"
owner            = "data-engineering"
rbac_assignments = {
  data_engineers_contributor = {
    group_key            = "data_engineers"
    role_definition_name = "Contributor"
  }

  data_analysts_reader = {
    group_key            = "data_analysts"
    role_definition_name = "Reader"
  }

  platform_admins_contributor = {
    group_key            = "platform_admins"
    role_definition_name = "Contributor"
  }

  platform_admins_rbac_admin = {
    group_key            = "platform_admins"
    role_definition_name = "Role Based Access Control Administrator"
  }
}
