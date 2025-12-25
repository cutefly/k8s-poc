# Docker rootless on Ubuntu

> 192.168.219.27

```
# install docker standard
$ sudo systemctl disable --now docker.service docker.socket
$ sudo rm /var/run/docker.sock

# install docker rootless
$ sudo apt-get install -y dbus-user-session
$ sudo apt-get install -y uidmap
$ dockerd-rootless-setuptool.sh install
```

## dockge

> http://192.168.219.27:5001 (pi / offspring1@)

```yaml
services:
  dockge:
    image: louislam/dockge:1
    restart: unless-stopped
    ports:
      # Host Port : Container Port
      - 5001:5001
    volumes:
      - ${XDG_RUNTIME_DIR}/docker.sock:/var/run/docker.sock
      - ./data:/app/data

      # If you want to use private registries, you need to share the auth file with Dockge:
      # - /root/.docker/:/root/.docker

      # Stacks Directory
      # ⚠️ READ IT CAREFULLY. If you did it wrong, your data could end up writing into a WRONG PATH.
      # ⚠️ 1. FULL path only. No relative path (MUST)
      # ⚠️ 2. Left Stacks Path === Right Stacks Path (MUST)
      - ${HOME}/opt/stacks:/opt/stacks
    environment:
      # Tell Dockge where is your stacks directory
      - DOCKGE_STACKS_DIR=${HOME}/opt/stacks
```