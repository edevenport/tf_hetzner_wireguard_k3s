# ------------------------------------------------------------------------------
# Data sources
# ------------------------------------------------------------------------------
data "cloudinit_config" "main" {
  part {
    content_type = "text/cloud-config"
    content = yamlencode(
      {
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
  wg_fqdn   = join(".", [var.wireguard_hostname, var.domain_name])
  conf_fqdn = join(".", [var.conf_hostname, var.domain_name])

  # Wireguard Kubernetes deployment manifest
  wg_deployment = templatefile("${path.module}/assets/wireguard.tpl", {
    app_name              = var.app_name
    wg_fqdn               = local.wg_fqdn
    wg_subnet_cidr        = var.wireguard_subnet_cidr
  })

  # Caddy webserver Kuberentes deployment manifest
  caddy_deployment = templatefile("${path.module}/assets/caddy.tpl", {
    app_name      = var.app_name
    conf_fqdn     = var.cloudflare_https ? "http://:80" : local.conf_fqdn
    http_password = random_password.caddy.bcrypt_hash
  })
}
