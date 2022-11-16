# Fleet server

> k -n elastic port-forward services/elasticsearch-master 9200 &

## example

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
  --fleet-server-es=https://elasticsearch:9200 \
  --fleet-server-es=http://localhost:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjY5MjQ5NzUwMjE6WFVjUjE1SjVSNG1fcUlOUEJybzhTdw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --fleet-server-insecure-http
```

## insecure fleet server(secure with elasticsearch)

```sh
sudo ./elastic-agent install --url=http://fleet-server:8220  \
  --fleet-server-es=https://elasticsearch:9200 \
  --fleet-server-es-ca=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/ca.crt \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjcxODM4NTcyMTA6RHZpSGZCUmFTUEMzNkdzWG9HT1Vkdw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --fleet-server-insecure-http
```

### with secure

```sh
sudo ./elastic-agent install   \
  --fleet-server-es=https://elasticsearch:9200 \
  --fleet-server-es-ca=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/ca.crt \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjcxODM4NTcyMTA6RHZpSGZCUmFTUEMzNkdzWG9HT1Vkdw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --certificate-authorities=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/ca.crt \
  --fleet-server-es-ca=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/elasticsearch.crt \
  --fleet-server-cert=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/fleet-server.crt \
  --fleet-server-cert-key=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/fleet-server.key
```