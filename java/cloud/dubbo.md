# [Dubbo](http://dubbo.apache.org/zh-cn/index.html)

## [简介](https://www.bilibili.com/video/av57001521/)

Apache Dubbo™ 是一款高性能Java RPC框架

RPC：远程过程调用(`Remote Procedure Call`,缩写为RPC)，是一种计算机通信协议(*？与http、tcp等协议是否为同级的*)。该协议允许运行于一台计算机的程序调用另一台计算的子程序，而程序员无需额外地为这个交互作用编程。如果涉及的软件采用面向对象编程(Java)，那么远程过程调用也可称为远程调用或远程方法调用

> 比如说 两个应用之间的服务通过http/socket/webservice等调用，都是一种通过RPC协议实现的调用
>
> RPC是一种广义的通信协议，比如http、webservice等都属于RPC协议，只是一种通信协议的抽象

Apache Dubbo |ˈdʌbəʊ| 是一款高性能、轻量级的开源Java RPC框架，它提供了三大核心能力：**面向接口的远程方法调用**，**智能容错和负载均衡**，以及**服务自动注册和发现**

### 背景

随着互联网的发展，网站应用的规模不断扩大，常规的垂直应用架构已无法应对，分布式服务架构以及流动计算架构势在必行，亟需一个治理系统确保架构有条不紊的演进。

![image](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-architecture-roadmap.jpg)

#### 单一应用架构

当网站流量很小时，只需一个应用，将所有功能都部署在一起，以减少部署节点和成本。此时，用于简化增删改查工作量的数据访问框架(ORM)是关键。

#### 垂直应用架构

当访问量逐渐增大，单一应用增加机器带来的加速度越来越小，将应用拆成互不相干的几个应用，以提升效率。此时，用于加速前端页面开发的Web框架(MVC)是关键。

#### 分布式服务架构

当垂直应用越来越多，应用之间交互不可避免，将核心业务抽取出来，作为独立的服务，逐渐形成稳定的服务中心，使前端应用能更快速的响应多变的市场需求。此时，用于提高业务复用及整合的分布式服务框架(RPC)是关键。

#### 流动计算架构

当服务越来越多，容量的评估，小服务资源的浪费等问题逐渐显现，此时需增加一个调度中心基于访问压力实时管理集群容量，提高集群利用率。此时，用于提高机器利用率的资源调度和治理中心(SOA)是关键。

### 需求

![Dubbo服务治理](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-service-governance.jpg)

在大规模服务化之前，应用可能只是通过 RMI 或 Hessian 等工具，简单的暴露和引用远程服务，通过配置服务的URL地址进行调用，通过 F5 等硬件进行负载均衡。

**当服务越来越多时，服务 URL 配置管理变得非常困难，F5 硬件负载均衡器的单点压力也越来越大。** 此时需要一个服务注册中心，动态地注册和发现服务，使服务的位置透明。并通过在消费方获取服务提供方地址列表，实现软负载均衡和 Failover，降低对 F5 硬件负载均衡器的依赖，也能减少部分成本。

**当进一步发展，服务间依赖关系变得错踪复杂，甚至分不清哪个应用要在哪个应用之前启动，架构师都不能完整的描述应用的架构关系。** 这时，需要自动画出应用间的依赖关系图，以帮助架构师理清理关系。

**接着，服务的调用量越来越大，服务的容量问题就暴露出来，这个服务需要多少机器支撑？什么时候该加机器？** 为了解决这些问题，第一步，要将服务现在每天的调用量，响应时间，都统计出来，作为容量规划的参考指标。其次，要可以动态调整权重，在线上，将某台机器的权重一直加大，并在加大的过程中记录响应时间的变化，直到响应时间到达阈值，记录此时的访问量，再以此访问量乘以机器数反推总容量。

以上是 Dubbo 最基本的几个需求。

### 架构

