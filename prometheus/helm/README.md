helm repo add prometheus-community https://prometheus-comm
unity.github.io/helm-charts

helm install kpc prometheus-community/prometheus -n monitoring --create-namespace -f values.yaml
helm uninstall kpc -n monitoring

오류 처리
nodeExporter:
hostRootfs: false

추가설정
http://lens-prometheus-server.monitoring.svc.cluster.local/
kpcard-mongodb-metrics.mongodb-cluster.svc.cluster.local
exporter 추가를 위해 annotation을 추가

failed to try resolving symlinks in path "/var/log/pods/lens-metrics_lens-prometheus-node-exporter-s5gmd_51a3c4d1-d835-4526-be66-78f5403990a6/prometheus-node-exporter/5.log": lstat /var/log/pods/lens-metrics_lens-prometheus-node-exporter-s5gmd_51a3c4d1-d835-4526-be66-78f5403990a6/prometheus-node-exporter/5.log: no such file or directory
