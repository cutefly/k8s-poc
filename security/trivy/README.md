# Trivy

## installation

> https://github.com/aquasecurity/trivy-operator

```
$ helm repo add aqua https://aquasecurity.github.io/helm-charts/
$ helm repo update

helm install trivy-operator aqua/trivy-operator \
     --namespace trivy-system \
     --create-namespace \
     --version 0.23.3 \
     -f values.yaml

helm upgrade trivy-operator aqua/trivy-operator \
     --namespace trivy-system \
     --version 0.23.3 \
     -f values.yaml

helm uninstall trivy-operator --namespace trivy-system
```

```
NAME: trivy-operator
LAST DEPLOYED: Wed Jun 19 18:59:53 2024
NAMESPACE: trivy-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
You have installed Trivy Operator in the trivy-system namespace.
It is configured to discover Kubernetes workloads and resources in
all namespace(s).

Inspect created VulnerabilityReports by:

    kubectl get vulnerabilityreports --all-namespaces -o wide

Inspect created ConfigAuditReports by:

    kubectl get configauditreports --all-namespaces -o wide

Inspect the work log of trivy-operator by:

    kubectl logs -n trivy-system deployment/trivy-operator
```

## Monitoring

> https://aquasecurity.github.io/trivy-operator/v0.12.1/tutorials/grafana-dashboard/

grafana dashboard ID : 17813
