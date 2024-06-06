# Key cloak

> https://github.com/bitnami/charts/tree/main/bitnami/keycloak

## Installation

```sh
To install Keycloak using Helm chart, follow these steps:

Add the Bitnami repository:
$ helm repo add bitnami https://charts.bitnami.com/bitnami

Install Keycloak using the Helm chart:
$ helm install keycloak bitnami/keycloak --namespace keycloak --create-namespace -f values.yaml
$ helm upgrade keycloak bitnami/keycloak --namespace keycloak -f values.yaml

This will install Keycloak using the Bitnami Helm chart with the release name "my-keycloak". You can customize the installation by providing additional configuration values

# 제거
$ helm uninstall keycloak --namespace keycloak

```
