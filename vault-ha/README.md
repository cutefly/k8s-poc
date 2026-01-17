# Hashicorp Vault

## Unseal vault

## Vault cluster

## Auth

```
Token 방식
Userpass
LDAP
AppRole
Kubernetes
```

## Appllication 적용방식

```
Vault 서버에 직접 Access
- Token : 영구 Token을 사용하는 것은 보안적으로 추천하지 않음.
          실행 시점에 Token을 발급해야 함.
          토큰을 생성하기 위한 인증이 필요함.(Root 토큰 또는 사용자 인증)
- AppRole : ROLE_ID, SECRET_ID를 필요로 함.
            영구 SECRET_ID를 사용하는 것은 보안적으로 추천하지 않음.
            실행 시점에 SECRET_ID를 발급해야 함.
            SECRET_ID를 생성하기 위한 인증이 필요함.(Root 토큰 또는 사용자 인증)

Jenkins를 이용한 배포
- 인증방식 : Token 또는 AppRole
- 시스템 환경변수에 영구 토큰(또는 영구 ROLE_ID, SECRET_ID)을 저장
- 배포 시점에 유효시간이 설정되는 토큰(또는 SECRET_ID 발급)을 발급 
- 배포 어플리케이션에 환경변수로 토큰(또는 SECRET_ID 발급)을 전달

Kubernetes 배포
- Vault Agent Injector(init container)
- pod 생성 시 init-container에서 vault에 로그인 후 secret을 읽어서 환경변수(또는 shared 파일)로 전달
- pod 생성 시 init-container에서 vault에 로그인 후 token을 발급하여 환경변수(또는 shared 파일)로 전달
```
