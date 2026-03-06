
# postgreSQL with vault

> https://developer.hashicorp.com/vault/docs/secrets/databases/postgresql

## database 설정


```sql
-- create admin user
CREATE USER vault_admin WITH SUPERUSER PASSWORD '${VAULT_ADMIN_PASSWORD}';

-- 데이터베이스 생성(생성된 user가 접속할 데이터베이스)
create user vault_user password '${VAULT_USER_PASSWORD}';
create database vault_db owner vault_user;
```

## secret 생성

```sh
vault secrets enable database

vault write database/config/db-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="db-postgresql-role" \
    connection_url="postgresql://{{username}}:{{password}}@db.club012.com:5432/vault_db" \
    username="vault_admin" \
    password="${VAULT_ADMIN_PASSWORD}" \
    password_authentication="scram-sha-256"

vault write database/roles/db-postgresql-role \
    db_name="db-postgresql-database" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
         GRANT ALL ON SCHEMA public TO \"{{name}}\";" \
    revocation_statements="REVOKE ALL PRIVILEGES ON SCHEMA public FROM \"{{name}}\"; \
         DROP OWNED BY \"{{name}}\"; \
         DROP ROLE \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"

# 패스워드 규칙 적용
$ vault write database/config/db-postgresql-database password_policy="database"

$ vault read database/creds/db-postgresql-role
```

## vibe_db credential

```sh
vault write database/config/vibe-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="vibe-postgresql-role" \
    connection_url="postgresql://{{username}}:{{password}}@db.club012.com:5432/vibe_db" \
    username="vault_admin" \
    password="${VAULT_ADMIN_PASSWORD}" \
    password_authentication="scram-sha-256"

vault write database/roles/vibe-postgresql-role \
    db_name="vibe-postgresql-database" \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
         GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    revocation_statements="REVOKE ALL PRIVILEGES ON SCHEMA public FROM \"{{name}}\"; DROP OWNED BY \"{{name}}\"; DROP ROLE \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"

# 패스워드 규칙 적용
$ vault write database/config/vibe-postgresql-database password_policy="database"

$ vault read database/creds/vibe-postgresql-role
```
