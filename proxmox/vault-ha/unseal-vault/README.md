# Auto Unseal vault

## Initialize unseal vault

```sh
docker network create vault-net
docker compose up -d
```

```sh
$ docker exec -it unseal-vault apk add jq

$ docker exec -it unseal-vault sh
/ # sh /init-transit.sh
⏳ Waiting for Vault to start...
🚀 Initializing Unseal Vault...
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.15.6
Build Date      2024-02-28T17:07:34Z
Storage Type    file
Cluster Name    vault-cluster-3ac15bf2
Cluster ID      5ef9fbec-31db-bf69-bf95-377fff8004fd
HA Enabled      false
🔓 Vault unsealed
Success! Enabled the transit secrets engine at: transit/
Key                       Value
---                       -----
allow_plaintext_backup    false
auto_rotate_period        0s
deletion_allowed          false
derived                   false
exportable                false
imported_key              false
keys                      map[1:1766125797]
latest_version            1
min_available_version     0
min_decryption_version    1
min_encryption_version    0
name                      vault-unseal
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      aes256-gcm96
Success! Uploaded policy: unseal
✅ Transit Unseal Vault ready
```

## Unseal vault 복원

```
# vault 경로에서 data 폴더 백업
$ tar cvfz unseal-vault-data.tar.gz data

# vault.hcl 설정을 이용하여 새로운 인스턴스 생성
$ docker compose up -d

# 인스턴스 중지
$ docker compose stop

# data 폴더 복원
tar xvfz unseal-vault-data.tar.gz

# 인스턴스 재시작
$ docker compose start

# unseal(/vault/data/unseal.key 활용)
$ docker exec -it unseal-vault sh
/ # vault operator unseal
Unseal Key (will be hidden):
또는
/ # vault operator unseal `cat /vault/data/unseal.key`
```
