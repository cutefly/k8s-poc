# AWX on rocky linux

## info

```
IP.    : 192.168.219.36(ens18)
Account: root / proxmox
         pi / offspring
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
# 선택사항
$ export KUBECONFIG=/home/pi/.kube/config

# NODEPORT: 30358

# AWX UI
AWX URL: https://awx.club012.com/
Account: pi / offspring
```
