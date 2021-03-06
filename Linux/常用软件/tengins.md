# Tengine安装

## 编译环境准备

```bash
#Tengine安装需要使用源代码自行编译，所以在安装前需要安装必要的编译工具
yum update
yum install gcc gcc-c++ autoconf automake
```

## 组件准备

###  PCRE 

 PCRE(Perl Compatible Regular Expressions)是一个Perl库，包括 perl 兼容的正则表达式库。nginx rewrite依赖于PCRE库，所以在安装Tengine前一定要先安装PCRE，最新版本的PCRE可在官网（http://www.pcre.org/）获取 

```bash
mkdir /opt/tengins
cd /opt/tengins
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.36.tar.gz
tar zxvf pcre-8.36.tar.gz
cd pcre-8.36
./configure --prefix=/usr/local/pcre
make && make install
```

###  OpenSSL 

 OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及SSL协议，并提供丰富的应用程序供测试或其它目的使用。，安装OpenSSL（http://www.openssl.org/source/）主要是为了让tengine支持Https的访问请求。具体是否安装看需求。 

```bash
cd /opt/tengins
wget http://www.openssl.org/source/openssl-1.0.2.tar.gz
tar zxvf openssl-1.0.2.tar.gz
cd openssl-1.0.2
./config --prefix=/usr/local/openssl
make && make install
```

### Zlib

Zlib是提供资料压缩之用的函式库，当Tengine想启用GZIP压缩的时候就需要使用到Zlib（http://www.zlib.net/）。

```bash
cd /opt/tengins
wget http://zlib.net/zlib-1.2.8.tar.gz
tar zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=/usr/local/zlib
make && make install
```

###  jemalloc

 jemalloc（http://www.canonware.com/jemalloc/）是一个更好的内存管理工具，使用jemalloc可以更好的优化Tengine的内存管理。 

```
cd /opt/tengins
wget http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2
tar jxvf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
./configure --prefix=/usr/local/jemalloc
make && make install
```

## Tengine安装

### 用户

```
groupadd tengine
useradd -s /sbin/nologin -g tengine tengine
```

### 安装

```bash
cd /opt/tengins
wget http://tengine.taobao.org/download/tengine-2.3.2.tar.gz
tar zxvf tengine-2.3.2.tar.gz
cd tengine-2.3.2
./configure --prefix=/winning/winmid/nginx \
--user=tengine \
--group=tengine \
--with-pcre=/opt/tengins/pcre-8.36 \
--with-openssl=/opt/tengins/openssl-1.0.2 \
--with-jemalloc=/opt/tengins/jemalloc-3.6.0 \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_stub_status_module \
--with-zlib=/opt/tengins/zlib-1.2.8
make && make install
```

### 配置

```bash
vim /etc/rc.d/init.d/nginx
```

`nginx`

```shell
#!/bin/bash
# nginx Startup script for the Nginx HTTP Server
# it is v.0.0.2 version.
# chkconfig: - 85 15
# description: Nginx is a high-performance web and proxy server.
#              It has a lot of features, but it's not for everyone.
# processname: nginx
# pidfile: /var/run/nginx.pid
# config: /winning/winmid/nginx/conf/nginx.conf
nginxd=/winning/winmid/nginx/sbin/nginx                        #/注意你安装nginx是否这个路径
nginx_config=/winning/winmid/nginx/conf/nginx.conf             #/注意你安装nginx是否这个路径
nginx_pid=/winning/winmid/nginx/logs/nginx.pid                 #/注意你安装nginx是否这个路径
#nginx_pid=/var/run/nginx.pid                 #/注意你安装nginx是否这个路径
RETVAL=0
prog="nginx"
# Source function library.
. /etc/rc.d/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0
[ -x $nginxd ] || exit 0
# Start nginx daemons functions.
start() {
if [ -e $nginx_pid ];then
   echo "nginx already running...."
   exit 1
fi
   echo -n $"Starting $prog: "
   daemon $nginxd -c ${nginx_config}
   RETVAL=$?
   echo
   [ $RETVAL = 0 ] && touch /var/lock/subsys/nginx
   cp $nginx_pid /var/run/nginx.pid  
   #return $RETVAL
}
# Stop nginx daemons functions.
stop() {
        echo -n $"Stopping $prog: "
        killproc $nginxd
        rm -f /var/lock/subsys/nginx /var/run/nginx.pid $nginx_pid
        RETVAL=$?
        echo
        [ $RETVAL = 0 ] && rm -f /var/lock/subsys/nginx /var/run/nginx.pid $nginx_pid
}
# reload nginx service functions.
reload() {
    echo -n $"Reloading $prog: "
    #kill -HUP `cat ${nginx_pid}`
    killproc $nginxd -HUP
    RETVAL=$?
    echo
}
# See how we were called.
case "$1" in
start)
        start
        ;;
stop)
        stop
        ;;
reload)
        reload
        ;;
restart)
        stop
        start
        ;;
status)
        status $prog
        RETVAL=$?
        ;;
*)
        echo $"Usage: $prog {start|stop|restart|reload|status|help}"
        exit 1
esac
exit $RETVAL

```

