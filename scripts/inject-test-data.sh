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
fname=$ddir/meta/record1.json
echo "### inject MetaData record $fname"
cat $fname
echo
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d@$fname \
    http://localhost:8300/meta
echo
echo
fname=$ddir/meta/record2.json
echo "### inject MetaData record $fname"
cat $fname
echo
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d@$fname \
    http://localhost:8300/meta
echo
echo
fname=$ddir/meta/record3.json
echo "### inject MetaData record $fname"
cat $fname
echo
curl -v -X POST -H "Content-type: application/json" \
    -H "Authorization: Bearer $token" \
    -d@$fname \
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
    fname=$ddir/sites/record1.json
    echo "### inject site record $fname"
    cat $fname
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$fname \
        http://localhost:8320/site
    echo
    echo
    fname=$ddir/sites/record2.json
    echo "### inject site record $fname"
    cat $fname
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$fname \
        http://localhost:8320/site
else
    echo
    echo
    fname=$ddir/sites/local1.json
    echo "### inject site record $fname"
    cat $fname
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$fname \
        http://localhost:8320/site
    echo
    echo
    fname=$ddir/sites/local2.json
    echo "### inject site record $fname"
    cat $fname
    echo
    curl -v -X POST -H "Content-type: application/json" \
        -H "Authorization: Bearer $token" \
        -d@$fname \
        http://localhost:8320/site
fi
echo
echo
echo "### List of site records"
curl -v -H "Authorization: Bearer $token" http://localhost:8320/sites
echo

echo
fname=$ddir/dbs/record1.json
echo "### insert record 1 into DBS system $fname"
cat $fname
echo
curl -v -X POST -H "Authorization: Bearer $token" \
    -H "Content-type: application/json" \
    -d@$fname \
    http://localhost:8310/dataset
echo

echo
fname=$ddir/dbs/record2.json
echo "### insert record 2 into DBS system $fname"
cat $fname
echo
curl -v -X POST -H "Authorization: Bearer $token" \
    -H "Content-type: application/json" \
    -d@$fname \
    http://localhost:8310/dataset
echo

dataset=/x/y/z
echo
echo "### look-up all datasets"
curl -v http://localhost:8310/datasets
echo
echo
echo "### look-up concrete dataset=/x/y/z"
curl -v http://localhost:8310/dataset$dataset
echo
echo
echo "### look-up files from a dataset"
curl -v "http://localhost:8310/file?dataset=$dataset"
echo
