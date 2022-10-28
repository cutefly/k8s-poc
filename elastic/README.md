# Elastic stack on kubernetes

## install elasticsearch

```sh
helm repo add elastic https://helm.elastic.co
# helm install elasticsearch elastic/elasticsearch
helm install elasticsearch --create-namespace --namespace elastic --values helm/elasticsearch/values.yaml elastic/elasticsearch
helm delete elasticsearch --namespace elastic
```

## install kibana

```
helm install kibana --create-namespace --namespace elastic --values helm/kibana/values.yaml elastic/kibana
helm delete kibana --namespace elastic
```

## Security

```
certificate 생성
elastic-certificates: elastic-certificates.p12
elastic-certificate-pem: elastic-certificate.pem
elastic-certificate-crt: elastic-certificate.crt
./bin/elasticsearch-certutil http

kubernetes에 secret을 추가
kubectl -n elastic delete secret elastic-certificates
kubectl -n elastic delete secret elastic-certificate-pem

kubectl -n elastic create secret generic elastic-certificates --from-file=certs/elastic-certificates.p12 && \
kubectl -n elastic create secret generic elastic-certificate-pem --from-file=certs/elastic-certificate.pem && \
kubectl -n elastic create secret generic elastic-certificate-crt --from-file=certs/elastic-certificate.crt

kubectl -n elastic create secret generic elasticsearch-ca-pem --from-file=certs/elasticsearch-ca.pem
```
