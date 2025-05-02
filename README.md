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

## minikube on oracle cloud

> 2025년 4월 29일 현재 배포 상황

```sh
$ minikube start \
  --memory 8192 --cpus 4 --network-plugin=cni --cni=calico --apiserver-ips=144.24.74.72 \
  --extra-config=apiserver.oidc-issuer-url=https://keycloak.club012.com/realms/ldap-realm \
  --extra-config=apiserver.oidc-username-claim=preferred_username \
  --extra-config=apiserver.oidc-groups-claim=groups \
  --extra-config=apiserver.oidc-client-id=k8s-client
```

```text
변경이 필요한 옵션
--container-runtime=containerd
--extra-config=scheduler.bind-address=0.0.0.0 \
--extra-config=controller-manager.bind-address=0.0.0.0

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
