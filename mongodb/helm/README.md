# MongoDB with helm

> https://docs.bitnami.com/kubernetes/infrastructure/mongodb/get-started/install/

## installation

```sh
# repository 지정
helm repo add bitnami https://charts.bitnami.com/bitnami

# mongodb-cluster 설치
helm install kpcard bitnami/mongodb -n mongodb-cluster --create-namespace -f values.yaml
helm upgrade kpcard bitnami/mongodb -n mongodb-cluster --create-namespace -f values.yaml

# mongodb-cluster 삭제
$ helm uninstall kpcard -n mongodb-cluster
$ kubectl -n mongodb-cluster delete pvc --all

# busy box
$ kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=mongodb-cluster -- sh

# temporary mongosh
$ kubectl run -it --rm mongosh --image=mongo:5 --restart=Never --namespace=mongodb-cluster -- bash

kubectl exec -it -n mongodb-cluster kpcard-mongodb-0 -- mongosh
kpcard-mongodb-0.kpcard-mongodb-headless.mongodb-cluster.svc.cluster.local
```

## NodePort 설정

```
service:
  type: NodePort
  ports:
    redis: 6379
  # port range(30000~32767)
  nodePorts:
    redis: 32379
```

## Monitoring 설정(Prometheus)

```yaml
metrics:
  enabled: true
```