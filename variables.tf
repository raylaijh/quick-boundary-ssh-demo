variable "boundary_addr" {
  type = string
}

variable "auth_method_id" {
  type = string
  default = "ampw_1234567890"
}

variable "auth_login_user" {
  type = string
  default = "admin"
}

variable "password_auth_method_login_name" {
  type = string
}

variable "password_auth_method_password" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "vault_addr" {
  type = string
}

variable "vault_token" {
  type = string
}

variable "vault_namespace" {
  type = string
  default = "admin"
}


variable "ssh_private_key_path" {
  type = string
}