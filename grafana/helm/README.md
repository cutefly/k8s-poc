# Grafana Dashboard

> https://github.com/grafana/helm-charts/tree/main/charts/grafana

## installation

```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana --namespace monitoring --create-namespace -f values.yaml
helm upgrade grafana grafana/grafana --namespace monitoring -f values.yaml

$ helm uninstall grafana -n grafana

http://grafana.k8s.local:32080/
```

## ingress 설정

```yaml
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: "nginx"
  hosts:
    - "grafana.k8s.local"
```

## persistent volume 설정

```yaml
persistence:
  type: pvc
  enabled: true
  # storageClassName: ""
```

## 기타

```
default datasource
default dashboardProvider, dashboard...
```
