# RabbitMQ Operator

> https://www.rabbitmq.com/kubernetes/operator/quickstart-operator.html

```
$ kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

$ kubectl create namespace rabbitmq

# https://www.rabbitmq.com/kubernetes/operator/using-operator.html#create
$ kubectl apply -n rabbitmq -f rabbitmq-cluster.yaml

```
