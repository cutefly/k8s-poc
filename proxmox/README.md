# Proxmox Virtual Environment

## Information

```
OS : root / proxmox
     chris / proxmox
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
