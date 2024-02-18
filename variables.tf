variable "hcloud_token" {
  sensitive = true
}

variable "app_name" { default = "wireguard" }
variable "wg_subnet_cidr" { default = "192.168.10.0/24" }
variable "http_username" { default = "wg" }

variable "datacenter" {}
variable "domain_name" {}
variable "image" {}
variable "secrets_path" {}
variable "server_name" {}
variable "server_type" {}
