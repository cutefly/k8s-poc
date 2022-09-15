https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner

# WSL에 NFS 설정

> https://www.youtube.com/watch?v=LoGDkVvR68w

## WSL Terminal

```
sudo mkdir /opt/nfsshare
sudo chown nobody:nogroup /opt/nfsshare
sudo chmod 777 /opt/nfsshare

/etc/exports에 추가
/opt/nfsshare        *(rw,sync,no_subtree_check,insecure)

sudo apt install nfs-kernel-server rpcbind
sudo service rpcbind start
sudo service nfs-kernel-server start
```

## PowerShell(Administrator)

```
# Port forwarding
# 172.21.89.67은 wsl의 eth0 주소
netsh interface portproxy add v4tov4 listenport=2049 listenaddress=0.0.0.0 connectport=2-49 connectaddress=172.21.89.67
netsh interface portproxy show v4tov4
```

## nfs strorage provisioner 설정

```yaml
volumes:
- name: nfs-client-root
    nfs:
    # 172.21.80.1은 윈도우의 WSL의 vEthernet 주소
    server: 172.21.80.1
    # exports 주소
    path: /opt/nfsshare/nfs-path-provisioner
```
