# ES问题

## All shards failed for phase

```json
// 运行命令：查看所有的index的状态，发现都是yellow
curl -XGET 'http://127.0.0.1:19200/_cat/indices?v&pretty'
// 处理方法
curl -H "Content-Type: application/json" -XPUT 'http://localhost:19200/_all/_settings' -d '{ "index" : { "number_of_replicas" : 0} }'
// 一般以（节点数*1.5或3倍）来计算，比如有4个节点，分片数量一般是6个到12个，每个分片一般分配一个副本
curl -H "Content-Type: application/json" -XPUT 'http://localhost:19200/_all/_settings' -d '{ "index" : { "number_of_replicas" : 1, "number_of_shards" : 3 } }'

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
curl -u elastic:abcd1234 -H "Content-Type: application/json" -XPUT 'http://127.0.0.1:19200/_cluster/settings' -d '{"transient": {"cluster": {"max_shards_per_node":100000}}}'

curl -H "Content-Type: application/json" -XPUT 'http://127.0.0.1:19200/_cluster/settings' -d '{"transient": {"cluster": {"max_shards_per_node":100000}}}'

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

## 删除全部删除

```bash
# kibana
DELETE /_all
DELETE /aaio_*

# bash
curl -XDELETE "http://localhost:19200/aaio-dev1__*"
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

## 文件空间不足时候清理空间后处理

```bash
curl -XPUT -H "Content-Type: application/json" http://localhost:19200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null,"index.blocks.read_only": null}'

curl -XPUT -H "Content-Type: application/json" http://127.0.0.1:19200/cli_search_medicine/_settings -d '{"index.blocks.read_only_allow_delete": null}'

curl -XPOST 'http://localhost:19200/_forcemerge?only_expunge_deletes=true'
```



#### 修改最大硬盘使用率

```bash

curl -XPUT -H "Content-Type: application/json" http://localhost:19200/_cluster/settings -d '{
    "transient" : {
        "cluster.routing.allocation.disk.watermark.low" : "85%",
        "cluster.routing.allocation.disk.watermark.high" : "95%",
        "cluster.info.update.interval" : "1m"
    }
}'
```



## 重启es服务

```bash
# 重启前需要将索引锁定
curl -XPUT 'http://localhost:19200/_cluster/settings' -d '{
"transient" : {
"cluster.routing.allocation.enable" : "all"
}
}' -H 'Content-Type: application/json'
```



```bash
# 默认配置 elasticsearch.yml
cluster.name: winning_elasticsearch
node.name: 172.20.64.79
path.data: /winning/winmid/elasticsearch/data
path.logs: /winning/winmid/elasticsearch/logs
path.repo: /winning/winmid/elasticsearch/repo
network.host: 0.0.0.0
http.port: 19200
transport.tcp.port: 19300
discovery.seed_hosts: ['172.20.64.79:19300']
cluster.initial_master_nodes: ['172.20.64.79']

# es登录
#xpack.security.enabled: true
#xpack.security.transport.ssl.enabled: true
#xpack.security.transport.ssl.verification_mode: certificate
#xpack.security.transport.ssl.keystore.path: es-certificates.p12
#xpack.security.transport.ssl.truststore.path: es-certificates.p12

# 允许跨域请求
http.cors.enabled: true
http.cors.allow-origin: '*'
http.cors.allow-credentials: true

# 最大查询数量
indices.query.bool.max_clause_count: 10240
```

