This document describe proof-of-concept for OreCast architecture
![Architecture](https://github.com/OreCast/Architecture/blob/main/OreCastInfrastructure.png)
The receipt below provides information about 3 main services:
- Frontend, the OreCast front-end web service designed for OreCast end-users
  - by default it is deployed at `http://localhost:9000` URL
- Discovery, the OreCast discovery services which provides site-URL
  associations
  - by default it is deployed at `http://localhost:9091` URL
  - so far it only has `/sites` end-point which you may used and it
  provides site information in JSON data-format
- MetaData, the OreCast meta-data services which contains meta-data
information about specific sites
  - by default it is deployed at `http://localhost:9092` URL
  - so far it only has `/meta` end-point which you may used and it
  provides meta-data information in JSON data-format

At this moment the Discovery and MetaData services use fake data, i.e.
we hard-coded site and meta-data info. And, frontend service will use
`play.min.io` to simulate storage access. But it relies on
[min.io Go SDK](https://min.io/docs/minio/linux/developers/go/minio-go.html)
to access the storage.

Here is full set of instructions to run OreCast on your local node:
```
# clone three OreCast repositories
git clone git@github.com:OreCast/Discovery.git
git clone git@github.com:OreCast/MetaData.git
git clone git@github.com:OreCast/Frontend.git

# compile code in these repositories
# in each repository it will compile `web` executeable
# which represents web server

cd Frontend
make
cd ../MetaData
make
cd ../Discovery
make
cd ../
```

Now, you can use the following script to start all services at once:
```
#!/bin/bash

mkdir -p logs

for srv in Metadata Discovery Frontend
do
    pid=`ps auxww | grep "$srv/web" | grep -v grep | awk '{print $2}'`
    if [ -n "$pid" ]; then
        echo "kill previous $srv/web process $pid"
        kill -9 $pid
    fi
    echo "Start $srv service..."
    nohup ./$srv/web 2>&1 1>& logs/$srv.log < /dev/null & \
        echo $! > logs/$srv.pid
done
```
As you can see it will create logs area and start each service independently.
In log area you'll have correspoding log and pid files for your inspection.

Once all services have started you may perform individual tests:
- test MetaData service:
```
curl -s http://localhost:9092/meta | jq
[
  {
    "site": "SiteA",
    "description": "this site provides access to mineral waste",
    "tags": [
      "waste",
      "minerals"
    ]
  },
  {
    "site": "SiteB",
    "description": "this site provides access to metal waste",
    "tags": [
      "waste",
      "metal"
    ]
  },
  {
    "site": "SiteC",
    "description": "this site provides access to glass waste",
    "tags": [
      "waste",
      "glass"
    ]
  }
]
```
- test Discovery service, e.g.
```
curl -s http://localhost:9091/sites | jq
[
  {
    "name": "SiteA",
    "url": "http://aaa.com"
  },
  {
    "name": "SiteB",
    "url": "http://bbb.com"
  },
  {
    "name": "SiteC",
    "url": "http://ccc.com"
  }
]
```
- and, finally visit Frontend url `http://localhost:9000` and visit
`Sites` page. It will show Sites with corresponding MetaData, and if
you'll click on specific site it will show its data (storage info).
