# Vault HA

## Vault HA with RAFT

```hcl
# /vault/config/vault.hcl
ui = true
disable_mlock = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}

storage "raft" {
  path    = "/vault/data"
  node_id = "vault-1"
}

api_addr     = "http://vault-1:8200"
cluster_addr = "http://vault-1:8201"
```

```sh
$ docker compose up -d
```

### Initialize vault-1 node

```sh
$ docker exec -it vault-1 sh
/ # export VAULT_ADDR=http://127.0.0.1:8200

/ # vault operator init -key-shares=1 -key-threshold=1
Unseal Key 1: rXWHeoZGsm7kLvc47zOkeiWHQwmGtdWgva9ojMWtSL4=

Initial Root Token: ${ROOT_TOKEN}

Vault initialized with 1 key shares and a key threshold of 1. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 1 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 1 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.

/ # vault operator unseal
Unseal Key (will be hidden):
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            1
Threshold               1
Version                 1.15.6
Build Date              2024-02-28T17:07:34Z
Storage Type            raft
Cluster Name            vault-cluster-5bdba822
Cluster ID              b1eb8c6f-8642-41a0-03b3-3495e8bc0c92
HA Enabled              true
HA Cluster              n/a
HA Mode                 standby
Active Node Address     <none>
Raft Committed Index    29
Raft Applied Index      29
```

## Initialize vault-2 node

```sh
$ docker exec -it vault-2 sh
/ # export VAULT_ADDR=http://127.0.0.1:8200

/ # vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       1
Threshold          1
Unseal Progress    0/1
Unseal Nonce       n/a
Version            1.15.6
Build Date         2024-02-28T17:07:34Z
Storage Type       raft
HA Enabled         true
```

## Initialize vault-3 node

```sh
$ docker exec -it vault-3 sh
/ # export VAULT_ADDR=http://127.0.0.1:8200

/ # vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       1
Threshold          1
Unseal Progress    0/1
Unseal Nonce       n/a
Version            1.15.6
Build Date         2024-02-28T17:07:34Z
Storage Type       raft
HA Enabled         true
```

## Raft peer 상태 확인

```sh
$ docker exec -it vault-1 sh
/ # export VAULT_ADDR=http://127.0.0.1:8200
/ # export VAULT_TOKEN=${ROOT_TOKEN}

/ # vault operator raft list-peers
Node       Address         State       Voter
----       -------         -----       -----
vault-1    vault-1:8201    leader      true
vault-2    vault-2:8201    follower    true
vault-3    vault-3:8201    follower    true

/ # vault status
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            1
Threshold               1
Version                 1.15.6
Build Date              2024-02-28T17:07:34Z
Storage Type            raft
Cluster Name            vault-cluster-5bdba822
Cluster ID              b1eb8c6f-8642-41a0-03b3-3495e8bc0c92
HA Enabled              true
HA Cluster              https://vault-1:8201
HA Mode                 active
Active Since            2025-12-19T04:44:10.274989779Z
Raft Committed Index    76
Raft Applied Index      76
```

## Auto unseal

> unseal vault 생성 후

```hcl
# /vault/config/vault.hcl
ui = true
disable_mlock = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true
}

seal "transit" {
  address     = "http://unseal-vault:8200"
  token       = "${UNSEAL_TOKEN}"
  key_name    = "vault-unseal"
  mount_path  = "transit/"
  tls_skip_verify = true
}

storage "raft" {
  path    = "/vault/data"
  node_id = "vault-1"
}

api_addr     = "http://vault-1:8200"
cluster_addr = "http://vault-1:8201"
```

> seal "transit" 이 init 이전에 존재해야 함

```sh
$ docker exec -it vault-1 sh
/ # vault operator init
Recovery Key 1: IJfoXEZJbHgSzs1gY/WVfmx3Fo8q6KPJlFr0n2Ob0/Be
Recovery Key 2: PQnn6D6JnyEm5P35GSLWfpKRiUoYaFHdEYsrXublEiZD
Recovery Key 3: RQEBvZU4Ny80NUVT9CWPF30IdV9DrnP8aCiXDN4EPPFs
Recovery Key 4: 43cUU7S3ow2bUMVBKVbNue29AmJG5EnQOGwxg/tuovHh
Recovery Key 5: /M1j/TrxkksvfDHuyMZgcJzzG6LQxBQkQ702YKWyJ/UE

Initial Root Token: ${ROOT_TOKEN}

Success! Vault is initialized

Recovery key initialized with 5 key shares and a key threshold of 3. Please
securely distribute the key shares printed above.
```

## Nginx Proxy Manager Load balancing

### configure upstream

```conf
# /data/nginx/custom/http.conf
upstream vault-ha-group {
    server 192.168.219.72:8201;
    server 192.168.219.72:8202;
    server 192.168.219.72:8203;
}
```

### configure proxy host

> Forward Hostname / IP 주소는 임의의 값 입력

```conf
# Advanced > Custom Nginx Configuration
location / {
    proxy_pass http://vault-ha-group;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

> https://vault.club012.com/