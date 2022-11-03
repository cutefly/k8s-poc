# MongoDB with helm

> https://docs.bitnami.com/kubernetes/infrastructure/mongodb/get-started/install/

```sh
# repository 지정
helm repo add bitnami https://charts.bitnami.com/bitnami

# mongodb-cluster 설치
helm install kpcard bitnami/mongodb -n mongodb-cluster --create-namespace -f values.yaml
helm upgrade kpcard bitnami/mongodb -n mongodb-cluster --create-namespace -f values.yaml

# mongodb-cluster 삭제
helm uninstall kpcard -n mongodb-cluster

# temporary mongosh
$ kubectl run -it --rm mongosh --image=mongo --restart=Never --namespace=mongodb-cluster -- bash

kubectl exec -it -n mongodb-cluster kpcard-mongodb-0 -- mongosh

kpcard-mongodb-0.kpcard-mongodb-headless.mongodb-cluster.svc.cluster.local

rs.initiate({
_id: "MainRepSet",
members: [
    { _id: 0, host: "kpcard-mongodb-0.kpcard-mongodb-headless.mongodb-cluster.svc.cluster.local:27017"
    },
    { _id: 1, host: "kpcard-mongodb-1.kpcard-mongodb-headless.mongodb-cluster.svc.cluster.local:27017"
    },
    { _id: 2, host: "kpcard-mongodb-2.kpcard-mongodb-headless.mongodb-cluster.svc.cluster.local:27017"
    }]
})

rs.initiate({
_id: "MainRepSet",
members: [
    { _id: 0, host: "192.168.65.4:30017"
    },
    { _id: 1, host: "192.168.65.4:30018"
    },
    { _id: 2, host: "192.168.65.4:30019"
    }]
})

rs.add("192.168.65.4:30018")
rs.add("192.168.65.4:30019")

```
