# RabbitMQ

## minikubr 준비

```
$ minikube start -p rabbitmq
$ minikube profile list
$ minikube profile rabbitmq
$ miinikube stop
$ minikube profile rabbitmq
$ minikube start
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
