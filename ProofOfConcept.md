This document describes proof-of-concept for OreCast architecture:
![Architecture](https://github.com/OreCast/Architecture/blob/main/OreCastInfrastructure.png)

### Details of implementation
The recipe below provides information about 3 main services:
- Frontend service, the OreCast front-end web service designed for OreCast end-users
  - by default it is deployed at `http://localhost:9000` URL
- Discovery service, the OreCast discovery services which provides site-URL
  associations
  - by default it is deployed at `http://localhost:9091` URL
  - so far it only has `/sites` end-point which you may used and it
  provides site information in JSON data-format
- MetaData servuce, the OreCast meta-data services which contains meta-data
information about specific sites
  - by default it is deployed at `http://localhost:9092` URL
  - so far it only has `/meta` end-point which you may used and it
  provides meta-data information in JSON data-format

At this moment the Discovery and MetaData services use fake data, i.e.
we hard-coded site and meta-data info. And, frontend service relies on usage of
`play.min.io` to simulate storage access. But it is based on
[min.io Go SDK](https://min.io/docs/minio/linux/developers/go/minio-go.html)
to provide access to the storage.

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
The script above creates logs area and starts each service independently.
In log area you'll have correspoding log and pid files for your inspection.

Once all services have started we may perform individual tests:
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
- and, finally we may visit Frontend url `http://localhost:9000` and see
`Sites` page. It will show Sites with corresponding MetaData, and provide
details of specific site and show its data (storage info).

### MinIO references
- [MinIO for developers](https://www.youtube.com/watch?v=gY090GEDdu8&list=PLFOIsHSSYIK37B3VtACkNksUw8_puUuAC&pp=iAQB)
- [Data redundancy and availability with MinIO](https://www.youtube.com/watch?v=QniHMNNmbfI)
- [Replace file system with MinIO](https://medium.com/cloud-native-daily/replace-filesystem-with-minio-golang-3148c61f2d28)
##### APIs
- [Build scalable RESTful APIs with Go gin-gonic](https://medium.com/@wahyubagus1910/build-scalable-restful-api-with-golang-gin-gonic-framework-43793c730d10)
- [Microservices patterns in golang](https://levelup.gitconnected.com/12-microservices-pattern-i-wish-i-knew-before-the-system-design-interview-5c35919f16a2)
- [REST API design in golang](https://medium.com/@lordmoma/build-a-social-network-in-go-3-architecture-fd99e3647026)
