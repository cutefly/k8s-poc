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

$ kubectl apply -n redis -f redis-config.yaml
$ kubectl get configmap -n redis

$ kubectl apply -n redis -f redis-statefulset.yaml
$ kubectl get pods -n redis

$ kubectl apply -n redis -f redis-service.yaml
$ kubectl get service -n redis
```

## Test redis

```

```
