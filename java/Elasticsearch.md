# Elasticsearch

## 简介

ES=elaticsearch简写， Elasticsearch是一个开源的高扩展的分布式全文检索引擎，它可以近乎实时的存储、检索数据；本身扩展性很好，可以扩展到上百台服务器，处理PB级别的数据。 
Elasticsearch也使用Java开发并使用Lucene作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得简单。

Elasticsearch 是一个分布式可扩展的实时搜索和分析引擎,一个建立在全文搜索引擎 Apache Lucene(TM) 基础上的搜索引擎.当然 Elasticsearch 并不仅仅是 Lucene 那么简单，它不仅包括了全文搜索功能，还可以进行以下工作:

- 分布式实时文件存储，并将每一个字段都编入索引，使其可以被搜索。
- 实时分析的分布式搜索引擎。
- 可以扩展到上百台服务器，处理PB级别的结构化或非结构化数据。

官网：https://www.elastic.co/cn/

参考文档： https://es.xiaoleilu.com/

### Lucene与ES关系？

1）Lucene只是一个库。想要使用它，你必须使用Java来作为开发语言并将其直接集成到你的应用中，更糟糕的是，Lucene非常复杂，你需要深入了解检索的相关知识来理解它是如何工作的。

2）Elasticsearch也使用Java开发并使用Lucene作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得简单。

### ES主要解决问题

1）检索相关数据； 
2）返回统计结果； 
3）速度要快。

###  ES工作原理

当ElasticSearch的节点启动后，它会利用多播(multicast)(或者单播，如果用户更改了配置)寻找集群中的其它节点，并与之建立连接。这个过程如下图所示： 

