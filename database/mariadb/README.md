# MariaDB

## Installation

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mariadb bitnami/mariadb -n mariadb-system --create-namespace -f values.yaml
helm upgrade mariadb bitnami/mariadb -n mariadb-system -f values.yaml

helm delete mariadb -n mariadb-system
kubectl delete ns mariadb-system
```

### values.yaml

```yaml
architecture: standalone

primary:
    persistence:
        enabled: true
        storageClass: longhorn
        size: 8Gi
```

## mariadb client

```sh
kubectl run --rm -it mariadb-client --image=mariadb -n mariadb-system -- bash
```
