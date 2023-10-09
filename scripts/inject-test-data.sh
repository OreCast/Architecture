#!/bin/bash

sdir=$(dirname "$0")
echo "Script dir: $sdir"
ddir=$sdir/../data
echo "Data dir: $ddir"

echo "### get authz token"
# curl -v "http://localhost:8380/oauth/token?client_id=client_id&client_secret=client_secret&grant_type=client_credentials&scope=read"
token=`curl -s "http://localhost:8380/oauth/token?client_id=client_id&client_secret=client_secret&grant_type=client_credentials&scope=read" | jq '.access_token' | sed -e "s,\",,g"`
echo "token=$token"

#
echo
echo
echo "### inject MetaData record 1"
cat $ddir/meta/record1.json
echo
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d@$ddir/meta/record1.json \
    http://localhost:8300/meta
echo
echo
echo "### inject MetaData record 2"
cat $ddir/meta/record2.json
echo
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d@$ddir/meta/record2.json \
    http://localhost:8300/meta
echo
echo
echo "### inject MetaData record 3"
cat $ddir/meta/record3.json
echo
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d@$ddir/meta/record3.json \
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
    cat $ddir/sites/record1.json
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$ddir/sites/record1.json \
        http://localhost:8320/sites
    echo
    echo
    echo "### inject site record 2"
    cat $ddir/sites/record2.json
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$ddir/sites/record2.json \
        http://localhost:8320/sites
else
    echo
    echo
    echo "### inject site record 1"
    cat $ddir/sites/local1.json
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$ddir/sites/local1.json \
        http://localhost:8320/sites
    echo
    echo
    echo "### inject site record 2"
    cat $ddir/sites/local2.json
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$ddir/sites/local2.json \
        http://localhost:8320/sites
fi
echo
echo
echo "### List of site records"
curl -v -H "Authorization: Bearer $token" http://localhost:8320/sites
echo

echo
echo "### insert record into DBS system"
cat $ddir/dbs/record1.json
echo
curl -v -X POST -H "Authorization: Bearer $token" \
    -H "Content-type: application/json" \
    -d@$ddir/dbs/record1.json \
    http://localhost:8310/dataset
echo
