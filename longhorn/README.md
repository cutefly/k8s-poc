# Longhorn(Block Storage System)

## Installation

> https://github.com/longhorn/charts

```sh
$ helm repo add longhorn https://charts.longhorn.io
$ helm repo update

$ helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace -f values.yaml
$ helm upgrade longhorn longhorn/longhorn --namespace longhorn-system -f values.yaml
```

## Uninstall

```sh
$ kubectl -n longhorn-system patch -p '{"value": "true"}' --type=merge lhs deleting-confirmation-flag
$ helm uninstall longhorn -n longhorn-system
$ kubectl delete namespace longhorn-system
```
