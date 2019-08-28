# Nginx

## 1、简介

想必大家一定听说过Nginx，若没听说过它？那么一定听过它的"同行"Apache吧！Nginx同Apache一样都是一种WEB服务器。基于REST架构风格，以统一资源描述符(Uniform Resources Identifier)URI或者统一资源定位符(Uniform Resources Locator)URL作为沟通依据，通过HTTP协议提供各种网络服务。

然而，这些服务器在设计之初受到当时环境的局限，例如当时的用户规模，网络带宽，产品特点等局限并且各自的定位和发展都不尽相同。这也使得各个WEB服务器有着各自鲜明的特点。

Apache的发展时期很长，而且是毫无争议的世界第一大服务器。它有着很多优点：稳定、开源、跨平台等等。它出现的时间太长了，它兴起的年代，互联网产业远远比不上现在。所以它被设计为一个重量级的。它不支持高并发的服务器。在Apache上运行数以万计的并发访问，会导致服务器消耗大量内存。操作系统对其进行进程或线程间的切换也消耗了大量的CPU资源，导致HTTP请求的平均响应速度降低。

这些都决定了Apache不可能成为高性能WEB服务器，轻量级高并发服务器Nginx就应运而生了。

俄罗斯的工程师Igor Sysoev，他在为Rambler Media工作期间，使用C语言开发了Nginx。Nginx作为WEB服务器一直为Rambler Media提供出色而又稳定的服务。

然后呢，Igor Sysoev将Nginx代码开源，并且赋予自由软件许可证。

由于：

- Nginx使用基于事件驱动架构，使得其可以支持数以百万级别的TCP连接
- 高度的模块化和自由软件许可证是的第三方模块层出不穷（这是个开源的时代啊~）
- Nginx是一个跨平台服务器，可以运行在Linux,Windows,FreeBSD,Solaris, AIX,Mac OS等操作系统上
- 这些优秀的设计带来的极大的稳定性

所以，Nginx火了！

Nginx是一款自由的、开源的、高性能的HTTP服务器和反向代理服务器；同时也是一个IMAP、POP3、SMTP代理服务器；Nginx可以作为一个HTTP服务器进行网站的发布处理，另外Nginx可以作为反向代理进行负载均衡的实现。

### 1.1 **关于代理**

说到代理，首先我们要明确一个概念，所谓代理就是一个代表、一个渠道；

此时就设计到两个角色，一个是被代理角色，一个是目标角色，被代理角色通过这个代理访问目标角色完成一些任务的过程称为代理操作过程；如同生活中的专卖店~客人到adidas专卖店买了一双鞋，这个专卖店就是代理，被代理角色就是adidas厂家，目标角色就是用户。

### 1.2 **正向代理**

说反向代理之前，我们先看看正向代理，正向代理也是大家最常接触的到的代理模式，我们会从两个方面来说关于正向代理的处理模式，分别从软件方面和生活方面来解释一下什么叫正向代理。

在如今的网络环境下，我们如果由于技术需要要去访问国外的某些网站，此时你会发现位于国外的某网站我们通过浏览器是没有办法访问的，此时大家可能都会用一个操作FQ进行访问，FQ的方式主要是找到一个可以访问国外网站的代理服务器，我们将请求发送给代理服务器，代理服务器去访问国外的网站，然后将访问到的数据传递给我们！

上述这样的代理模式称为正向代理，**正向代理最大的特点是客户端非常明确要访问的服务器地址**；服务器只清楚请求来自哪个代理服务器，而不清楚来自哪个具体的客户端；**正向代理模式屏蔽或者隐藏了真实客户端信息**。来看个示意图（我把客户端和正向代理框在一块，同属于一个环境，后面我有介绍）：

![640](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWg2rULWLhibjQw8uhLpGr5OiaC2v2uEjfwEVeibORnk7yQ0nBGJnAqd87kaXyT1nibz7AfxzX9xwXYzAg/640)

**客户端必须设置正向代理服务器**，当然前提是要知道正向代理服务器的IP地址，还有代理程序的端口。如图。

![640](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWg2rULWLhibjQw8uhLpGr5Oiakjutv8O9MOhvY7fvcDzc7CtsrexicbzRymQ8ibGdQAW8TtFPjx35EcKw/640)

总结来说：**正向代理，"它代理的是客户端"**，是一个位于客户端和原始服务器(origin server)之间的服务器，为了从原始服务器取得内容，客户端向代理发送一个请求并指定目标(原始服务器)，然后代理向原始服务器转交请求并将获得的内容返回给客户端。客户端必须要进行一些特别的设置才能使用正向代理。

正向代理的用途：
（1）访问原来无法访问的资源，如Google
（2） 可以做缓存，加速访问资源
（3）对客户端访问授权，上网进行认证
（4）代理可以记录用户访问记录（上网行为管理），对外隐藏用户信息

### 1.3 **反向代理**

