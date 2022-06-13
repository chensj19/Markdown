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

// 密码用户
curl -u 'elastic:123456' -H "Content-Type: application/json" -XPUT 'http://localhost:29200/_all/_settings' -d '
{
    "index" : {
       "number_of_replicas" : 0
    }
}'

curl -H "Content-Type: application/json" -XPUT 'http://localhost:19200/_all/_settings' -d '{"index":{"number_of_replicas" : 0}}'

// es默认分⽚的副本数 1,这里修改默认值为 0
PUT /_all/_settings
{
  "index": {
    "number_of_replicas" : 0
  }
}

```

## this action would add [2] total shards, 集群分片数不足

es 默认只允许1000个分片，问题是因为集群分片数不足引起的。现在在elasticsearch.yml中定义

```bash
curl -u elastic:abcd1234 -H "Content-Type: application/json" -XPUT 'http://127.0.0.1:19200/_cluster/settings' -d '{"transient": {"cluster": {"max_shards_per_node":10000}}}'

PUT /_cluster/settings
{"transient": {
    "cluster": {
      "max_shards_per_node":10000
    }
  }
}
```

## ES 写索引报错 FORBIDDEN/12/index read-only / allow delete (api)解决方案

> ElasticSearch进入“只读”模式，只允许删除。
> 　　ES说明文档中有写明，当ES数据所在目录磁盘空间使用率超过90%后，ES将修改为只读状态，所以初步判断是磁盘空间不足导致ES不允许写入。

## 报错信息（默认es不支持对text字段聚合，需要请打开某些开关）

>  Please use a keyword field instead。set fielddata=true on [tag]

```bash
# kibana
POST /enc_encounter_list/_mapping
{
  "properties":{
    "scheduledDate":{
      "type":"text",
      "fielddata":true
    }
  }
}
# bash
curl -XPOST -H "Content-Type: application/json" http://localhost:19200/enc_encounter_list/_mapping -d '{"properties": {"scheduledDate":{"type":"text","fielddata": true}}}'

```





```bash
# 修改用户密码
curl -H "Content-Type:application/json" -XPOST -u elastic:abcd1234 \
'http://127.0.0.1:9200/_xpack/security/user/elastic/_password' -d '{ "password" : "123456" }'

# 创建用户
curl -H "Content-Type:application/json" -XPOST -u elastic:abcd1234 \
'http://127.0.0.1:29200/_xpack/security/user/demo' \
-d '{"email":"","username":"demo","full_name":"demo","roles":["superuser"],"enabled":true,"password":"abcd1234"}'

```

