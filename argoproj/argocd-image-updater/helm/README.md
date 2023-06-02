# Argo CD image update

## install argocd image updater

```
$ helm repo add argo https://argoproj.github.io/argo-helm

$ helm install argocd-image-updater argo/argocd-image-updater --namespace argocd --create-namespace -f values.yaml
$ helm upgrade argocd-image-updater argo/argocd-image-updater --namespace argocd --create-namespace -f values.yaml
```
