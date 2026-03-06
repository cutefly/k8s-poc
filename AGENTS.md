# Agent Guide: k8s-poc

This repository is a comprehensive collection of Kubernetes Proof of Concept (POC) deployments and learning materials, primarily focused on Minikube and K3s orchestration. It serves as both a playground for GitOps/SSO/Secret Management integration and a preparation environment for Kubernetes certification (CKA).

## Core Technologies
- **Cluster Orchestration**: Minikube, K3s (Docker-rootless supported)
- **Deployment Tools**: Helm (Bitnami & community charts), Kustomize, Kubectl
- **CI/CD & GitOps**: ArgoCD, Argo Rollouts, Argo CD Image Updater
- **Secret Management**: Hashicorp Vault (Agent Injector, Transit Unseal)
- **Identity Provider**: Keycloak (LDAP/AD integration, OIDC for K8s)
- **Monitoring & Observability**: Prometheus Operator, Grafana, Skywalking
- **Storage**: Longhorn, NFS Storage Provisioner, Local-path Provisioner

---

## Build, Deploy, and Test Commands

### 1. Cluster Setup (Minikube)
The repository uses profiles to isolate different POC environments (e.g., `test`, `deploy`, `argoproj`).
- **Start Cluster**: `minikube start -p <profile-name> --memory 8192 --cpus 4`
- **Oracle Cloud Config**:
  ```sh
  minikube start \
    --memory 8192 --cpus 4 --network-plugin=cni --cni=calico --apiserver-ips=<external-ip> \
    --extra-config=apiserver.oidc-issuer-url=https://keycloak.example.com/realms/ldap-realm \
    --extra-config=apiserver.oidc-username-claim=preferred_username \
    --extra-config=apiserver.oidc-groups-claim=groups \
    --extra-config=apiserver.oidc-client-id=k8s-client
  ```
- **Set Default Profile**: `minikube profile <profile-name>`
- **Enable Ingress**: `minikube addons enable ingress`

### 2. Deployment Patterns
Before making changes, check for a `README.md` or `values.yaml` in the component's subdirectory.
- **Helm Install/Upgrade**:
  ```sh
  # Standard pattern for Helm-based services (e.g., Keycloak, Redis)
  helm upgrade --install <release-name> <chart-path> -f <values-file>.yaml --namespace <ns> --create-namespace
  ```
- **Kustomize Overlays**:
  ```sh
  # Apply environment-specific overlays (e.g., argocd insecure/secure)
  kustomize build kustomize/update-method-argocd/overlays/development | kubectl apply -f -
  ```
- **Kubectl Direct Apply**:
  ```sh
  kubectl apply -f <manifest-directory>/
  ```

### 3. Verification and "Single Test" Procedures
There is no centralized automated test suite. Verification is component-specific:
- **Run a Single Test (Helm)**:
  ```sh
  helm test <release-name> --namespace <namespace>
  ```
- **Argo CD Image Updater Test**:
  ```sh
  # Verifying image update strategy for a specific registry
  argocd-image-updater test <image-name> --platforms linux/amd64 --update-strategy latest --credentials env:REGISTRY_PULLSECRET
  ```
- **Vault Auth Verification**:
  ```sh
  # Test Kubernetes auth in Vault
  vault write auth/kubernetes/login role=k3s-kubernetes-role jwt=$KUBE_TOKEN
  ```
- **Manual Verification**:
  ```sh
  kubectl get pods -A
  kubectl logs -f <pod-name> -n <namespace>
  kubectl describe pod <pod-name> -n <namespace>
  # Network tools for connectivity checks
  kubectl run -it --rm network-tools --image=wbitt/network-multitool --restart=Never -- bash
  ```

---

## Code Style and Best Practices

### 1. Kubernetes YAML Standards
- **Indentation**: Use exactly 2 spaces. No tabs.
- **Naming**: Resources should use kebab-case (e.g., `keycloak-values.yaml`, `argocd-cm`).
- **Labels/Annotations**: Follow the standard `app.kubernetes.io/name` and `app.kubernetes.io/part-of` conventions for ArgoCD compatibility.
- **Secret Management**: **NEVER** commit plain-text secrets. Use `SealedSecrets` or Vault injection.

### 2. Helm & Values.yaml Conventions
- **Overrides**: Keep `values.yaml` minimal; only override what is necessary for the POC.
- **Insecure Modes**: Many components (ArgoCD, Registry) have "insecure" overlays for local dev. Ensure the correct overlay is used.

### 3. Shell Scripting Best Practices
Scripts are used for initialization (e.g., `vault-ha/unseal-vault/init-transit.sh`).
- **Safety**: Always include `set -e` or `set -euo pipefail`.
- **Portability**: Use `#!/bin/bash` over `#!/bin/sh` if Bash-isms are used.

### 4. GitOps & ArgoCD Guidelines
- **Source of Truth**: The `kustomize/` and `helm/` directories are the source of truth for ArgoCD applications.
- **Syncing**: Ensure `argocd-cm` and `argocd-rbac-cm` are updated when adding new users or applications.

---

## Repository Structure & Context

- **argoproj/**: ArgoCD, Rollouts, and Image Updater configurations.
- **keycloak/**: Identity management with LDAP federation and K8s OIDC integration.
- **vault-ha/**: High-availability Vault setup with multiple integration patterns (SSH, K8s).
- **redis/ /mongodb/ /mysql/**: StatefulSet examples with persistent volume claims (PVC).
- **tanzu/**: Configurations related to VMware Tanzu implementations.
- **doc/cka/**: Deep-dive notes and mock labs for the CKA exam. Useful for reference on cluster troubleshooting.

---

## Guidelines for AI Agents

1. **Locality of Context**: Each component folder is largely self-contained. **Always check for a local `README.md`** within the subfolder before proposing changes.
2. **Profile Awareness**: Verify the active Minikube profile before running `kubectl` commands.
3. **Connectivity**: If a service is inaccessible, check `minikube tunnel` status or Ingress rules (found in `argoproj/argo-cd/tls-ingress.yaml` or similar).
4. **No Speculation**: If a build command is missing from a sub-README, look for a `Makefile` or `docker-compose.yaml`. If neither exist, the component is likely a raw manifest collection.
5. **Incremental Changes**: When updating Helm values, prefer `helm upgrade` with `-f` to preserve existing configurations not present in your current context.

---
(End of AGENTS.md)
