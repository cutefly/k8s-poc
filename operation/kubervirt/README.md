# Kubevirt

> https://kubevirt.io/quickstart_minikube/

> https://killercoda.com/kubevirt/scenario/kubevirt-101

## Trouble shooting

```text
# 가상화 지원 여부 확인(가상화가 가능한 시스템에서 virtual machine 생성이 가능함.)
$ cat /proc/cpuinfo| egrep "vmx|svm"

# "Too many open files"라는 에러로 컨테이너가 죽는 경우 조치 절차
https://ssnotebook.tistory.com/entry/Fluent-Bit-Too-many-open-files
```

## Deploy KubeVirt

```sh
# get the latest available release
ubuntu $ export KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | jq -r .tag_name)
ubuntu $ echo $KUBEVIRT_VERSION

# deploy the KubeVirt Operator
ubuntu $ kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml"
ubuntu $ kubectl delete -f "https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml"

# deploy KubeVirt by creating a Custom Resource
ubuntu $ kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml"
ubuntu $ kubectl delete -f "https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml"

# configure KubeVirt to use software emulation for virtualization
ubuntu $ kubectl -n kubevirt patch kubevirt kubevirt --type=merge --patch '{"spec":{"configuration":{"developerConfiguration":{"useEmulation":true}}}}'
```

# Install Virtctl

```sh
# Install Virtctl
ubuntu $ wget -O virtctl https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-arm64
ubuntu $ chmod +x virtctl
```

## Wait for KubeVirt deployment to finalize

```sh
# check the deployment
ubuntu $ kubectl get pods -n kubevirt

# check the operator's Custom Resource itself
ubuntu $ kubectl -n kubevirt get kubevirt
```

## Deploy a Virtual Machine

```sh
# creating a Virtual Machine
ubuntu $ kubectl apply -f https://kubevirt.io/labs/manifests/vm.yaml

# manage the VMs with standard 'kubectl' commands
ubuntu $ kubectl get vms
ubuntu $ kubectl get vms -o yaml testvm | grep -E 'runStrategy:.*|$'

# start a VM
ubuntu $ ./virtctl start testvm
ubuntu $ kubectl get vms

# inspect its status
ubuntu $ kubectl get vmis
```

## Access a VM

```sh
# access its serial console
ubuntu $ ./virtctl console testvm

```

## Shutdown and cleanup

```sh
# stop a VM
ubuntu $ ./virtctl stop testvm

# delete a VM
ubuntu $ kubectl delete vms testvm
```
