# Argo Project

## Prepare minikube cluster

```
minikube start -p argoproj
minikube profile argoproj

# ingress controller(nginx)
minikube addons enable ingress
```

## Argo CD

### 1. Install Argo CD¶

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
# redepoly argocd-service
$ kubectl apply -n argocd -f cd/install.yaml
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

### 4. Login Using The CLI¶

```
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

$ argocd login 127.0.0.1
$ argocd account update-password
```

## Argo Rollouts

### Controller Installation

```
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml
```

### Kubectl Plugin Installation

```
brew install argoproj/tap/kubectl-argo-rollouts
```

### Getting Started - NGINX Ingress

```
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/nginx/rollout.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/nginx/services.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-rollouts/master/docs/getting-started/nginx/ingress.yaml
```

```
# check status
kubectl argo rollouts get rollout rollouts-demo
```

```
# perform an update

kubectl argo rollouts set image rollouts-demo rollouts-demo=argoproj/rollouts-demo:yellow
kubectl argo rollouts get rollout rollouts-demo
```
