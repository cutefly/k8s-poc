# Certification Details

```
Note!
In the video, I said the exam is 3 hours. With the latest version of the exam, it is now only 2 hours. The contents of this course has been updated with the changes required for the latest version of the exam.

Below are some references:Certified Kubernetes Administrator: https://www.cncf.io/certification/cka/
Exam Curriculum (Topics): https://github.com/cncf/curriculum
Candidate Handbook: https://www.cncf.io/certification/candidate-handbook
Exam Tips: http://training.linuxfoundation.org/go//Important-Tips-CKA-CKAD

Use the code - DEVOPS15 - while registering for the CKA or CKAD exams at Linux Foundation to get a 15% discount.


Reference Notes for lectures and labs
We have created a repository with notes, links to documentation and answers to practice questions here. Please make sure to go through these as you progress through the course:
https://github.com/kodekloudhub/certified-kubernetes-administrator-course

Link: https://uklabs.kodekloud.com/courses/labs-certified-kubernetes-administrator-with-practice-tests/
Apply the coupon code udemystudent151113
```

## Upgrade cluster

```
apt update
apt-cache madison kubeadm

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.20.0-00 && \
apt-mark hold kubeadm

sudo kubeadm upgrade apply v1.20.0

apt-mark unhold kubelet kubectl && \
    apt-get update && apt-get install -y kubelet=1.20.0-00 kubectl=1.20.0-00 && \
    apt-mark hold kubelet kubectl


apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.20.0-00 && \
apt-mark hold kubeadm


apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.20.0-00 kubectl=1.20.0-00 && \
apt-mark hold kubelet kubectl
```

### ETC 문제풀이

```
ETCDCTL_API=3 etcdctl --endpoints https://127.0.0.1:2379 snapshot save /opt/snapshot-pre-boot.db

ETCDCTL_API=3 etcdctl --endpoints https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key /etc/kubernetes/pki/etcd/healthcheck-client.key snapshot save /opt/snapshot-pre-boot.db


ETCDCTL_API=3 etcdctl --endpoints https://127.0.0.1:2379 snapshot restore /opt/snapshot-pre-boot.db

ETCDCTL_API=3 etcdctl snapshot restore /opt/snapshot-pre-boot.db —data-dir=/var/lib/etcd-from-backup

Edit /etc/kubernetes/manifest/etcd.yaml

kubectl create secret docker-registry private-reg-cred --docker-server=myprivateregistry.com:5000 --docker-username=dock_user --docker-password=dock_password --docker-email=dock_user@myprivateregistry.com
```

### CNI Memo

```
CNI
/opt/cni/bin
/etc/cni/net.d/
```
