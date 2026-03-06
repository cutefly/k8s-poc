# OpenLDAP on kubernetes

> https://github.com/jp-gouin/helm-openldap

## installation

> ARM64에서 동작하지 않음.

```sh
$ helm repo add helm-openldap https://jp-gouin.github.io/helm-openldap/

$ helm install openldap helm-openldap/openldap-stack-ha --namespace keycloak --create-namespace -f values.yaml
$ helm upgrade openldap helm-openldap/openldap-stack-ha --namespace keycloak -f values.yaml

# 제거
$ helm uninstall openldap --namespace keycloak
```
