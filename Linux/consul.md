[TOC]

# Consul

## 一、Nginx Consul Docker高可用

### 1、环境配置

#### 1.1 docker配置

##### 1.1.1 镜像启动无法访问

```bash
vi /etc/sysctl.conf 
# 添加如下代码
net.ipv4.ip_forward=1
# 重启network服务
systemctl restart network 
# 查看是否修改成功
sysctl net.ipv4.ip_forward 
# 如果返回为“net.ipv4.ip_forward = 1”则表示成功了
```

##### 1.1.2 网段冲突

1.修改文件`/etc/docker/daemon.json`添加内容` “bip”: “ip/netmask” `[ 切勿与宿主机同网段 ]
命令：

```bash
cat << EOF >> daemon.json
>{
>“registry-mirrors”:[“https://docs.docker.com”],
>“bip”:“172.17.10.1/24”
>}
```
2.重启docker服务 
```bash
systemctl restart docker
```
3.查看修改后的docker0网桥信息 

```bash 
ifconfig docker0
```

#### 1.2 Nginx 配置

##### 1.2.1 [emerg] bind() to 0.0.0.0:XXXX failed (13: Permission denied)

第一种：端口小于1024的情况：

```bash
[emerg] bind() to 0.0.0.0:80 failed (13: Permission denied)
```

> 原因是1024以下端口启动时需要root权限，所以sudo nginx即可。

第二种：端口大于1024的情况：

```bash
[emerg] bind() to 0.0.0.0:8380 failed (13: Permission denied)
```


这种情况，需要如下操作：

首先，查看http允许访问的端口：

```bash
semanage port -l | grep http_port_t
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
```

其次，将要启动的端口加入到如上端口列表中

```bash
semanage port -a -t http_port_t  -p tcp 8090
```

#### 1.3 docker-compose 安装

```bash
yum install -y docker-componse
```

### 2、consul集群搭建

#### 2.1 docker consul

 使用docker容器来搭建consul集群，编写Docker compose

集群说明

1. 3个server节点（consul-server1 ~ 3）和 2个node节点（consul-node1 ~ 2）
2. 映射本地 consul/data1 ~ 3/ 目录到 Docker 容器中，避免 Consul 集群重启后数据丢失。
3. Consul web http 端口分别为 8501、8502、8503

` docker-compose.yml `

```yml

version: '2.0'
services:
  consul-server1:
    image: consul:latest
    hostname: "consul-server1"
    ports:
      - "8501:8500"
    volumes:
      - ./consul/data1:/consul/data
    command: "agent -server -bootstrap-expect 3 -ui -disable-host-node-id -client 0.0.0.0"
  consul-server2:
    image: consul:latest
    hostname: "consul-server2"
    ports:
      - "8502:8500"
    volumes:
      - ./consul/data2:/consul/data
    command: "agent -server -ui -join consul-server1 -disable-host-node-id -client 0.0.0.0"
    depends_on: 
      - consul-server1
  consul-server3:
    image: consul:latest
    hostname: "consul-server3"
    ports:
      - "8503:8500"
    volumes:
      - ./consul/data3:/consul/data
    command: "agent -server -ui -join consul-server1 -disable-host-node-id -client 0.0.0.0"
    depends_on:
      - consul-server1
  consul-node1:
    image: consul:latest
    hostname: "consul-node1"
    command: "agent -join consul-server1 -disable-host-node-id"
    depends_on:
      - consul-server1
  consul-node2:
    image: consul:latest
    hostname: "consul-node2"
    command: "agent -join consul-server1 -disable-host-node-id"
    depends_on:
```

集群启动时默认以`consul-server1`为 leader，然后`server2 ~ 3`和`node1 ~ 2`加入到该集群。当`server1`出现故障下线是，`server2 ~ 3`则会进行选举选出新leader。

集群操作

* 创建并启动集群：docker-compose up -d
* 停止整个集群：docker-compose stop
* 启动集群：docker-compose start
* 清除整个集群：docker-compose rm（注意：需要先停止）
* 访问
  http://localhost:8501
  http://localhost:8502
  http://localhost:8503

#### 2.2 nginx

##### 2.2.1  设定负载均衡服务器列表 

```nginx
upstream consul {
    server 127.0.0.1:8501;
    server 127.0.0.1:8502;
    server 127.0.0.1:8503;
}
```

##### 2.2.2 服务配置

在`/etc/nginx/conf.d`下面新建一个`consul.conf`，添加如下内容

```nginx
upstream consul {
    server 127.0.0.1:8501;
    server 127.0.0.1:8502;
    server 127.0.0.1:8503;
}
server {
    listen       8500;
    server_name  localhost; #服务域名，需要填写你的服务域名

    charset utf-8;
    access_log  /var/log/nginx/consul.access.log  main;

    location / {
        proxy_pass  http://consul;#请求转向consul服务器列表
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## 二、Consul服务化

### 1.1 下载

```bash
wget https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip
```

### 1.2 复制与验证

```bash
unzip consul_1.6.1_linux_amd64.zip
cp consul /usr/local/bin/
consul version
```

### 1.3 consul.service

`vim /usr/lib/systemd/system/consul.service`

```bash
[Unit]
Description=consul
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/consul/start.sh
ExecStop=ps -ef|grep consul.service |awk '{print $2}'| kill -9 $1
ExecReload=/usr/local/bin/consul reload
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

`vim /usr/local/consul/start.sh`

```bash
#!/bin/bash
/usr/bin/nohup /usr/local/bin/consul agent -server -node=consul-97 -data-dir=/data/consul/ -config-dir=/etc/consul/ -ui -log-file=/var/log/consul/consul-run-$(date +%Y%m%d).log -bind=192.168.31.97 -join=192.168.31.97 -datacenter=consul >> /var/log/consul/consul-start.log 2>&1 &
```

 文件夹

```bash
mkdir -p /data/consul/
mkdir -p /var/log/consul/
mkdir -p /etc/consul
```

`vim /etc/consul/server.json`

```json
{
    "data_dir": "/data/consul",
    "log_level": "INFO",
    "node_name": "consul-97",
    "server": true,
    "bootstrap_expect": 1,
    "client_addr": "0.0.0.0",		
    "advertise_addr": "192.168.31.97",
    "advertise_addr_wan": "192.168.31.97"
}

```

### 1.4 测试

```bash
systemctl daemon-reload
systemctl start consul
systemctl stop consul
systemctl reload consul
```

