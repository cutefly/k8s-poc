https://github.com/grafana/helm-charts/tree/main/charts/grafana

```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install kpcard grafana/grafana --namespace grafana --create-namespace -f values.yaml

$ helm uninstall kpcard -n grafana

http://grafana.k9s.local:32080/
```
