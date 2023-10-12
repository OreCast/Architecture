### How to setup reploication
Let's setup replication between two distinct hosts.
- localhost where we have /bucket
- remove host where we create /bucket

First, we start with local setup
```
# start minio, e.g. using non-standard port
minio server /path --address :8330

# initialize our mc client using cornell alias
mc alias set cornell http://localhost:8330 minioadmin minioadmin

# create new bucket under cornell alias
mc mb cornell/bucket

# enable versionining on that bucket
mc version enable cornell/bucket

# now we can add files to that bucket
mc cp file cornell/bucket
```

Now, we repeat simiarl setup on remove server:

```
# step 0: login to remote host, and start minio on its dedicated port
minio server /path --address :9001

# initialize mc client using cornell alias
mc alias set cornell http://localhost:9001 minioadmin minioadmin

# create new bucket, e.g.
mc mb cornell/bucket

# enable versioninig on that bucket
mc version enable cornell/bucket
```

Now, to perform replication we setup SSH tunnel on our host to remote one
(we should replace user and hostXXX appropriately):
```
ssh -L 9001:hostXXX:9001 user@hostXXX
```

Finally, we create new replication rule to remote bucket from our local host:
```
mc replicate add cornell/bucket --remote-bucket http://minioadmin:minioadmin@localhost:9001/bucket --priority 1
Replication configuration rule applied to cornell/bucket successfully.
```

And, we can check our buckets as following:
```
# check content of localhost bucket
mc ls cornell/bucket

# create new alias to remote host (which is accessible via SSH tunnel on localhost:9001)
mc alias set remote http://localhost:9001 minioadmin minioadmin

# check content of remote host bucket
mc ls remote/buclek
```
