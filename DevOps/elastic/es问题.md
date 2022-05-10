# ES问题

## All shards failed for phase

```json
// 运行命令：查看所有的index的状态，发现都是yellow
curl -XGET 'http://127.0.0.1:19200/_cat/indices?v&pretty'
// 处理方法
curl -H "Content-Type: application/json" -XPUT 'http://172.16.7.27:19200/_all/_settings' -d '{"index":{"number_of_replicas" : 0}}'
```

# this action would add [2] total shards, 集群分片数不足

默认只允许1000个分片，问题是因为集群分片数不足引起的。现在在elasticsearch.yml中定义

```bash
curl -u elastic:abcd1234 -H "Content-Type: application/json" -XPUT 'http://127.0.0.1:29200/_cluster/settings' -d '{"transient": {"cluster": {"max_shards_per_node":10000}}}'

PUT /_cluster/settings
{"transient": {
    "cluster": {
      "max_shards_per_node":10000
    }
  }
}
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

