# K3s

## OS

```
# Rocky linux 9.5
IP: 192.168.219.151
root / ********
pi / ********
```

## install

```
# disable firewall
$ systemctl disable firewalld
$ systemctl stop firewalld
$ systemctl status firewalld

# disable selinux
$ setenforce 0
$ sed -i 's/enforcing/disabled/g' /etc/selinux/config
$ sestatus
Current mode : permissive
Mode from config file : disabled
```

### k3s

```
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# 설치 후 /etc/systemd/system/k3s.service 파일에 실행 옵션(--write-kubeconfig-mode 644) 추가 후 실행
$ sudo systemctl daemon-reload
$ sudo systemctl restart k3s.service

# crictl을 일반 계정으로 실행
$ sudo chmod 755 /var/lib/rancher/k3s/agent/etc/
$ sudo chmod 644 /var/lib/rancher/k3s/agent/etc/crictl.yaml
$ sudo chmod 755 /run/k3s/containerd
$ sudo chmod 666 /run/k3s/containerd/containerd.sock

$ crictl ps
```

```
# /etc/systemd/system/k3s.service
ExecStart=/usr/local/bin/k3s \
    server \
        '--write-kubeconfig-mode' \
        '644' \```

# 선택사항
$ export KUBECONFIG=/home/pi/.kube/config

# NODEPORT: 30358

# AWX UI
AWX URL: https://awx.club012.com/
Account: pi / ********
```

## AWX deploy

```yaml
# kubectl apply -f awx-tower.yml -n awx
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-tower
spec:
  # service_type: nodeport
  ingress_type: ingress
  ingress_hosts:
    - hostname: awx.club012.com
  ingress_controller: traefik
  projects_persistence: true
  projects_storage_size: 20Gi
  projects_storage_access_mode: ReadWriteOnce
  extra_settings:
    - setting: CSRF_TRUSTED_ORIGINS
      value:
        - https://awx.club012.com
```
