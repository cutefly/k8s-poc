
k -n elastic port-forward services/elasticsearch-master 9200 &

```sh
sudo ./elastic-agent install --url=http://localhost:8220 \
  --fleet-server-es=http://localhost:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjY5MjQ5NzUwMjE6WFVjUjE1SjVSNG1fcUlOUEJybzhTdw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --certificate-authorities=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elasticsearch-ca.pem \
  --fleet-server-es-ca=<PATH_TO_ES_CERT> \
  --fleet-server-cert=<PATH_TO_FLEET_SERVER_CERT> \
  --fleet-server-cert-key=<PATH_TO_FLEET_SERVER_CERT_KEY>
```

```sh
sudo ./elastic-agent install   \
  --fleet-server-es=https://elasticsearch-master:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjY5MjU3MjE1NjY6LUpILWdRZ3FSZUNnYXVIUlhWR3cwQQ \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --certificate-authorities=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elasticsearch-ca.pem \
  --fleet-server-insecure-http
```

```
sudo ./elastic-agent install --url=https://elasticsearch-master:8220 \
  --fleet-server-es=https://elasticsearch-master:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjY5MzQzODI3MjU6ZFEtSm1pTkdUUGEzS19WOElPa3lCdw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --certificate-authorities=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elasticsearch-ca.pem \
  --fleet-server-es-ca=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elasticsearch-ca.pem \
  --fleet-server-cert=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elastic-certificate.pem \
  --fleet-server-cert-key=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elastic-certificate.pem
```

```sh
sudo ./elastic-agent install --url=https://elasticsearch-master:8220 \
  --fleet-server-es=https://elasticsearch-master:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjY5Mzc5Njc4NzA6bVMxYnJQQ0dTd2FGaHpJYjBYUTd4Zw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --certificate-authorities=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elasticsearch-ca.pem \
  --fleet-server-es-ca=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elasticsearch-ca.pem \
  --fleet-server-cert=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elastic-certificate.pem \
  --fleet-server-cert-key=/home/chris/Documents/docker-workspace/k8s-poc/elastic/certs/elastic-certificate.pem
```
