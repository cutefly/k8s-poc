# MySQL with vault

> https://developer.hashicorp.com/vault/docs/secrets/databases/mysql-maria

## database 생성

```sql
-- Create Admin(user를 생성할 admin 계정)
-- Create User
CREATE USER 'vault_admin'@'%' IDENTIFIED BY '${VAULT_ADMIN_PASSWORD}';
-- Full Admin
GRANT ALL PRIVILEGES ON *.* TO 'vault_admin'@'%' WITH GRANT OPTION;
-- Check Grants	
SHOW GRANTS FOR 'vault_admin'@'%';
```

```sql
-- 데이터베이스 생성(생성된 user가 접속할 데이터베이스)
CREATE DATABASE vault_db;
-- 아이디 생성
CREATE USER 'vault_user'@'%' IDENTIFIED BY '${VAULT_USER_PASSWORD}';
-- 사용자 권한 주기
GRANT ALL PRIVILEGES ON vault_db.* TO 'vault_user'@'%';
-- 새로고침
FLUSH PRIVILEGES;
```

## database secret 생성

```sh
vault secrets enable -description="database credential store" database
vault secrets tune -description="database credential store" database # change description

vault write database/config/db-mysql-database \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(db.club012.com:3306)/" \
    allowed_roles="db-mysql-role" \
    username="vault_admin" \
    password="${VAULT_ADMIN_PASSWORD}"

vault write database/roles/db-mysql-role \
    db_name=db-mysql-database \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON vault_db.* TO '{{name}}'@'%';" \
    default_ttl="1h" \
    max_ttl="24h"

# 패스워드 규칙 적용
$ vault write database/config/db-mysql-database password_policy="database"

vault read database/creds/db-mysql-role
```

## password policy

> https://developer.hashicorp.com/vault/tutorials/db-credentials/password-policies?productSlug=vault&tutorialSlug=policies&tutorialSlug=password-policies

```sh
$ tee database_policy.hcl <<EOF
length=20

rule "charset" {
  charset = "abcdefghijklmnopqrstuvwxyz"
  min-chars = 1
}

rule "charset" {
  charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  min-chars = 1
}

rule "charset" {
  charset = "0123456789"
  min-chars = 1
}

rule "charset" {
  charset = "!@#$%^&*"
  min-chars = 1
}
EOF

$ vault write sys/policies/password/database policy=@database_policy.hcl

$ vault read sys/policies/password/database

# 패스워드 생성
$ vault read sys/policies/password/database/generate

$ vault read database/config/db-mysql-database
Key                                   Value
---                                   -----
allowed_roles                         [db-mysql-role]
password_policy                       n/a

$ vault write database/config/db-mysql-database password_policy="database"

$ vault read database/config/db-mysql-database
Key                                   Value
---                                   -----
password_policy                       database

$ vault read database/creds/db-mysql-role
```
