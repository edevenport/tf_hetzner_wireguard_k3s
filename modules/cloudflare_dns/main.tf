# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 1.7"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

# ------------------------------------------------------------------------------
# Data sources
# ------------------------------------------------------------------------------
data "cloudflare_zone" "domain" {
  name = var.domain_name
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "cloudflare_record" "ipv4" {
  zone_id         = data.cloudflare_zone.domain.id
  name            = var.hostname
  value           = var.ipv4_address
  proxied         = true
  type            = "A"
  ttl             = 1
  allow_overwrite = true
}

resource "cloudflare_record" "ipv6" {
  zone_id         = data.cloudflare_zone.domain.id
  name            = var.hostname
  value           = var.ipv6_address
  proxied         = true
  type            = "AAAA"
  ttl             = 1
  allow_overwrite = true
}
