# Prometheus 설치


## kube-prometheus-stack(Active)

> helm cahrt : https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

```sh
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace --version=70.7.0 -f values.yaml
helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring --version=70.7.0 -f values.yaml
helm uninstall prometheus -n monitoring
```

## Service Monitor(모니터링)

> Prometheus Operator를 사용해 Kubernetes 환경에서 Prometheus 구성하기 : https://nangman14.tistory.com/75

## Granfana dashboard

> minikube 환경으로 인해 일부 metric들은 수집이 되지 않을 수 있습니다.

```
redis overview : https://grafana.com/grafana/dashboards/18345-redis-overview/
redis dashboard : https://grafana.com/grafana/dashboards/763-redis-dashboard-for-prometheus-redis-exporter-1-x/
rabbitmq overview : https://grafana.com/grafana/dashboards/10991-rabbitmq-overview/
```

## Deprecated

### prometheus operator(Inactive)

> operator : https://github.com/prometheus-operator/prometheus-operator

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace -f values.yaml
helm upgrade prometheus prometheus-community/prometheus -n monitoring -f values.yaml
helm uninstall prometheus -n monitoring
```

### 이슈처리

```
오류 처리(Windows Docker desktop 인 경우)
nodeExporter:
  hostRootfs: false

추가설정
http://kpc-prometheus-server.monitoring.svc.cluster.local/
kpcard-mongodb-metrics.mongodb-cluster.svc.cluster.local
exporter 추가를 위해 annotation을 추가
```
