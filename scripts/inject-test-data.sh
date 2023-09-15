#!/bin/bash
echo "inject MetaData record"
curl -X POST -H "Content-type: application/json" -d '{"site":"cornell", "description": "bla-bla", "tags": ["tagA", "tagB"]}' http://localhost:8300/meta
echo

echo "inject site record"
curl -X POST -H "Content-type: application/json" -d '{"name":"cornell", "url": "http://127.0.0.1:8330", "access_key": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "access_secret": "79c936397f8846f67026104fc175908d29f4ff0f61d1e7da4102f46b2db499f3c4acf1e37c3d", "use_ssl": false, "endpoint": "localhost:8330"}' http://localhost:8320/sites
echo
