# Proxmox Virtual Environment

## install

> N150 cpu 하드웨어 호환성 이슈가 있어 kernel 6.14 버전 적용

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
# SDN(8.4.1 버전에서는 불필요함)
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

## 시스템 설정 변경

### Auto power on(AMI bios)

> https://www.reddit.com/r/MiniPCs/comments/17ipj7j/how_to_automatically_start_on_turning_computer/
```
# Bios 수정
AMI BOIS 2.23.1287 Tab: chipset PCH-IO configuration 
Wake on power on (set to S0 state) 
```

### Sleep mode 전환 방지

> https://askubuntu.com/questions/1076623/ubuntu-server-keeps-suspending-when-external-monitor-is-disconnected

```
# 가급적 bios 수정을 피하고자 함.
# /etc/systemd/logind.conf 수정
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
HandleSuspendKey=ignore
HandleHibernateKey=ignore
IdleAction=ignore

# logind 서비스 재시작
sudo systemctl restart systemd-logind
```
