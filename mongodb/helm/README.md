# MongoDB with helm

> <https://docs.bitnami.com/kubernetes/infrastructure/mongodb/get-started/install/>

## installation

```sh
# repository 지정
helm repo add bitnami https://charts.bitnami.com/bitnami

# mongodb-cluster 설치
helm install mongodb bitnami/mongodb -n mongodb-cluster --create-namespace -f values.yaml
helm upgrade mongodb bitnami/mongodb -n mongodb-cluster -f values.yaml

# mongodb-cluster 삭제
$ helm uninstall mongodb -n mongodb-cluster
$ kubectl -n mongodb-cluster delete pvc --all

# busy box
$ kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=mongodb-cluster -- sh

# temporary mongosh
$ kubectl run -it --rm mongosh --image=mongo:5 --restart=Never --namespace=mongodb-cluster -- bash

kubectl exec -it -n mongodb-cluster mongodb-0 -- mongosh
kpcard-mongodb-0.kpcard-mongodb-headless.mongodb-cluster.svc.cluster.local
```

## NodePort 설정

```yaml
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

## MongoDB 클러스터 이슈

```text
1. 최초 Cluster 구성 시 정상 동작(NodePort)
- Pod가 순차적으로 생성되며 "-0" Pod는 Primary, 기타는 Secondary로 생성됨
2. 일부 Pod가 종료된 경우 자동 재생성되면 Priority에 따라 Primary 자동 복원
3. 모든 Pod 종료된 후 재구동되는 경우 Replication 구성이 멈춤(Primary가 없는 상태)
- 아래 조치 방법에 따라 Priority를 수정하여 Replication Set을 재구성함.
4. Cluster를 삭제 후 재생성 시 클러스터 구성이 작동안함
- Pod가 순차적으로 생성이 되다보니 Secondary가 없어 Primary 생성이 중단됨.
- ReadinessProbe에서 정상상태로 인식하지 않음.
- ReadinessProbe를 Disable하여 재생성
```

### 재시작 후 정상 동작이 불가한 경우 조치 방안

```sh
# Priority를 변경하여 Replication Set이 재구성되도록 함.
# https://stackoverflow.com/questions/47439781/mongodb-replica-set-member-state-is-other
$ kubectl run -it --rm mongosh --image=bitnami/mongodb:5.0.13-debian-11-r12 --restart=Never --namespace=mongodb-cluster -- bash

/# mongosh --host docker-desktop --port 32017 -u kpcadmin -p kpcard
cfg = rs.conf()
cfg.members[0].priority = 5 <=> 1
cfg.members[1].priority = 1
cfg.members[2].priority = 1 <=> 5
rs.reconfig(cfg, {force: true})
rs.config()

# 운영 중일 때는 각 member별 priority가 동일해야 함.

$ kubectl exec -it  mongosh --namespace=mongodb-cluster -- bash
/# mongosh --host docker-desktop --port 32019 -u kpcadmin -p kpcard
```
