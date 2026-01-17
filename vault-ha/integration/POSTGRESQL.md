
# postgreSQL with vault

> https://developer.hashicorp.com/vault/docs/secrets/databases/postgresql

## database 설정


```sql
-- create admin user
CREATE USER vault_admin WITH SUPERUSER PASSWORD '${admin_password}';

-- 데이터베이스 생성(생성된 user가 접속할 데이터베이스)
create user vault_user password '${vault_password}';
create database vault_db owner vault_user;
```

## secret 생성

```sh
vault secrets enable database

vault write database/config/k3s-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="k3s-postgresql-role" \
    connection_url="postgresql://{{username}}:{{password}}@k3s.club012.com:5432/vault_db" \
    username="vault_admin" \
    password="${admin_password}" \
    password_authentication="scram-sha-256"

vault write database/roles/k3s-postgresql-role \
    db_name="k3s-postgresql-database" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
         GRANT ALL ON SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"

# 패스워드 규칙 적용
$ vault write database/config/k3s-postgresql-database password_policy="database"

$ vault read database/creds/k3s-postgresql-role
```
