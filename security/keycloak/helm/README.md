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
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml --version 24.7.3
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml
$ helm upgrade keycloak bitnami/keycloak --namespace keycloak -f values.yaml

This will install Keycloak using the Bitnami Helm chart with the release name "my-keycloak". You can customize the installation by providing additional configuration values

# 제거
$ helm uninstall keycloak --namespace keycloak
```

### 중요사항

```
reverse proxy(nginx proxy manager)를 사용하는 경우에는 proxy: edge 설정 추가
```

### oidc helper plugin

```
krew(plugin manager) 설치
kubelogin 설치
kubectl oidc-login get-token --oidc-issuer-url=https://keycloak.club012.com/realms/ldap-realm --oidc-client-id=k8s-client --oidc-client-secret=V60CJsW6vdg8WkFn2Pu658YSO6UmBUhv --grant-type=password
```

### Minikube 연동

```
# Openldap 연동
https://hs-note.tistory.com/23

# kubernetes 연동
https://wlsdn3004.tistory.com/62
```

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

