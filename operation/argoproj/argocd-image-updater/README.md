# ArgoCD Image Updater

## 설치 현황

```
최초 argocd imager updater manifest yaml을 이용하여 설치

argocd image updater 0.x.x
- kustomize를 이용하여 업데이트
- annotation 기반의 이미지 변경 체크
- kustomize 설치 방식은 기본 manifest를 매번 변경하여 설치하므로 비효율적

argocd image updater 1.x.x 
- helm chart를 이용하여 설치하여 update가 용이함
- annotation 기반에서 CRD 방식을로 변경
- ImageUpdater Application을 배포환경에 추가
```

## 변경사항

```
문제점
- 매 어플리케이션별로 2분마다 Nexus registry를 호출하여 불필요한 오버헤드 발생
- Nexus의 호출 횟수가 많아 제약이 있음(일 100,000건 제한)
해결방안
- 이미지 변경 체크 Interval을 기본값 2m에서 최소 10m 이상으로 수정
- 운영의 경우 interval을 30분으로 조정하고 필요 시 수동 체크 실행
```

## 수동 실행

```
1. 클러스터 내 argocd image updater controller pod 에서 실행(argocd-image-updater-controller deployment)
$ /manager run --once --leader-election=false

2. argocd image updater cli를 원격에서 실행
$ ./argocd-image-updater \
      run \
      --once \
      --argocd-namespace argocd \
      --leader-election=false \
      --registries-conf-path ${PWD}/registries.conf

# registries.conf 예시
# 환경변수에 DOCKER_REGISTRY_CREDS="username:password" 형식으로 지정
registries:
  - name: Club012 Registry
    prefix: docker.club012.com
    api_url: https://docker.club012.com
    ping: yes
    insecure: false
    credentials: "env:DOCKER_REGISTRY_CREDS"
```


