# Argo CD helm

## install argocd

```
$ helm repo add argo https://argoproj.github.io/argo-helm

$ helm install kpc argo/argo-cd --namespace argocd --create-namespace -f values.yaml
$ helm upgrade kpc argo/argo-cd --namespace argocd --create-namespace -f values.yaml
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
