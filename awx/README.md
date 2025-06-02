# Ansible AWX

## Install awx-oprator

> <https://ansible.readthedocs.io/projects/awx-operator/en/latest/installation/basic-install.html>

### deplyment 설치

```sh
kubectl apply -n awx -f awx-tower.yaml
# Resouce 부족으로 awx-task pod의 실행 불가(CPU 리소스 부족)

kubectl delete awx awx-tower
```
