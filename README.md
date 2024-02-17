# tf_hetzner_wireguard

## Description

Creates a server on Hetzner Online and deploys Wireguard.

## Usage

Example `terraform.tfvars`

```
hcloud_token = "API_TOKEN"
domain_name  = "mydomain.com"
datacenter   = "hil-dc1"
secret_path  = "/path/to/secrets"
```

Stores SSH keys in `secrets_path` and outputs URLs and credentials to the Wireguard client config.

## Notes

* Wireguard configuration may not survive a server reboot at this time.
