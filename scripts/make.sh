#!/bin/bash

odir=${ORECAST_DIR:-$PWD}
echo "OreCast directory: $odir"
cd $odir

mkdir -p logs


# processes
for srv in Authz MetaData Discovery DataManagement DataBookkeeping Frontend
do
    echo
    echo "### $srv service..."
    cd $srv
    make
    cd -
done
