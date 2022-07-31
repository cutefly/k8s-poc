# MongoDB Statefulset

> https://blog.knoldus.com/how-to-deploy-mongodb-cluster-on-kubernetes/

## persitent volume

```
$ kubectl create namespace mongodb
$ kubectl get ns

$ kubectl apply -f sc.yaml
$ kubectl get sc

# /storage/mongodb volume 생성
$ kubectl apply -f pv.yaml
$ kubectl get pv

$ kubectl apply -n mongodb -f mongodb-config.yaml

$ kubectl apply -n monogodb -f monogodb-statefulset.yaml
$ kubectl get pods -n monogodb

$ kubectl apply -n monogodb -f monogodb-service.yaml
$ kubectl get service -n monogodb
```
