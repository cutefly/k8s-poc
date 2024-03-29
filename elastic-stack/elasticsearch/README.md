# Elastic stack on Docker

> https://www.elastic.co/guide/en/elastic-stack-get-started/7.17/get-started-docker.html

## 키생성 v2

```
./bin/elasticsearch-certutil ca --pem

./bin/elasticsearch-certutil cert \
  --name elasticsearch \
  --ca-cert tmp/ca/ca.crt \
  --ca-key tmp/ca/ca.key \
  --dns elasticsearch,elasticsearch-master,localhost \
  --pem \
  --out tmp/elasticsearch.zip


./bin/elasticsearch-certutil cert \
  --name kibana \
  --ca-cert tmp/ca/ca.crt \
  --ca-key tmp/ca/ca.key \
  --dns kibana,kibana-ui,localhost \
  --pem \
  --out tmp/kibana.zip


./bin/elasticsearch-certutil cert \
  --name fleet-server \
  --ca-cert tmp/ca/ca.crt \
  --ca-key tmp/ca/ca.key \
  --dns fleet-server,localhost \
  --pem \
  --out tmp/fleet-server.zip

# 한번에 여러 키를 생성하려면(ca.key가 생성되지 않아 추가 발급이 안됨)
$ bin/elasticsearch-certutil cert --silent --pem --in tmp/instances.yml -out tmp/bundle.zip
```

## es, kibana 실행

```sh
# create network
$ docker network create elastic

# container start
$ docker compose up -d

# kibana의 기본 패스워드가 맞지 않는 경우 패스워드 재설정
$ docker exec -it elasticsearch bash
$ bin/elasticsearch-setup-passwords auto --url=https://elasticsearch:9200

$ docker compose down
# config 변경 후 재기동(volume은 지우지 않음)
$ docker compose up -d
```

## fleet-server

> https://www.elastic.co/guide/en/fleet/current/secure-connections.html

```sh
# install service
$ sudo ./elastic-agent install --url=https://fleet-server:8220 \
  --fleet-server-es=https://elasticsearch:9200 \
  --fleet-server-service-token=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjY5NTE4NDQ5MDc6V2hwZGJCdU5RSVNpQmM4SWJoTW1EZw \
  --fleet-server-policy=499b5aa7-d214-5b5d-838b-3cd76469844e \
  --certificate-authorities=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/ca.crt \
  --fleet-server-es-ca=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/elasticsearch.crt \
  --fleet-server-cert=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/fleet-server.crt \
  --fleet-server-cert-key=/home/chris/Documents/docker-workspace/k8s-poc/elastic/docker/certs/fleet-server.key

# uninstall service
$ sudo ./elastic-agent uninstall

# stop, start 서비스
$ sudo service elastic-agent stop
$ sudo service elastic-agent start
```

### fleet-server in container

```sh
# docker run
$ docker run --name fleet-server \
  --rm \
  --env FLEET_SERVER_ENABLE=true \
  --env FLEET_SERVER_ELASTICSEARCH_HOST=https://elasticsearch:9200 \
  --env FLEET_SERVER_SERVICE_TOKEN=AAEAAWVsYXN0aWMvZmxlZXQtc2VydmVyL3Rva2VuLTE2NjczNzgyOTg4OTk6aUxZd0NYTVVUdC1ZR2NBN1c5ZFNxdw \
  --env ELASTICSEARCH_CA=/usr/share/elastic-agent/certs/ca.crt \
  --env FLEET_SERVER_ELASTICSEARCH_CA=/usr/share/elastic-agent/certs/ca.crt \
  --env FLEET_SERVER_INSECURE_HTTP=true \
  --volume ${PWD}/certs:/usr/share/elastic-agent/certs \
  --publish 8220:8220 \
  --network elastic \
  docker.elastic.co/beats/elastic-agent:7.17.6

# https://kifarunix.com/ship-system-logs-to-elk-stack-using-elastic-agents/
# 마지막 스텝에서 fleet settings에 Elasticsearch output configuration(YAML)에 cert file 경로 지정
# ssl.certificate_authorities: ['/usr/share/elastic-agent/certs/ca.crt']
# 모든 Agent에 동일하게 적용되므로 해당 경로에 파일이 있어야 함(?)

# health check
$ curl http://localhost:8220/api/status

sudo ./elastic-agent install --url=http://fleet-server:8220 --insecure --enrollment-token=MnVyd0hZUUJGcDE0MU9OSW1UczY6MzVnd3hRMWVTVnE1UmxhMlFWZzEwQQ==
```

docker run --name fleet-server \
  --rm \
  docker.elastic.co/beats/elastic-agent:7.17.6