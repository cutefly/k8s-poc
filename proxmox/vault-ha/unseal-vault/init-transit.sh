#!/bin/sh
set -e

echo "⏳ Waiting for Vault to start..."
sleep 5

# Vault 초기화 여부 확인
if vault status | grep -q 'Initialized.*true'; then
  echo "✔ Vault already initialized"
  exit 0
fi

echo "🚀 Initializing Unseal Vault..."
INIT=$(vault operator init -key-shares=1 -key-threshold=1 -format=json)

UNSEAL_KEY=$(echo "$INIT" | jq -r '.unseal_keys_b64[0]')
ROOT_TOKEN=$(echo "$INIT" | jq -r '.root_token')

echo "$UNSEAL_KEY" > /vault/data/unseal.key
echo "$ROOT_TOKEN" > /vault/data/root.token

vault operator unseal "$UNSEAL_KEY"
export VAULT_TOKEN="$ROOT_TOKEN"

echo "🔓 Vault unsealed"

# Transit Engine 활성화
vault secrets enable transit || true

# Unseal Key 생성
vault write -f transit/keys/vault-unseal

# Policy 생성
cat <<EOF | vault policy write unseal -
path "transit/encrypt/vault-unseal" {
  capabilities = ["update"]
}

path "transit/decrypt/vault-unseal" {
  capabilities = ["update"]
}
EOF

# Token 생성
vault token create -policy=unseal -period=24h -renewable=true -orphan > /vault/data/unseal-token.txt

echo "✅ Transit Unseal Vault ready"
