# RabbitMQ Operator

> https://www.rabbitmq.com/kubernetes/operator/quickstart-operator.html

```
$ kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

$ kubectl apply -f cluster-operator.yml
$ kubectl delete -f cluster-operator.yml

# https://www.rabbitmq.com/kubernetes/operator/using-operator.html#create
$ kubectl apply -n rabbitmq-system -f rabbitmq-cluster.yaml
$ kubectl delete -n rabbitmq-system -f rabbitmq-cluster.yaml
```

## client test

### Credential 확인

```sh
$ kubectl get -n rabbitm-system rabbitmqcluster rabbitmqcluster -ojsonpath='{.status.defaultUser.secretReference.name}'
$ kubectl -n rabbitm-system get secret rabbitmqcluster-default-user -o jsonpath="{.data.password}" | base64 --decode
```

```sh
$ kubectl run -it --rm rabbitmq-client --image=ubuntu:18.04 --restart=Never --namespace=rabbitmq-system -- bash
root@rabbitmq-client:/# apt-get update
root@rabbitmq-client:/# apt-get install -y curl ca-certificates amqp-tools python dnsutils

root@rabbitmq-client:/# nslookup rabbitmqcluster
root@rabbitmq-client:/# env | grep RABBIT | grep HOST
```

### 대기열 생성

```sh
# rabbitmq-service는 호스트(서비스)네임이다. 5672는 rabbitmq의 표준 포트이다.

export RABBITMQ_USER="default_user_zgbxqRcP5LAqbl2orx0"
export RABBITMQ_PASS="9UHO-hn49tnftR327IRR6__b3Z8cjfBQ"
root@rabbitmq-client:/# export BROKER_URL=amqp://$RABBITMQ_USER:$RABBITMQ_PASS@rabbitmqcluster:5672
# 이 커맨드를 대신 사용하면 된다.
# root@rabbitmq-client:/# BROKER_URL=amqp://guest:guest@$RABBITMQCLUSTER_SERVICE_HOST:5672

# 이제 대기열을 생성한다.

root@rabbitmq-client:/# /usr/bin/amqp-declare-queue --url=$BROKER_URL -q foo -d
foo

# 대기열에 메시지를 하나 발행한다.

root@rabbitmq-client:/# /usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b Hello

# 다시 메시지를 돌려받는다.

root@rabbitmq-client:/# /usr/bin/amqp-consume --url=$BROKER_URL -q foo -c 1 cat && echo
Hello
```


```
kubectl -n rabbitmq-system get secret rabbitmqcluster-default-user -o jsonpath="{.data.password}" | base64 --decode

curl -udefault_user_m0Hp1hdHKp2ZLpKPePn:_vtOVmhMCkK7HpXlLB96aCpUvXFpzjDC localhost:15672/api/overview

default_user_m0Hp1hdHKp2ZLpKPePn
_vtOVmhMCkK7HpXlLB96aCpUvXFpzjDC
```

### How to install plugin

> https://github.com/rabbitmq/cluster-operator/blob/main/docs/examples/community-plugins/rabbitmq.yaml
