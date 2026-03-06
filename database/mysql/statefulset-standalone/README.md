# Non Clustering MySQL StatefulSet

> https://blog.knoldus.com/how-to-deploy-mysql-statefulset-in-kubernetes/

## installation

```
$ echo -n "password" | base64
cGFzc3dvcmQ==

$ kubectl apply -n mysql-system -f secret.yaml
$ kubectl apply -n mysql-system -f service.yaml
$ kubectl apply -n mysql-system -f statefulset.yaml

$ kubectl exec -it -n mysql-system mysql-0 -- sh

$ kubectl run --rm -it mysql-client --image=mysql -n mysql-system -- bash
bash-4.4# mysql -h mysql -u root -p
bash-4.4# mysql -h mysql-0.mysql.mysql-system.svc.cluster.local -u root -p
```
