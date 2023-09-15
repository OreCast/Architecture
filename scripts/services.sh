#!/bin/bash

mkdir -p logs

# delete existing web processes
pid=`ps auxww | grep "\./web" | grep -v grep | awk '{print $2}' | awk '{print "kill -9 "$1""}'`
if [ -n "$pid" ]; then
    echo "$pid" | sed "s,\n,,g"
    echo "$pid" | sed "s,\n,,g" | /bin/sh
fi

# start new processes
for srv in MetaData Discovery Frontend
do
    echo "Start $srv service..."
    cd $srv
    nohup ./web 2>&1 1>& ../logs/$srv.log < /dev/null & \
        echo $! > ../logs/$srv.pid
    echo "$srv started with PID=`cat ../logs/$srv.pid`"
    tail -3 ../logs/$srv.log
    cd -
done