![](https://img-blog.csdn.net/20160818205953345)

### ES核心概念

1. Cluster：集群。

   ES可以作为一个独立的单个搜索服务器。不过，为了处理大型数据集，实现容错和高可用性，ES可以运行在许多互相合作的服务器上。这些服务器的集合称为集群。

2. Node：节点。

   形成集群的每个服务器称为节点。

3. Shard：分片。

   当有大量的文档时，由于内存的限制、磁盘处理能力不足、无法足够快的响应客户端的请求等，一个节点可能不够。这种情况下，数据可以分为较小的分片。每个分片放到不同的服务器上。 
   当你查询的索引分布在多个分片上时，ES会把查询发送给每个相关的分片，并将结果组合在一起，而应用程序并不知道分片的存在。即：这个过程对用户来说是透明的。

4. Replia：副本。

   为提高查询吞吐量或实现高可用性，可以使用分片副本。 
   副本是一个分片的精确复制，每个分片可以有零个或多个副本。ES中可以有许多相同的分片，其中之一被选择更改索引操作，这种特殊的分片称为主分片。 
   当主分片丢失时，如：该分片所在的数据不可用时，集群将副本提升为新的主分片。

5. 全文检索。

   全文检索就是对一篇文章进行索引，可以根据关键字搜索，类似于mysql里的like语句。 全文索引就是把内容根据词的意义进行分词，然后分别创建索引，例如”你们的激情是因为什么事情来的” 可能会被分词成：“你们“，”激情“，“什么事情“，”来“ 等token，这样当你搜索“你们” 或者 “激情” 都会把这句搜出来。

#### 存储结构

Elasticsearch是文件存储，Elasticsearch是面向**文档**型数据库，一条数据在这里就是一个文档，用**JSON**作为序列化的格式，比如下面这个用户的数据

```json
{
 “name”：“chensj”，
 “sex”：0，
 “age”：25
}
```

与数据库对比

关系数据库 => 数据库 => 表 => 行 => 列(Columns)

Elasticsearch  => 索引(index) => 类型(type) => 文档(Document) => 字段(Field)

#### ES数据架构的主要概念

（与关系数据库Mysql对比）

![这里写图片描述](https://img-blog.csdn.net/20160818210034345) 
（1）关系型数据库中的数据库（DataBase），等价于ES中的索引（Index） 
（2）一个数据库下面有N张表（Table），等价于1个索引Index下面有N多类型（Type）， 
（3）一个数据库表（Table）下的数据由多行（ROW）多列（column，属性）组成，等价于1个Type由多个文档（Document）和多Field组成。 
（4）在一个关系型数据库里面，schema定义了表、每个表的字段，还有表和字段之间的关系。 与之对应的，在ES中：Mapping定义索引下的Type的字段处理规则，即索引如何建立、索引类型、是否保存原始索引JSON文档、是否压缩原始JSON文档、是否需要分词处理、如何进行分词处理等。 
（5）在数据库中的增insert、删delete、改update、查search操作等价于ES中的增PUT/POST、删Delete、改update、查GET.

#### ELK

ELK=elasticsearch+Logstash+kibana 
elasticsearch：后台分布式存储以及全文检索 
logstash: 日志加工、“搬运工” 
kibana：数据可视化展示。 
ELK架构为数据分布式存储、可视化查询和日志解析创建了一个功能强大的管理链。 三者相互配合，取长补短，共同完成分布式大数据处理工作。

#### ES对外接口

##### 1 JAVA API接口

<http://www.ibm.com/developerworks/library/j-use-elasticsearch-java-apps/index.html>

##### 2 RESTful API接口

常见的增、删、改、查操作实现： 
<http://blog.csdn.net/laoyang360/article/details/51931981>

#### 端口

> elasticsearch常用的端口为9200和9300

##### 9200

暴露RESTful接口端口号，ES节点与外部通讯使用

使用：

```
http://192.168.31.96:9200/userindex/user/1
```

结果：

```json
{
    "_index":"userindex",
    "_type":"user",
    "_id":"1",
    "_version":1,
    "found":true,
    "_source":
    {
        "id":"1",
        "username":"chensj",
        "password":"123456",
        "age":25,
        "sex":0
    }
}
```

kibana就是使用这种方式来实现操作的

##### 9300

TCP协议端口号，ES集群之间通信的端口号，就是ES之间通讯的使用

### Elasticsearch应用场景

1. 大型分布式日志分析系统ELK  elasticsearch(存储日志)+logstash(收集日志)+kibana(日志展示)

2. 大型电商商品搜索、站内搜索、网盘搜索等

### Elasticsearch使用公司

1） 2013年初，GitHub抛弃了Solr，采取ElasticSearch 来做PB级的搜索。 “GitHub使用ElasticSearch搜索20TB的数据，包括13亿文件和1300亿行代码”。
2）维基百科：启动以elasticsearch为基础的核心搜索架构。 
3）SoundCloud：“SoundCloud使用ElasticSearch为1.8亿用户提供即时而精准的音乐搜索服务”。 
4）百度：百度目前广泛使用ElasticSearch作为文本数据分析，采集百度所有服务器上的各类指标数据及用户自定义数据，通过对各种数据进行多维分析展示，辅助定位分析实例异常或业务层面异常。目前覆盖百度内部20多个业务线（包括casio、云分析、网盟、预测、文库、直达号、钱包、风控等），单集群最大100台机器，200个ES节点，每天导入30TB+数据。

## 安装

### 切换目录

```bash
cd /usr/local
```

### 下载文件

```bash
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.1.1-linux-x86_64.tar.gz
```

### 解压

```bash
tar -zxvf elasticsearch-7.1.1-linux-x86_64.tar.gz
```

#### 配置修改

#### 使用内存修改

修改启动使用内存信息

修改`/usr/local/elasticsearch-7.1.1/config/jvm.options`下面的内容

```
-Xms1g
-Xmx1g
```

####  配置修改

修改使用ip和端口信息

修改`/usr/local/elasticsearch-7.1.1/config/elasticsearch.yml`的如下内容

```
# 绑定IP
#network.host: 192.168.0.1
network.host: 192.168.31.96
# 服务端口 外部端口
#http.port: 9200
http.port: 9200
```

> 9200 外部端口号
>
> 9300 内部通讯端口号

###  问题处理

#### can not run elasticsearch as root

* **创建用户和组**

  由于elasticsearch的使用安全策略问题，允许使用root账户，所以需要创建指定的非root账户进行启动，使用root启动则会出现异常`java.lang.RuntimeException: can not run elasticsearch as root `

  ```bash
  groupadd es
  useradd es -g es -p 123456
  chown -R  es:es /usr/local/elasticsearch-7.1.1
  ```

* **重新启动**

  ```bash
  ./elasticsearch
  ```

####  bootstrap checks failed

```bash
[2019-06-07T16:46:01,999][INFO ][o.e.b.BootstrapChecks    ] [centos7.develop] bound or publishing to a non-loopback address, enforcing bootstrapchecks
ERROR: [2] bootstrap checks failed
[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65535]
[2]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
[2019-06-07T16:46:02,014][INFO ][o.e.n.Node               ] [centos7.develop] stopping ...
[2019-06-07T16:46:02,066][INFO ][o.e.n.Node               ] [centos7.develop] stopped
[2019-06-07T16:46:02,067][INFO ][o.e.n.Node               ] [centos7.develop] closing ...
[2019-06-07T16:46:02,089][INFO ][o.e.n.Node               ] [centos7.develop] closed
[2019-06-07T16:46:02,093][INFO ][o.e.x.m.p.NativeController] [centos7.develop] Native controller process has stopped - no new native processes can be started
```

* **max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]**

  每个进程最大同时打开文件数太小，可通过下面2个命令查看当前数量

  ```bash
  ulimit -Hn
  ulimit -Sn
  ```

  ![](https://images2018.cnblogs.com/blog/1031555/201802/1031555-20180228192703048-776330364.png)

  解决方法：

  　修改/etc/security/limits.conf文件，增加配置，用户退出后重新登录生效

  ```bash
  *   soft    nofile          65536
  *   hard    nofile          65536
  ```

  

* **the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured**

  解决方法：

   修改配置文件`/usr/local/elasticsearch-7.1.1/config/elasticsearch.yml`中集群节点配置

  ```bash
  #cluster.initial_master_nodes: ["node-1", "node-2"]
  cluster.initial_master_nodes: ["node-1"]
  ```

* **max number of threads [3818] for user [es] is too low, increase to at least [4096]**

　　问题同上，最大线程个数太低。修改配置文件/etc/security/limits.conf，增加配置

  ```bash
  *               soft    nproc           4096
  *               hard    nproc           4096
  ```

　　可通过命令查看

  ```bash
  ulimit -Hu
  ulimit -Su
  ```

![img](https://images2018.cnblogs.com/blog/1031555/201802/1031555-20180228193331496-1676615485.png)

* **max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]**

　　修改/etc/sysctl.conf文件，增加配置vm.max_map_count=262144

  ```bash
  vi /etc/sysctl.conf
  sysctl -p
  ```

　　执行命令sysctl -p生效

![img](https://images2018.cnblogs.com/blog/1031555/201802/1031555-20180228170034226-366544473.png)

* **Exception in thread "main" java.nio.file.AccessDeniedException: /usr/local/elasticsearch/elasticsearch-6.2.2-1/config/jvm.options**

　　elasticsearch用户没有该文件夹的权限，执行命令

  ```
  chown -R es:es /usr/local/elasticsearch/
  ```

### 防火墙处理

```bash
firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --zone=public --add-port=9300/tcp --permanent
firewall-cmd --zone=public --add-service=elasticsearch --permanent
firewall-cmd --reload
```

### 启动

```bash 
# 普通启动
$ ./elasticsearch 

# 守护进程启动
$ ./elasticsearch  -d
```

## kibana 环境搭建

### 简介

Kibana是一个开源的分析和可视化平台，设计用于和Elasticsearch一起工作。

你用Kibana来搜索，查看，并和存储在Elasticsearch索引中的数据进行交互。

你可以轻松地执行高级数据分析，并且以各种图标、表格和地图的形式可视化数据。

Kibana使得理解大量数据变得很容易。它简单的、基于浏览器的界面使你能够快速创建和共享动态仪表板，实时显示Elasticsearch查询的变化。

### 安装

#### 切换目录

```bash
cd /usr/local
```

#### 源文件下载

```
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.3-linux-x86_64.tar.gz
```

#### 解压

```
tar -zxvf kibana-6.4.3-linux-x86_64.tar.gz
```

#### 配置修改

切换目录到`/usr/local/kibana-6.4.3-linux-x86_64/config`，修改`kibana.yml`文件

```yaml
# Kibana 端口
server.port: 5601
# ip信息
server.host: "192.168.31.96"
# elasticsearch 的ip与端口
elasticsearch.url: "http://192.168.31.96:9200"
```

#### 防火墙

```bash
firewall-cmd --zone=public --add-port=5601/tcp --permanent
firewall-cmd --zone=public --add-service=kibana --permanent
firewall-cmd --reload
```

#### 启动

```bash
./kibana
 echo "nohup /usr/local/kibana-6.4.3-linux-x86_64/bin/kibana >> kibana-log.log 2>&1 &" > startup
```

## kibana CRUD

### 操作命令

#### **创建索引**

```Elasticsearch
PUT /esindex
```

#### **查询索引**

```Elasticsearch
GET /esindex
```

#### **创建文档**

```Elasticsearch
PUT /esindex/user/1 
{
  "name":"chensj",
  "age":30,
  "sex":0
}
```

#### **查询文档**

```
GET /esindex/user/1
```

#### **修改文档**

```
PUT /esindex/user/1 
{
  "name":"chensj",
  "age":32,
  "sex":0
}
```

注意返回结果如下：

```json
{
  "_index": "esindex",
  "_type": "user",
  "_id": "1",
  "_version": 2, // 版本变化
  "result": "updated",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 1,
  "_primary_term": 1
}
```

#### **删除文档**

```
DELETE /esindex/user/1
```

返回结果

```json
{
  "_index": "esindex",
  "_type": "user",
  "_id": "1",
  "_version": 3,
  "result": "deleted",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 2,
  "_primary_term": 1
}
```

#### **不传递ID**

```
POST /esindex/user/
{
  "name":"chensj",
  "age":32,
  "sex":0
}
```

结果：

```
{
  "_index": "esindex",
  "_type": "user",
  "_id": "2DXRN2sBevCrxE3YcxUV",
  "_version": 1,
  "result": "created",
  "_shards": {
    "total": 2,
    "successful": 1,
    "failed": 0
  },
  "_seq_no": 0,
  "_primary_term": 2
}
```

> 会自动生成主键ID

### 高级查询

#### 根据id进行查询

```
GET /userindex/user/1
```

#### 查询所有的文档

```
GET /userindex/user/_search
```

#### 根据多个ID查询

```
GET /userindex/user/_mget
{
  "ids": ["1","2"]
}
```

#### 条件查询

```bash
# 年龄32
GET /userindex/user/_search?q=age:32
# 区间查询
GET /userindex/user/_search?q=age[20 TO 40]
# 降序排列
GET /userindex/user/_search?q=age[20 TO 40]&sort=age:desc
# 分页
GET /userindex/user/_search?q=age[20 TO 40]&sort=age:desc&from=0&size=2
```

### DSL语言查询与过滤

#### 什么是DSL

Elasticsearch中查询请求分为两种，一种简易版的查询，另一种是使用JSON完整的请求体，叫做结构化查询(DSL)

由于DSL查询更为直观也更为简易，所以大多数请情况使用这种方式

DSL查询是POST一个json，由于POST的请求是JSON格式的，所以存在很多灵活性，也存在很多形式

#### 根据名称精确查询姓名



## Elasticsearch 乐观锁版本控制

Elasticsearch版本控制使用的是CAS无锁机制，乐观锁机制

### 问题说明

#### 为什么要进行版本控制

为了保证数据在多线程操作下的准确性

#### 乐观锁与悲观锁

乐观锁：假设会发生并发冲突，屏蔽一切可能违反数据准确性的操作

悲观锁：假设不会发生并发冲突，只在提交操作时检查是否违反数据完整性

#### 内部版本控制与外部版本控制

内部版本控制：`_version`自增长，待数据修改后，`_version`会自动加1

外部版本控制：为了保证`_version`与外部版本控制的数字一致，使用`version_type=external`检查当前的`version`值是否小于请求中的`version`的值

## Elasticsearch 底层实现原理

### 1.spring boot 整合 Elasticsearch 

工程地址：https://gitee.com/chensj881008/spring-boot-elasticsearch.git

#### Postman测试

##### 新增

url：`localhost:8080/user/add`

postman参数：

```json
{
    "id": "1",
    "username": "chensj",
    "password": "123456",
    "age": 25,
    "sex": 0
}
```

结果：

```json
{
    "id": "1",
    "username": "chensj",
    "password": "123456",
    "age": 25,
    "sex": 0
}
```

es查询结果

```bash
GET /userindex/user/1
```

```json
{
  "_index": "userindex",
  "_type": "user",
  "_id": "1",
  "_version": 1,
  "found": true,
  "_source": {
    "id": "1",
    "username": "chensj",
    "password": "123456",
    "age": 25,
    "sex": 0
  }
}
```

##### 查询

url：`localhost:8080/user/query/1`

postman参数：无

结果；

```json
{
    "id": "1",
    "username": "chensj",
    "password": "123456",
    "age": 25,
    "sex": 0
}
```

无结果的时候则为如下结果：

```json
{
    "timestamp": "2019-06-08T14:47:19.879+0000",
    "status": 500,
    "error": "Internal Server Error",
    "message": "No value present",
    "path": "/user/query/12"
}
```

#### 报错：

###### 1. None of the configured nodes are available

` None of the configured nodes are available:[{#transport#-1}{alvwcygdRSCA-rpEeLO6vQ}{192.168.31.96}{192.168.31.96:9300}]`

无配置集群节点

解决方案：

由于在application.yml中指定的是集群的名称，需要修改es的配置文件

```yaml
cluster.name: myes
```

保存重启es

### 2. Elasticsearch  倒排索引

在Elasticsearch全文检索底层采用的倒排索引，倒排索引比数据库中B-tree(数据库采用)查询效率更快。倒排索引就是对文档内容使用**关键词**进行分词，可以直接通过**关键词**直接定位到文档内容。

关键词来源于词库，词库可以自己定义，或者采用第三方提供的比如IK，还可以在IK中增加自定义词语

倒排索引详见[倒排索引.md](倒排索引.md)文件

##### Elasticsearch  默认分词器使用

url: `http://192.168.31.96:9200/_analyze`

postman参数：

```json
{
    "analyzer": "standard",
    "text": "奥迪"
}
```

结果：

```json
{
    "tokens": [
        {
            "token": "奥",
            "start_offset": 0,
            "end_offset": 1,
            "type": "<IDEOGRAPHIC>",
            "position": 0
        },
        {
            "token": "迪",
            "start_offset": 1,
            "end_offset": 2,
            "type": "<IDEOGRAPHIC>",
            "position": 1
        }
    ]
}
```

> 不支持中文。。。。
>
> 中文使用会按照一个一个字来分词。。。
>
> 支持中文需要使用ik_smart分词器


## Elasticsearch Mapping映射



## 深入Elasticsearch搜索查询



## Elasticsearch 索引分词器



## 使用Elasticsearch 分布式日志收集ELK



