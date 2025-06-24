# Argo CD helm

> https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd

## install argocd

```
$ helm repo add argo https://argoproj.github.io/argo-helm

$ helm install argocd argo/argo-cd --namespace argocd --create-namespace -f values.yaml
$ helm upgrade argocd argo/argo-cd --namespace argocd -f values.yaml

helm delete argocd --namespace argocd

```

### local accounts

```yaml
configs:
  params:
    server.insecur: true
  cm:
    accounts.devuser: apiKey, login
  rbac:
    policy.csv: |
      p, role:devuser, applications, *, */*, allow
      p, role:devuser, clusters, get, *, allow
      p, role:devuser, projects, get, *, allow
      p, role:devuser, repositories, get, *, allow
      p, role:devuser, repositories, create, *, allow
      p, role:devuser, repositories, update, *, allow
      p, role:devuser, repositories, delete, *, allow
      g, devuser, role:devuser
```

## change password

```sh
# port forward https
kubectl port-forward svc/argocd-server -n argocd 8080:443

# get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# login admin
argocd login localhost:8080

# cahnge password
argocd account update-password

# cahnge devuser password
argocd account update-password --account devuser --current-password $(adminPassword) --new-password $(devuserPassword)
```

### openldap

> https://gomgomshrimp.oopy.io/posts/7

```yaml
configs:
  params:
    server.insecur: true
  cm:
    # url 설정은 반드시 필요(https://github.com/argoproj/argo-cd/discussions/7693)
    url: https://localhost:8080
    dex.config: |
      connectors:
      - type: ldap
        name: openldap
        id: ldap
        config:
          host: "172.16.4.225:389"
          insecureNoSSL: true
          insecureSkipVerify: true
          # rootCA: <ldap 서버 CA 인증서>
          bindDN: cn=admin,dc=kpcard,dc=co,dc=kr
          bindPW: admin
          usernamePrompt: Username
          # 사용자를 찾는데 사용되는 정보
          userSearch: 
            baseDN: ou=users,dc=kpcard,dc=co,dc=kr
            filter: "(objectClass=inetOrgPerson)"
            username: uid
            idAttr: uid
            emailAttr: mail
            nameAttr: displayName
          # 그룹을 찾는데 사용되는 정보
          groupSearch:
            baseDN: ou=groups,dc=kpcard,dc=co,dc=kr
            filter: "(objectClass=posixGroup)"
            userMatchers:
            - userAttr: cn
              groupAttr: memberUid
            nameAttr: cn
  rbac:
    policy.csv: |
      p, role:devuser, applications, *, */*, allow
      p, role:devuser, clusters, get, *, allow
      p, role:devuser, projects, get, *, allow
      p, role:devuser, repositories, get, *, allow
      p, role:devuser, repositories, create, *, allow
      p, role:devuser, repositories, update, *, allow
      p, role:devuser, repositories, delete, *, allow
      g, jenkins-admin, role:admin
      g, jenkins-users, role:devuser
```

### oidc login

> https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/keycloak/

```
# LDAP 연동은 완료된 후 진행
realm: sso-realm
client-id: argocd-client

# Client 생성
Clients -> Create client : argocd-client
Root URL: https://argocd.club012.com
Home URL: /applications
Valid redirect URIs: https://argocd.club012.com/auth/callback
Valid post logout redirect URIs: https://argocd.club012.com/applications, https://argocd.club012.com/
Web origins: *
Admin URL: https://argocd.club012.com
Client authentication: On
Authentication flow: Standard flow, Direct access grants

Client Scope -> Create client scope
[Settings]
Name: groups
Type: None
Display on consent screen: On
Include in token scope: On
[Meppers]
Add mapper -> by configuration
Name: groups
Mapper type: Group Membership
Full group path: Off
Add to ID token: On
Add to access token: On
Add to userinfo: On

Clients -> argocd-client -> Client scope
Add client scope
groups 선택 후 Add(Default)
```

### Get Token 확인

```
$ kubectl oidc-login get-token \
  --oidc-issuer-url="https://keycloak.club012.com/realms/sso-realm" \
  --oidc-client-id="argocd-client" \
  --oidc-client-secret="RSPniIjycPM2IeEmKMN8WCQvyaTHQcWG" \
  --grant-type=password
```

### group policy mapping

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  policy.csv: |
    g, admin, role:admin
```

### oidc

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  url: https://argocd.club012.com
  oidc.config: |
    name: Keycloak
    issuer: https://keycloak.club012.com/realms/sso-realm
    clientID: argocd-client
    clientSecret: RSPniIjycPM2IeEmKMN8WCQvyaTHQcWG
    requestedScopes: ["openid", "profile", "email", "groups"]
    requestedIDTokenClaims: {"groups": {"essential": true}}
    logoutURL: https://keycloak.club012.com/realms/sso-realm/protocol/openid-connect/logout?id_token_hint={{token}}&post_logout_redirect_uri=https://argocd.club012.com/applications
```

## ArgoCD with keycloak login

> https://argocd.club012.com/




