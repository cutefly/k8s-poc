# Minikube cluster

## multiple cluster(by profile)

```sh
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

```sh
# multiple node cluster
$ minikube start --nodes 3

# change memory and cpu
minikube start --memory 8192 --cpus 4

kubectl taint nodes minikube node-role.kubernetes.io/control-plane:NoSchedule node-role.kubernetes.io/master:NoSchedule

```

### 잡다한 정보

```sh
# network tool
kubectl run -it --rm network-tools --image=jonlabelle/network-tools --restart=Never -- bash

# Network-Multitool
kubectl run -it --rm network-tools --image=wbitt/network-multitool --restart=Never -- bash

# busybox
kubectl run -it --rm busybox --image=busybox --restart=Never --namespace=$(NAMESPACE) -- sh
```
