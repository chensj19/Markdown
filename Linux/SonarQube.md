# SonarQube 7.3 安装

## 1、下载

注意最新版本的SonarQube  7.9 LTS版本需要jdk 11 的支持

[下载网址](https://www.sonarqube.org/downloads/)

```bash
$ wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.3.zip
```

## 2、安装

### 2.1 创建用户

```bash
$ useradd sonar -d /opt/sonar
$ passwd sonar
```

在SonarQube中集成的有Elasticsearch，不能使用root账户启动，所以创建一个用户，用于操作SonarQube

### 2.2 解压

```bash
$ unzip sonarqube-7.3.zip -d /opt/sonar/
```

解压后的目录结构如下：

```bash
[sonar@centos7 sonarqube-7.3]$ ll
total 12
drwxr-xr-x. 8 sonar sonar  136 Aug 10  2018 bin
drwxr-xr-x. 2 sonar sonar   50 Jul  5 19:38 conf
-rw-r--r--. 1 sonar sonar 7651 Aug 10  2018 COPYING
drwxr-xr-x. 4 sonar sonar   65 Jul  5 19:37 data
drwxr-xr-x. 9 sonar sonar  174 Jul  5 19:18 elasticsearch
drwxr-xr-x. 5 sonar sonar   57 Jul  5 19:12 extensions
drwxr-xr-x. 6 sonar sonar   91 Aug 10  2018 lib
drwxr-xr-x. 2 sonar sonar  102 Jul  5 19:13 logs
drwxr-xr-x. 4 sonar sonar   49 Jul  5 19:38 temp
drwxr-xr-x. 7 sonar sonar 4096 Aug 10  2018 web
```

* bin 用来启动 SonarQube 服务，这里已经提供好了不同系统启动 | 停止脚本了，目前提供了 linux-x86-32、linux-x86-64、macosx-universal-64、windows-x86-32、windows-x86-64
* conf 用来存放配置文件，若需要修改配置，修改 sonar.properties 文件即可。
* data 用来存放数据，SonarQube默认使用 h2 数据库存储，同时支持其他如Mysql、Orace、Mssql、Postgresql数据库存储。
* extensions 用来存放插件 jar 包，以后我们需要安装插件就放在这里。
* lib 用来存放各种所依赖的 jar 包，包括上边各数据库驱动包 (默认已提供一个版本，如果版本不匹配，则在这里手动更新下)。
* logs 用来存放各日志信息
* web 用来提供 SonarQube web 网页服务。

## 3、配置

### 3.1 测试使用

执行如下命令

```bash
/opt/sonar/sonarqube-7.3/bin/linux-x86-64/sonar.sh console
```

然后在`http://localhost:9000`上面即可看见SonarQube的使用页面

### 3.2 配置

#### 3.1 Elasticsearch配置

elasticsearch的配置文件存放在在`${SONARQUBE_INSTALL_PATH}/elasticsearch/config`下面

* 修改elasticsearch运行参数

  运行参数都是放置在`jvm.options`中，默认使用内存为2G，如下：

  ```yaml
  -Xms2g
  -Xmx2g
  ```

  根据实际情况修改一下

  ```options
  -Xms1g
  -Xmx1g
  ```

* 修改elasticsearch的ip与端口

  elasticsearch的ip和端口配置文件是放置在` elasticsearch.yml`中，默认配置是使用localhost的

  ```yaml
  network.host: 192.168.31.96
  http.port: 9200
  ```

* 测试使用

  到bin目录下执行如下命令，看设置的参数是否成功，elasticsearch是否可以启动

  ```
  ./elasticsearch
  ```

#### 3.2 SonarQube配置

SonarQube的配置文件放置在`${SONARQUBE_INSTALL_PATH}/conf`下面

```bash
ls -ltr /opt/sonar/sonarqube-7.3/conf
total 24
-rw-r--r--. 1 sonar sonar  3221 Aug 10  2018 wrapper.conf
-rw-r--r--. 1 sonar sonar 20037 Jul  5 19:38 sonar.properties
```

* sonar.properties 就是sonar的配置文件

* wrapper.conf 用于指定sonar运行的参数信息，比如jdk安装路径等

修改sonar.properties中ip、端口、elasticsearch配置

```bash
vim sonar.properties
```

```properties
# WEB SERVER
# ip
sonar.web.host=192.168.31.96
# Web context. When set, it must start with forward slash (for example /sonarqube).
# The default value is root context (empty value).
# 根路径
#sonar.web.context=
# TCP port for incoming HTTP connections. Default value is 9000.
# 端口
sonar.web.port=8000

# ELASTICSEARCH
# ELASTICSEARCH 使用的端口
sonar.search.port=9200

# Elasticsearch IP
sonar.search.host=192.168.31.96
```

## 4、启动

到`${SONARQUBE_INSTALL_PATH}/bin/{OS}/`下执行如下命令，启动sonar

```bash
./sonar.sh start
```

注意：

在这里启动并不一定会成功，需要到logs目录查看日志

```bash
$ ls -ltr /opt/sonar/sonarqube-7.3/logs
total 164
-rw-r--r--. 1 sonar sonar    88 Aug 10  2018 README.txt
-rw-r--r--. 1 sonar sonar 47586 Jul  5 19:30 access.log
-rw-r--r--. 1 sonar sonar 29294 Jul  5 22:03 es.log
-rw-r--r--. 1 sonar sonar 50820 Jul  5 22:03 web.log
-rw-r--r--. 1 sonar sonar 10396 Jul  5 22:03 ce.log
-rw-r--r--. 1 sonar sonar 13998 Jul  5 22:03 sonar.log
```

* access.log 连接信息
* es.log elasticsearch模块启动日志
* web.log  web模块启动日志
* ce.log  ce模块启动日志
* sonar.log  sonar启动日志

查看`sonar.log`或者执行`./bin/{OS}/sonar.sh status`判断当前SonarQube启动情况

```bash
$ tail -f sonar.log 
Launching a JVM...
Wrapper (Version 3.2.3) http://wrapper.tanukisoftware.org
  Copyright 1999-2006 Tanuki Software, Inc.  All Rights Reserved.

2019.07.05 22:02:46 INFO  app[][o.s.a.AppFileSystem] Cleaning or creating temp directory /opt/sonar/sonarqube-7.3/temp
2019.07.05 22:02:46 INFO  app[][o.s.a.es.EsSettings] Elasticsearch listening on /192.168.31.96:9200
2019.07.05 22:02:46 INFO  app[][o.s.a.p.ProcessLauncherImpl] Launch process[[key='es', ipcIndex=1, logFilenamePrefix=es]] from [/opt/sonar/sonarqube-7.3/elasticsearch]: /opt/sonar/sonarqube-7.3/elasticsearch/bin/elasticsearch -Epath.conf=/opt/sonar/sonarqube-7.3/temp/conf/es
2019.07.05 22:02:46 INFO  app[][o.s.a.SchedulerImpl] Waiting for Elasticsearch to be up and running
2019.07.05 22:02:48 INFO  app[][o.e.p.PluginsService] no modules loaded
2019.07.05 22:02:48 INFO  app[][o.e.p.PluginsService] loaded plugin [org.elasticsearch.transport.Netty4Plugin]
2019.07.05 22:03:08 INFO  app[][o.s.a.SchedulerImpl] Process[es] is up
2019.07.05 22:03:08 INFO  app[][o.s.a.p.ProcessLauncherImpl] Launch process[[key='web', ipcIndex=2, logFilenamePrefix=web]] from [/opt/sonar/sonarqube-7.3]: /usr/local/java/jre/bin/java -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djava.io.tmpdir=/opt/sonar/sonarqube-7.3/temp -Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError -cp ./lib/common/*:/opt/sonar/sonarqube-7.3/lib/jdbc/h2/h2-1.3.176.jar org.sonar.server.app.WebServer /opt/sonar/sonarqube-7.3/temp/sq-process8308076536608797765properties
2019.07.05 22:03:36 INFO  app[][o.s.a.SchedulerImpl] Process[web] is up
2019.07.05 22:03:36 INFO  app[][o.s.a.p.ProcessLauncherImpl] Launch process[[key='ce', ipcIndex=3, logFilenamePrefix=ce]] from [/opt/sonar/sonarqube-7.3]: /usr/local/java/jre/bin/java -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djava.io.tmpdir=/opt/sonar/sonarqube-7.3/temp -Xmx512m -Xms128m -XX:+HeapDumpOnOutOfMemoryError -cp ./lib/common/*:/opt/sonar/sonarqube-7.3/lib/jdbc/h2/h2-1.3.176.jar org.sonar.ce.app.CeServer /opt/sonar/sonarqube-7.3/temp/sq-process9102505006627115354properties
2019.07.05 22:03:41 INFO  app[][o.s.a.SchedulerImpl] Process[ce] is up
2019.07.05 22:03:41 INFO  app[][o.s.a.SchedulerImpl] SonarQube is up
```

```bash
$ ../bin/linux-x86-64/sonar.sh status
SonarQube is running (14420).
```

上面这两种就代表已经启动成功

同样也可以根据日志判断是哪一个模块启动失败

## 5、插件安装

### 5.1 中文插件

[下载地址](https://github.com/SonarQubeCommunity/sonar-l10n-zh)

根据下面的兼容列表到`releases`下载对应的中文包

|               |         |         |         |         |         |         |         |         |         |         |
| ------------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| **SonarQube** | **7.0** | **7.1** | **7.2** | **7.3** | **7.4** | **7.5** | **7.6** | **7.7** | **7.8** | **7.9** |
| sonar-l10n-zh | 1.20    | 1.21    | 1.22    | 1.23    | 1.24    | 1.25    | 1.26    | 1.27    | 1.28    | 1.29    |
| **SonarQube** | **6.0** | **6.1** | **6.2** | **6.3** | **6.4** | **6.5** | **6.6** | **6.7** |         |         |
| sonar-l10n-zh | 1.12    | 1.13    | 1.14    | 1.15    | 1.16    | 1.17    | 1.18    | 1.19    |         |         |
| **SonarQube** |         |         |         |         | **5.4** | **5.5** | **5.6** |         |         |         |
| sonar-l10n-zh |         |         |         |         | 1.9     | 1.10    | 1.11    |         |         |         |
| **SonarQube** | **4.0** | **4.1** |         |         |         |         |         |         |         |         |
| sonar-l10n-zh | 1.7     | 1.8     |         |         |         |         |         |         |         |         |
| **SonarQube** |         | **3.1** | **3.2** | **3.3** | **3.4** | **3.5** | **3.6** | **3.7** |         |         |
| sonar-l10n-zh |         | 1.0     | 1.1     | 1.2     | 1.3     | 1.4     | 1.5     | 1.6     |         |         |

我目前安装的是7.3 版本的，那么就是下载1.23版本

```bash
$ cd sonarqube-7.3/extensions/plugins/
$ wget https://github.com/SonarQubeCommunity/sonar-l10n-zh/releases/download/sonar-l10n-zh-plugin-1.23/sonar-l10n-zh-plugin-1.23.jar
```

下载完成后，重启即可，页面就是中文的了

![](https://img-blog.csdn.net/2018090415073246?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTMxMTEwMDM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 6、MySQL数据库配置

> 注意：SonarQube对于MySQL数据库存在版本要求
>
> #----- DEPRECATED 
> #----- MySQL >=5.6 && <8.0
>
> 数据库版本需要控制在 5.6和5.7版本，不支持8.x

### 6.1 mysql数据库

```sql
 create user 'sonar'@'%'  IDENTIFIED BY 'sonar' ;
 create database sonar default charset utf8 collate utf8_general_ci;
 GRANT ALL ON sonar.* TO 'sonar'@'%';
 flush privileges;
```

### 6.2 SonarQube配置

修改`sonar.properties`中数据库配置

```properties
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
#----- DEPRECATED 
#----- MySQL >=5.6 && <8.0
sonar.jdbc.url=jdbc:mysql://192.168.31.96:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false
```

### 6.3 重新启动

```
./bin/{OS}/sonar.sh restart
```

再次访问Sonar过程较慢，Sonar需要在数据库创建一系列相关数据表

![](https://img-blog.csdn.net/20180904151506795?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTMxMTEwMDM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 7、使用SonarQube

* 生成令牌

* 选择项目

  在Maven项目中通过以下命令对项目源代码进行分析

```bash
mvn sonar:sonar \
  -Dsonar.host.url=http://192.168.31.96:8000 \
  -Dsonar.login=ebbd6704315fc8e8fb03e9fb26a07a3ce5c53b8b
```

* 完成后访问Sonar可以看到多了一个项目。

  ![](https://img-blog.csdn.net/20180905150250324?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTMxMTEwMDM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

  