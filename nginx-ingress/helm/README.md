# Nginx ingress controller

## Install ingress controller

- https://kubernetes.github.io/ingress-nginx/deploy/#quick-start
https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml

```sh

# Github
# Repository 추가 없이 설치
$ helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f values.yaml

# Repository 추가
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# 설치
$ helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f values.yaml
# 업데이트
$ helm upgrade ingress-nginx ingress-nginx -f values.yaml
# 제거
$ helm uninstall ingress-nginx --namespace ingress-nginx

# Bitnami
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm repo update
$ helm install ingress-nginx bitnami/nginx \
  --namespace ingress-nginx --create-namespace \
  -f values.yaml
$ helm uninstall ingress-nginx --namespace ingress-nginx

# Nginx
$ helm repo add nginx-stable https://helm.nginx.com/stable
$ helm repo update
$ helm install ingress-nginx nginx-stable/nginx-ingress --namespace ingress-nginx --create-namespace
$ helm uninstall ingress-nginx --namespace ingress-nginx

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/baremetal/deploy.yaml

```

## monitoring(grafana dashboard)

> <https://grafana.com/grafana/dashboards/9614-nginx-ingress-controller/>
