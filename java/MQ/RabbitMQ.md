# Rabbit MQ

​	rabbitMQ是一个在AMQP协议标准基础上完整的，可服用的企业消息系统。它遵循Mozilla Public License开源协议，采用 Erlang 实现的工业级的消息队列(MQ)服务器，Rabbit MQ 是建立在Erlang OTP平台上。

## 1、Windows安装Rabbit MQ

### 1.1 安装Erlang

所以在安装rabbitMQ之前，需要先安装Erlang 。使用的是[otp_win64_21.3](https://pan.baidu.com/s/1c2826rA) ，需要其他版本或者32位系统的，可以去[官网](http://www.erlang.org/downloads)下载。全部点击“下一步”就行。

有的选择其他的安装方式，可能需要添加一下系统环境变量（正常安装的也要检查下）

![](https://images2015.cnblogs.com/blog/784082/201609/784082-20160923235447637-1807926011.png)

有最好，没有的话就手动添加嘛。

### 1.2 安装RabbitMQ

下载运行[rabbitmq-server-3.7.14.exe](https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.14/rabbitmq-server-3.7.14.exe)需要其他版本或者32位系统的，可以去[官网](http://www.rabbitmq.com/download.html)下载。依旧可以不改变默认进行安装。

需要注意：默认安装的RabbitMQ 监听端口是**5672**

>  将RabbitMQ安装目录下sbin目录配置到环境变量中，方便后面使用

## 2、Linux 安装

### 2.1 安装erlang

[CentOS](https://github.com/rabbitmq/erlang-rpm)按照参考文档在`/etc/yum.repos.d`创建文件`rabbitmq_erlang.repo`，填入如下内容：

* CentOS 7

```bash
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_erlang-source]
name=rabbitmq_erlang-source
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
```

* CentOS 6

```bash
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/6/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[rabbitmq_erlang-source]
name=rabbitmq_erlang-source
baseurl=https://packagecloud.io/rabbitmq/erlang/el/6/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
```

接下来执行`erlang`安装命令

```bash
$ yum install erlang
```

### 2.2 安装RabbitMQ

* 导入Package Cloud的GPG keys

```bash
＃导入将从2018年12月1日开始使用的新PackageCloud密钥（GMT） 
rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
# import将于12月1日停止使用的旧PackageCloud密钥，2018（GMT） 
rpm --import https://packagecloud.io/gpg.key
```

* 配置[Bintray Yum存储库](https://www.rabbitmq.com/install-rpm.html#bintray)

  * [RabbitMQ签名密钥](https://www.rabbitmq.com/signatures.html)

  ```bash
  rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
  ```

  * `rabbitmq.repo`

  ` CentOS 7`

  ```bash
  [bintray-rabbitmq-server]
  name=bintray-rabbitmq-rpm
  baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/
  gpgcheck=0
  repo_gpgcheck=0
  enabled=1
  ```

  `CentOS6`

  ```bash
  [bintray-rabbitmq-server]
  name=bintray-rabbitmq-rpm
  baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/6/
  gpgcheck=0
  repo_gpgcheck=0
  enabled=1
  ```

* 安装

  ```bash
  # GitHub
  rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
  # this example assumes the CentOS 7 version of the package
  yum install rabbitmq-server-3.7.14-1.el7.noarch.rpm
  
  # Rabbit 官网
  rpm --import https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
  # this example assumes the CentOS 7 version of the package
  yum install rabbitmq-server-3.7.14-1.el7.noarch.rpm
  
  
  # 或者
  
  yum install rabbitmq-server
  ```

* 开机启动

  ```bash
  chkconfig rabbitmq-server on
  ```


## 3 配置

### 3.1 plugins 激活

#### windows

使用RabbitMQ 管理插件，可以更好的可视化方式查看Rabbit MQ 服务器实例的状态。

```bash
D:\tools\RabbitMQ Server\rabbitmq_server-3.7.14\sbin\rabbitmq-plugins.bat enable rabbitmq_management
Enabling plugins on node rabbit@LAPTOP-ORJO1IR4:
rabbitmq_management
The following plugins have been configured:
  rabbitmq_management
  rabbitmq_management_agent
  rabbitmq_web_dispatch
Applying plugin configuration to rabbit@LAPTOP-ORJO1IR4...
The following plugins have been enabled:
  rabbitmq_management
  rabbitmq_management_agent
  rabbitmq_web_dispatch
```

#### linux

```bash
$ rabbitmq-plugins enable rabbitmq_management
Enabling plugins on node rabbit@centos7:
rabbitmq_management
The following plugins have been configured:
  rabbitmq_management
  rabbitmq_management_agent
  rabbitmq_web_dispatch
Applying plugin configuration to rabbit@centos7...
The following plugins have been enabled:
  rabbitmq_management
  rabbitmq_management_agent
  rabbitmq_web_dispatch

set 3 plugins.
Offline change; changes will take effect at broker restart.
```

### 3.2  重启

#### windows

> 需要管理员权限

```bash
$ net stop RabbitMQ & net start RabbitMQ
```

#### linux

```bash
$ systemctl restart rabbitmq-server
```

### 3.3 权限信息

用户，密码，绑定角色

使用rabbitmqctl控制台命令（位于D:\tools\RabbitMQ Server\rabbitmq_server-3.7.14\sbin>）来创建用户，密码，绑定权限等。

注意：安装路径不同的请看仔细啊。

rabbitmq的用户管理包括增加用户，删除用户，查看用户列表，修改用户密码。

* 查看已有用户及用户的角色：

```bash
$ rabbitmqctl list_users
```

![](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924001810231-489339837.png)

* 新增一个用户：

  ```bash
  $ rabbitmqctl add_user username password
  ```

![添加用户](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924002317996-1750317042.png)

![查看用户](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924002417481-667312419.png)

* 配置角色

  * 角色分类

    * 超级管理员(administrator)

      可登陆管理控制台(启用management plugin的情况下)，可查看所有的信息，并且可以对用户，策略(policy)进行操作。

    * 监控者(monitoring)

      可登陆管理控制台(启用management plugin的情况下)，同时可以查看rabbitmq节点的相关信息(进程数，内存使用情况，磁盘使用情况等) 

    * 策略制定者(policymaker)

      可登陆管理控制台(启用management plugin的情况下), 同时可以对policy进行管理。

    * 普通管理者(management)

      仅可登陆管理控制台(启用management plugin的情况下)，无法看到节点信息，也无法对策略进行管理。

    * 其他的

      无法登陆管理控制台，通常就是普通的生产者和消费者。

  * 配置角色

  ```bash
  $ rabbitmqctl set_user_tags username administrator
  ```

  ![角色变更](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924003014246-2015422375.png)

  ![查看用户](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924003047621-1862534375.png)

  * 多角色添加

  ```bash
  $ rabbitmqctl.bat  set_user_tags  username tag1 tag2 ...
  ```

* 密码修改

  现在总觉得guest 这个不安全（它的默认密码是guest）,想更改密码

```bash
$ rabbitmqctl change_password userName newPassword
```

![修改密码](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924003352168-1350202979.png)

​	

* 用户删除

```bash
$ rabbitmqctl.bat delete_user username
```

![用户删除](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924003722731-332310837.png)

* 管理页面

```url
http://localhost:15672/
```

![](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924004023387-110874920.png)

![](https://images2015.cnblogs.com/blog/784082/201609/784082-20160924004035121-53385779.png)

* ### 权限设置

  用户有了角色，那也需要权限设置啊，别急，慢慢来：

  按照官方文档，用户权限指的是用户对exchange，queue的操作权限，包括配置权限，读写权限。

  我们配置权限会影响到exchange、queue的声明和删除。

  读写权限影响到从queue里取消息、向exchange发送消息以及queue和exchange的绑定(binding)操作。

  例如： 将queue绑定到某exchange上，需要具有queue的可写权限，以及exchange的可读权限；向exchange发送消息需要具有exchange的可写权限；从queue里取数据需要具有queue的可读权限

   

  权限相关命令为：

  (1) 设置用户权限

  ```bash
  $ rabbitmqctl  set_permissions  -p  VHostPath  User  ConfP  WriteP  ReadP
  ```

  (2) 查看(指定hostpath)所有用户的权限信息 

  ```bash
  rabbitmqctl  list_permissions  [-p  VHostPath]
  ```

  (3) 查看指定用户的权限信息

  ```bash
  rabbitmqctl  list_user_permissions  User
  ```

  (4)  清除用户的权限信息

  ```bash
  rabbitmqctl  clear_permissions  [-p VHostPath]  User
  ```

### 3.4 虚拟主机

1. 创建虚拟主机

```bash 
 rabbitmqctl  add_vhost  vhostpath
```

2. 删除虚拟主机

```bash
rabbitmqctl delete_vhost vhostpath
```

3.列出所有虚拟主机

```bash
 rabbitmqctl list_vhosts
```

4.设置用户权限

```bash
 rabbitmqctl set_permissions [-pvhostpath] username regexp regexp regexp
 rabbitmqctl  set_permissions  -p mq_test chensj  ConfP WriteP ReadP
```

5.清除用户权限

```bash
rabbitmqctl clear_permissions [-pvhostpath] username
```

6.列出虚拟主机上的所有权限

```bash
rabbitmqctl list_permissions [-pvhostpath]
```

7.列出用户权限

```bash
 rabbitmqctl list_user_permissionsusername
```

### 3.5 防火墙

```bash
[root@centos7 rabbitmq]# firewall-cmd --zone=public --add-port=15672/tcp --permanent
success
[root@centos7 rabbitmq]# firewall-cmd --zone=public --add-port=5672/tcp --permanent
success
[root@centos7 rabbitmq]# firewall-cmd --reload
success
```



## 4、问题

### 4.1 rabbitmqctl list_users 无结果，报错

```bash
# rabbitmqctl list_users
Error: unable to perform an operation on node 'rabbit@centos7'. Please see diagnostics information and suggestions below.

Most common reasons for this are:

 * Target node is unreachable (e.g. due to hostname resolution, TCP connection or firewall issues)
 * CLI tool fails to authenticate with the server (e.g. due to CLI tool's Erlang cookie not matching that of the server)
 * Target node is not running

In addition to the diagnostics info below:

 * See the CLI, clustering and networking guides on https://rabbitmq.com/documentation.html to learn more
 * Consult server logs on node rabbit@centos7
 * If target node is configured to use long node names, don't forget to use --longnames with CLI tools

DIAGNOSTICS
===========

attempted to contact: [rabbit@centos7]

rabbit@centos7:
  * connected to epmd (port 4369) on centos7
  * epmd reports node 'rabbit' uses port 25672 for inter-node and CLI tool traffic
  * can't establish TCP connection to the target node, reason: timeout (timed out)
  * suggestion: check if host 'centos7' resolves, is reachable and ports 25672, 4369 are not blocked by firewall

Current node details:
 * node name: 'rabbitmqcli-9479-rabbit@centos7'
 * effective user's home directory: /var/lib/rabbitmq
 * Erlang cookie hash: QFTLLiuyW687QJpboJ67lA==
```

原因分析：

unable to perform an operation on node 'rabbit@centos7'. Please see diagnostics information and suggestions below

本机hostname是centos7.node.web1，但是RabbitMQ中使用 的centos7，对于本机来说，是无法识别的，导致ping不通

解决方法：

```
在/etc/hosts 中增加一个 centos7即可
```

