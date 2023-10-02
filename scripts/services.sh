#!/bin/bash

mkdir -p logs

# delete existing web processes
pid=`ps auxww | grep "\./web" | grep -v grep | awk '{print $2}' | awk '{print "kill -9 "$1""}'`
if [ -n "$pid" ]; then
    echo "$pid" | sed "s,\n,,g"
    echo "$pid" | sed "s,\n,,g" | /bin/sh
fi

# start new processes
for srv in Authz MetaData Discovery DataManagement Frontend
do
    echo "Start $srv service..."
    cd $srv
    if [ "$srv" == "Authz" ]; then
        # check that auth.db exists, if not we'll create it
        if [ ! -f "auth.db" ]; then
            sqlite3 ./auth.db < static/schema/sqlite-schema.sql
        fi
    fi
    nohup ./web 2>&1 1>& ../logs/$srv.log < /dev/null & \
        echo $! > ../logs/$srv.pid
    echo "$srv started with PID=`cat ../logs/$srv.pid`"
    tail -3 ../logs/$srv.log
    cd -
done
