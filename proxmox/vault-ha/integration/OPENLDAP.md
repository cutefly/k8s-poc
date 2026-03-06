# LDAP with vault

## Manage LDAP credentials with Vault

> https://developer.hashicorp.com/vault/tutorials/secrets-management/openldap

```
# Enable the LDAP secrets engine
vault secrets enable ldap

# Configure LDAP secrets engine
vault write ldap/config \
    binddn=cn=admin,dc=club012,dc=com \
    bindpass=${admin_password} \
    url=ldap://192.168.219.110

# Rotate the root credential
vault write -f ldap/rotate-root

```

## Vault Auth with LDAP

> https://wjsh.tistory.com/20

```
# enable ldap auth
vault auth enable ldap

# ldap configuration
vault write auth/ldap/config \
    url="ldap://192.168.219.110:389" \
    starttls=false \
    insecure_tls=true \
    binddn="cn=admin,dc=club012,dc=com" \
    bindpass="${admin_password}" \
    userdn="ou=users,dc=club012,dc=com" \
    groupdn="ou=groups,dc=club012,dc=com" \
    groupfilter="(&(objectClass=posixGroup)(memberUid={{.Username}}))" \
    # groupfilter="(memberUid=uid={{.Username}},ou=users,dc=club012,dc=com)" \
    groupattr="cn"

# ldap 인증 테스트
vault login -method=ldap username=chris
Password (will be hidden):

# root 토큰 로그인 후 진행
## administrator policy 생성
vault policy write administrator - <<EOF
path "*" {
capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

## admin policy 확인
vault policy read administrator
path "*" {
capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

## developer policy 생성
vault policy write developer - <<EOF
path "*" {
capabilities = ["create", "read", "update","list"]
}
EOF

# developer policy 확인
vault policy read developer
path "*" {
capabilities = ["create", "read", "update","list"]
}

# LDAP admins 그룹에 admin (vault) 정책 지정
vault write auth/ldap/groups/administrator policies=administrator

# LDAP devs 그룹에 develop 정책 지정
vault write auth/ldap/groups/developer policies=developer

vault login -method=ldap username=user1
```
