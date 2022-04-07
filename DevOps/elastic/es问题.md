# ES问题

## All shards failed for phase

```json
// 运行命令：查看所有的index的状态，发现都是yellow
curl -XGET 'http://127.0.0.1:19200/_cat/indices?v&pretty'
// 处理方法
curl -H "Content-Type: application/json" -XPUT 'http://localhost:19200/_all/_settings' -d '
{
    "index" : {
       "number_of_replicas" : 0
    }
}'

```

# this action would add [2] total shards, 集群分片数不足

默认只允许1000个分片，问题是因为集群分片数不足引起的。现在在elasticsearch.yml中定义

```js
PUT /_cluster/settings
{
  "transient": {
    "cluster": {
      "max_shards_per_node":10000
    }
  }
}
```