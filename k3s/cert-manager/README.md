# Lets encrypt

## install cert manager

```sh
# https://cert-manager.io/docs/installation/kubectl/
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
```

## configure nginx

```yaml
# https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx
controller:
  # 추가
  admissionWebhooks:
    certManager:
      enabled: "true"
```

## Lets Encrypt

```sh
$ kubectl apply -f letsencrypt-staging.yaml
$ kubectl apply -f letsencrypt-prod.yaml
```

## Add Cert Manager to Minikube Nginx Addon

To add Cert Manager to the Nginx addon in Minikube, you can follow these steps:

1. Start Minikube with the Nginx addon enabled:

```sh
minikube start --addons=ingress
```

2. Install Cert Manager using the official Helm chart:

```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.5.3
```

3. Verify that Cert Manager is running:

```sh
kubectl get pods --namespace cert-manager
```

4. Configure the Nginx Ingress Controller to use Cert Manager:

```sh
minikube addons configure ingress --addon-namespace=cert-manager
```

5. Restart the Nginx Ingress Controller:

```sh
minikube addons enable ingress
```

After following these steps, Cert Manager will be added to the Nginx addon in Minikube, allowing you to manage SSL certificates for your applications.
