# Prometheus 설치


## kube-prometheus-stack(Active)

> helm cahrt : https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm search repo prometheus-community/kube-prometheus-stack

helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace --version=87.17.0 -f values.yaml
helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring --version=87.17.0 -f values.yaml
helm uninstall prometheus -n monitoring
```
