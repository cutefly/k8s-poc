# Redis with helm(Master & replication with sentinel)

> https://github.com/bitnami/charts/tree/main/bitnami/redis-cluster

## installation

```sh
# repository 지정
helm repo add bitnami https://charts.bitnami.com/bitnami

# redis-cluster 설치
helm install kpcard bitnami/redis-cluster -n redis-cluster --create-namespace -f values.yaml
helm upgrade kpcard bitnami/redis-cluster -n redis-cluster --create-namespace -f values.yaml

# redis-cluster 삭제
helm uninstall kpcard -n redis-cluster

# redis-sentinel 설치
helm install redis-sentinel bitnami/redis -n redis-sentinel --create-namespace -f values-sentinel.yaml
helm upgrade redis-sentinel bitnami/redis -n redis-sentinel --create-namespace -f values-sentinel.yaml

# redis-cluster 삭제
helm uninstall redis-sentinel -n redis-sentinel

```

# Test

```sh
# 1. busybox를 이용한 연결 테스트
$ kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=redis-cluster -- sh
/ # telnet kpcard-redis-cluster 6379
Connected to kpcard-redis-cluster
PING
+PONG

# 2. redis-cli를 이용한 redis command 실행
$ kubectl run -it --rm redis-cli --image=bitnami/redis:7.0.9 --restart=Never --namespace=redis-cluster -- bash
I have no name!@redis-cli:/$ redis-cli -h kpcard-redis-cluster -c
kpcard-redis-cluster:6379> cluster nodes
kpcard-redis-cluster:6379> set user1 value
# master가 아닌 경우 master로 redirect됨
10.1.1.184:6379> get user1

# cluster nodes 바로 확인
I have no name!@redis-cli:/$ redis-cli -h kpcard-redis-cluster -c cluster nodes
```

## Monitoring

```yaml
metrics:
  enabled: true
```

### Note

```
TO DO:
Redis cluster를 외부에서 사용하기 위해서는 LoadBalancer를 이용한 NodeType이 정의되어야 함.
Redis cluster내의 Node들의 Public한 주소를 가지고 있어야 client가 cluster 모드로 동작할 수 있음.

방법은 계속 검토가 필요함.
```
