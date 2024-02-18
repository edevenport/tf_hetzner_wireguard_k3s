# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
variable "app_name" {
  type    = string
  default = "tf_hcloud"
}

variable "datacenter" {
  type = string
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "image" {
  type    = string
  default = "ubuntu-22.04"
}

variable "image_username" {
  type    = string
  default = "root"
}

variable "server_name" {
  type    = string
  default = "tf_node"
}

variable "server_type" {
  type    = string
  default = "cpx11"
}

variable "ssh_private_key" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type = string
}

variable "user_data" {
  type = string
}
