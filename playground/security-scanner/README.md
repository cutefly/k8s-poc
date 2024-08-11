#  Trivy

## install
To install Trivy on Kubernetes using Helm, you can follow these steps:

1. Add the Trivy Helm repository:
```shell
helm repo add aquasecurity https://aquasecurity.github.io/helm-charts
```

2. Update the Helm repositories:
```shell
helm repo update
```

3. Install Trivy using Helm:
```shell
helm install trivy aquasecurity/trivy

helm install trivy-operator aqua/trivy-operator \
    --namespace trivy-system \
    --create-namespace \
    --version 0.23.3 \
    -f values.yaml

helm upgrade trivy-operator aqua/trivy-operator \
    --namespace trivy-system \
    --version 0.23.3 \
    -f values.yaml
```

4. Verify the installation:
```shell
helm list
```

You should see the Trivy release listed in the output.

That's it! Trivy is now installed on your Kubernetes cluster using Helm.

## Scanning Kubernetes Cluster using Trivy

To scan your Kubernetes cluster using Trivy, you can follow these steps:

1. Get the list of running pods in your cluster:
```shell
kubectl get pods -n <namespace>
```
Replace `<namespace>` with the actual namespace where your pods are running.

2. Run Trivy scan on each pod:
```shell
kubectl exec -it <pod-name> -n <namespace> -- trivy image <image-name>
```
Replace `<pod-name>` with the name of the pod you want to scan and `<image-name>` with the name of the image used by the pod.

3. Review the scan results:
Trivy will provide a detailed report on vulnerabilities found in the scanned image. Make sure to review and address any critical vulnerabilities.

That's it! You have successfully scanned your Kubernetes cluster using Trivy.
