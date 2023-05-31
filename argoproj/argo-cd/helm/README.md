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
