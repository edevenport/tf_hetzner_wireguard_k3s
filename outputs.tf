output "public_ip" {
  value = module.infrastructure.ipv4_address
}

output wg_server {
  value = "${local.wg_fqdn}:51820"
}

output wg_qrcode_url {
  value = "https://${local.conf_fqdn}/peer1.png"
}

output wg_config_url {
  value = "https://${local.conf_fqdn}/peer1.conf"
}

output http_username {
  value = var.http_username
}

output http_password {
  value     = random_password.caddy.result
  sensitive = true
}
