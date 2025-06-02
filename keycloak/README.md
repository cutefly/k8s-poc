# Keycloak(sso)

## Installation

> https://honglab.tistory.com/265

```sh
To install Keycloak using Helm chart, follow these steps:

Add the Bitnami repository:
$ helm repo add bitnami https://charts.bitnami.com/bitnami

Install Keycloak using the Helm chart:
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml --version 24.7.3
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml
$ helm upgrade keycloak bitnami/keycloak --namespace keycloak -f values.yaml

This will install Keycloak using the Bitnami Helm chart with the release name "my-keycloak". You can customize the installation by providing additional configuration values

# 제거
$ helm uninstall keycloak --namespace keycloak
```

## LDAP 연동

> https://hs-note.tistory.com/23

### Realm 생성 후 LDAP 연동

```
Keycload Admin 게정으로 로그인(https://keycloak.club012.com)
Manage realms -> Create realm : ldap-realm
Current realm: ldap-realm

# LDAP 설정

- User federation > Add new provier: LDAP
- Settings
UI display name: ldap
Connection URL: ldap://192.168.1.34:389

Bind Type: simple
Bind DN: cn=admin,dc=kpcard,dc=co,dc=kr
Bind credentials: ********

Edit mode: READ_ONLY
User DN: ou=users,dc=kpcard,dc=co,dc=kr
Username LDAP attribute: uid
UUID LDAP attribute: cn
User object classes: inetOrgPerson, organizationPerson, posixAccount

- Mappers
Add Mapper
  - Name: groups
  - Mapper type: group-ldap-mapper
LDAP Groups DN: ou=groups,dc=kpcard,dc=co,dc=kr
Group Name LDAP Attribute: cn
Group Object Classes: posixGroup
Perserve Group Inheritance: Off
Membership LDAP Attribute: memberUid
Membership Attribute Type: UID
Membership User LDAP Attribute: uid
Mode: LDAP_ONLY
User Group Retrive Strategy: LOAD_GROUPS_BY_MEMBER_ATTRIBUTE
Member-Of LDAP Attribute: memberUid
```

## Kubernetes 연동

> https://wlsdn3004.tistory.com/62

### k8s client 설정

```
1. Realm 변경 (Realm 없을시 생성)
```

```
2. k8s-client Client 생성 
- "Cliet ID": k8s-client
- "Valid redirect URIs": /*, http://localhost:8000
- "Web origins": /*
- "Client authentication": On
- "Authentication flow": Standard flow(check), Direct access grants(check)
- "Role" Tab: k8s-role 생성
- "Client Scopes" Tab: k8s-client-dedicated: "Scope" Tab > Full scope allowed: Off 비활성화
- "Client Scopes" Tab: k8s-client-dedicated: "Mappers" 생성: Add mapper > By configuration > User Client Role
    - Name: groups
    - Client ID: k8s-client
    - Token Claim Name: groups
- Group 생성 (LDAP 연동시 이미 Group 생성되어있어, Skip)
- admin "Groups" > "Role mapping" Tab > Assign role > Filter by clients > k8s-client 선택 > Assign
- User 생성 (LDAP 연동시 이미 Group 생성되어있어, Skip)
- User > Credentials > Set password > 비밀번호 입력 > Save > Save password (LDAP연동시, Skip)
- Users "kpcadmin" user 선택> Groups "Join Group" admin > Join
```

```
3. OIDC 연동 설정 확인
# get token 확인(oidc-login plugin 설치 후)
$ kubectl oidc-login get-token \
  --oidc-issuer-url="https://auth.kpcard.co.kr/realms/ldap-realm" \
  --oidc-client-id="k8s-client" \
  --oidc-client-secret="****************" \
  --grant-type=password
```

```
4. kubernete OIDC 설정 - minikube 옵션 수정
minikube start
    --memory 8192 
    --cpus 4 
    --network-plugin=cni 
    --cni=calico 
    --apiserver-ips=144.24.74.72
    --extra-config=apiserver.oidc-issuer-url=https://keycloak.club012.com/realms/ldap-realm
    --extra-config=apiserver.oidc-username-claim=preferred_username
    --extra-config=apiserver.oidc-groups-claim=groups
    --extra-config=apiserver.oidc-client-id=k8s-client
```

```
5. kubernetes Role 설정
- LDAP 그룹 - k8s 그룹 Role Binding 설정

# kubectl apply -f keycloak-role.yaml
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: keycloak-users-role
rules:
- apiGroups:
  - '*'
  resources:
  - 'namespaces'
  - 'pods'
  verbs:
  - 'get'
  - 'list'
  - 'watch'
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: keycloak-users-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: keycloak-users-role
subjects:
- kind: Group
  name: k8s-users-role
  apiGroup: rbac.authorization.k8s.io
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: keycloak-admin-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: Group
  name: k8s-admin-role
  apiGroup: rbac.authorization.k8s.io
```

```
6. kubectl context 생성 후 사용자 배포
kubectl config set-credentials oidc \
  --exec-api-version=client.authentication.k8s.io/v1beta1 \
  --exec-command=kubectl \
  --exec-arg=oidc-login \
  --exec-arg=get-token \
  --exec-arg=--oidc-issuer-url="https://keycloak.club012.com/realms/ldap-realm" \
  --exec-arg=--oidc-client-id="k8s-client" \
  --exec-arg=--oidc-client-secret="*****************" \
  --grant-type=password

kubectl config get-contexts
```

## Client 설정(kubelogin)

```
$ brew install kubelogin
```
