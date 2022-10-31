provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
    address = var.vault_addr
    token = var.vault_token
#    namespace = var.vault_namespace #Uncomment if using HCP Vault
}

resource "vault_policy" "boundary-controller-policy" {
  name = "boundary-controller"
  
  policy = <<EOT
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

path "sys/leases/renew" {
  capabilities = ["update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

path "sys/capabilities-self" {
  capabilities = ["update"]
}

EOT
}

resource "vault_policy" "kv-policy" {
  name = "kv-read"
  
  policy = <<EOT
path "secret/data/my-secret" {
  capabilities = ["read"]
}

path "secret/data/my-app-secret" {
  capabilities = ["read"]
}

EOT
}

data "local_sensitive_file" "ssh_private_key" {
    filename = var.ssh_private_key_path
}

resource "vault_kv_secret_v2" "my-secret" {
  
  mount                      = "secret"
  name                       = "my-secret"
  data_json                  = jsonencode(
  {
    username       = "ubuntu",
    password       = data.local_sensitive_file.ssh_private_key.content
  }
  )
}

resource "vault_kv_secret_v2" "my-app-secret" {
  
  mount                      = "secret"
  name                       = "my-app-secret"
  data_json                  = jsonencode(
  {
    username       = "someuser",
    password       = "somepassword"
  }
  )
}

# resource "vault_token" "boundary_token" {
#  no_default_policy = true
# policies = ["boundary-controller", "kv-read"]
#  no_parent = true
#  renewable = true
#  ttl = "3600h"

#  renew_min_lease = 43200
#  renew_increment = 86400

#  metadata = {
#    "purpose" = "for-boundary-controller"
#  }
# }

