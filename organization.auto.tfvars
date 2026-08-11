entra_groups = {
  data_engineers = {
    display_name = "grp-data-engineers"
    description  = "Data engineers for the DEV data platform."
  }

  data_analysts = {
    display_name = "grp-data-analysts"
    description  = "Data analysts for the DEV data platform."
  }

  platform_admins = {
    display_name = "grp-data-platform-admins"
    description  = "Administrators for the DEV data platform."
  }
}
entra_users = {
  data_engineer = {
    display_name  = "Terraform Data Engineer"
    mail_nickname = "tf-data-engineer"
    group_key     = "data_engineers"
  }

  data_analyst = {
    display_name  = "Terraform Data Analyst"
    mail_nickname = "tf-data-analyst"
    group_key     = "data_analysts"
  }

  platform_admin = {
    display_name  = "Terraform Platform Admin"
    mail_nickname = "tf-platform-admin"
    group_key     = "platform_admins"
  }
}
