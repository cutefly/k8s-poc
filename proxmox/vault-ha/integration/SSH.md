# HashiCorp Vault를 활용한 SSH 인증서 기반 서버 접속 구현

> https://devocean.sk.com/blog/techBoardDetail.do?ID=167675

> https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates


## Vault Server 설정

```
vault secrets enable -path=ssh-client-signer ssh

vault write ssh-client-signer/config/ca generate_signing_key=true

#policy.hcl
path "ssh-client-signer/config/ca" {
  capabilities = ["read"]
}
vault policy write ssh-pubkey-read policy.hcl

vault token create -policy=ssh-pubkey-read
Key                  Value
---                  -----
token                ********
token_accessor       57e5wAdftUUphig9Os4Yr9kk
token_duration       768h
token_renewable      true
token_policies       ["default" "ssh-pubkey-read"]
identity_policies    []
policies             ["default" "ssh-pubkey-read"]

vault write ssh-client-signer/roles/ssh-client-role -<<"EOH"
{
  "algorithm_signer": "rsa-sha2-256",
  "allow_user_certificates": true,
  "allowed_users": "*",
  "allowed_extensions": "permit-pty,permit-port-forwarding",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "pi",
  "ttl": "5m0s"
}
EOH

#sign-policy.hcl
path "ssh-client-signer/sign/ssh-client-role" {
  capabilities = ["update"]
}
vault policy write require-ssh-sign sign-policy.hcl

vault token create -policy=require-ssh-sign
Key                  Value
---                  -----
token                ********
token_accessor       q83YSIjTxbAbv8h4r0M8iTJp
token_duration       768h
token_renewable      true
token_policies       ["default" "require-ssh-sign"]
identity_policies    []
policies             ["default" "require-ssh-sign"]


```

## ssh server

```
export VAULT_ADDR=https://valut.club012.com
export VAULT_TOKEN=ssh-pubkey-read
vault read -field=public_key ssh-client-signer/config/ca | sudo tee ./trusted-user-ca-keys.pem > /dev/null

# /etc/ssh/sshd_config
TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem

sudo systemctl restart ssh
```

# ssh client

```
export VAULT_ADDR=https://valut.club012.com
export VAULT_TOKEN=require-ssh-sign

# key pair 생성(있는 경우 있는 key pair 사용)
ssh-keygen -t rsa

vault write -field=signed_key ssh-client-signer/sign/ssh-client-role \
  public_key=@$HOME/.ssh/id_rsa.pub > $HOME/.ssh/id_rsa-cert.pub

ssh -i ~/.ssh/id_rsa pi@192.168.219.98
```

# HashiCorp Vault로 OTP 방식 SSH 인증 구현

> https://devocean.sk.com/blog/techBoardDetail.do?ID=167690

## Vault Server 설정

```
vault secrets enable -path=otp-key-ssh ssh

vault write otp-key-ssh/roles/otp-key-role \
      key_type=otp \
      default_user=pi \
      allowed_user=pi \
      cidr_list=192.168.219.0/24

# otp-key-role.hcl
path "otp-key-ssh/creds/otp-key-role" {
  capabilities = ["create", "read", "update"]
}

path "sys/leases/revoke" {
  capabilities = ["update"]
}

vault policy write otp-key-role ./otp-key-role.hcl

# Vault에서 Username & Password 인증 방식을 활성
vault auth enable userpass
vault write auth/userpass/users/pi-vault-user password="${uer_password}" policies="default,otp-key-role"
```

## Vault Server 설정

```
wget https://releases.hashicorp.com/vault-ssh-helper/0.2.1/vault-ssh-helper_0.2.1_linux_amd64.zip
sudo unzip -q vault-ssh-helper_0.2.1_linux_amd64.zip -d /usr/local/bin
-- sudo chmod 0755 /usr/local/bin/vault-ssh-helper
-- sudo chown root:root /usr/local/bin/vault-ssh-helper
sudo mkdir /etc/vault-ssh-helper.d/

# /etc/vault-ssh-helper.d/config.hcl
vault_addr = "https://vault.club012.com"
tls_skip_verify = true
ssh_mount_point = "otp-key-ssh"
allowed_roles = "*"

#sudo nano /etc/pam.d/sshd

#@include common-auth    #비활성화 처리
auth requisite pam_exec.so quiet expose_authtok log=/var/log/vault-ssh.log /usr/local/bin/vault-ssh-helper -dev -config=/etc/vault-ssh-helper.d/config.hcl #추가
auth optional pam_unix.so not_set_pass use_first_pass nodelay #추가

#/etc/ssh/sshd_config
KbdInteractiveAuthentication yes
UsePAM yes
PasswordAuthentication no <= 넣으면 로그인이 불가

sudo systemctl restart ssh
```

## SSH Client 설정

```
export VAULT_ADDR=https://vault.club012.com
vault login -method=userpass username=pi-vault-user password=${user_password}

# get one time password
vault write otp-key-ssh/creds/otp-key-role ip=192.168.219.98
Key                Value
---                -----
lease_id           otp-key-ssh/creds/otp-key-role/wpm9Fo168KFsuV0M6ClQQcgf
lease_duration     768h
lease_renewable    false
ip                 192.168.219.98
key                75bbe548-a8e0-f013-702c-aaa6bc61b613 <= one time password
key_type           otp
port               22
username           pi

ssh ip=192.168.219.98
pi@192.168.219.98's password:
75bbe548-a8e0-f013-702c-aaa6bc61b613

# ssh login without prompt(install sshpass first)
vault ssh \
    -mount-point=otp-key-ssh\
    -role otp-key-role \
    -mode otp \
    -strict-host-key-checking=no \
    pi@192.168.219.98
```
