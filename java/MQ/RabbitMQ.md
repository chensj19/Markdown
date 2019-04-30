# Rabbit MQ

​	rabbitMQ是一个在AMQP协议标准基础上完整的，可服用的企业消息系统。它遵循Mozilla Public License开源协议，采用 Erlang 实现的工业级的消息队列(MQ)服务器，Rabbit MQ 是建立在Erlang OTP平台上。

## 1、安装Rabbit MQ

### 1.1 安装Erlang

所以在安装rabbitMQ之前，需要先安装Erlang 。使用的是[otp_win64_21.3](https://pan.baidu.com/s/1c2826rA) ，需要其他版本或者32位系统的，可以去[官网](http://www.erlang.org/downloads)下载。全部点击“下一步”就行。

有的选择其他的安装方式，可能需要添加一下系统环境变量（正常安装的也要检查下）

![](https://images2015.cnblogs.com/blog/784082/201609/784082-20160923235447637-1807926011.png)

有最好，没有的话就手动添加嘛。

### 1.2 安装RabbitMQ

下载运行[rabbitmq-server-3.7.14.exe](https://dl.bintray.com/rabbitmq/all/rabbitmq-server/3.7.14/rabbitmq-server-3.7.14.exe)需要其他版本或者32位系统的，可以去[官网](http://www.rabbitmq.com/download.html)下载。依旧可以不改变默认进行安装。

需要注意：默认安装的RabbitMQ 监听端口是**5672**

>  将RabbitMQ安装目录下sbin目录配置到环境变量中，方便后面使用

### 1.3 配置

#### 1.3.1 激活Plugin

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

#### 1.3.2 重启

> 需要管理员权限

```bash
$ net stop RabbitMQ & net start RabbitMQ
```

#### 1.3.3 创建用户，密码，绑定角色

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

  