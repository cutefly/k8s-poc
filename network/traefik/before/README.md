# Traefik Gateway API

> https://doc.traefik.io/traefik/v3.6/getting-started/kubernetes/

## Quick start

```sh
# Add the Traefik Helm repository:
helm repo add traefik https://traefik.github.io/charts
helm repo update

# install traefik
helm install traefik traefik/traefik --create-namespace --namespace traefik -f values.yaml --wait

# Access dashboard
http://traefik.club012.com/dashboard/
```

## Workload

```
kubectl apply -f whoami.yaml -n traefik
curl http://whoami.localhost/

# Install the Gateway API CRDs in your cluster:
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml

kubectl apply -f httproute.yaml -n traefik
curl http://whoami-gatewayapi.localhost/
```

## Setup

> https://doc.traefik.io/traefik/v3.6/setup/kubernetes/

```
helm repo add traefik https://traefik.github.io/charts
helm repo update
kubectl create namespace traefik
```
```
# 1) Generate a self‑signed certificate valid for *.docker.localhost
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=*.docker.localhost"

# 2) Create the TLS secret in the traefik namespace
kubectl create secret tls local-selfsigned-tls \
  --cert=tls.crt --key=tls.key \
  --namespace traefik

# Access dashboard
https://traefik.club012.com:8443/dashboard/
```

````
# Install the chart into the 'traefik' namespace
helm install traefik traefik/traefik \
  --namespace traefik --version=37.4.0 \
  --values values.yaml

helm upgrade traefik traefik/traefik \
  --namespace traefik --version=37.4.0 \
  --values values.yaml

# Access demo web
https://whoami.club012.com:8443/
```

# Certificate

```
install cert-manager
create ClusterIssuer(letsencrypt, cloudflare)
create Certificate(domain or wildcard domain)
mapping with websecure in traefik
```
