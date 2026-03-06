# AppRole for applicatino

## enable approle

```sh
# enable approle
$ vault auth enable approle

# create approle pi-vault-app
$ vault write auth/approle/role/pi-vault-app \
  secret_id_ttl=10m \
  token_ttl=20m \
  token_max_ttl=30m \
  token_policies="secret-read-only"

# get role-id
$ vault read auth/approle/role/pi-vault-app/role-id
Key        Value
---        -----
role_id    8ef66e56-3263-7052-82ec-f4ea2e0d156b

# create secret-id
$ vault write -force auth/approle/role/pi-vault-app/secret-id
Key                   Value
---                   -----
secret_id             ********
secret_id_accessor    3bbb2761-1601-95e1-3907-d2e169e648b1
secret_id_num_uses    0
secret_id_ttl         0s

# create token cli
$ vault write auth/approle/login role_id="${APPROLE_ROLE_ID}" secret_id="${APPROLE_SECRET_ID}"
Key                     Value
---                     -----
token                   ********
token_accessor          GQXvWOmIHDPdHlkIW48jtbtC
token_duration          768h
token_renewable         true
token_policies          ["default" "secret-read-only"]
identity_policies       []
policies                ["default" "secret-read-only"]
token_meta_role_name    pi-vault-app

# create token api
$ curl -s --request POST \
    --data "{\"role_id\":\"${APPROLE_ROLE_ID}\",\"secret_id\":\"${APPROLE_SECRET_ID}\"}" \
    ${VAULT_ADDR}/v1/auth/approle/login

$ curl --header "X-Vault-Token: ${APPROLE_TOKEN}" https://vault.club012.com/v1/secret/data/vault-secret/local
```
