# Tailscale subnet

## Information

```
IP :
Account : root / ********
          pi / ********
```

## Install tailscale

### prerequisite

```
# /etc/pve/lxc/113.conf
# add for tailscale
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```

```
$ curl -fsSL https://tailscale.com/install.sh | sh


echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

$ sudo tailscale up --advertise-routes=192.168.219.0/24

add for tailscale
```

