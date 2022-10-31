# Terraform Code: HashiCorp Boundary simple and quick SSH setup

This set of Terraform code is meant to quickly setup a simple Boundary demo with an SSH server. \

Setup is based on [HashiCorp Boundary Learn Guide](https://developer.hashicorp.com/boundary/tutorials/hcp-administration/hcp-ssh-cred-injection?in=boundary%2Fhcp-administration)

## Requirements

1. SSH server 
2. Boundary cluster (Can be HCP Boundary)
3. Vault cluser (Can be HCP Vault)
4. Terminal with Vault and Boundary CLI installed (Tested with Boundary v0.11.0 and Vault v.1.11.2)

## Example usage

Fill up the relevant values in terraform.tfvars
```hcl
boundary_addr= "http://127.0.0.1:9200" #can be HCP Boundary
host_ip= "1.1.1.1" #IP of SSH server
auth_method_id = "ampw_1234567890"
password_auth_method_login_name = "admin"
password_auth_method_password = "password"
vault_addr = "http://127.0.0.1:8200" #can be HCP Vault
vault_token = "root"
ssh_private_key_path = "/Users/raymond/.ssh/id_rsa"
```

For HCP Vault (or Vault Enterprise which has namespaces configured), uncomment namespace line in vault.tf

Use Terraform to perform the setup
```
terraform init
terraform apply -auto-approve
```

## Output

The relevant output instructions will allow you to use Boundary to ssh into the target host

```
Follow the steps on your terminal to start testing:

1. export BOUNDARY_ADDR = http://127.0.0.1:9200
2. boundary authenticate password -auth-method-id ampw_1234567890 -login-name admin 
2. boundary connect ssh -target-id ttcp_JlTmSGlwg2
```