# PostgreSQL

> <https://github.com/bitnami/charts/tree/main/bitnami/postgresql>

## Install on k3s

```sh
# install postgresql
helm install gpgc oci://registry-1.docker.io/bitnamicharts/postgresql --version 16.7.26 --create-namespace -n postgres-system -f values.yaml

# upgrade postgresql
helm upgrade gpgc oci://registry-1.docker.io/bitnamicharts/postgresql --version 16.7.26 -n postgres-system -f values.yaml

# uninstall postgresql
helm uninstall gpgc -n postgres-system
```

## Collation

```
기본값(en_UR.UTF-8) : 한글, 숫자, 영문(대소문자 구분안함)
ko-KR : 숫자, 한글, 영문(대소문자 구분안함)
ko-kr-x-icu : 숫자, 한글, 영문(대소문자 구분안함)
```
