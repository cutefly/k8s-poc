# RabbitMQ Helm chart

> https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq/#installing-the-chart
https://github.com/bitnami/charts/blob/master/bitnami/rabbitmq/values.yaml

```sh
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install rabbimq-server bitnami/rabbitmq

$ helm install -n rabbitmq-system -f values.yaml rabbitmq bitnami/rabbitmq
$ helm uninstall -n rabbitmq-system rabbitmq
```

```text
$ kubectl create namespace rabbitmq-helm
$ helm install -n rabbitmq-helm -f values.yaml rabbitmq bitnami/rabbitmq
NAME: rabbitmq
LAST DEPLOYED: Sat Sep 17 08:28:56 2022
NAMESPACE: rabbitmq-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: rabbitmq
CHART VERSION: 10.3.5
APP VERSION: 3.10.7** Please be patient while the chart is being deployed **

Credentials:
    echo "Username      : user"
    echo "Password      : $(kubectl get secret --namespace rabbitmq-system rabbitmq-cluster -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
    echo "ErLang Cookie : $(kubectl get secret --namespace rabbitmq-system rabbitmq-cluster -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"

Note that the credentials are saved in persistent volume claims and will not be changed upon upgrade or reinstallation unless the persistent volume claim has been deleted. If this is not the first installation of this chart, the credentials may not be valid.
This is applicable when no passwords are set and therefore the random password is autogenerated. In case of using a fixed password, you should specify it when upgrading.
More information about the credentials may be found at https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues/#credential-errors-while-upgrading-chart-releases.

RabbitMQ can be accessed within the cluster on port 5672 at rabbitmq-cluster.rabbitmq-system.svc.cluster.local

To access for outside the cluster, perform the following steps:

To Access the RabbitMQ AMQP port:

1. Create a port-forward to the AMQP port:

    kubectl port-forward --namespace rabbitmq-system svc/rabbitmq-cluster 5672:5672 &
    echo "URL : amqp://127.0.0.1:5672/"

2. Access RabbitMQ using using the obtained URL.

To Access the RabbitMQ Management interface:

1. Get the RabbitMQ Management URL and associate its hostname to your cluster external IP:

   export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters
   echo "RabbitMQ Management: http://mq-admin.k8s.local/"
   echo "$CLUSTER_IP  mq-admin.k8s.local" | sudo tee -a /etc/hosts

2. Open a browser and access RabbitMQ Management using the obtained URL.
chris@xps13plus:~/Documents/docker-workspace/k8s-poc/rabbitmq/helm$ helm uninstall -n rabbitmq-system rabbitmq
release "rabbitmq" uninstalled
chris@xps13plus:~/Documents/docker-workspace/k8s-poc/rabbitmq/helm$ kubectl get pvc -n rabbitmq-system 
NAME                      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-rabbitmq-cluster-0   Bound    pvc-5642d80a-b409-41f4-83cc-9e7c67a2a16e   8Gi        RWO            hostpath       113s
data-rabbitmq-cluster-1   Bound    pvc-d4b083c2-3481-4bc4-9571-89c6dcb1712b   8Gi        RWO            hostpath       49s
chris@xps13plus:~/Documents/docker-workspace/k8s-poc/rabbitmq/helm$ helm install -n rabbitmq-system -f values.yaml rabbitmq bitnami/rabbitmq
NAME: rabbitmq
LAST DEPLOYED: Sat Sep 17 08:31:38 2022
NAMESPACE: rabbitmq-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: rabbitmq
CHART VERSION: 10.3.5
APP VERSION: 3.10.7** Please be patient while the chart is being deployed **

Credentials:
    echo "Username      : user"
    echo "Password      : $(kubectl get secret --namespace rabbitmq-system rabbitmq-cluster -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
    echo "ErLang Cookie : $(kubectl get secret --namespace rabbitmq-system rabbitmq-cluster -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"

Note that the credentials are saved in persistent volume claims and will not be changed upon upgrade or reinstallation unless the persistent volume claim has been deleted. If this is not the first installation of this chart, the credentials may not be valid.
This is applicable when no passwords are set and therefore the random password is autogenerated. In case of using a fixed password, you should specify it when upgrading.
More information about the credentials may be found at https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues/#credential-errors-while-upgrading-chart-releases.

RabbitMQ can be accessed within the cluster on port 5672 at rabbitmq-cluster.rabbitmq-system.svc.cluster.local

To access for outside the cluster, perform the following steps:

To Access the RabbitMQ AMQP port:

1. Create a port-forward to the AMQP port:

    kubectl port-forward --namespace rabbitmq-system svc/rabbitmq-cluster 5672:5672 &
    echo "URL : amqp://127.0.0.1:5672/"

2. Access RabbitMQ using using the obtained URL.

To Access the RabbitMQ Management interface:

1. Get the RabbitMQ Management URL and associate its hostname to your cluster external IP:

   export CLUSTER_IP=$(minikube ip) # On Minikube. Use: `kubectl cluster-info` on others K8s clusters
   echo "RabbitMQ Management: http://mq-admin.k8s.local/"
   echo "$CLUSTER_IP  mq-admin.k8s.local" | sudo tee -a /etc/hosts

2. Open a browser and access RabbitMQ Management using the obtained URL.
```

### Additional plugins

> https://stackoverflow.com/questions/64246648/install-extra-rabbitmq-plugin-from-github-using-bitnami-rabbitmq-chart

```yaml
# Additional plugins(delayed message exchange)
# https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq
communityPlugins: "https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.10.2/rabbitmq_delayed_message_exchange-3.10.2.ez"
extraPlugins: "rabbitmq_delayed_message_exchange"
```