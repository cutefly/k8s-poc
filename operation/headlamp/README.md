# Headlamp

- Headlamp is a user-friendly Kubernetes UI focused on extensibility

>https://headlamp.dev/

## Install on k8s cluster

```
$ helm repo add headlamp https://headlamp-k8s.github.io/headlamp/
$ helm repo update
$ helm install headlamp headlamp/headlamp --namespace kube-system -f values.yaml
```

```
Release "headlamp" has been upgraded. Happy Helming!
NAME: headlamp
LAST DEPLOYED: Fri Mar 14 18:27:15 2025
NAMESPACE: kube-system
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
  http://headlamp.club012.com/
2. Get the token using
  kubectl create token headlamp --namespace kube-system
```

## To Do

> oidc를 연동한 sso 적용
