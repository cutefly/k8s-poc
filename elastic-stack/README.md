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

```sh
# certificate 생성
elastic-certificates: elastic-certificates.p12
elastic-certificate-pem: elastic-certificate.pem
$ openssl pkcs12 -nodes -passin pass:'' -in elastic-certificates.p12 -out elastic-certificate.pem
elastic-certificate-crt: elastic-certificate.crt
$ openssl x509 -outform der -in elastic-certificate.pem -out elastic-certificate.crt

./bin/elasticsearch-certutil http
도메인명은 지정해야 함.

# kubernetes에 secret을 추가
kubectl -n elastic delete secret elastic-certificates
kubectl -n elastic create secret generic elastic-certificates \
  --from-file=certs/elastic-certificates.p12 \
  --from-file=certs/elastic-certificate.pem \
  --from-file=certs/elastic-certificate.crt \
  --from-file=certs/elasticsearch-ca.pem

kubectl -n elastic delete secret elastic-certificates
kubectl -n elastic delete secret elastic-certificate-pem

kubectl -n elastic create secret generic elastic-certificates --from-file=certs/elastic-certificates.p12 && \
kubectl -n elastic create secret generic elastic-certificate-pem --from-file=certs/elastic-certificate.pem && \
kubectl -n elastic create secret generic elastic-certificate-crt --from-file=certs/elastic-certificate.crt

kubectl -n elastic create secret generic elasticsearch-ca-pem --from-file=certs/elasticsearch-ca.pem
```

### security config

| stack | key | value |
| --- | --- | --- |
| elasticsearch | xpack.security.enabled                       | true |
|               | xpack.security.transport.ssl.keystore.path   | /usr/share/elasticsearch/config/certs/elastic-certificates.p12 |
|               | xpack.security.transport.ssl.truststore.path | /usr/share/elasticsearch/config/certs/elastic-certificates.p12 |
|               | xpack.security.http.ssl.enabled              | true |
|               | xpack.security.http.ssl.truststore.path      | /usr/share/elasticsearch/config/certs/elastic-certificates.p12 |
|               | xpack.security.http.ssl.keystore.path        | /usr/share/elasticsearch/config/certs/elastic-certificates.p12 |
| kibana        | elasticsearch.ssl.certificateAuthorities     | /usr/share/kibana/config/certs/elasticsearch-ca.pem |
|               | server.ssl.enabled                           | true |
|               | server.ssl.certificate                       | https://www.elastic.co/guide/en/elasticsearch/reference/7.17/security-basic-setup-https.html#encrypt-kibana-browser |
|               | server.ssl.key                               |  |
| fleet-server  | fleet-server-es-ca                           | /usr/share/kibana/config/certs/elasticsearch-ca.pem |
|               | --certificate-authorities                    | https://www.elastic.co/guide/en/fleet/current/secure-connections.html |
|               | --fleet-server-cert                          |  |
|               | --fleet-server-cert-key                      |  |
