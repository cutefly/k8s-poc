# MySQL Statefulset

> https://blog.knoldus.com/how-to-deploy-mysql-statefulset-in-kubernetes/

## persitent volume

```
$ kubectl create namespace mysql
$ kubectl get ns

$ kubectl apply -f sc.yaml
$ kubectl get sc

# /storage/mysql volume 생성
$ kubectl apply -f pv.yaml
$ kubectl get pv

# secret 생성은 다음 스텝에서

$ kubectl apply -n mysql -f mysql-statefulset.yaml
$ kubectl get pods -n mysql

$ kubectl apply -n mysql -f mysql-service.yaml
$ kubectl get service -n mysql

```
