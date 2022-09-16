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

## PowerShell(Administrator) - 옵션 사항

```
# 외부에 NFS를 제공해야하는 경우에 설정
# Port forwarding
# wsl의 eth0 주소

# add portproxy
netsh interface portproxy add v4tov4 listenport=2049 listenaddress=0.0.0.0 connectport=2049 connectaddress=172.21.99.241

# delete portproxy
netsh interface portproxy delete v4tov4 listenport=2049 listenaddress=0.0.0.0

# show portproxy
netsh interface portproxy show v4tov4
```

## nfs strorage provisioner 설정

```yaml
volumes:
- name: nfs-client-root
    nfs:
    # wsl의 eth0 주소
    # 또는 (포트포워딩한 경우) 윈도우 상의 WSL vEthernet 주소
    server: 172.21.99.241
    # exports 주소
    path: /opt/nfsshare/nfs-path-provisioner
```
