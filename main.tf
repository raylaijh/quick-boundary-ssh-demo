provider "boundary" {
  addr                            = var.boundary_addr
  auth_method_id                  = var.auth_method_id
  password_auth_method_login_name = var.password_auth_method_login_name
  password_auth_method_password   = var.password_auth_method_password
}


resource "boundary_scope" "org" {
  scope_id                 = "global"
  name                     = "IT_Support"
  description              = "IT Support Team"
  auto_create_default_role = true
  auto_create_admin_role   = true
}


resource "boundary_scope" "project" {
  name             = "QA_Tests"
  description      = "Manage QA machines"

  # scope_id is taken from the org resource defined for 'IT_Support'
  scope_id                 = boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_host_catalog_static" "devops" {
  name        = "SSH"
  description = "For SSH boundary project"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "ubuntu" {
  name            = "ubuntu"
  description     = "Ubuntu host"
  address         = var.host_ip
  host_catalog_id = boundary_host_catalog_static.devops.id
}

resource "boundary_host_set_static" "ubuntu-machines" {
  name            = "ubuntu-machines"
  description     = "Host set for ubuntu"
  host_catalog_id = boundary_host_catalog_static.devops.id
  host_ids = [
      boundary_host_static.ubuntu.id
  ]
}

resource "boundary_target" "ubuntu" {
  type                     = "tcp"
  name                     = "ubuntu"
  description              = "Ubuntu target"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.ubuntu-machines.id
  ]

    brokered_credential_source_ids = [
    boundary_credential_library_vault.cred_lib_app.id,

  ]
#injected_application_credential_source_ids = [
#    boundary_credential_library_vault.cred_lib_ssh.id
#  ]

}

resource "vault_token" "boundary_token" {

no_default_policy = true
policies = ["boundary-controller", "kv-read"]
 no_parent = true
 renewable = true
 period = "3600h"

 renew_min_lease = 43200
 renew_increment = 86400

 metadata = {
   "purpose" = "for-boundary-controller"
 }
}

resource "boundary_credential_store_vault" "vault" {
  name        = "vault"
  address     = var.vault_addr     # change to Vault address
  token       = vault_token.boundary_token.client_token 
  scope_id    = boundary_scope.project.id
  namespace   = var.vault_namespace
}

resource "boundary_credential_library_vault" "cred_lib_ssh" {
  name                = "vault-cred-library"
  credential_type     = "ssh_private_key"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "secret/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  
}

resource "boundary_credential_library_vault" "cred_lib_app" {
  name                = "vault-app-library"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "secret/data/my-secret" # change to Vault backend path
  http_method         = "GET"
  credential_type     = "username_password"
  
}

