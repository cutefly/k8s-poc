# Argo Projfect

## Prepare minikube cluster

```
minikube start -p argoproj
minikube profile argoproj
```

## Argo CD

### 1. Install Argo CD¶

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 2. Download Argo CD CLI

```
brew install argocd
```

### 3. Access The Argo CD API Server

```
# Load Balance
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Tunneling
minikube tunnel
```

### 4. Login Using The CLI¶

```
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

$ argocd login 127.0.0.1
$ argocd account update-password
```
