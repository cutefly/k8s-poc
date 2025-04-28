# Prometheus 설치


## kube-prometheus-stack(Active)

> helm cahrt : https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

```sh
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f values.yaml
helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml
helm uninstall prometheus -n monitoring
```

## prometheus operator(Inactive)

> operator : https://github.com/prometheus-operator/prometheus-operator

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace -f values.yaml
helm upgrade prometheus prometheus-community/prometheus -n monitoring -f values.yaml
helm uninstall prometheus -n monitoring
```

## 이슈처리

```
오류 처리(Windows Docker desktop 인 경우)
nodeExporter:
  hostRootfs: false

추가설정
http://kpc-prometheus-server.monitoring.svc.cluster.local/
kpcard-mongodb-metrics.mongodb-cluster.svc.cluster.local
exporter 추가를 위해 annotation을 추가
```
