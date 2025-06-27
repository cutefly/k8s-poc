# MySQL

## Installation

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mysql bitnami/mysql -n mysql-system --create-namespace -f values.yaml
helm upgrade mysql bitnami/mysql -n mysql-system -f values.yaml

helm delete mysql -n mysql-system
kubectl delete ns mysql-system
```

## mysql client

```sh
kubectl run --rm -it mysql-client --image=mysql -n mysql-system -- bash

kubectl exec -it mysql-primary-0 -n mysql-system -- mysql -u root -p
kubectl exec -it mysql-secondary-0 -n mysql-system -- mysql -u root -p

mysql> create database longhorn;
mysql> create user 'pi'@'%' identified by 'offspring';
mysql> grant all privileges on longhorn.* to 'pi'@'%' identified by 'offspring';
```
