#!/bin/bash

odir=${ORECAST_DIR:-$PWD}
echo "OreCast directory: $odir"
cd $odir

# processes
for srv in Authz MetaData Discovery DataManagement DataBookkeeping Frontend
do
    echo "visit $srv service..."
    cd $srv
    rm go.mod go.sum
    go mod init github.com/OreCast/$srv
    go mod tidy
    git status
    git commit -m "update dependencies" go.mod go.sum
    git push
    cd -
done
