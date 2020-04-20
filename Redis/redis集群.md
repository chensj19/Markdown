# Redis 集群

## 环境规划

| IP             | 端口           | Redis版本 |
| -------------- | -------------- | --------- |
| 192.168.78.138 | 6001,6002,6003 | 5.0.5     |
| 192.168.78.129 | 6001,6002,6003 | 5.0.5     |
| 192.168.78.132 | 6001,6002,6003 | 5.0.5     |

## 环境准备

> 环境准备中的操作对每一台机器都是需要操作的

* 修改`limits.conf`

```bash
cat >> /etc/security/limits.conf << EOF
* soft nofile 102400
* hard nofile 102400
EOF
```

* 防火墙

```bash
firewall-cmd --zone=public --add-port=6001/tcp --permanent
firewall-cmd --zone=public --add-port=6002/tcp --permanent
firewall-cmd --zone=public --add-port=6003/tcp --permanent
firewall-cmd --zone=public --add-port=16001/tcp --permanent
firewall-cmd --zone=public --add-port=16002/tcp --permanent
firewall-cmd --zone=public --add-port=16003/tcp --permanent
firewall-cmd --reload
```

* `sysctl.conf`

```bash
echo "net.core.somaxconn = 32767" >> /etc/sysctl.conf
echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
sysctl -p
```

* transparent_hugepage

```bash
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" > /etc/rc.local 
```

* 创建文件夹

```bash
mkdir -p /usr/local/redis-cluster/{redis_6001,redis_6002,redis_6003}
```

## 节点安装

### redis-节点一

* 下载

```bash
wget http://download.redis.io/releases/redis-5.0.5.tar.gz
tar -zxvf redis-5.0.5.tar.gz
cd cd redis-5.0.5
```

* 编译安装

```bash
make MALLOC=libc &&   make PREFIX=/usr/local/redis-cluster install
```

* 配置文件

  * redis_6001

  ```bash
  bind 0.0.0.0
  protected-mode no
  port 6001
  dir /usr/local/redis-cluster/redis_6001
  cluster-enabled yes
  cluster-config-file /usr/local/redis-cluster/redis_6001/nodes.conf
  cluster-node-timeout 5000
  appendonly yes
  daemonize yes
  pidfile /usr/local/redis-cluster/redis_6001/redis.pid
  logfile /usr/local/redis-cluster/redis_6001/redis.log
  ```

  * redis_6002

  ```bash
  bind 0.0.0.0
  protected-mode no
  port 6002
  dir /usr/local/redis-cluster/redis_6002
  cluster-enabled yes
  cluster-config-file /usr/local/redis-cluster/redis_6002/nodes.conf
  cluster-node-timeout 5000
  appendonly yes
  daemonize yes
  pidfile /usr/local/redis-cluster/redis_6002/redis.pid
  logfile /usr/local/redis-cluster/redis_6002/redis.log
  ```

  * redis_6003

  ```
  bind 0.0.0.0
  protected-mode no
  port 6003
  dir /usr/local/redis-cluster/redis_6003
  cluster-enabled yes
  cluster-config-file /usr/local/redis-cluster/redis_6003/nodes.conf
  cluster-node-timeout 5000
  appendonly yes
  daemonize yes
  pidfile /usr/local/redis-cluster/redis_6003/redis.pid
  logfile /usr/local/redis-cluster/redis_6003/redis.log
  ```

* 启动脚本

```bash
REDIS_HOME=/usr/local/redis-cluster
$REDIS_HOME/bin/redis-server $REDIS_HOME/redis_6001/redis.conf
$REDIS_HOME/bin/redis-server $REDIS_HOME/redis_6002/redis.conf
$REDIS_HOME/bin/redis-server $REDIS_HOME/redis_6003/redis.conf
```

### redis-其他节点

安装上面的操作即可

## 集群配置

```bash
/usr/local/redis-cluster/bin/redis-cli --cluster create 192.168.78.138:6001 192.168.78.138:6002 192.168.78.129:6001 192.168.78.129:6002 192.168.78.132:6001 192.168.78.132:6002 --cluster-replicas 1
```

如果上述命令一直卡在`Waiting for the cluster to join`,代表端口未开，建议执行下面的批量命令，kill进程，删除生成的信息文件，执行上面的防火墙的代码后重新执行集群配置

出现下面的内容代表已经成功了

```bash
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 192.168.78.129:6002 to 192.168.78.138:6001
Adding replica 192.168.78.132:6002 to 192.168.78.129:6001
Adding replica 192.168.78.138:6002 to 192.168.78.132:6001
M: 7e3b9cc7c151ffd05479d7e28cb6aa8b61f65eeb 192.168.78.138:6001
   slots:[0-5460] (5461 slots) master
S: 2b65bb2ee74d57c69904b94c67113512145b471c 192.168.78.138:6002
   replicates fc63305b64334d2328a8a6dcab489e90c9189cef
M: d2b6017ed4235f0bfa1b46510f314078c21e6ac8 192.168.78.129:6001
   slots:[5461-10922] (5462 slots) master
S: 253b1b683693004114a97dbe73e95cfcd60300de 192.168.78.129:6002
   replicates 7e3b9cc7c151ffd05479d7e28cb6aa8b61f65eeb
M: fc63305b64334d2328a8a6dcab489e90c9189cef 192.168.78.132:6001
   slots:[10923-16383] (5461 slots) master
S: d1d2bc55429e1313ef4cc1c608902def7f744e9e 192.168.78.132:6002
   replicates d2b6017ed4235f0bfa1b46510f314078c21e6ac8
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 192.168.78.138:6001)
M: 7e3b9cc7c151ffd05479d7e28cb6aa8b61f65eeb 192.168.78.138:6001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: d1d2bc55429e1313ef4cc1c608902def7f744e9e 192.168.78.132:6002
   slots: (0 slots) slave
   replicates d2b6017ed4235f0bfa1b46510f314078c21e6ac8
S: 253b1b683693004114a97dbe73e95cfcd60300de 192.168.78.129:6002
   slots: (0 slots) slave
   replicates 7e3b9cc7c151ffd05479d7e28cb6aa8b61f65eeb
M: fc63305b64334d2328a8a6dcab489e90c9189cef 192.168.78.132:6001
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
M: d2b6017ed4235f0bfa1b46510f314078c21e6ac8 192.168.78.129:6001
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 2b65bb2ee74d57c69904b94c67113512145b471c 192.168.78.138:6002
   slots: (0 slots) slave
   replicates fc63305b64334d2328a8a6dcab489e90c9189cef
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```



## 批量命令

1. 批量结束redis进程

```bash
 ps aux| grep 'redis' |grep -v 'grep' |awk '{print $2}'|xargs kill -9
```

2. 批量删除文件

```bash
rm -rf redis1_600*/{appendonly.aof,nodes.conf,redis.log,redis.pid}
```

