# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 1.7"
}

provider "hcloud" {
  token = var.hcloud_token
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "hcloud_ssh_key" "default" {
  name       = "wireguard-server"
  public_key = var.ssh_public_key
}

resource "hcloud_firewall" "wireguard" {
  name = "wireguard-fw"

  # Allow incoming ICMP (ping, etc.)
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Allow incoming SSH
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Allow incoming HTTP
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Allow incoming HTTPS
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # Allow incoming Wireguard connections
  rule {
    direction = "in"
    protocol  = "udp"
    port      = "51820"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_server" "wireguard" {
  name         = var.server_name
  image        = var.image
  server_type  = var.server_type
  datacenter   = var.datacenter
  user_data    = var.user_data
  ssh_keys     = [ hcloud_ssh_key.default.name ]
  firewall_ids = [hcloud_firewall.wireguard.id]

  labels = {
    "app" : var.app_name
  }

  connection {
    type        = "ssh"
    user        = var.image_username
    host        = hcloud_server.wireguard.ipv4_address
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }
}
