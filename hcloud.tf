# ------------------------------------------------------------------------------
# Data sources
# ------------------------------------------------------------------------------
data "cloudinit_config" "cloud_config" {
  part {
    content_type = "text/cloud-config"
    content      = yamlencode(
      {
        "packages": ["podman"],
        "write_files": [
          {
            "path": "/var/lib/rancher/k3s/server/manifests/wireguard.yaml",
            "content": "${local.wg_deployment}",
            "permissions": "0600"
          },
          {
            "path": "/var/lib/rancher/k3s/server/manifests/caddy.yaml",
            "content": "${local.caddy_deployment}",
            "permissions": "0600"
          },
        ],
        "runcmd": [
          "curl -sfL https://get.k3s.io | sh -s - --disable=traefik",
          "echo 'alias k=kubectl' >> /root/.bashrc",
          "echo 'source <(kubectl completion bash)' >> /root/.bashrc",
          "echo 'complete -o default -F __start_kubectl k' >> /root/.bashrc"
        ]
      }
    )
  }
}

# ------------------------------------------------------------------------------
# Resources
# ------------------------------------------------------------------------------
resource "random_password" "caddy" {
  length           = 16
  special          = true
}

resource "hcloud_ssh_key" "default" {
  name       = "wireguard-server"
  public_key = module.ssh_keygen.public_key
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
  user_data    = data.cloudinit_config.cloud_config.rendered
  ssh_keys     = [ hcloud_ssh_key.default.name ]
  firewall_ids = [hcloud_firewall.wireguard.id]

  labels = {
    "app" : "wireguard"
  }

  connection {
    type        = "ssh"
    user        = var.image_username
    host        = hcloud_server.wireguard.ipv4_address
    private_key = module.ssh_keygen.private_key
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]
  }
}

# ------------------------------------------------------------------------------
# Local variables
# ------------------------------------------------------------------------------
locals {
  wg_netmask_bits = split("/", var.wg_subnet_cidr)[1]

  # Wireguard Kubernetes deployment manifest
  wg_deployment = templatefile("${path.module}/assets/wireguard.tpl", {
    app_name       = var.app_name
    domain_name    = var.domain_name
    wg_subnet_cidr = var.wg_subnet_cidr
  })

  # Caddy webserver Kuberentes deployment manifest
  caddy_deployment = templatefile("${path.module}/assets/caddy.tpl", {
    app_name      = var.app_name
    domain_name   = var.domain_name
    http_password = random_password.caddy.bcrypt_hash
  })
}
