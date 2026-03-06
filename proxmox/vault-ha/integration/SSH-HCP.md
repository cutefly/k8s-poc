# Vault

## Signed SSH certificates

> https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates

### Signing key & role configuration

```
vault secrets enable -path=ssh-client-signer ssh
vault write ssh-client-signer/config/ca generate_signing_key=true

curl -o /etc/ssh/trusted-user-ca-keys.pem https://vault.club012.com/v1/ssh-client-signer/public_key

$ vault write ssh-client-signer/roles/ssh-client-role -<<"EOH"
{
  "algorithm_signer": "rsa-sha2-256",
  "allow_user_certificates": true,
  "allowed_users": "*",
  "allowed_extensions": "permit-pty,permit-port-forwarding",
  "default_extensions": {
    "permit-pty": ""
  },
  "key_type": "ca",
  "default_user": "ubuntu",
  "ttl": "30m0s"
}
EOH
```

### Client SSH authentication

```
vault write ssh-client-signer/sign/ssh-client-role \
    public_key=@$HOME/.ssh/id_rsa.pub
Key              Value
---              -----
serial_number    b4313d72ede16850
signed_key       ********

vault write -field=signed_key ssh-client-signer/sign/ssh-client-role \
    public_key=@$HOME/.ssh/id_rsa.pub > signed-cert.pub

ssh -i signed-cert.pub -i ~/.ssh/id_rsa pi@192.168.219.98
```

# Host key signing

```
vault secrets enable -path=ssh-host-signer ssh

vault write ssh-host-signer/config/ca generate_signing_key=true

vault secrets tune -max-lease-ttl=87600h ssh-host-signer

vault write ssh-host-signer/roles/ssh-host-role \
    key_type=ca \
    algorithm_signer=rsa-sha2-256 \
    ttl=87600h \
    allow_host_certificates=true \
    allowed_domains="localdomain,club012.com" \
    allow_subdomains=true

```
