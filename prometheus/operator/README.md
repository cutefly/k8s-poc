# Prometheus operator

> https://github.com/prometheus-operator/prometheus-operator

```
kubectl create -f bundle.yaml

for n in $(kubectl get namespaces -o jsonpath={..metadata.name}); do
  kubectl delete --all --namespace=$n prometheus,servicemonitor,podmonitor,alertmanager
done
kubectl delete -f bundle.yaml
```

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

helm install kpcard prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml

helm uninstall kpcard -n monitoring
