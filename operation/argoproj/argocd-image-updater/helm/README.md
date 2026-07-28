# Argo CD image update

> https://github.com/argoproj/argo-helm/tree/main/charts/argocd-image-updater

## install argocd image updater

```
$ helm repo add argo https://argoproj.github.io/argo-helm

$ helm install argocd-image-updater argo/argocd-image-updater --namespace argocd --version 0.14.0 --create-namespace -f values.yaml
$ helm upgrade argocd-image-updater argo/argocd-image-updater --namespace argocd --version 1.2.4 -f values.yaml

$ helm delete argocd-image-updater --namespace argocd
```

## registry credential

```
kubectl delete secret -n argocd nexus-registry-cred
kubectl create secret -n argocd docker-registry nexus-registry-cred --docker-server='docker.club012.com' --docker-username='chris' --docker-password='${DOCKER_PASSWORD}' --docker-email='chris@kpcard.co.kr'

# workload namespace에도 credential 추가
kubectl delete secret -n argoproj-namespace nexus-registry-cred
kubectl create secret -n argoproj-namespace docker-registry nexus-registry-cred --docker-server='docker.club012.com' --docker-username='chris' --docker-password='${DOCKER_PASSWORD}' --docker-email='chris@kpcard.co.kr'
```

```
cat config.json | base64 | tr -d '\n'
kubectl apply -n argocd -f secret.yaml
kubectl apply -n argoproj-namespace -f secret.yaml
```
