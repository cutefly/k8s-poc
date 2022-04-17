# Argo Project

## Prepare minikube cluster

```
minikube start -p argoproj - 1.2G
minikube profile argoproj

# ingress controller(nginx)
minikube addons enable ingress
```

## Argo CD

### 1. Install Argo CD

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- insecure mode

```yaml
# override configmap
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-cmd-params-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cmd-params-cm
data:
  server.insecure: "true"
```

# redepoly argocd-service

```
# install argocd insecure mode
$ kubectl apply -n argocd -f argo-cd/install.yaml - 1.8G

# install using kustomization
$ kustomize build kustomize/overlays/insecure | kubectl apply -f -

# 인증서 등록
$ kubectl apply -n argocd -f argo-cd/secret/prepaidcard-secret-tls.yaml
$ kubectl apply -f argo-cd/tls-ingress.yaml
https://argocd.prepaidcard.co.kr/
```

### 2. Download Argo CD CLI

```
brew install argocd
```

### 3. Access The Argo CD API Server

```
# Load Balance
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "ClusterIP"}}'

# Tunneling
minikube tunnel
```

### 4. Login Using The CLI

```
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

$ argocd login 127.0.0.1
$ argocd account update-password
```

### 5. Add User

> https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cm
data:
  # add an additional local user with apiKey and login capabilities
  #   apiKey - allows generating API keys
  #   login - allows to login using UI
  accounts.devuser: apiKey, login
  # disables user. User is enabled by default
  # accounts.devuser.enabled: "false"
```

```sh
$ argocd account list
NAME     ENABLED  CAPABILITIES
admin    true     login
devuser  true     apiKey, login

$ argocd account update-password --account devuser --current-password <currentUserPassword> --new-password <newPassword>
```

```yaml
# devuser 사용자에 권한 부여
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: argocd-rbac-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-rbac-cm
data:
  policy.csv: |
    p, role:devuser, applications, *, */*, allow
    p, role:devuser, clusters, get, *, allow
    p, role:devuser, repositories, get, *, allow
    p, role:devuser, repositories, create, *, allow
    p, role:devuser, repositories, update, *, allow
    p, role:devuser, repositories, delete, *, allow
    g, devuser, role:devuser
```

## Argo Rollouts

> https://argoproj.github.io/argo-rollouts/getting-started/

> https://argoproj.github.io/argo-rollouts/getting-started/nginx/

### Controller Installation

```
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```

### Kubectl Plugin Installation

```
brew install argoproj/tap/kubectl-argo-rollouts
```

## Getting Started - NGINX Ingress

### Canary strategy

```
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/nginx/rollout.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/nginx/services.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/nginx/ingress.yaml

# ingress upgrade
kubectl apply -f argo-rollouts/canary/
```

```
# check status
kubectl argo rollouts get rollout rollouts-demo
```

```
# perform an update
kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:yellow
kubectl argo rollouts get rollout rollouts-demo

# Promoting a Rollout
kubectl argo rollouts promote rollouts-demo

kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:red
kubectl argo rollouts get rollout rollouts-demo

# Aborting a Rollout
kubectl argo rollouts abort rollouts-demo

# Healthy again and not Degraded
kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:yellow
```

```
# UI Dashboard

kubectl argo rollouts dashboard
```

### Bluegreen strategy

```
# ingress upgrade
kubectl apply -f argo-rollouts/bluegreen/
kubectl argo rollouts promote rollout-bluegreen

# check status
kubectl argo rollouts get rollout rollout-bluegreen --watch

# Promoting a Rollout
kubectl argo rollouts set image rollout-bluegreen rollouts-demo=argoproj/rollouts-demo:yellow
kubectl argo rollouts promote rollout-bluegreen

# Aborting a Rollout
kubectl argo rollouts set image rollout-bluegreen rollouts-demo=argoproj/rollouts-demo:red
kubectl argo rollouts abort rollout-bluegreen

# Healthy again and not Degraded
kubectl argo rollouts set image rollout-bluegreen rollouts-demo=argoproj/rollouts-demo:yellow
```

## Argo CD Image Updater

```sh
# install cli
# download argocd-image-updater_platform
$ mv argocd-image-updater_$platform /usr/local/bin/argocd-image-updater

$ argocd-image-updater version

$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml

# install using kustomization
$ kustomize build kustomize/overlays/registries | kubectl apply -f -
```

```sh
# argocd image-updater test command(using env)
$ export REGISTRY_PULLSECRET="userid:password"
$ argocd-image-updater test registry.kpcard.co.kr/kr.co.prepaidcard/cadmium-coupon-admin --platforms linux/amd64 --update-strategy latest --credentials env:REGISTRY_PULLSECRET

# argocd image-updater test command(using pullsecret)
argocd-image-updater test --kubeconfig ~/.kube/config docker.kpcard.co.kr/nginx --credentials pullsecret:argocd/kpcard-registry-cred

# argocd annotation
argocd-image-updater.argoproj.io/image-list: nginx-alias=docker.kpcard.co.kr/nginx
argocd-image-updater.argoproj.io/nginx-alias.pull-secret: pullsecret:argocd/kpcard-registry-cred
argocd-image-updater.argoproj.io/nginx-alias.update-strategy: latest

```

```yaml
# ca-certificates 이슈가 있는 경우 registries.conf 파일로 설정(insecure: true)
data:
  registries.conf: |
    registries:
    - name: KPC Registry
      prefix: docker.kpcard.co.kr
      api_url: https://docker.kpcard.co.kr
      credentials: pullsecret:argocd/kpcard-registry-cred
      insecure: true
      default: true

# kubectl apply -n argocd -f custom-install.yaml

# 참고 URL
# X509: certificate signed by unknown authority, private registry, NOT a self-signed cert
# https://forums.docker.com/t/x509-certificate-signed-by-unknown-authority-private-registry-not-a-self-signed-cert/53150
```