明白了什么是正向代理，我们继续看关于反向代理的处理方式，举例如我大天朝的某宝网站，每天同时连接到网站的访问人数已经爆表，单个服务器远远不能满足人民日益增长的购买欲望了，此时就出现了一个大家耳熟能详的名词：分布式部署；也就是通过部署多台服务器来解决访问人数限制的问题；某宝网站中大部分功能也是直接使用Nginx进行反向代理实现的，并且通过封装Nginx和其他的组件之后起了个高大上的名字：Tengine，有兴趣的童鞋可以访问Tengine的官网查看具体的信息：http://tengine.taobao.org/。那么反向代理具体是通过什么样的方式实现的分布式的集群操作呢，我们先看一个示意图（我把服务器和反向代理框在一块，同属于一个环境，后面我有介绍）：

![640](https://ss.csdn.net/p?https://mmbiz.qpic.cn/mmbiz_png/e1jmIzRpwWg2rULWLhibjQw8uhLpGr5OiaOTPEHnBQFmnFmmIBAYqgyTkyj3hpRdIRKpewbGeVzibgRb9LGibsgg8w/640)

通过上述的图解大家就可以看清楚了，多个客户端给服务器发送的请求，Nginx服务器接收到之后，按照一定的规则分发给了后端的业务处理服务器进行处理了。此时~请求的来源也就是客户端是明确的，但是请求具体由哪台服务器处理的并不明确了，Nginx扮演的就是一个反向代理角色。

**客户端是无感知代理的存在的，反向代理对外都是透明的，访问者并不知道自己访问的是一个代理。因为客户端不需要任何配置就可以访问。**

**反向代理，"它代理的是服务端"**，主要用于服务器集群分布式部署的情况下，反向代理隐藏了服务器的信息。

反向代理的作用：
（1）保证内网的安全，通常将反向代理作为公网访问地址，Web服务器是内网
（2）负载均衡，通过反向代理服务器来优化网站的负载

#### 1.3.1 项目场景

通常情况下，我们在实际项目操作时，正向代理和反向代理很有可能会存在在一个应用场景中，正向代理代理客户端的请求去访问目标服务器，目标服务器是一个反向单利服务器，反向代理了多台真实的业务处理服务器。具体的拓扑图如下：

![img](https://images2018.cnblogs.com/blog/1202586/201804/1202586-20180406180130452-1246060303.png)

### 1.4 二者区别

截了一张图来说明正向代理和反向代理二者之间的区别，如图。

![img](https://img2018.cnblogs.com/blog/1202586/201812/1202586-20181211122806997-940664368.png)

图解：

在正向代理中，Proxy和Client同属于一个LAN（图中方框内），隐藏了客户端信息；

在反向代理中，Proxy和Server同属于一个LAN（图中方框内），隐藏了服务端信息；

实际上，Proxy在两种代理中做的事情都是**替服务器代为收发请求和响应**，不过从结构上看正好左右互换了一下，所以把后出现的那种代理方式称为反向代理了。

### 1.5 负载均衡

我们已经明确了所谓代理服务器的概念，那么接下来，Nginx扮演了反向代理服务器的角色，它是以依据什么样的规则进行请求分发的呢？不用的项目应用场景，分发的规则是否可以控制呢？

这里提到的客户端发送的、Nginx反向代理服务器接收到的请求数量，就是我们说的负载量。

请求数量按照一定的规则进行分发到不同的服务器处理的规则，就是一种均衡规则。

所以~将服务器接收到的请求按照规则分发的过程，称为负载均衡。

负载均衡在实际项目操作过程中，有硬件负载均衡和软件负载均衡两种，硬件负载均衡也称为硬负载，如F5负载均衡，相对造价昂贵成本较高，但是数据的稳定性安全性等等有非常好的保障，如中国移动中国联通这样的公司才会选择硬负载进行操作；更多的公司考虑到成本原因，会选择使用软件负载均衡，软件负载均衡是利用现有的技术结合主机硬件实现的一种消息队列分发机制。

![img](https://images2018.cnblogs.com/blog/1202586/201804/1202586-20180406180405961-333776342.png)

Nginx支持的负载均衡调度算法方式如下：

1. **weight轮询**(默认，常用)：接收到的请求按照权重分配到不同的后端服务器，即使在使用过程中，某一台后端服务器宕机，Nginx会自动将该服务器剔除出队列，请求受理情况不会受到任何影响。 这种方式下，可以给不同的后端服务器设置一个权重值(weight)，用于调整不同的服务器上请求的分配率；权重数据越大，被分配到请求的几率越大；该权重值，主要是针对实际工作环境中不同的后端服务器硬件配置进行调整的。
2. **ip_hash**（常用）：每个请求按照发起客户端的ip的hash结果进行匹配，这样的算法下一个固定ip地址的客户端总会访问到同一个后端服务器，这也在一定程度上解决了集群部署环境下session共享的问题。
3. **fair**：智能调整调度算法，动态的根据后端服务器的请求处理到响应的时间进行均衡分配，响应时间短处理效率高的服务器分配到请求的概率高，响应时间长处理效率低的服务器分配到的请求少；结合了前两者的优点的一种调度算法。但是需要注意的是Nginx默认不支持fair算法，如果要使用这种调度算法，请安装upstream_fair模块。
4. **url_hash**：按照访问的url的hash结果分配请求，每个请求的url会指向后端固定的某个服务器，可以在Nginx作为静态服务器的情况下提高缓存效率。同样要注意Nginx默认不支持这种调度算法，要使用的话需要安装Nginx的hash软件包。

## 2、几种常用web服务器对比

| **对比项\服务器** | **Apache** | **Nginx** | **Lighttpd** |
| ----------------- | ---------- | --------- | ------------ |
| Proxy代理         | 非常好     | 非常好    | 一般         |
| Rewriter          | 好         | 非常好    | 一般         |
| Fcgi              | 不好       | 好        | 非常好       |
| 热部署            | 不支持     | 支持      | 不支持       |
| 系统压力          | 很大       | 很小      | 比较小       |
| 稳定性            | 好         | 非常好    | 不好         |
| 安全性            | 好         | 一般      | 一般         |
| 静态文件处理      | 一般       | 非常好    | 好           |
| 反向代理          | 一般       | 非常好    | 一般         |

## 3、CentOS7 安装Nginx

### 3.1安装所需环境

Nginx 是 C语言 开发，可以安装在Linux和Windows上面，建议是安装在Linux上面

```bash
rpm -qa|grep gcc
```

#### 3.1.1 gcc

安装 nginx 需要先将官网下载的源码进行编译，编译依赖 gcc 环境，如果没有 gcc 环境，则需要安装：

```bash
yum install -y gcc-c++
```

#### 3.1.2 **PCRE pcre-devel**

PCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。命令：

```bash
yum install -y pcre pcre-devel
```

#### 3.1.3  **zlib 安装**

zlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。

```bash
yum install -y zlib zlib-devel
```

#### 3.1.4 **OpenSSL 安装**

OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。
nginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。

```bash
yum install -y openssl openssl-devel
```

### 3.2 下载与安装

#### 3.2.1 Nginx安装

##### 下载

直接下载`.tar.gz`安装包，地址：https://nginx.org/en/download.html

![](https://www.linuxidc.com/upload/2016_09/160905180451092.png)

就是下载速度有点慢，可以使用[华为开源镜像](https://mirrors.huaweicloud.com/nginx/)来下载，不过不是最新版本

```bash
# 官方
wget https://nginx.org/download/nginx-1.16.0.tar.gz
# 华为
wget https://mirrors.huaweicloud.com/nginx/nginx-1.15.3.tar.gz
```

我下载的是1.16.0版本，这个是目前的稳定版。

##### 解压

```bash
tar -zxvf nginx-1.16.0.tar.gz
```

##### 配置

其实在 nginx-1.16.0 版本中你就不需要去配置相关东西，默认就可以了。当然，如果你要自己配置目录也是可以的。
1.使用默认配置

```bash
./configure
```

```bash
./configure \
--prefix=/usr/local/web1 \
--with-http_stub_status_module \
--with-http_ssl_module \
 --with-pcre
```

> --prefix Nginx安装路径，其他路径都是依赖这个，默认为/usr/local/nginx
>
> with-xxxx 表示启用某个nginx的模块
>
> with-http_stub_status_module 启用这个模块后会收集 Nginx 自身的状态信息
>
> with-http_ssl_module 如果需要对流量进行加密，那么可以使用到这个选项，在 URL中开始部分将会是 https （需要 OpenSSL 库）
>
> without-xxx 表示禁用某个模块
>
> --without-http_charset_module  该字符集模块负责设置 Content-Type 响应头，以及将以个字符集转换到另一个字符集 

2.自定义配置（不推荐）

```bash
./configure \
--prefix=/usr/local/nginx \
--conf-path=/usr/local/nginx/conf/nginx.conf \
--pid-path=/usr/local/nginx/conf/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--with-http_gzip_static_module \
--http-client-body-temp-path=/var/temp/nginx/client \
--http-proxy-temp-path=/var/temp/nginx/proxy \
--http-fastcgi-temp-path=/var/temp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/temp/nginx/uwsgi \
--http-scgi-temp-path=/var/temp/nginx/scgi
```

> 注：将临时文件目录指定为/var/temp/nginx，需要在/var下创建temp及nginx目录

##### 编译

```bash
make && make install
```

查找安装路径：

```bash
[root@centos7 nginx-1.16.0]# whereis nginx
nginx: /usr/local/nginx
```

### 3.3 启动/停止Nginx

```bash
cd /usr/local/nginx/sbin/
# 启动服务
./nginx 
# 停止服务
./nginx -s stop
# 停止服务
./nginx -s quit
# 重新加载配置文件
./nginx -s reload
```

> `./nginx -s quit`:此方式停止步骤是待nginx进程处理任务完毕进行停止。
> `./nginx -s stop`:此方式相当于先查出nginx进程id再使用kill命令强制杀掉进程。

查询nginx进程：

```
ps aux|grep nginx
```

### 3.4 重启 nginx

1. 先停止再启动（推荐）：
   对 nginx 进行重启相当于先停止再启动，即先执行停止命令再执行启动命令。如下：

```bash
./nginx -s quit
./nginx
```

2. 重新加载配置文件：
   当 ngin x的配置文件 nginx.conf 修改后，要想让配置生效需要重启 nginx，使用`-s reload`不用先停止 ngin x再启动 nginx 即可将配置信息在 nginx 中生效，如下：

   ```bash
   ./nginx -s reload
   ```

### 3.5 防火墙

```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```

### 3.6 启动成功

启动成功后，在浏览器可以看到这样的页面：

![](https://www.linuxidc.com/upload/2016_09/160905180451093.png)

### 3.7 开机启动

#### 3.7.1 添加到rc.local

在`rc.local`增加启动代码就可以了。

```bash
vi /etc/rc.local
```

增加一行 `/usr/local/nginx/sbin/nginx`

设置执行权限：

```bash
chmod 755 rc.local
```

#### 3.7.2 服务模式

1. **在系统服务目录里创建nginx.service文件**
   `vi /lib/systemd/system/nginx.service`
   `nginx.service`内容如下：

```bash
[Unit]
Description=nginx
After=network.target
 
[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true
 
[Install]
WantedBy=multi-user.target
```

> 参数说明
>
> Description:描述服务
> After:描述服务类别
> [Service]服务运行参数的设置
> Type=forking是后台运行的形式
> ExecStart为服务的具体运行命令
> ExecReload为重启命令
> ExecStop为停止命令
> PrivateTmp=True表示给服务分配独立的临时空间
> 注意：[Service]的启动、重启、停止命令全部要求使用绝对路径
> [Install]运行级别下服务安装的相关设置，可设置为多用户，即系统运行级别为3

## 4、编译参数说明

```
--prefix= 指向安装目录
--sbin-path 指向（执行）程序文件（nginx）
--conf-path= 指向配置文件（nginx.conf）
--error-log-path= 指向错误日志目录
--pid-path= 指向pid文件（nginx.pid）
--lock-path= 指向lock文件（nginx.lock）（安装文件锁定，防止安装文件被别人利用，或自己误操作。）
--user= 指定程序运行时的非特权用户
--group= 指定程序运行时的非特权用户组
--builddir= 指向编译目录
--with-rtsig_module 启用rtsig模块支持（实时信号）
--with-select_module 启用select模块支持（一种轮询模式,不推荐在高载环境下使用）禁用：--without-select_module
--with-poll_module 启用poll模块支持（功能与select相同，与select特性相同，为一种轮询模式,不推荐在高载环境下使用）
--with-file-aio 启用file aio支持（一种APL文件传输格式）
--with-ipv6 启用ipv6支持
--with-http_ssl_module 启用ngx_http_ssl_module支持（使支持https请求，需已安装openssl）
--with-http_realip_module 启用ngx_http_realip_module支持（这个模块允许从请求标头更改客户端的IP地址值，默认为关）
--with-http_addition_module 启用ngx_http_addition_module支持（作为一个输出过滤器，支持不完全缓冲，分部分响应请求）
--with-http_xslt_module 启用ngx_http_xslt_module支持（过滤转换XML请求）
--with-http_image_filter_module 启用ngx_http_image_filter_module支持（传输JPEG/GIF/PNG 图片的一个过滤器）（默认为不启用。gd库要用到）
--with-http_geoip_module 启用ngx_http_geoip_module支持（该模块创建基于与MaxMind GeoIP二进制文件相配的客户端IP地址的ngx_http_geoip_module变量）
--with-http_sub_module 启用ngx_http_sub_module支持（允许用一些其他文本替换nginx响应中的一些文本）
--with-http_dav_module 启用ngx_http_dav_module支持（增加PUT,DELETE,MKCOL：创建集合,COPY和MOVE方法）默认情况下为关闭，需编译开启
--with-http_flv_module 启用ngx_http_flv_module支持（提供寻求内存使用基于时间的偏移量文件）
--with-http_gzip_static_module 启用ngx_http_gzip_static_module支持（在线实时压缩输出数据流）
--with-http_random_index_module 启用ngx_http_random_index_module支持（从目录中随机挑选一个目录索引）
--with-http_secure_link_module 启用ngx_http_secure_link_module支持（计算和检查要求所需的安全链接网址）
--with-http_degradation_module  启用ngx_http_degradation_module支持（允许在内存不足的情况下返回204或444码）
--with-http_stub_status_module 启用ngx_http_stub_status_module支持（获取nginx自上次启动以来的工作状态）
--without-http_charset_module 禁用ngx_http_charset_module支持（重新编码web页面，但只能是一个方向--服务器端到客户端，并且只有一个字节的编码可以被重新编码）
--without-http_gzip_module 禁用ngx_http_gzip_module支持（该模块同-with-http_gzip_static_module功能一样）
--without-http_ssi_module 禁用ngx_http_ssi_module支持（该模块提供了一个在输入端处理处理服务器包含文件（SSI）的过滤器，目前支持SSI命令的列表是不完整的）
--without-http_userid_module 禁用ngx_http_userid_module支持（该模块用来处理用来确定客户端后续请求的cookies）
--without-http_access_module 禁用ngx_http_access_module支持（该模块提供了一个简单的基于主机的访问控制。允许/拒绝基于ip地址）
--without-http_auth_basic_module禁用ngx_http_auth_basic_module（该模块是可以使用用户名和密码基于http基本认证方法来保护你的站点或其部分内容）
--without-http_autoindex_module 禁用disable ngx_http_autoindex_module支持（该模块用于自动生成目录列表，只在ngx_http_index_module模块未找到索引文件时发出请求。）
--without-http_geo_module 禁用ngx_http_geo_module支持（创建一些变量，其值依赖于客户端的IP地址）
--without-http_map_module 禁用ngx_http_map_module支持（使用任意的键/值对设置配置变量）
--without-http_split_clients_module 禁用ngx_http_split_clients_module支持（该模块用来基于某些条件划分用户。条件如：ip地址、报头、cookies等等）
--without-http_referer_module 禁用disable ngx_http_referer_module支持（该模块用来过滤请求，拒绝报头中Referer值不正确的请求）
--without-http_rewrite_module 禁用ngx_http_rewrite_module支持（该模块允许使用正则表达式改变URI，并且根据变量来转向以及选择配置。如果在server级别设置该选项，那么他们将在 location之前生效。如果在location还有更进一步的重写规则，location部分的规则依然会被执行。如果这个URI重写是因为location部分的规则造成的，那么 location部分会再次被执行作为新的URI。 这个循环会执行10次，然后Nginx会返回一个500错误。）
--without-http_proxy_module 禁用ngx_http_proxy_module支持（有关代理服务器）
--without-http_fastcgi_module 禁用ngx_http_fastcgi_module支持（该模块允许Nginx 与FastCGI 进程交互，并通过传递参数来控制FastCGI 进程工作。 ）FastCGI一个常驻型的公共网关接口。
--without-http_uwsgi_module 禁用ngx_http_uwsgi_module支持（该模块用来医用uwsgi协议，uWSGI服务器相关）
--without-http_scgi_module 禁用ngx_http_scgi_module支持（该模块用来启用SCGI协议支持，SCGI协议是CGI协议的替代。它是一种应用程序与HTTP服务接口标准。它有些像FastCGI但他的设计 更容易实现。）
--without-http_memcached_module 禁用ngx_http_memcached_module支持（该模块用来提供简单的缓存，以提高系统效率）
-without-http_limit_zone_module 禁用ngx_http_limit_zone_module支持（该模块可以针对条件，进行会话的并发连接数控制）
--without-http_limit_req_module 禁用ngx_http_limit_req_module支持（该模块允许你对于一个地址进行请求数量的限制用一个给定的session或一个特定的事件）
--without-http_empty_gif_module 禁用ngx_http_empty_gif_module支持（该模块在内存中常驻了一个1*1的透明GIF图像，可以被非常快速的调用）
--without-http_browser_module 禁用ngx_http_browser_module支持（该模块用来创建依赖于请求报头的值。如果浏览器为modern ，则$modern_browser等于modern_browser_value指令分配的值；如 果浏览器为old，则$ancient_browser等于 ancient_browser_value指令分配的值；如果浏览器为 MSIE中的任意版本，则 $msie等于1）
--without-http_upstream_ip_hash_module 禁用ngx_http_upstream_ip_hash_module支持（该模块用于简单的负载均衡）
--with-http_perl_module 启用ngx_http_perl_module支持（该模块使nginx可以直接使用perl或通过ssi调用perl）
--with-perl_modules_path= 设定perl模块路径
--with-perl= 设定perl库文件路径
--http-log-path= 设定access log路径
--http-client-body-temp-path= 设定http客户端请求临时文件路径
--http-proxy-temp-path= 设定http代理临时文件路径
--http-fastcgi-temp-path= 设定http fastcgi临时文件路径
--http-uwsgi-temp-path= 设定http uwsgi临时文件路径
--http-scgi-temp-path= 设定http scgi临时文件路径
-without-http 禁用http server功能
--without-http-cache 禁用http cache功能
--with-mail 启用POP3/IMAP4/SMTP代理模块支持
--with-mail_ssl_module 启用ngx_mail_ssl_module支持
--without-mail_pop3_module 禁用pop3协议（POP3即邮局协议的第3个版本,它是规定个人计算机如何连接到互联网上的邮件服务器进行收发邮件的协议。是因特网电子邮件的第一个离线协议标 准,POP3协议允许用户从服务器上把邮件存储到本地主机上,同时根据客户端的操作删除或保存在邮件服务器上的邮件。POP3协议是TCP/IP协议族中的一员，主要用于 支持使用客户端远程管理在服务器上的电子邮件）
--without-mail_imap_module 禁用imap协议（一种邮件获取协议。它的主要作用是邮件客户端可以通过这种协议从邮件服务器上获取邮件的信息，下载邮件等。IMAP协议运行在TCP/IP协议之上， 使用的端口是143。它与POP3协议的主要区别是用户可以不用把所有的邮件全部下载，可以通过客户端直接对服务器上的邮件进行操作。）
--without-mail_smtp_module 禁用smtp协议（SMTP即简单邮件传输协议,它是一组用于由源地址到目的地址传送邮件的规则，由它来控制信件的中转方式。SMTP协议属于TCP/IP协议族，它帮助每台计算机在发送或中转信件时找到下一个目的地。）
--with-google_perftools_module 启用ngx_google_perftools_module支持（调试用，剖析程序性能瓶颈）
--with-cpp_test_module 启用ngx_cpp_test_module支持
--add-module= 启用外部模块支持
--with-cc= 指向C编译器路径
--with-cpp= 指向C预处理路径
--with-cc-opt= 设置C编译器参数（PCRE库，需要指定–with-cc-opt=”-I /usr/local/include”，如果使用select()函数则需要同时增加文件描述符数量，可以通过–with-cc- opt=”-D FD_SETSIZE=2048”指定。）
--with-ld-opt= 设置连接文件参数。（PCRE库，需要指定–with-ld-opt=”-L /usr/local/lib”。）
--with-cpu-opt= 指定编译的CPU，可用的值为: pentium, pentiumpro, pentium3, pentium4, athlon, opteron, amd64, sparc32, sparc64, ppc64
--without-pcre 禁用pcre库
--with-pcre 启用pcre库
--with-pcre= 指向pcre库文件目录
--with-pcre-opt= 在编译时为pcre库设置附加参数
--with-md5= 指向md5库文件目录（消息摘要算法第五版，用以提供消息的完整性保护）
--with-md5-opt= 在编译时为md5库设置附加参数
--with-md5-asm 使用md5汇编源
--with-sha1= 指向sha1库目录（数字签名算法，主要用于数字签名）
--with-sha1-opt= 在编译时为sha1库设置附加参数
--with-sha1-asm 使用sha1汇编源
--with-zlib= 指向zlib库目录
--with-zlib-opt= 在编译时为zlib设置附加参数
--with-zlib-asm= 为指定的CPU使用zlib汇编源进行优化，CPU类型为pentium, pentiumpro
--with-libatomic 为原子内存的更新操作的实现提供一个架构
--with-libatomic= 指向libatomic_ops安装目录
--with-openssl= 指向openssl安装目录
--with-openssl-opt 在编译时为openssl设置附加参数
--with-debug 启用debug日志
```



## 5、nginx.conf

在nginx目录下进入conf目录，该目录下有个nginx.conf文件，这是nginx最重要的配置文件

```bash
vim /usr/local/nginx/conf
```

**nginx.conf文件的全部内容如下(有注释版):**

```bash
 # 运行nginx的所属组和所有者
 #user  nobody;  

#开启进程数 <=CPU数   
worker_processes  1;  

#错误日志保存位置  
#error_log  logs/error.log;  
#error_log  logs/error.log  notice;  
#error_log  logs/error.log  info;  

#进程号保存文件  
#pid        logs/nginx.pid;  

#每个进程最大连接数（最大连接=连接数x进程数）每个worker允许同时产生多少个链接，默认1024  
events {  
    worker_connections  1024;  
}  


http {  
    #文件扩展名与文件类型映射表  
    include       mime.types;  
    #默认文件类型  
    default_type  application/octet-stream;  

    #日志文件输出格式 这个位置相于全局设置  
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '  
    #                  '$status $body_bytes_sent "$http_referer" '  
    #                  '"$http_user_agent" "$http_x_forwarded_for"';  

    #请求日志保存位置  
    #access_log  logs/access.log  main;  

    #打开发送文件  
    sendfile        on;  
    #tcp_nopush     on;  

    #keepalive_timeout  0;  
    #连接超时时间  
    keepalive_timeout  65;  

    #打开gzip压缩  
    #gzip  on;  

    server {  
        #监听端口，默认是80端口  
        listen       80;  
        #监听域名  
        server_name  localhost;  

        #charset koi8-r;  

        #nginx访问日志放在logs/host.access.log下，并且使用main格式（还可以自定义格式）  
        #access_log  logs/host.access.log  main;  

        #如果没有location更明确的匹配访问路径的话，访问请求都会被该location处理。  
        location / {  
            #root指定nginx的根目录为/usr/local/nginx/html  
            root   html;  
            #默认访问文件，欢迎页先去html目录下找index.html，如果找不到再去找index.htm  
            index  index.html index.htm;  
        }  

        #error_page  404              /404.html;  
        # redirect server error pages to the static page /50x.html  
        #  

        #错误页面及其返回地址，错误码为500、502、503、504都会返回50.html错误页面。  
        error_page   500 502 503 504  /50x.html;  
        #location后面是"="的话，说明是精确匹配  
        location = /50x.html {  
            root   html;  
        }  

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80  
        #  
        #location ~ \.php$ {  
        #    proxy_pass   http://127.0.0.1;  
        #}  

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000  
        #  
        #location ~ \.php$ {  
        #    root           html;  
        #    fastcgi_pass   127.0.0.1:9000;  
        #    fastcgi_index  index.php;  
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;  
        #    include        fastcgi_params;  
        #}  

        # deny access to .htaccess files, if Apache's document root  
        # concurs with nginx's one  
        #  
        #location ~ /\.ht {  
        #    deny  all;  
        #}  
    }  


    # another virtual host using mix of IP-, name-, and port-based configuration  
    #  
    #server {  
    #    listen       8000;  
    #    listen       somename:8080;  
    #    server_name  somename  alias  another.alias;  

    #    location / {  
    #        root   html;  
    #        index  index.html index.htm;  
    #    }  
    #}  


    # HTTPS server  
    #  
    #server {  
    #    listen       443 ssl;  
    #    server_name  localhost;  

    #    ssl_certificate      cert.pem;  
    #    ssl_certificate_key  cert.key;  

    #    ssl_session_cache    shared:SSL:1m;  
    #    ssl_session_timeout  5m;  

    #    ssl_ciphers  HIGH:!aNULL:!MD5;  
    #    ssl_prefer_server_ciphers  on;  

    #    location / {  
    #        root   html;  
    #        index  index.html index.htm;  
    #    }  
    #}  

} 
```

配置文件里可以添加多个server，server监听的端口不同，可以根据需要让nginx代理多个端口，当访问某个端口的时候，指定去做某些事情。我这里添加了一个server，这个server监听的端口为1234，server_name我指定为了test.com，也就是域名为test.com，当访问1234端口时会自动导航到/usr/local/nginx/tester/tester111.html页面，如下所示。

```bash
# 运行nginx的所属组和所有者
#user  nobody;  

#开启进程数 <=CPU数   
worker_processes  1;  

#错误日志保存位置  
#error_log  logs/error.log;  
#error_log  logs/error.log  notice;  
#error_log  logs/error.log  info;  

#进程号保存文件  
#pid        logs/nginx.pid;  

#每个进程最大连接数（最大连接=连接数x进程数）每个worker允许同时产生多少个链接，默认1024  
events {  
    worker_connections  1024;  
}  


http {  
    #文件扩展名与文件类型映射表  
    include       mime.types;  
    #默认文件类型  
    default_type  application/octet-stream;  

    #日志文件输出格式 这个位置相于全局设置  
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '  
    #                  '$status $body_bytes_sent "$http_referer" '  
    #                  '"$http_user_agent" "$http_x_forwarded_for"';  

    #请求日志保存位置  
    #access_log  logs/access.log  main;  

    #打开发送文件  
    sendfile        on;  
    #tcp_nopush     on;  

    #keepalive_timeout  0;  
    #连接超时时间  
    keepalive_timeout  65;  

    #打开gzip压缩  
    #gzip  on;  

    server {  
        #监听端口  
        listen       80;  
        #监听域名  
        server_name  localhost;  

        #charset koi8-r;  

        #nginx访问日志放在logs/host.access.log下，并且使用main格式（还可以自定义格式）  
        #access_log  logs/host.access.log  main;  

        #如果没有location更明确的匹配访问路径的话，访问请求都会被该location处理。  
        location / {  
            #root指定nginx的根目录为/usr/local/nginx/html  
            root   html;  
            #默认访问文件，欢迎页先去html目录下找index.html，如果找不到再去找index.htm  
            index  index.html index.htm;  
        }  

        #error_page  404              /404.html;  
        # redirect server error pages to the static page /50x.html  
        #  

        #错误页面及其返回地址，错误码为500、502、503、504都会返回50.html错误页面。  
        error_page   500 502 503 504  /50x.html;  
        #location后面是"="的话，说明是精确匹配  
        location = /50x.html {  
            root   html;  
        }  

        server {  
            listen 1234;  
            server_name test.com;  
            location / {  
                #正则表达式匹配uri方式：在/usr/local/nginx/tester下 建立一个tester111.html 然后使用正则匹配  
                root tester;  
                index tester111.html;  
            }  
        }  
    }  
}  
```

### 5.1 配置文件的文件结构

```bash
...              #全局块

events {         #events块
   ...
}

http      #http块
{
    ...   #http全局块
    server        #server块
    { 
        ...       #server全局块
        location [PATTERN]   #location块
        {
            ...
        }
        location [PATTERN] 
        {
            ...
        }
    }
    server
    {
      ...
    }
    ...     #http全局块
}
```

- 1、**全局块**：配置影响nginx全局的指令。一般有运行nginx服务器的用户组，nginx进程pid存放路径，日志存放路径，配置文件引入，允许生成worker process数等。
- 2、**events块**：配置影响nginx服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网路连接，开启多个网络连接序列化等。
- 3、**http块**：可以嵌套多个server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type定义，日志自定义，是否使用sendfile传输文件，连接超时时间，单连接请求数等。
- 4、**server块**：配置虚拟主机的相关参数，一个http中可以有多个server。
- 5、**location块**：配置请求的路由，以及各种页面的处理情况。

### 5.2 基本格式

nginx配置文件是由若干个部分组成，每一个部分都是通过如下的方式来定义的

```bash
<section> {
   <directive>  <parameters>;
}
```

需要注意的是,每个指令行都由分号结束(;)，这标记着 行的结束。大括号({})实际上表示一个个新配置的上下文(context) ，但是在大多数情况下，我们将它们作为"节、部分(section)"来读。

### 5.3 全局配置参数

全局配置部分被用于配置对整个server都有效的参数和前 个章节中的例外格式。全局部分可能包含配置指令，例如user和worker_processes，也包括“节、部分（ section ）”。 例如， events，这里没有大括号({})包围全局部分。 

| 全局配置指令       | 说明                                                         |
| ------------------ | ------------------------------------------------------------ |
| user               | 使用这个参数来配置 worker 进程的用户和组。如果忽略 group ，那么group的名称等于该参数指定用户的用户组 |
| worker_processes   | 指定 worker 进程启动的数量。这些进程用于处理客户的所有连接。选择一个正确的数量取决于服务器环境、磁盘子系统和网络基础设施。一个好的经验法则是设置该参数的值与 CPU 绑定的负载处理器核心的数量相同，并用1.5~2 之间的数乘以这个数作为I/O密集型负载 |
| error_log          | error_log是所有错误写入的文件。如果在其他区段中没有设置其他的 error_log ，那么这个日志文件将会记录所有的错误。该指令的第二个参数指定了被记录错误的级别（debug、info、notice、warn、error、crit、alert、emerg）。注意， debug 级别的错误只有在编译时配置了--with-debug 选项才可以使用 |
| pid                | 设置记录主进程 ID 的文件，这个配置将会覆盖编译时的默认配置   |
| use                | 该指令用于指示使用什么样的连接方法。这个配置将会覆盖编译时的默认配置，如果配置该指令，那么需要 一个events的区段，通常不需要覆盖，除非是当编译时的默认值随着时间的推移产生错误时才需要被覆盖设置 |
| worker_connections | 该指令配置一个个工作进程能够接受并发连接的最大数。这个连接包括客户连接和向上游服务器的连接，但并不限于此。这对于反向代理服务器尤为重要，为了达到这个并发性连接数量，需要在操作系统层面进行一些额外调整 |

## 6、nginx使用

### **6.1 nginx** **安装配置+清缓存模块安装**

* 软件包下载

```
mkdir /opt/nginx/web1
cd /opt/software
wget http://nginx.org/download/nginx-1.16.0.tar.gz
wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz
tar zxvf nginx-1.16.0.tar.gz
tar zxvf ngx_cache_purge-2.3.tar.gz
```

* 编译安装

```bash
cd nginx-1.16.0

./configure \
--prefix=/opt/nginx/web1 \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_realip_module \
--add-module=../ngx_cache_purge-2.3 \
--with-pcre

make && make install
```

* 内核参数优化

```bash
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 1800
net.ipv4.ip_conntrack_max = 16777216
net.ipv4.netfilter.ip_conntrack_max = 16777216
net.ipv4.tcp_max_syn_backlog = 65536
net.core.netdev_max_backlog = 32768
net.core.somaxconn = 32768
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.ip_local_port_range = 1024 65535
```

* 系统连接数的优化

  在/etc/security/limits.conf最后增加

```bash
* soft nofile 102400
* hard nofile 102400
* soft nproc 65535
* hard nproc 65535
```

* 站点设置

| 序号 | 域名         | 目录                   |
| ---- | ------------ | ---------------------- |
| 1    | www.chen.com | /www/html/www.chen.com |
| 2    | bbs.chen.com | /www/html/bbs.chen.com |

* 配置文件修改

```bash
user  nobody; # 运行 nginx 的所属组和所有者
worker_processes  2; # 开启两个 nginx 工作进程,一般几个 CPU 核心就写几

#error_log  logs/error.log;
error_log  logs/error.log  notice; # 错误日志路径
#error_log  logs/error.log  info;

pid        logs/nginx.pid; #  pid 路径

events {
    worker_connections  1024; # 一个进程能同时处理 1024 个请求
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main; # 默认访问日志路径

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;  # keepalive 超市时间

    #gzip  on;
	# 开始配置一个域名,一个 server 配置段一般对应一个域名
    server {
		# 在本机所有 ip 上监听 80,也可以写为 192.168.78.138:80,这样的话,就只监听192.168.78.138上的 80 口
        listen       80;
        server_name  www.chen.com;  # 域名
        root         /www/html/www.chen.com; # 站点根目录（程序目录）
        index        index.html index.htm; # 索引文件
        location / { # 可以有多个 location
            root   /www/html/www.chen.com; # 站点根目录（程序目录）
        }
        # 定义错误页面,如果是 500 错误,则把站点根目录下的 50x.html 返回给用户
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root  /www/html/www.chen.com;
        }
    }
    server {
        listen       80;
        server_name  bbs.chen.com;
        root         /www/html/bbs.chen.com;
        index        index.html index.htm;
        location / {
            root   /www/html/bbs.chen.com;
        }
        # redirect server error pages to the static page /50x.html
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root  /www/html/bbs.chen.com;
        }
    } 
}
```

* nginx 启动关闭

```bash
/opt/nginx/web1/sbin/nginx  #启动
/opt/nginx/web1/sbin/nginx  -t # 验证nginx配置文件的正确性
/opt/nginx/web1/sbin/nginx  -s reload # 重载nginx
/opt/nginx/web1/sbin/nginx  -s stop # 关闭nginx
```

* 测试

```bash
mkdir -p /www/html/bbs.chen.com
mkdir -p /www/html/www.chen.com
echo "bbs.chen.com" >> /www/html/bbs.chen.com/index.html
echo "www.chen.com" >> /www/html/www.chen.com/index.html
```

* nginx 启动

```
/opt/nginx/web1/sbin/nginx
```

* 绑定hosts测试

修改`C:\Windows\System32\drivers\etc\hosts` 

```
192.168.78.138 bbs.chen.com
192.168.78.138 www.chen.com
```

