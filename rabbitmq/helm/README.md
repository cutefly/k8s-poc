# RabbitMQ Helm chart

> https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq/#installing-the-chart

```sh
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install rabbimq-server bitnami/rabbitmq

$ helm install -n rabbitmq-system -f values.yaml kpc bitnami/rabbitmq
```