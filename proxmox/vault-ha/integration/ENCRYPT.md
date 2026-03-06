# Encrypt Spring application data with Vault

> https://developer.hashicorp.com/vault/tutorials/app-integration/eaas-spring-demo

## 데이터베이스 준비

```sql
-- postgres(admin권한)으로 실행

-- 리소스 생성 절차(Simple)
-- 1. Create a User
CREATE USER pay_user WITH PASSWORD '${pay_password}';

-- 2. Create a Database
CREATE DATABASE payments OWNER pay_user;

-- 3. Grant Permissions
GRANT CONNECT ON DATABASE payments TO pay_user;
GRANT USAGE, CREATE ON SCHEMA public TO pay_user;

-- 테이블 생성
set time zone 'UTC';
create extension if not exists pgcrypto;

CREATE TABLE if not exists payments
(
    id              VARCHAR(255) PRIMARY KEY NOT NULL,
    name            VARCHAR(255)             NOT NULL,
    cc_info         VARCHAR(255)             NOT NULL,
    created_at      TIMESTAMP                NOT NULL
);
```

## Vault key 생성

```sh
# transit secret 생성
vault secrets enable transit

# payments key 생성
vault write -f transit/keys/payments
vault read transit/keys/payments
```

## Vault token 생성

```
vault login -method=ldap username=user1

export VAULT_ADDR=https://vault.club012.com
export VAULT_TOKEN=********

./mvnw spring-boot:run

# input data
curl -XPOST -d '{"name": "Test Customer", "cc_info": "What a wonderful world!"}' -H 'Content-Type:application/json' localhost:8080/payments
[{"cc_info":"vault:v1:haNRRGLmL2VbZJ43i55ZcDltc9x3La1Dq/pO2hFNNd2VLT6h+QtThvPIrB1XIC5rKPVA","id":"e6c9188a-b3b3-412f-9ecd-b7d0addddbf0","name":"Test Customer","createdAt":"2026-01-07T00:35:37.329957Z"}]

# view data
curl localhost:8080/payments
[
  {
    "cc_info": "What a wonderful world!",
    "id": "e6c9188a-b3b3-412f-9ecd-b7d0addddbf0",
    "name": "Test Customer",
    "createdAt": "2026-01-07T00:35:37.329957Z"
  }
]
```
