[TOC]

# Redis

## 一、Redis 简介

Redis 是完全开源免费的，遵守BSD协议，是一个高性能的key-value数据库。 
Redis 与其他 key - value 缓存产品有以下三个特点： 
Redis支持数据的持久化，可以将内存中的数据保存在磁盘中，重启的时候可以再次加载进行使用。 
Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。 
Redis支持数据的备份，即master-slave模式的数据备份。

## 二、Redis 优势

性能极高 – Redis能读的速度是110000次/s,写的速度是81000次/s 。 
丰富的数据类型 – Redis支持二进制案例的 Strings, Lists, Hashes, Sets 及 Ordered Sets 数据类型操作。 
原子 – Redis的所有操作都是原子性的，同时Redis还支持对几个操作全并后的原子性执行。 
丰富的特性 – Redis还支持 publish/subscribe, 通知, key 过期等等特性。

##  三、安装redis

> 参考:<http://www.runoob.com/redis/redis-install.html> 
> 下载地址：<https://github.com/MSOpenTech/redis/releases>

###  3.1 Windows安装

解压文件到E盘，并重命名为redis，运行dos，切换目录到redis下， 
运行:`redis-server.exe redis.windows.conf `

![](http://img.blog.csdn.net/20170819140620238?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

重新打开一个窗口，切换到redis目录下并运行`redis-cli.exe -h 127.0.0.1 -p 6379 `
设置键值对 **set myKey abc** 
取出键值对 **get myKey** 

![](http://img.blog.csdn.net/20170819140633187?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### 3.2 Linux安装

下载地址：<http://redis.io/download>，下载最新文档版本。 
本教程使用的最新文档版本为5.0.5，下载并安装：

```bash
$ wget http://download.redis.io/releases/redis-5.0.5.tar.gz
$ tar zxzf redis-5.0.5.tar.gz
$ cd redis-5.0.5.tar.gz
$ make install
```

#### 3.2.1 问题

##### 3.2.1 .1 cc：Command not found

```bash
make[1]: [persist-settings] Error 2 (ignored)
    CC adlist.o
/bin/sh: cc: command not found
make[1]: *** [adlist.o] Error 127
make[1]: Leaving directory `/opt/redis-5.0.5/src'
make: *** [all] Error 2
```

机器未安装gcc编译器，解决方案：

```bash
$ yum install gcc -y	
```

##### 3.2.1.2 jemalloc/jemalloc.h: No such file or directory

```bash
[root@centos7 redis-5.0.5]# make && install
cd src && make all
make[1]: Entering directory `/opt/redis-5.0.5/src'
    CC Makefile.dep
make[1]: Leaving directory `/opt/redis-5.0.5/src'
make[1]: Entering directory `/opt/redis-5.0.5/src'
    CC adlist.o
In file included from adlist.c:34:0:
zmalloc.h:50:31: fatal error: jemalloc/jemalloc.h: No such file or directory
 #include <jemalloc/jemalloc.h>
```

>  Allocator  
>
>  Selecting a non-default memory allocator when building Redis is done by setting  
>  the `MALLOC` environment variable. Redis is compiled and linked against libc  
>  malloc by default, with the exception of jemalloc being the default on Linux  
>  systems. This default was picked because jemalloc has proven to have fewer  
>  fragmentation problems than libc malloc.  
>
>  To force compiling against libc malloc, use:  
>
>  % make MALLOC=libc  
>
>  To compile against jemalloc on Mac OS X systems, use:  
>
>  % make MALLOC=jemalloc

关于分配器allocator， 如果有MALLOC  这个 环境变量， 会有用这个环境变量的 去建立Redis。而且libc 并不是默认的 分配器， 默认的是 jemalloc, 因为 jemalloc 被证明 有更少的 fragmentation problems 比libc。但是如果你又没有jemalloc 而只有 libc 当然 make 出错。 所以加这么一个参数

```bash
$ mkdir /usr/local/redis && \
  mkdir /usr/local/redis/etc && \
  make MALLOC=libc && \
  make PREFIX=/usr/local/redis-cluster install && \
  cp redis.conf /usr/local/redis/etc/
```

上述命令执行完成后，会将

redis-benchmark  redis-check-aof  redis-check-rdb  redis-cli  redis-sentinel  redis-server

拷贝到/usr/local/bin目录下

##  四、配置redis

### 4.1 配置文件

Redis 的配置文件位于 Redis 安装目录下，文件名为 redis.conf。

主要修改bind、requirepass，前者是可以通过网络访问，后者是设置密码

```bash
# bind 127.0.0.1
bind 0.0.0.0
# requirepass foobar
requirepass 123456
# 守护进程 运行
daemonize yes
```

### 4.2 命令行

1. 通过CONFIG查看命令或设置配置项。

   例如：`CONFIG SET loglevel` 

   ![](http://img.blog.csdn.net/20170819140712409?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

2. 获取所有项目:

![](http://img.blog.csdn.net/20170819140721020?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

3. 修改配置 
   修改**redis.conf** 或 使用**config set** 命令修改配置 
   ![这里写图片描述](http://img.blog.csdn.net/20170819140728524?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## 五、Redis的数据类型

Redis支持五种数据类型：string（字符串），hash（哈希），list（列表），set（集合）及zset(sorted set：有序集合)。

### String

string是redis最基本的类型，你可以理解成与Memcached一模一样的类型，一个key对应一个value。 
string类型是二进制安全的。意思是redis的string可以包含任何数据。比如jpg图片或者序列化的对象 。 
string类型是Redis最基本的数据类型，一个键最大能存储512MB。 
例: 
![这里写图片描述](http://img.blog.csdn.net/20170819142522817?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### Hash

Redis hash 是一个键名对集合。 
Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。 
`hmset` 设值 
`hgetall` 取值 
![这里写图片描述](http://img.blog.csdn.net/20170819142532307?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### List

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。 
`lpush` 插入 
`lrange` 查看 
![这里写图片描述](http://img.blog.csdn.net/20170819142540919?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### Set

Redis的Set的无序集合。 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)。 
`sadd `命令 
	添加一个string元素到,key对应的set集合中，

​		成功返回1,

​		如果元素已经在集合中返回0,

​		key对应的set不存在返回错误。 
`smembers` 查看 
![这里写图片描述](http://img.blog.csdn.net/20170819142550082?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### Zset

Redis的Zset(sorted set)是string类型的有序集合。 
Redis zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。 
不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。 
zset的成员是唯一的,但分数(score)却可以重复。 
`zadd` 命令  添加元素到集合，元素在集合中存在则更新对应score 
`zrangebyscore` 查看 
![这里写图片描述](http://img.blog.csdn.net/20170819142558791?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcWF6d3N4cGNt/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

## Java 操作Redis

