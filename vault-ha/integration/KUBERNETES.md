# Kubernetes auth

> https://developer.hashicorp.com/vault/tutorials/kubernetes-introduction/agent-kubernetes

## Retrieve secrets for Kubernetes workloads(일반적인 방식)

```sh
# enable kubernetes auth
$ vault auth enable kubernetes

# create kubernetes service account and secret
$ kubectl apply --filename vault-auth-service-account.yaml
$ kubectl apply --filename - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth
  namespace: vault
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-vault
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: vault-auth
  namespace: vault
EOF

$ kubectl apply --filename vault-auth-secret.yaml
$ kubectl apply -n vault --filename - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vault-auth-secret
  annotations:
    kubernetes.io/service-account.name: vault-auth
type: kubernetes.io/service-account-token
EOF

# Set the environment variables 
$ export SA_SECRET_NAME=$(kubectl get secrets -n vault --output=json \
    | jq -r '.items[].metadata | select(.name|startswith("vault-auth-")).name')

$ export SA_JWT_TOKEN=$(kubectl get secret -n vault $SA_SECRET_NAME \
    --output 'go-template={{ .data.token }}' | base64 --decode)

$ export SA_CA_CRT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

$ export K8S_HOST=$(kubectl config view --raw --minify --flatten \
    --output 'jsonpath={.clusters[].cluster.server}')

# Tell Vault how to communicate with the Kubernetes
$ vault write auth/kubernetes/config \
     token_reviewer_jwt="$SA_JWT_TOKEN" \
     kubernetes_host="$K8S_HOST" \
     kubernetes_ca_cert="$SA_CA_CRT" \
     issuer="https://kubernetes.default.svc.cluster.local"

# maps the Kubernetes Service Account to Vault policies
$ vault write auth/kubernetes/role/k3s-kubernetes-role \
     bound_service_account_names="vault-auth" \
     bound_service_account_namespaces="*" \
     token_policies="secret-read-only" \
     audience=https://kubernetes.default.svc.cluster.local \
     ttl=1h

```

### Verify the Kubernetes auth method configuration

```
# example pod
$ cat > devwebapp.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: devwebapp
  labels:
    app: devwebapp
spec:
  serviceAccountName: vault-auth
  containers:
    - name: devwebapp
      image: burtlo/devwebapp-ruby:k8s
      env:
        - name: VAULT_ADDR
          value: "https://vault.club012.com"
EOF

# create devwebapp pod in default namespace
$ kubectl apply --filename devwebapp.yaml --namespace default
$ kubectl apply --namespace vault --filename - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: devwebapp
  labels:
    app: devwebapp
spec:
  serviceAccountName: vault-auth
  containers:
    - name: devwebapp
      image: burtlo/devwebapp-ruby:k8s
      env:
        - name: VAULT_ADDR
          value: "https://vault.club012.com"
EOF

$ kubectl delete pod --namespace vault devwebapp

$ kubectl get pods

$ kubectl exec --stdin=true --tty=true -n vault devwebapp -- /bin/sh
/ # export KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

# create client toke from kubernetes token
/ # curl --request POST \
       --data '{"jwt": "'"$KUBE_TOKEN"'", "role": "k3s-kubernetes-role"}' \
       $VAULT_ADDR/v1/auth/kubernetes/login | python3 -m json.tool

/# export CLIENT_TOKEN=$(cat /vault/secrets/token)

# client_token from kubernetes auth login
/ # curl --header "X-Vault-Token: ${CLIENT_TOKEN}" \
         https://vault.club012.com/v1/secret/data/vault-secret/local
```

### Vault agent injector

```sh
# template에서 오류가 발생하는 경우 yaml 파일을 생성한 후 apply 할 것
$ kubectl apply --namespace default --filename - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vault-injector-webapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vault-injector-webapp
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/role: "k3s-kubernetes-role"
        # Vault Token 파일 주입
        vault.hashicorp.com/agent-inject-token: "true"
        # Vault 주소
        vault.hashicorp.com/vault-addr: "https://vault.club012.com"
        # init container is the only injected container(no sidecar container)
        vault.hashicorp.com/agent-pre-populate-only: "true"
        vault.hashicorp.com/agent-inject-secret-app: "secret/data/vault-secret/local"
        vault.hashicorp.com/agent-inject-template-app: |
          {{- with secret "secret/data/vault-secret/local" -}}
          {{- range $key, $value := .Data.data }}
          {{ $key }}={{ $value }}
          {{- end }}
          {{- end }}
      labels:
        app: vault-injector-webapp
    spec:
      serviceAccountName: vault-auth
      containers:
        - name: webapp
          image: burtlo/devwebapp-ruby:k8s
          env:
            - name: VAULT_ADDR
              value: "https://vault.club012.com"
            - name: VAULT_TOKEN_FILE
              value: "/vault/secrets/token"
EOF

# 위에 오류가 발생하는 경우
$ kubectl apply --namespace vault --filename vault-injector-webapp.yaml
$ kubectl apply --namespace default --filename vault-injector-webapp.yaml
$ kubectl apply --namespace webapp --filename vault-injector-webapp.yaml
```

