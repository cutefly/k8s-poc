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
