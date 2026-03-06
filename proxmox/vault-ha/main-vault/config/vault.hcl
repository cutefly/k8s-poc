ui = true
disable_mlock = true

storage "raft" {
  path    = "/vault/data"
  node_id = "vault-1"

  retry_join {
  leader_api_addr = "http://vault-1:8200"
}
}

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

api_addr     = "http://vault-1:8200"
cluster_addr = "http://vault-1:8201"
