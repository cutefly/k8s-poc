# Userpass auth

```sh
vault auth enable userpass

vault write auth/userpass/users/pi-vault-user \
    password=${uer_password} \
    policies=developer

vault login -method=userpass \
    username=pi-vault-user \
    password=${uer_password}
```
