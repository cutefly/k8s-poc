# Prometheus 설치

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install kpc prometheus-community/prometheus -n monitoring --create-namespace -f values.yaml
helm upgrade kpc prometheus-community/prometheus -n monitoring -f values.yaml
helm uninstall kpc -n monitoring
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
