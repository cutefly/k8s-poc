# OpenLDAP on kubernetes

> https://artifacthub.io/packages/helm/symas-openldap/openldap

## installation

```sh
$ helm repo add symas-openldap https://symas.github.io/helm-openldap/

$ helm install openldap symas-openldap/openldap --namespace keycloak --create-namespace -f values.yaml
$ helm upgrade openldap symas-openldap/openldap --namespace keycloak -f values.yaml

# 제거
$ helm uninstall openldap --namespace keycloak
```
