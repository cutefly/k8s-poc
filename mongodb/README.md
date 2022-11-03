# MongoDB Statefulset

## References

```
> https://blog.knoldus.com/how-to-deploy-mongodb-cluster-on-kubernetes/
> https://medium.com/@shubhamdhote9717/mongodb-deployment-on-kubernetes-cluster-via-deploymentset-and-statefulset-6ca649894ca7
> https://www.cloudblogg.com/kubernetes/google-kubernetes-engine-running-a-mongodb-database-in-kubernetes-with-statefulsets/

# 최종 참고 URL
https://www.caseywylie.io/kubernetes/mongodb-stateful-set/
```

## minikube 준비

```
$ minikube start -p mongodb
$ minikube profile list
$ minikube stop -p mongodb
$ minikube start -p mongodb
```

## persitent volume

```
$ kubectl create namespace mongodb-system
$ kubectl get ns

$ kubectl apply -f sc.yaml
$ kubectl get sc

# /storage/mongodb volume 생성
$ kubectl apply -f pv.yaml
$ kubectl get pv

# bitami 대신 공식 이미지로 구현
$ kubectl apply -n mongodb-system -f mongodb-statefulset.yaml
$ kubectl get pods -n mongodb-system

$ kubectl apply -n mongodb-system -f mongodb-service.yaml
$ kubectl get service -n mongodb-system
```

## Configure

```
$ kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=mongodb-system -- sh
ping mongodb-0.mongodb.mongodb-system.svc.cluster.local
```


```sh
$ kubectl exec -it -n mongodb-system mongodb-0 -- mongo

# initialize mongodb cluster
MainRepSet:PRIMARY> rs.initiate({
_id: "MainRepSet",
members: [
    { _id: 0, host: "mongodb-0.mongodb.mongodb-system.svc.cluster.local:27017"
    },
    { _id: 1, host: "mongodb-1.mongodb.mongodb-system.svc.cluster.local:27017"
    },
    { _id: 2, host: "mongodb-2.mongodb.mongodb-system.svc.cluster.local:27017"
    }]
})

# insert data
MainRepSet:PRIMARY> db.local.insert({"name":"dbot"})

# find data
MainRepSet:PRIMARY> db.local.find()
{ "_id" : ObjectId("62e7c88ef6a4ad93a24f54b8"), "name" : "dbot" }




$ kubectl exec -it -n mongodb-system mongodb-1 -- mongo
MainRepSet:SECONDARY> rs.secondaryOk()
MainRepSet:SECONDARY> db.local.find()
{ "_id" : ObjectId("62e7c88ef6a4ad93a24f54b8"), "name" : "dbot" }


$ kubectl exec -it -n mongodb-system mongodb-2 -- mongo
MainRepSet:SECONDARY> rs.secondaryOk()
MainRepSet:SECONDARY> db.local.find()
{ "_id" : ObjectId("62e7c88ef6a4ad93a24f54b8"), "name" : "dbot" }
```
