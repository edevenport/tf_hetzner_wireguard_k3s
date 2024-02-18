# tf_hetzner_wireguard

## Description

Creates a server on Hetzner Cloud and deploys Wireguard on K3s.

## Usage

Example `terraform.tfvars`:

```
# App name used for labels
app_name = "wireguard"

# Domain for Wireguard client config URL
domain_name = "wg.domain.com"

# Wireguard internal network
wg_subnet_cidr = "192.168.10.0/24"

# Server variables
server_name = "wireguard"
server_type = "cpx11"
image       = "ubuntu-22.04"
datacenter  = "hil-dc1"

# Path variables
secrets_path = "./secrets"
```

Stores SSH keys in `secrets_path` and outputs URLs and HTTP credentials to the Wireguard client config.

## TODO

* Add Cloudflare resource to automatically add returned IP to DNS record.
* Add an indicator  when backend setup is complete and URL is accessible.
* Set better default variable values along with documentation.
