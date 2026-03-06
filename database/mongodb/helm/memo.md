# Mongodb script

## Liveness

```sh
# exec [/bitnami/scripts/ping-mongodb.sh]delay=30stimeout=10speriod=20s#success=1#failure=6
#!/bin/bash
mongosh  $TLS_OPTIONS --port $MONGODB_PORT_NUMBER --eval "db.adminCommand('ping')"
```

## Readiness

```sh
# exec [/bitnami/scripts/readiness-probe.sh]delay=5stimeout=5speriod=10s#success=1#failure=6
#!/bin/bash
# Run the proper check depending on the version
[[ $(mongod -version | grep "db version") =~ ([0-9]+\.[0-9]+\.[0-9]+) ]] && VERSION=${BASH_REMATCH[1]}
. /opt/bitnami/scripts/libversion.sh
VERSION_MAJOR="$(get_sematic_version "$VERSION" 1)"
VERSION_MINOR="$(get_sematic_version "$VERSION" 2)"
VERSION_PATCH="$(get_sematic_version "$VERSION" 3)"
if [[ ( "$VERSION_MAJOR" -ge 5 ) || ( "$VERSION_MAJOR" -ge 4 && "$VERSION_MINOR" -ge 4 && "$VERSION_PATCH" -ge 2 ) ]]; then
    mongosh $TLS_OPTIONS --port $MONGODB_PORT_NUMBER --eval 'db.hello().isWritablePrimary || db.hello().secondary' | grep -q 'true$'
else
    mongosh  $TLS_OPTIONS --port $MONGODB_PORT_NUMBER --eval 'db.isMaster().ismaster || db.isMaster().secondary' | grep -q 'true$'
fi

```
