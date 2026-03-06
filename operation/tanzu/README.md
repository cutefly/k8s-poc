# Tanzu community edition

> https://github.com/vmware-tanzu/community-edition

## Install tanzu cli

```sh
https://tanzucommunityedition.io/docs/edge/getting-started/

# Linux(WSL)
$ brew install vmware-tanzu/tanzu/tanzu-community-edition
$ configure-tce.sh 실행(/home/linuxbrew/.linuxbrew/Cellar/tanzu-community-edition/v0.12.1/libexec/configure-tce.sh)

# Windows
$ choco install tanzu-community-edition

# Autocompletion
https://docs.vmware.com/en/VMware-Tanzu/services/vmware-tanzu-cli-ref/GUID-tanzu-completion.html
```

## Deploy cluster

```
Docker desktop extensions
Tanzu Community Edition > Create Cluster
```

## Deploy package

```
# package list
$ tanzu package available list

# install package
$ tanzu package install contour --package-name contour.community.tanzu.vmware.com --version 1.20.1 --values-file contour.yaml
$ tanzu package install prometheus --package-name prometheus.community.tanzu.vmware.com --version 2.27.0-1
$ tanzu package install grafana --package-name grafana.community.tanzu.vmware.com --version 7.5.11 --values-file grafana.yaml

# installed package list
$ tanzu package installed list

# delete package
$ tanzu package installed delete grafana
```