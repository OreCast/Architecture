#!/bin/bash

echo "### get authz token"
# curl -v "http://localhost:8380/oauth/token?client_id=client_id&client_secret=client_secret&grant_type=client_credentials&scope=read"
token=`curl -s "http://localhost:8380/oauth/token?client_id=client_id&client_secret=client_secret&grant_type=client_credentials&scope=read" | jq '.access_token' | sed -e "s,\",,g"`
echo "token=$token"

#
echo
echo
echo "### inject MetaData record 1"
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d '{"site":"Cornell", "description": "waste minerals", "tags": ["waste", "minerals"], "bucket": "waste"}' \
    http://localhost:8300/meta
echo
echo
echo "### inject MetaData record 2"
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d '{"site":"Cornell", "description": "rare-materials", "tags": ["rare"], "bucket": "minerals"}' \
    http://localhost:8300/meta
echo
echo
echo "### inject MetaData record 3"
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d '{"site":"Mineville", "description": "waste materials", "tags": ["waste"], "bucket": "waste"}' \
    http://localhost:8300/meta
echo
echo
echo "### List of meta-data records"
curl -v -H "Authorization: Bearer $token" http://localhost:8300/meta
echo

echo
echo "### inject site records"
if [ "`hostname -s`" == "lnx15" ]; then
    echo
    echo
    echo "### inject site record 1"
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d '{"name":"Cornell", "description": "Cornell minerals site", "url": "http://orecast-s3-dev.classe.cornell.edu:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
    echo
    echo
    echo "### inject site record 2"
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d '{"name":"Mineville", "description": "Mineville waste site", "url": "http://orecast-s3-dev.classe.cornell.edu:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
else
    echo
    echo
    echo "### inject site record 1"
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d '{"name":"Cornell", "description": "Cornell minerals site", "url": "http://127.0.0.1:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
    echo
    echo
    echo "### inject site record 2"
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d '{"name":"Mineville", "description": "Minevill waste site", "url": "http://127.0.0.1:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
fi
echo
echo
echo "### List of site records"
curl -v -H "Authorization: Bearer $token" http://localhost:8320/sites
echo
