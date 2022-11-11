# Grafana Dashboard

> https://github.com/grafana/helm-charts/tree/main/charts/grafana

## installation

```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install kpcard grafana/grafana --namespace grafana --create-namespace -f values.yaml
helm upgrade kpcard grafana/grafana --namespace grafana --create-namespace -f values.yaml

$ helm uninstall kpcard -n grafana

http://grafana.k9s.local:32080/
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
  # storageClass: ""
```

## 기타

```
default datasource
default dashboardProvider, dashboard...
```
