variable "app_name" {
  type    = string
  default = "wireguard"
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "cloudflare_https" {
  description = "Enable automatic DNS updates through Cloudflare; domain must already exist."
  type        = bool
  default     = false
}

variable "cloudflare_token" {
  description = "Cloudflare API token."
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name used for Wireguard and Cloudflare if enabled."
  type        = string
}

variable "image" {
  description = "Host image to use for server node."
  type        = string
  default     = "debian-12"
}

variable "wireguard_hostname" {
  description = "Hostname of Wireguard server."
  type        = string
  default     = "wg"
}

variable "conf_hostname" {
  description = "Hostname of URL where to retrieve Wireguard client config and QR code."
  type        = string
  default     = "config"
}

variable "http_username" {
  type    = string
  default = "wg"
}

variable "wireguard_subnet_cidr" {
  description = "Internal Wireguard subnet CIDR."
  type        = string
  default     = "192.168.10.0/24"
}

variable "datacenter" {}
variable "secrets_path" {}
variable "server_name" {}
variable "server_type" {}
