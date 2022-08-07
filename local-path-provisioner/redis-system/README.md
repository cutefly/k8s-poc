```
$ kubectl create namespace redis-system
$ kubectl get ns

$ kubectl apply -n redis-system -f redis-config.yaml
$ kubectl get configmap -n redis-system

$ kubectl apply -n redis-system -f redis-statefulset.yaml
$ kubectl get pods -n redis-system

$ kubectl apply -n redis-system -f redis-service.yaml
$ kubectl get service -n redis-system
```
