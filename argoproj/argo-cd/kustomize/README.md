# ArgoCD kustomize

## install argocd

```sh
# create namespace
kubectl create namespace argocd

# default build
kubectl kustomize base
kubectl kustomize overlays/secure

# apply secure argocd(default)
kubectl kustomize overlays/secure | kubectl apply -f -

########################################
########### install insecure ###########
########################################
# insecure build
kubectl kustomize overlays/insecure

# apply insecure argocd
kubectl kustomize overlays/insecure | kubectl apply -f -

# remove argocd
kubectl kustomize overlays/insecure | kubectl delete -f -
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
argocd account update-pasword

# cahnge devuser password
argocd account update-pasword --account devuser --current-password $(adminPassword) --new-password $(devuserPassword)
```
