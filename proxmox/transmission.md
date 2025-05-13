# Transmission on Ubuntu

## infomation

```
IP      : 192.168.219.135
Account : root / ********
          pi / ********
```

## mount storage

```
$ sudo mount -t cifs -o uid=110,gid=118,username=pi,password=******** //192.168.219.149/shared /mnt/cifs

# /etc/fstab
# mount OpenMediaVault
//192.168.219.149/shared /mnt/cifs cifs uid=110,gid=118,username=pi,password=******** 0 0
```

## Transmission settings

```
# /etc/transmission-daemon/settings.json
"download-dir": "/mnt/cifs/transmission-daemon/torrent-complete",
"incomplete-dir": "/mnt/cifs/transmission-daemon/torrent-inprogress",

http://192.168.219.135:9091/
```

## Tailscale client

```
# install tailcale client
$ curl -fsSL https://tailscale.com/install.sh | sh

# /etc/pve/lxc.112.conf
# add for tailscale
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file

# restart lxc and start tailscale
$ sudo tailscale set --exit-node= 100.68.232.48 --exit-node-allow-lan-access=true
```

## WireGuard client

```
# WireGuard Server
# install pivpn
$ curl -L https://install.pivpn.io | bash
$ pivpn add => ${name}.conf

# WireGuard Client
# install WireGuard
$ sudo apt install wireguard
# copy conf file
# /etc/wirequard/wg0.conf
$ systemctl start wg-quick@wg0.service
```