![架构图](http://dubbo.apache.org/img/architecture.png)

#### 节点角色说明

| 节点        | 角色说明                               |
| ----------- | -------------------------------------- |
| `Provider`  | 暴露服务的服务提供方                   |
| `Consumer`  | 调用远程服务的服务消费方               |
| `Registry`  | 服务注册与发现的注册中心               |
| `Monitor`   | 统计服务的调用次数和调用时间的监控中心 |
| `Container` | 服务运行容器                           |

#### 调用关系说明

1. 服务容器负责启动，加载，运行服务提供者。
2. 服务提供者在启动时，向注册中心注册自己提供的服务。
3. 服务消费者在启动时，向注册中心订阅自己所需的服务。
4. 注册中心返回服务提供者地址列表给消费者，如果有变更，注册中心将基于长连接推送变更数据给消费者。
5. 服务消费者，从提供者地址列表中，基于软负载均衡算法，选一台提供者进行调用，如果调用失败，再选另一台调用。
6. 服务消费者和提供者，在内存中累计调用次数和调用时间，定时每分钟发送一次统计数据到监控中心。

#### Dubbo 架构特点

Dubbo 架构具有以下几个特点，分别是连通性、健壮性、伸缩性、以及向未来架构的升级性。

##### 连通性

- 注册中心负责服务地址的注册与查找，相当于目录服务，服务提供者和消费者只在启动时与注册中心交互，注册中心不转发请求，压力较小
- 监控中心负责统计各服务调用次数，调用时间等，统计先在内存汇总后每分钟一次发送到监控中心服务器，并以报表展示
- 服务提供者向注册中心注册其提供的服务，并汇报调用时间到监控中心，此时间不包含网络开销
- 服务消费者向注册中心获取服务提供者地址列表，并根据负载算法直接调用提供者，同时汇报调用时间到监控中心，此时间包含网络开销
- 注册中心，服务提供者，服务消费者三者之间均为长连接，监控中心除外
- 注册中心通过长连接感知服务提供者的存在，服务提供者宕机，注册中心将立即推送事件通知消费者
- 注册中心和监控中心全部宕机，不影响已运行的提供者和消费者，消费者在本地缓存了提供者列表
- 注册中心和监控中心都是可选的，服务消费者可以直连服务提供者

##### 健壮性

- 监控中心宕掉不影响使用，只是丢失部分采样数据
- 数据库宕掉后，注册中心仍能通过缓存提供服务列表查询，但不能注册新服务
- 注册中心对等集群，任意一台宕掉后，将自动切换到另一台
- 注册中心全部宕掉后，服务提供者和服务消费者仍能通过本地缓存通讯
- 服务提供者无状态，任意一台宕掉后，不影响使用
- 服务提供者全部宕掉后，服务消费者应用将无法使用，并无限次重连等待服务提供者恢复

#### 伸缩性

- 注册中心为对等集群，可动态增加机器部署实例，所有客户端将自动发现新的注册中心
- 服务提供者无状态，可动态增加机器部署实例，注册中心将推送新的服务提供者信息给消费者

##### 升级性

当服务集群规模进一步扩大，带动IT治理结构进一步升级，需要实现动态部署，进行流动计算，现有分布式服务架构不会带来阻力。下图是未来可能的一种架构：

![dubbo-architucture-futures](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-architecture-future.jpg)

##### 节点角色说明

| 节点         | 角色说明                               |
| ------------ | -------------------------------------- |
| `Deployer`   | 自动部署服务的本地代理                 |
| `Repository` | 仓库用于存储服务应用发布包             |
| `Scheduler`  | 调度中心基于访问压力自动增减服务提供者 |
| `Admin`      | 统一管理控制台                         |
| `Registry`   | 服务注册与发现的注册中心               |
| `Monitor`    | 统计服务的调用次数和调用时间的监控中心 |

### 特性

* 面向接口代理的高性能RPC调用

  提供高性能的基于代理的远程调用能力，服务以接口为粒度，为开发者屏蔽远程调用底层细节。

* 智能负载均衡

  内置多种负载均衡策略，智能感知下游节点健康状况，显著减少调用延迟，提高系统吞吐量。

* 服务自动注册与发现

  支持多种注册中心服务，服务实例上下线实时感知。

*  高度可扩展能力

  遵循微内核+插件的设计原则，所有核心能力如Protocol、Transport、Serialization被设计为扩展点，平等对待内置实现和第三方实现。

* 运行期流量调度

  内置条件、脚本等路由策略，通过配置不同的路由规则，轻松实现灰度发布，同机房优先等功能。

*  可视化的服务治理与运维

  提供丰富服务治理、运维工具：随时查询服务元数据、服务健康状态及调用统计，实时下发路由策略、调整配置参数。

### 用法

#### 本地服务 Spring 配置

local.xml:

```xml
<bean id=“xxxService” class=“com.xxx.XxxServiceImpl” />
<bean id=“xxxAction” class=“com.xxx.XxxAction”>
    <property name=“xxxService” ref=“xxxService” />
</bean>
```

#### 远程服务 Spring 配置

在本地服务的基础上，只需做简单配置，即可完成远程化：

- 将上面的 `local.xml` 配置拆分成两份，将服务定义部分放在服务提供方 `remote-provider.xml`，将服务引用部分放在服务消费方 `remote-consumer.xml`。
- 并在提供方增加暴露服务配置 `<dubbo:service>`，在消费方增加引用服务配置 `<dubbo:reference>`。

remote-provider.xml:

```xml
<!-- 和本地服务一样实现远程服务 -->
<bean id=“xxxService” class=“com.xxx.XxxServiceImpl” /> 
<!-- 增加暴露远程服务配置 -->
<dubbo:service interface=“com.xxx.XxxService” ref=“xxxService” /> 
```

remote-consumer.xml:

```xml
<!-- 增加引用远程服务配置 -->
<dubbo:reference id=“xxxService” interface=“com.xxx.XxxService” />
<!-- 和本地服务一样使用远程服务 -->
<bean id=“xxxAction” class=“com.xxx.XxxAction”> 
    <property name=“xxxService” ref=“xxxService” />
</bean>
```



## `Zookeeper` 注册中心

[Zookeeper](http://zookeeper.apache.org/) 是 Apacahe Hadoop 的子项目，是一个树型的目录服务，支持变更推送，适合作为 Dubbo 服务的注册中心，工业强度较高，可用于生产环境，并推荐使用 [[1\]](http://dubbo.apache.org/zh-cn/docs/user/references/registry/zookeeper.html#fn1)。

### 搭建与启动

源文件：https://archive.apache.org/dist/zookeeper/

然后选择指定版本，下载解压，到bin目录下面后，按照环境选择不同的启动脚本

第一次启动，会报错

```bash
 ./zkServer.cmd

D:\DevTools\zookeeper-3.4.14\bin>call "D:\DevTools\Java\jdk1.8.0_181"\bin\java "-Dzookeeper.log.dir=D:\DevTools\zookeeper-3.4.14\bin\.." "-Dzookeeper.root.logger=INFO,CONSOLE" -cp "D:\DevTools\zookeeper-3.4.14\bin\..\build\classes;D:\DevTools\zookeeper-3.4.14\bin\..\build\lib\*;D:\DevTools\zookeeper-3.4.14\bin\..\*;D:\DevTools\zookeeper-3.4.14\bin\..\lib\*;D:\DevTools\zookeeper-3.4.14\bin\..\conf" org.apache.zookeeper.server.quorum.QuorumPeerMain "D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg"
2019-07-16 20:45:48,403 [myid:] - INFO  [main:QuorumPeerConfig@136] - Reading configuration from: D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg
2019-07-16 20:45:48,411 [myid:] - ERROR [main:QuorumPeerMain@88] - Invalid config, exiting abnormally
org.apache.zookeeper.server.quorum.QuorumPeerConfig$ConfigException: Error processing D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg
        at org.apache.zookeeper.server.quorum.QuorumPeerConfig.parse(QuorumPeerConfig.java:156)
        at org.apache.zookeeper.server.quorum.QuorumPeerMain.initializeAndRun(QuorumPeerMain.java:104)
        at org.apache.zookeeper.server.quorum.QuorumPeerMain.main(QuorumPeerMain.java:81)
Caused by: java.lang.IllegalArgumentException: D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg file is missing
        at org.apache.zookeeper.server.quorum.QuorumPeerConfig.parse(QuorumPeerConfig.java:140)
        ... 2 more
Invalid config, exiting abnormally
```

处理方法：

复制conf文件下的`zoo_sample.cfg`为`zoo.cfg`，重新执行启动命令即可

```bash
zkServer.cmd

D:\DevTools\zookeeper-3.4.14\bin>call "D:\DevTools\Java\jdk1.8.0_181"\bin\java "-Dzookeeper.log.dir=D:\DevTools\zookeeper-3.4.14\bin\.." "-Dzookeeper.root.logger=INFO,CONSOLE" -cp "D:\DevTools\zookeeper-3.4.14\bin\..\build\classes;D:\DevTools\zookeeper-3.4.14\bin\..\build\lib\*;D:\DevTools\zookeeper-3.4.14\bin\..\*;D:\DevTools\zookeeper-3.4.14\bin\..\lib\*;D:\DevTools\zookeeper-3.4.14\bin\..\conf" org.apache.zookeeper.server.quorum.QuorumPeerMain "D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg"
2019-07-16 20:49:00,603 [myid:] - INFO  [main:QuorumPeerConfig@136] - Reading configuration from: D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg
2019-07-16 20:49:00,622 [myid:] - INFO  [main:DatadirCleanupManager@78] - autopurge.snapRetainCount set to 3
2019-07-16 20:49:00,623 [myid:] - INFO  [main:DatadirCleanupManager@79] - autopurge.purgeInterval set to 0
2019-07-16 20:49:00,624 [myid:] - INFO  [main:DatadirCleanupManager@101] - Purge task is not scheduled.
2019-07-16 20:49:00,628 [myid:] - WARN  [main:QuorumPeerMain@116] - Either no config or no quorum defined in config, running  in standalone mode
2019-07-16 20:49:00,738 [myid:] - INFO  [main:QuorumPeerConfig@136] - Reading configuration from: D:\DevTools\zookeeper-3.4.14\bin\..\conf\zoo.cfg
2019-07-16 20:49:00,739 [myid:] - INFO  [main:ZooKeeperServerMain@98] - Starting server
2019-07-16 20:49:00,799 [myid:] - INFO  [main:Environment@100] - Server environment:zookeeper.version=3.4.14-4c25d480e66aadd371de8bd2fd8da255ac140bcf, built on 03/06/2019 16:18 GMT
2019-07-16 20:49:00,800 [myid:] - INFO  [main:Environment@100] - Server environment:host.name=DESKTOP-EMLDN78
2019-07-16 20:49:00,801 [myid:] - INFO  [main:Environment@100] - Server environment:java.version=1.8.0_181
2019-07-16 20:49:00,801 [myid:] - INFO  [main:Environment@100] - Server environment:java.vendor=Oracle Corporation
2019-07-16 20:49:00,802 [myid:] - INFO  [main:Environment@100] - Server environment:java.home=D:\DevTools\Java\jdk1.8.0_181\jre
2019-07-16 20:49:00,802 [myid:] - INFO  [main:Environment@100] - Server environment:java.class.path=D:\DevTools\zookeeper-3.4.14\bin\..\build\classes;D:\DevTools\zookeeper-3.4.14\bin\..\build\lib\*;D:\DevTools\zookeeper-3.4.14\bin\..\zookeeper-3.4.14.jar;D:\DevTools\zookeeper-3.4.14\bin\..\lib\audience-annotations-0.5.0.jar;D:\DevTools\zookeeper-3.4.14\bin\..\lib\jline-0.9.94.jar;D:\DevTools\zookeeper-3.4.14\bin\..\lib\log4j-1.2.17.jar;D:\DevTools\zookeeper-3.4.14\bin\..\lib\netty-3.10.6.Final.jar;D:\DevTools\zookeeper-3.4.14\bin\..\lib\slf4j-api-1.7.25.jar;D:\DevTools\zookeeper-3.4.14\bin\..\lib\slf4j-log4j12-1.7.25.jar;D:\DevTools\zookeeper-3.4.14\bin\..\conf
2019-07-16 20:49:00,804 [myid:] - INFO  [main:Environment@100] - Server environment:java.library.path=D:\DevTools\Java\jdk1.8.0_181\bin;.
2019-07-16 20:49:00,810 [myid:] - INFO  [main:Environment@100] - Server environment:java.io.tmpdir=C:\Users\chensj\AppData\Local\Temp\
2019-07-16 20:49:00,810 [myid:] - INFO  [main:Environment@100] - Server environment:java.compiler=<NA>
2019-07-16 20:49:00,812 [myid:] - INFO  [main:Environment@100] - Server environment:os.name=Windows 10
2019-07-16 20:49:00,812 [myid:] - INFO  [main:Environment@100] - Server environment:os.arch=amd64
2019-07-16 20:49:00,813 [myid:] - INFO  [main:Environment@100] - Server environment:os.version=10.0
2019-07-16 20:49:00,813 [myid:] - INFO  [main:Environment@100] - Server environment:user.name=chensj
2019-07-16 20:49:00,814 [myid:] - INFO  [main:Environment@100] - Server environment:user.home=C:\Users\chensj
2019-07-16 20:49:00,814 [myid:] - INFO  [main:Environment@100] - Server environment:user.dir=D:\DevTools\zookeeper-3.4.14\bin
2019-07-16 20:49:00,824 [myid:] - INFO  [main:ZooKeeperServer@836] - tickTime set to 2000
2019-07-16 20:49:00,826 [myid:] - INFO  [main:ZooKeeperServer@845] - minSessionTimeout set to -1
2019-07-16 20:49:00,826 [myid:] - INFO  [main:ZooKeeperServer@854] - maxSessionTimeout set to -1
2019-07-16 20:49:01,640 [myid:] - INFO  [main:ServerCnxnFactory@117] - Using org.apache.zookeeper.server.NIOServerCnxnFactory as server connection factory
2019-07-16 20:49:01,642 [myid:] - INFO  [main:NIOServerCnxnFactory@89] - binding to port 0.0.0.0/0.0.0.0:2181
```

### 配置

`zookeeper`的配置文件如下

```properties
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
# 数据存放位置，当前是linux
dataDir=/tmp/zookeeper
# the port at which the clients will connect
# 使用端口
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
```

#### 配置文件

```properties
tickTime=2000
initLimit=10
syncLimit=5
# 数据存放位置
dataDir=../data
# 使用端口
clientPort=2181
```

### `zookeeper`流程

zookeeper常用命令：

使用zkcli.cmd运行，即可连接到本地运行的zookeeper注册中心

``` bash
# 获取根节点
get /
# 查看根节点
ls /
# 创建节点
create -e /chensj 123456
```



![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/zookeeper.jpg)

流程说明：

- 服务提供者启动时: 向 `/dubbo/com.foo.BarService/providers` 目录下写入自己的 URL 地址
- 服务消费者启动时: 订阅 `/dubbo/com.foo.BarService/providers` 目录下的提供者 URL 地址。并向 `/dubbo/com.foo.BarService/consumers` 目录下写入自己的 URL 地址
- 监控中心启动时: 订阅 `/dubbo/com.foo.BarService` 目录下的所有提供者和消费者 URL 地址。

支持以下功能：

- 当提供者出现断电等异常停机时，注册中心能自动删除提供者信息
- 当注册中心重启时，能自动恢复注册数据，以及订阅请求
- 当会话过期时，能自动恢复注册数据，以及订阅请求
- 当设置 `<dubbo:registry check="false" />` 时，记录失败注册和订阅请求，后台定时重试
- 可通过 `<dubbo:registry username="admin" password="1234" />` 设置 zookeeper 登录信息
- 可通过 `<dubbo:registry group="dubbo" />` 设置 `zookeeper` 的根节点，不设置将使用无根树
- 支持 `*` 号通配符 `<dubbo:reference group="*" version="*" />`，可订阅服务的所有分组和所有版本的提供者

## `Dubbo` 监控中心

1. 下载代码: `git clone https://github.com/apache/dubbo-admin.git`

2. 在 `dubbo-admin-server/src/main/resources/application.properties`中指定注册中心地址

3. 构建

   ```bash
   mvn clean package
   ```

4. 启动

   - `mvn --projects dubbo-admin spring-boot:run`
     或者
   - `cd dubbo-admin/target; java -jar dubbo-admin-0.0.1-SNAPSHOT.jar`

5. 访问 `http://localhost:7001`


