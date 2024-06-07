# Key cloak

> https://github.com/bitnami/charts/tree/main/bitnami/keycloak

## Installation

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
$ helm install keycloak bitnami/keycloak --namespace auth --create-namespace -f values.yaml --version 15.1.8
$ helm upgrade keycloak bitnami/keycloak --namespace auth -f values.yaml

This will install Keycloak using the Bitnami Helm chart with the release name "my-keycloak". You can customize the installation by providing additional configuration values

# 제거
$ helm uninstall keycloak --namespace auth

```
