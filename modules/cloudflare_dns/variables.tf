variable "cloudflare_token" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
}

variable "hostname" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "ipv6_address" {
  type = string
}
