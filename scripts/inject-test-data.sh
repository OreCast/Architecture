#!/bin/bash
echo "inject MetaData record"
curl -X POST -H "Content-type: application/json" \
    -d '{"site":"Cornell", "description": "waste minerals", "tags": ["waste", "minerals"], "bucket": "waste"}' \
    http://localhost:8300/meta
curl -X POST -H "Content-type: application/json" \
    -d '{"site":"Cornell", "description": "rare-materials", "tags": ["rare"], "bucket": "minerals"}' \
    http://localhost:8300/meta
curl -X POST -H "Content-type: application/json" \
    -d '{"site":"Mineville", "description": "waste materials", "tags": ["waste"], "bucket": "waste"}' \
    http://localhost:8300/meta
echo
echo "List of meta-data records"
curl http://localhost:8300/meta
echo

echo "inject site record"
if [ "`hostname -s`" == "lnx15" ]; then
    curl -X POST -H "Content-type: application/json" \
        -d '{"name":"Cornell", "description": "Cornell minerals site", "url": "http://orecast-s3-dev.classe.cornell.edu:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
    curl -X POST -H "Content-type: application/json" \
        -d '{"name":"Mineville", "description": "Mineville waste site", "url": "http://orecast-s3-dev.classe.cornell.edu:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
else
    curl -X POST -H "Content-type: application/json" \
        -d '{"name":"Cornell", "description": "Cornell minerals site", "url": "http://127.0.0.1:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
    curl -X POST -H "Content-type: application/json" \
        -d '{"name":"Mineville", "description": "Minevill waste site", "url": "http://127.0.0.1:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' \
        http://localhost:8320/sites
fi
echo
echo "List of site records"
curl http://localhost:8320/sites
echo
