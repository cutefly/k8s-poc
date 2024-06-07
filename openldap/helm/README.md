# OpenLDAP on kubernetes

> https://github.com/jp-gouin/helm-openldap

## installation

```sh
$ helm repo add helm-openldap https://jp-gouin.github.io/helm-openldap/

$ helm install openldap helm-openldap/openldap-stack-ha --namespace auth --create-namespace -f values.yaml
$ helm upgrade openldap helm-openldap/openldap-stack-ha --namespace auth -f values.yaml

# 제거
$ helm uninstall openldap --namespace auth
```
