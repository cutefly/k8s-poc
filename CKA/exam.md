# CKA Exam

## 시험준비

```
- 시험비: $395 -> $256.75(35% discount)
- PSI bridge
- take picture of ID card and face
- Scanning room
- Screen
  - titlebar(top)
  - Left pane(question)
  - Right pane(Remote desktop : linux)
```

## 기출문제

```
Create Persistent Volume
- classname: csi...
- 2Gi
- hostpath

(X)ETCD Backup and restore
- master node가 아닌 candidate terminal에서 실행
- 파일백업 경로 및 복원DB 경로가 터미널임.
- 백업은 했는데 Restore할 때 Permission denied 오류 발생

서비스 중인 POD에 sidecar 컨테이너 추가
- emptyDir()
- tail -f

Master node 업그레이드
- 1.25.1 -> 1.25.2
- Worker node는 유지

NotReady Node 응급조치
- kubelet restart

Multi container POD
- nginx
- memcached

Ingress network
- /hello mapping
- backend
- 5678 port
- I don't know what ingressclassname is

Network policy
- Ingress network
- from namespace(label), allow port

Pod의 Error log
- kubectl logs

Available node 수
- control-plane taint 노드 제외

Cluster Role
- serviceaccount
- namespace
- clusterrolebinding

Scale out deployment
- 2 -> 4 replicas

(X)Set node unavaliable, recreate pod on it
- 문제의 의도를 잘 파악하지 못했음

Top pod monitoring
- highest cpu usage pod
- kubectl top pod

Already created deployment
- expose service
- expose NodePort

pv, pvc
- 10Mi PV 선언
- PVC 생성 및 Pod에 Volume mount
- 70Mi로 resize

(?)ConfigMap이나 Volume과 관련된 문제

총 17문제
87점
```

## 참고사항

```
Don't panic
일단 완전하지 않은 문제는 패스 후 나중에 다시 푼다
직접 yaml을 만들지 않고 "--dry-run=client -o yaml"로 파일 생성
가능하면 yaml로 확인(검증) 후 리소스 생성(오타 또는 namespace가 지정되지 않는 경우 발생)
RBAC에서는 namespace에 주의(namespace를 지정할지 말지), auth can-i로 검증
patch 보다는 yaml로 만든 후 replace(--force)로 재생성
```
