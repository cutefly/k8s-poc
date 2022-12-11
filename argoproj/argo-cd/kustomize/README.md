# ArgoCD kustomize

## create namespace

kubectl create namespace argocd

## default build

kubectl kustomize base

## insecure build

kubectl kustomize overlays/insecure

## apply insecure argocd

kubectl kustomize overlays/insecure | kubectl apply -f -
