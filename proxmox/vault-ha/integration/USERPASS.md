# Userpass auth

```sh
vault auth enable userpass

vault write auth/userpass/users/pi-vault-user \
    password=${USER_PASSWORD} \
    policies=developer,secret-read-only

vault login -method=userpass \
    username=pi-vault-user \
    password=${USER_PASSWORD}
```
