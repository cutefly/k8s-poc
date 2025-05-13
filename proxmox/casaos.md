# Casa OS on Ubuntu 24.04

```
OS : chris / ********
IP : 192.168.219.92/24
```

## Static IP

```yaml
# /etc/netplan/50-cloud-init.yaml

network:
    ethernets:
        ens18:
          addresses:
            - 192.168.219.92/24
          nameservers:
            addresses:
              - 1.1.1.1
            search:
              - 8.8.8.8
          routes:
            - to: default
              via: 192.168.219.1
    version: 2

# netplan 적용
$ sudo netplan apply
```

## Installed

```
Casa OS
https://casaos.club012.com/
chris/ ********

Jellyfin
admin: chris / ********
user: pi / ********

NextCloud
https://nextcloud.casaos.club012.com/
chris / ********
```

