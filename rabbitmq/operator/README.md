# RabbitMQ Operator

> https://www.rabbitmq.com/kubernetes/operator/quickstart-operator.html

```
$ kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

$ kubectl apply -f cluster-operator.yml

$ kubectl create namespace rabbitmq

# https://www.rabbitmq.com/kubernetes/operator/using-operator.html#create
$ kubectl apply -n rabbitmq -f rabbitmq-cluster.yaml
```

## client test

### Credentail 확인

```sh
$ kubectl get -n rabbitmq rabbitmqcluster rabbitmqcluster -ojsonpath='{.status.defaultUser.secretReference.name}'
$ kubectl -n rabbitmq get secret rabbitmqcluster-default-user -o jsonpath="{.data.password}" | base64 --decode
```

```sh
$ kubectl run -it --rm rabbitmq-client --image=ubuntu:18.04 --restart=Never --namespace=rabbitmq -- bash
root@rabbitmq-client:/# apt-get update
root@rabbitmq-client:/# apt-get install -y curl ca-certificates amqp-tools python dnsutils

root@rabbitmq-client:/# nslookup rabbitmqcluster
root@rabbitmq-client:/# env | grep RABBIT | grep HOST
```

### 대기열 생성

```sh
# rabbitmq-service는 호스트(서비스)네임이다. 5672는 rabbitmq의 표준 포트이다.

root@rabbitmq-client:/# export BROKER_URL=amqp://rabbitmqcluster-default-user:2TqhJ3rIbGpp9bCwevdevtkdjiN6GMop@rabbitmqcluster:5672
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
