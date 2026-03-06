# RabbitMQ

## minikubr 준비

```
$ minikube start -p rabbitmq
$ minikube profile list
$ miinikube stop -p rabbitmq
$ minikube start -p rabbitmq
```

## Simple demo

```
https://kubernetes.io/ko/docs/tasks/job/coarse-parallel-processing-work-queue/

kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/release-1.3/examples/celery-rabbitmq/rabbitmq-service.yaml

kubectl create -f https://raw.githubusercontent.com/kubernetes/kubernetes/release-1.3/examples/celery-rabbitmq/rabbitmq-controller.yaml

kubectl apply -n rabbitmq -f rabbitmq-service.yaml
kubectl apply -n rabbitmq -f rabbitmq-controller.yaml

kubectl run -it --rm rabbitmq-client --image=ubuntu:18.04 --restart=Never --namespace=rabbitmq -- bash
```

## client test

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

root@rabbitmq-client:/# export BROKER_URL=amqp://guest:guest@rabbitmq-service:5672
# 이 커맨드를 대신 사용하면 된다.
# root@rabbitmq-client:/# BROKER_URL=amqp://guest:guest@$RABBITMQ_SERVICE_SERVICE_HOST:5672

# 이제 대기열을 생성한다.

root@rabbitmq-client:/# /usr/bin/amqp-declare-queue --url=$BROKER_URL -q foo -d
foo

# 대기열에 메시지를 하나 발행한다.

root@rabbitmq-client:/# /usr/bin/amqp-publish --url=$BROKER_URL -r foo -p -b Hello

# 다시 메시지를 돌려받는다.

root@rabbitmq-client:/# /usr/bin/amqp-consume --url=$BROKER_URL -q foo -c 1 cat && echo
Hello
```
