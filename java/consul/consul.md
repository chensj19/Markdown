## Linux 防火墙

```bash
firewall-cmd --zone=public --add-port=8300/tcp --permanent
firewall-cmd --zone=public --add-port=8301/tcp --permanent
firewall-cmd --zone=public --add-port=8500/tcp --permanent
firewall-cmd --zone=public --add-port=8501/tcp --permanent
firewall-cmd --zone=public --add-port=8600/tcp --permanent
firewall-cmd --zone=public --add-port=8600/udp --permanent
firewall-cmd --reload
```



## 增加服务

```bash
curl -X PUT -d '{"Datacenter": "consul-dc", "Node": "c2", "Address": "192.168.31.59", "Service": {"Service": "windows 10", "tags": ["chensj", "windows 10"], "Port": 22}}' http://127.0.0.1:8500/v1/catalog/register
```

