# Open Media Vault

## OS Account

```
IP : 192.168.219.149
Account : root / ********
```

## Static IP

```yaml
# /etc/netplan/50-cloud-init.yaml

network:
    ethernets:
        ens18:
          addresses:
            - 192.168.219.149/24
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


## Applicatin account(OMV7)

```
http://192.168.219.149/
admin / ********
chris / ********
```

## WebDAV

```
Select the shared folder → Access Control List → set {your username}, "webdav-users" and "www-data" to "Read/Write" permissions
```

## External Drive

> https://it-svr.com/proxmox-disk-passthrought/

```sh
$ qm set 108 -scsi1 /dev/disk/by-id/wwn-0x5000c500446b4f9e
```

## shared folder

```
shared(cifs) : ${disk.root}/shared
webdav       : ${disk.root}/webdav/
```

## plugins

```
openmediavault-webdav 7.0.8
OpenMediaVault WebDAV plugin.
```
