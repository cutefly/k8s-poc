# Minikube cluster

## multiple cluster(by profile)

```
# Profile 1
$ minikube profile test
$ minikube start -p test
$ minikube stop

$ minikube profile deploy
$ minikube start -p deploy
$ minikube stop

# set default profile
$ minikube profile test
```

```
multiple node cluster
$ minikube start --nodes 3

change memory and cpu
minikube start --memory 8192 --cpus 4

kubectl taint nodes minikube node-role.kubernetes.io/control-plane:NoSchedule node-role.kubernetes.io/master:NoSchedule

```
