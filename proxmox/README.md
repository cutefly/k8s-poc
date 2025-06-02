# Proxmox Virtual Environment

## install

```
Install Proxmox VE 8.4.1

/etc/apt/sources.list.d/pve-enterprise.list <= comment out
#deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise

/etc/apt/sources.list.d/ceph.list <= comment out
#deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise

/etc/apt/sources.list.d/pve-no-subscription.list
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

/etc/apt/sources.list.d/ceph.list
deb http://download.proxmox.com/debian/ceph-squid bookworm no-subscription

apt update
apt install proxmox-kernel-6.14
reboot
```

## Information

```
OS : root / ********
     chris / ********
URL : https://pve.club012.com/
```

## Reference

```
SDN
- https://pve.proxmox.com/wiki/Setup_Simple_Zone_With_SNAT_and_DHCP
- https://www.virtualizationhowto.com/2024/03/proxmox-sdn-configuration-step-by-step/
```

## 가상머신 정보가 정상적으로 표시되지 않는 경우

```sh
# shell에 접속한 후 pvestatd 서비스 restart
systemctl restart pvestatd
```

## Image 관리

```
openmediavault_7.0-32-amd64.iso
ubuntu
rocky linux

```
