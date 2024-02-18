# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "ipv4_address" {
  value = hcloud_server.wireguard.ipv4_address
}

output "ipv6_address" {
  value = hcloud_server.wireguard.ipv6_address
}
