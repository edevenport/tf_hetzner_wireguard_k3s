# ------------------------------------------------------------------------------
# Data sources
# ------------------------------------------------------------------------------
data "cloudinit_config" "wireguard_host" {
  part {
    content_type = "text/cloud-config"
    content      = yamlencode(
      {
        # "packages": ["podman"],
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
  length  = 16
  special = true
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
