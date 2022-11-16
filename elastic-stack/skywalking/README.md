# Skywalking

## setup with H2 DB

```sh
# Create network
$ docker network create skywalking

# https://skywalking.apache.org/docs/main/v9.2.0/en/setup/backend/backend-docker/
$ docker stop oap && docker rm oap
$ docker run --name oap \
  -d \
  -p 11800:11800 \
  --network skywalking \
  apache/skywalking-oap-server:9.2.0
#  --restart always \

# https://skywalking.apache.org/docs/main/v9.2.0/en/setup/backend/ui-setup/
$ docker stop oap-ui && docker rm oap-ui
$ docker run --name oap-ui \
  -d \
  -e SW_OAP_ADDRESS=http://oap:12800 \
  -p 8080:8080 \
  --network skywalking \
  apache/skywalking-ui:9.2.0
```

## setup with ElasticSearch

```sh
docker run \
  --name oap \
  --restart always \
  -d \
  -e SW_STORAGE=elasticsearch \
  -e SW_STORAGE_ES_CLUSTER_NODES=elasticsearch:9200 \
  -e SW_STORAGE_ES_HTTP_PROTOCOL=HTTPs \
  --network docker_elastic \
  apache/skywalking-oap-server:9.0.0
```
