variable "hcloud_token" {
  sensitive = true
}

variable "app_name" { default = "wireguard" }
variable "wg_subnet_cidr" { default = "192.168.10.0/24" }
variable "server_name" { default = "wireguard" }
variable "server_type" { default = "cpx11" }
variable "image" { default = "ubuntu-22.04" }
variable "image_username" { default = "root" }
variable "http_username" { default = "wg" }

variable "datacenter" {}
variable "secrets_path" {}
variable "domain_name" {}
