# Key cloak

> https://github.com/bitnami/charts/tree/main/bitnami/keycloak

## Installation(bitnami)

> https://honglab.tistory.com/265

```
(이 때, 버전을 15.1.8로 명시해야됨 (키클락 버전 21 의 제일 최신 차트임)

왜냐면 차트버전 16, 17은 키클락 버전 22인데 어드민 콘솔 페이지 이슈가 있다.)
```

```sh
To install Keycloak using Helm chart, follow these steps:

Add the Bitnami repository:
$ helm repo add bitnami https://charts.bitnami.com/bitnami

Install Keycloak using the Helm chart:
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml --version 15.1.8
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml
$ helm upgrade keycloak bitnami/keycloak --namespace keycloak -f values.yaml

This will install Keycloak using the Bitnami Helm chart with the release name "my-keycloak". You can customize the installation by providing additional configuration values

# 제거
$ helm uninstall keycloak --namespace keycloak
```

## Installation(codecentric)

> https://github.com/codecentric/helm-charts/tree/master/charts/keycloak

```text
ARM64에서 이슈가 있음.
Postgresql을 외부 DB로 사용하는 경우 가능할 것으로 보임.
```

## oidc helper plugin

```
krew(plugin manager) 설치
kubelogin 설치
kubectl oidc-login get-token--oidc-issuer-url=https://keycloak.club012.com/realms/ldap-realm --oidc-client-id=k8s-client --oidc-client-secret=gnY7tTVOo7MN4GUqmBH7ex43lK7dn2aO --grant-type=password
```

## Minikube 연동

```sh
minikube start
    --memory 8192 
    --cpus 4 
    --network-plugin=cni 
    --cni=calico 
    --apiserver-ips=144.24.74.72
    --extra-config=apiserver.oidc-issuer-url=https://keycloak.club012.com/realms/ldap-realm
    --extra-config=apiserver.oidc-username-claim=preferred_username
    --extra-config=apiserver.oidc-groups-claim=groups
    --extra-config=apiserver.oidc-client-id=k8s-client
```
