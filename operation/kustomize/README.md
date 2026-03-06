# Argocd Imager Updater

## annotation(argocd)

```
argocd-image-updater.argoproj.io/image-list=nginx-alias=docker.kpcard.co.kr/kr.co.prepaidcard.poc/nginx
argocd-image-updater.argoproj.io/nginx-alias.update-strategy=semver
```

## annotation(git)

```
argocd-image-updater.argoproj.io/write-back-method=git:secret:argocd/kpcard-git-cred
argocd-image-updater.argoproj.io/write-back-target=kustomization
argocd-image-updater.argoproj.io/image-list=nginx-alias=docker.kpcard.co.kr/kr.co.prepaidcard.poc/nginx
argocd-image-updater.argoproj.io/nginx-alias.update-strategy=semver
```
