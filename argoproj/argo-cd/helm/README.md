# Argo CD helm

> https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd

## install argocd

```
$ helm repo add argo https://argoproj.github.io/argo-helm

$ helm install kpc argo/argo-cd --namespace argocd --create-namespace -f values.yaml
$ helm upgrade kpc argo/argo-cd --namespace argocd --create-namespace -f values.yaml
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
