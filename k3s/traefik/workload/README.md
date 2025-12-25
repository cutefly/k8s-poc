# Deploy workload

## create services

```sh
kubectl create namespace whoami
kubectl apply -n whoami -f whoami.yaml
```

## create httproute

```sh
kubectl apply -n whoami -f whoami-route.yaml
kubectl delete -n whoami -f whoami-route.yaml
```

## club012.com(도메인별 테스트)

```sh
kubectl apply -n whoami -f whoami-nginx.yaml
kubectl apply -n whoami -f whoami-traefik.yaml
```

## crazytrain.xyz(도메인별 테스트)

```sh
kubectl apply -n whoami -f crazytrain-nginx.yaml
kubectl apply -n whoami -f crazytrain-traefik.yaml
```
