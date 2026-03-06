# Traefik Gateway API

## Add the chart repo and namespace

```sh
helm repo add traefik https://traefik.github.io/charts
helm repo update
kubectl create namespace traefik
``

## Create a Local Self‑Signed TLS Secret

```sh
# 1) Generate a self‑signed certificate valid for *.docker.localhost
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=*.club012.com"

# 2) Create the TLS secret in the traefik namespace
kubectl create secret tls local-selfsigned-tls \
  --cert=tls.crt --key=tls.key \
  --namespace traefik
```

## Install the Traefik Using the Helm Value

```sh
# Install the chart into the 'traefik' namespace
helm install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace \
  --values values.yaml

# upgrade helm chart
helm upgrade traefik traefik/traefik \
  --namespace traefik \
  --values values.yaml

# delete helm chart
helm delete traefik \
  --namespace traefik
```
