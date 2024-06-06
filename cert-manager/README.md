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

```

```
