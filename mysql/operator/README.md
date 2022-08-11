# MySQL Cluster Operator

> https://github.com/mysql/mysql-operator

## Operator를 이용한 cluster 설치

```sh
# Operator CRD 설치
$> kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/trunk/deploy/deploy-crds.yaml
$> kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/trunk/deploy/deploy-operator.yaml

# root Secret 생성
$> kubectl create secret generic rootpwd \
 --from-literal=rootUser=root \
 --from-literal=rootHost=% \
 --from-literal=rootPassword="kpcard"

$> kubectl create -n mysql-system -f mysql-root-secret.yaml

# mysql cluster 생성
$> kubectl apply -n mysql-system -f mysql-cluster.yaml
innodbcluster.mysql.oracle.com/mysql-cluster created
# mysql cluster 추가 옵션 메뉴얼
https://dev.mysql.com/doc/mysql-operator/en/mysql-operator-innodbcluster-common.html
```

## MySQL Client 연결

```
kubectl run --rm -it myshell --image=mysql/mysql-operator -n mysql-system -- mysqlsh
kubectl run --rm -it mysql-client --image=mysql -n mysql-system -- bash
```
