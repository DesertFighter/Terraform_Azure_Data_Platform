subscription_id   = "976fc750-3dbd-4d0d-916a-729e0f4d6845"
application_name  = "data-platform"
environment_name  = "dev"
location          = "West US"
demo_secret_value = "MyTerraformSecret123!"
owner             = "data-engineering"
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
key_vault_name_prefix = "kv-dp-dev"
# ============================================================
# Phase 9 - Azure Data Lake Storage Gen2
# ============================================================

adls_storage_account_prefix = "stdp"

adls_containers = [
  "raw",
  "processed"
]
# ============================================================
# Phase 10 - Azure Data Factory
# ============================================================

data_factory_name_prefix = "adf-dp-dev"
# ============================================================
# Phase 11 - ADF Managed Networking
# ============================================================

data_factory_integration_runtime_name = "ir-adf-managed-vnet-dev"

adf_adls_private_endpoint_name = "mpe-adf-adls-dfs-dev"
