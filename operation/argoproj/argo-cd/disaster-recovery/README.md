# Argo CD Disater recovery

```sh
$ argocd version | grep server

# set version
$ export VERSION=v2.3.1

# Backup
$ docker run -v ~/.kube:/home/argocd/.kube --rm argoproj/argocd:$VERSION argocd admin export > backup.yaml

# Restore
$ docker run -i -v ~/.kube:/home/argocd/.kube --rm argoproj/argocd:$VERSION argocd admin import - < backup.yaml
```
