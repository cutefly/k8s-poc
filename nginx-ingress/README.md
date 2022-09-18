# Nginx ingress controller

## Install ingress controller

- https://kubernetes.github.io/ingress-nginx/deploy/#quick-start

```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/baremetal/deploy.yaml

```

- https://minikube.sigs.k8s.io/docs/start/
- https://kubernetes.io/docs/concepts/services-networking/ingress/#tls

```
# minikube 실행(멀티 클러스터 환경)
$ minikube start -p nginx-ingress
$ minikube profile nginx-ingress
$ minikube addons enable ingress

# start load balance(127.0.0.1)
$ minikube tunnel
```

## 

```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace


$ helm repo add nginx-stable https://helm.nginx.com/stable
$ helm repo update

$ helm install ingress-nginx nginx-stable/nginx-ingress --namespace ingress-nginx --create-namespace
$ helm uninstall ingress-nginx --namespace ingress-nginx


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/baremetal/deploy.yaml

```

## Nginx ingress tls

```
$ kubectl create namespace kpcard-development

# nginx deploy
$ kubectl apply -f nginx-deploy-svc.yaml

# hello kubernetes deploy
$ kubectl apply -f hello-deploy-svc.yaml

# custom kubernetes deploy
$ kubectl apply -f custom-deploy-svc.yaml

# secret tls deploy
$ kubectl apply -f palrago-secret-tls.yaml
$ kubectl apply -f prepaidcard-secret-tls.yaml

# nginx ingress tls deploy
$ kubectl apply -f tls-ingress.yaml

http://nginx.palrago.com/
https://nginx.palrago.com/
http://nginx.palrago.local/
http://nginx.prepaidcard.co.kr/
https://nginx.prepaidcard.co.kr/
```