### Spring boot appliation

```text
initContainer 또는 sidecar 컨테이너를 통해 vault에서 secret 정보를 획득한 후 application 컨테이너에 전달

# bootstrap.properties
spring.config.import=file:/vault/secrets/application.properties
```

```
# get ca.crt
$ kubectl config view \
  --raw \
  --minify \
  --flatten \
  -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode > ca.crt && echo ca.crt
```

## Retrieve secrets for Kubernetes workloads(2nd namespace)

```sh
# enable kubernetes auth
$ vault auth disable -path=k8s-default kubernetes

# create kubernetes service account and secret
$ kubectl apply --namespace webapp --filename - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth
EOF

# 불필요함
$ kubectl apply --namespace webapp --filename - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: vault-auth
  namespace: default
EOF

$ kubectl delete -n default --filename - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vault-auth-secret
  namespace: default
  annotations:
    kubernetes.io/service-account.name: vault-auth
type: kubernetes.io/service-account-token
EOF

# Set the environment variables 
$ export SA_SECRET_NAME=$(kubectl get secrets -n default --output=json \
    | jq -r '.items[].metadata | select(.name|startswith("vault-auth-")).name')

$ export SA_JWT_TOKEN=$(kubectl get secret -n default $SA_SECRET_NAME \
    --output 'go-template={{ .data.token }}' | base64 --decode)

$ export SA_CA_CRT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

$ export K8S_HOST=$(kubectl config view --raw --minify --flatten \
    --output 'jsonpath={.clusters[].cluster.server}')

# Tell Vault how to communicate with the Kubernetes
$ vault write auth/k8s-default/config \
     token_reviewer_jwt="$SA_JWT_TOKEN" \
     kubernetes_host="$K8S_HOST" \
     kubernetes_ca_cert="$SA_CA_CRT" \
     issuer="https://kubernetes.default.svc.cluster.local"

# maps the Kubernetes Service Account to Vault policies
$ vault write auth/k8s-default/role/k3s-kubernetes-role \
     bound_service_account_names="vault-auth" \
     bound_service_account_namespaces="default" \
     token_policies="secret-read-only" \
     audience=https://kubernetes.default.svc.cluster.local \
     ttl=1h

```

## 전체 Namespace에서 사용 가능하도록(아직 해결되지 않음)

```sh
# create kubernetes service account and secret
# 사용할 Namespace 마다 생성
$ kubectl delete --filename - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth
  namespace: default
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth
  namespace: vault
EOF

# Kubernetes에 Vault 전용 ServiceAccount 생성
$ kubectl delete --filename - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-auth-reviewer
  namespace: kube-system
EOF

# TokenReview 권한 부여 (ClusterRole)
$ kubectl delete --filename - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: vault-auth-reviewer-role
rules:
- apiGroups: ["authentication.k8s.io"]
  resources: ["tokenreviews"]
  verbs: ["create"]
- apiGroups: [""]
  resources:
    - serviceaccounts
    - pods
    - namespaces
  verbs: ["get", "list"]
EOF

$ kubectl delete --filename - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vault-auth-reviewer-secret
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: vault-auth-reviewer
type: kubernetes.io/service-account-token
EOF

# ClusterRoleBinding
$ kubectl delete --filename - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: vault-auth-reviewer-binding
subjects:
- kind: ServiceAccount
  name: vault-auth-reviewer
  namespace: kube-system
roleRef:
  kind: ClusterRole
  name: vault-auth-reviewer-role
  apiGroup: rbac.authorization.k8s.io
EOF

# ServiceAccount 토큰 추출
kubectl get secret -n kube-system \
  $(kubectl get sa vault-auth-reviewer -n kube-system -o jsonpath='{.secrets[0].name}') \
  -o jsonpath='{.data.token}' | base64 -d

$ vault auth enable kubernetes

# Set the environment variables 
$ export SA_SECRET_NAME=$(kubectl get secrets -n kube-system --output=json \
    | jq -r '.items[].metadata | select(.name|startswith("vault-auth-reviewer")).name')

$ export SA_JWT_TOKEN=$(kubectl get secret -n kube-system $SA_SECRET_NAME \
    --output 'go-template={{ .data.token }}' | base64 --decode)

$ export SA_CA_CRT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

$ export K8S_HOST=$(kubectl config view --raw --minify --flatten \
    --output 'jsonpath={.clusters[].cluster.server}')

$ vault write auth/kubernetes/config \
  kubernetes_host="$K8S_HOST" \
  kubernetes_ca_cert="$SA_CA_CRT" \
  token_reviewer_jwt="$SA_JWT_TOKEN$"

$ vault write auth/kubernetes/role/k3s-kubernetes-role \
  bound_service_account_names=vault-auth \
  bound_service_account_namespaces="*" \
  policies=secret-read-only \
  ttl=1h
```

### Integrate Kubernetes with an external Vault cluster

> https://developer.hashicorp.com/vault/tutorials/kubernetes-introduction/kubernetes-external-vault

