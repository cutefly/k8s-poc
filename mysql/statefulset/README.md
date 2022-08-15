# MySQL Statefulset

```
# mysql statefulset(replication)
> https://blog.knoldus.com/how-to-deploy-mysql-statefulset-in-kubernetes/

# mysql statefulset(xtrabackup)
> https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/
```

## MySQL server

```
$ kubectl create namespace mysql-system
$ kubectl get ns

# Dynamic PV 사용시 불필요
$ kubectl apply -f sc.yaml
$ kubectl get sc

# Dynamic PV 사용시 불필요
# /storage/mysql volume 생성
$ kubectl apply -f pv.yaml
$ kubectl get pv

# config 생성
$ kubectl apply -n mysql-system -f mysql-config.yaml
$ kubectl get configmap -n mysql-system

$ kubectl apply -n mysql-system -f mysql-statefulset.yaml
$ kubectl get pods -n mysql-system

$ kubectl apply -n mysql-system -f mysql-service.yaml
$ kubectl get service -n mysql-system
```

## mysql-client

```
kubectl exec -it -n mysql-system mysql-0 -- sh
```
