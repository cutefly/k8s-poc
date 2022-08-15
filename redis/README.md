# Redis cluster on kubernetes

## create k8s cluster(redis)

```sh
$ minikube profile redis
$ minikube start -p redis
$ minikube stop
```

## redis custer on kubernetes

> https://www.containiq.com/post/deploy-redis-cluster-on-kubernetes

```
$ kubectl create namespace redis
$ kubectl get ns

$ kubectl apply -f sc.yaml
$ kubectl get sc

$ kubectl apply -f pv.yaml
$ kubectl get pv

$ kubectl apply -n redis-system -f redis-config.yaml
$ kubectl get configmap -n redis

$ kubectl apply -n redis-system -f redis-statefulset.yaml
$ kubectl get pods -n redis

$ kubectl apply -n redis-system -f redis-service.yaml
$ kubectl get service -n redis
```

## Test redis

```
# playground 네임스페이스 생성
# kubectl create namespace playground

# defalt 네임스페이스에서는 redis 네임스페이스에 있는 redis 서비스 접근 불가
# kubectl run -it --rm busybox --image=busybox --restart=Never -- sh
/> ping redis <= error

# redis 네임스페이스에서는 redis 네임스페이스에 있는 redis 서비스 접근 가능
# kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=redis -- sh
/> telnet redis 6379
PING
PONG

# playground 네임스페이스에서 redis 네임스페이스에 있는 redis 서비스를 ExternalService로 등록
# playground 네임스페이스에서는 playground 네임스페이스에 있는 redis 서비스 접근 가능
# kubectl apply -n playground -f redis-service-playground.yaml
# kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=playground -- sh
/> telnet redis 6379
PING
PONG
```
