# CentOS ALiSql

## 1、安装编译环境

AliSql提供的源码所有需要自己编译

### 1.1 编译环境搭建

```bash
yum install centos-release-scl -y
# gc++ 
yum install devtoolset-4-gcc-c++ devtoolset-4-gcc -y
# 执行配置命令
yum install cmake -y
# 下载源码
yum install git -y
yum install openssl-devel -y
yum install bison -y
# 数据库初始化时候需要
yum install autoconf -y
yum install ncurses-devel -y
# 将新安装的devtoolset-4 启
scl enable devtoolset-4 bash
```

### 1.2 卸载mariadb

centos 默认安装mariadb

```bash
rpm -qa|grep mariadb
mariadb-libs-5.5.60-1.el7_5.x86_64
yum remove -y mariadb-libs-5.5.60-1.el7_5.x86_64
```



## 2、下载源码

```bash
# github
git clone https://github.com/alibaba/AliSQL.git
cd AliSQL
# gitee
git clone https://gitee.com/mirrors/alisql.git
cd alisql
```

## 3、编译

### 3.1 编译AliSQL, 需要先设置cmake变量

```bash
cmake .                              \
 -DCMAKE_BUILD_TYPE="Release"         \
 -DCMAKE_INSTALL_PREFIX="/app/alisql" \
 -DWITH_EMBEDDED_SERVER=0             \
 -DWITH_EXTRA_CHARSETS=all            \
 -DWITH_MYISAM_STORAGE_ENGINE=1       \
 -DWITH_INNOBASE_STORAGE_ENGINE=1     \
 -DWITH_PARTITION_STORAGE_ENGINE=1    \
 -DWITH_CSV_STORAGE_ENGINE=1          \
 -DWITH_ARCHIVE_STORAGE_ENGINE=1      \
 -DWITH_BLACKHOLE_STORAGE_ENGINE=1    \
 -DWITH_FEDERATED_STORAGE_ENGINE=1    \
 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1   \
 -DWITH_TOKUDB_STORAGE_ENGINE=1 
 
```

> 参数说明
>
> -DCMAKE_INSTALL_PREFIX="/opt/alisql" 指定了安装位置。
>
> -DMYSQL_UNIX_ADDR  sock文件路径
>
> -DMYSQL_DATADIR="/data/alisql"  数据文件放置位置
>
> -DDEFAULT_CHARSET=utf8 默认字符集
>
> -DDEFAULT_COLLATION=utf8_general_ci  默认字符校对
>
> -DWITH_EXTRA_CHARSETS 扩展字符支持 默认all
>
> -DWITH_storage_STORAGE_ENGINE 存储引擎的支持,默认支持MyISAM,MERGE,MEMORY,CVS存储引擎
>
> -DENABLED_LOCAL_INFILE=1 启用加载本地数据
>
> -DMYSQL_DATADIR 数据存放目录
>
> -DMYSQL_USER mysql运行用户

### 3.2 编译

```bash
make -j4 && make install
```

## 4、配置

### 4.1 添加用户

```bash
# 添加mysql组
groupadd mysql
# 添加用户
useradd -M -s /sbin/nologin -g mysql -r mysql
# mysql数据存放位置
mkdir -p /data/alisql
```

### 4.2 修改数据库文件夹的所有者，初始化数据库

```bash
# 切换到数据库安装文件夹
cd /app/alisql
# 查看文件
ls
bin  COPYING  data  docs  include  lib  man  mysql-test  README  README.md  README-TOKUDB  scripts  share  sql-bench  support-files
# 切换目录到脚本路径准备初始化
cd scripts
# 修改数据库文件夹所有者
# 修改安装目录所有者
chown -R mysql:mysql /app/alisql/
# 修改数据存放路径所有者
chown -R mysql:mysql  /data/alisql/
# 初始化
./mysql_install_db --user=mysql --basedir=/app/alisql --datadir=/data/alisql
```

### 4.3 初始化报错

#### 4.3.1 FATAL ERROR: 

please install the following Perl modules before executing ./mysql_install_db

```bash
yum -y install autoconf
```

#### 4.3.2 

因为页面管理选项transparent huge pages 开启，根据提示关闭。关闭的命令在()内给出了提示：

```bash
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

* 完整信息

```bash
# ./mysql_install_db --user=mysql --basedir=/app/alisql --datadir=/data/alisql
Installing MySQL system tables...2019-12-21 17:43:31 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2019-12-21 17:43:31 0 [Note] /app/alisql/bin/mysqld (mysqld 5.6.32) starting as process 54740 ...
Transparent huge pages are enabled, according to /sys/kernel/mm/transparent_hugepage/enabled
2019-12-21 17:43:31 54740 [ERROR] TokuDB: Huge pages are enabled, disable them before continuing

2019-12-21 17:43:31 54740 [ERROR] ************************************************************
2019-12-21 17:43:31 54740 [ERROR]
2019-12-21 17:43:31 54740 [ERROR]                         @@@@@@@@@@@
2019-12-21 17:43:31 54740 [ERROR]                       @@'         '@@
2019-12-21 17:43:31 54740 [ERROR]                      @@    _     _  @@
2019-12-21 17:43:31 54740 [ERROR]                      |    (.)   (.)  |
2019-12-21 17:43:31 54740 [ERROR]                      |             ` |
2019-12-21 17:43:31 54740 [ERROR]                      |        >    ' |
2019-12-21 17:43:31 54740 [ERROR]                      |     .----.    |
2019-12-21 17:43:31 54740 [ERROR]                      ..   |.----.|  ..
2019-12-21 17:43:31 54740 [ERROR]                       ..  '      ' ..
2019-12-21 17:43:31 54740 [ERROR]                         .._______,.
2019-12-21 17:43:31 54740 [ERROR]
2019-12-21 17:43:31 54740 [ERROR] TokuDB will not run with transparent huge pages enabled.
2019-12-21 17:43:31 54740 [ERROR] Please disable them to continue.
2019-12-21 17:43:31 54740 [ERROR] (echo never > /sys/kernel/mm/transparent_hugepage/enabled)
2019-12-21 17:43:31 54740 [ERROR]
2019-12-21 17:43:31 54740 [ERROR] ************************************************************
2019-12-21 17:43:31 54740 [ERROR] Plugin 'TokuDB' init function returned error.
2019-12-21 17:43:31 54740 [ERROR] Plugin 'TokuDB' registration as a STORAGE ENGINE failed.
2019-12-21 17:43:31 54740 [Note] InnoDB: Using atomics to ref count buffer pool pages
2019-12-21 17:43:31 54740 [Note] InnoDB: The InnoDB memory heap is disabled
2019-12-21 17:43:31 54740 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2019-12-21 17:43:31 54740 [Note] InnoDB: Memory barrier is not used
2019-12-21 17:43:31 54740 [Note] InnoDB: Compressed tables use zlib 1.2.3
2019-12-21 17:43:31 54740 [Note] InnoDB: Using CPU crc32 instructions
2019-12-21 17:43:31 54740 [Note] InnoDB: Initializing buffer pool, size = 128.0M
2019-12-21 17:43:31 54740 [Note] InnoDB: Completed initialization of buffer pool
2019-12-21 17:43:31 54740 [Note] InnoDB: The first specified data file ./ibdata1 did not exist: a new database to be created!
2019-12-21 17:43:31 54740 [Note] InnoDB: Setting file ./ibdata1 size to 12 MB
2019-12-21 17:43:31 54740 [Note] InnoDB: Database physically writes the file full: wait...
2019-12-21 17:43:31 54740 [Note] InnoDB: Setting log file ./ib_logfile101 size to 48 MB
2019-12-21 17:43:31 54740 [Note] InnoDB: Setting log file ./ib_logfile1 size to 48 MB
2019-12-21 17:43:31 54740 [Note] InnoDB: Renaming log file ./ib_logfile101 to ./ib_logfile0
2019-12-21 17:43:31 54740 [Warning] InnoDB: New log files created, LSN=45781
2019-12-21 17:43:31 54740 [Note] InnoDB: Doublewrite buffer not found: creating new
2019-12-21 17:43:31 54740 [Note] InnoDB: Doublewrite buffer created
2019-12-21 17:43:31 54740 [Note] InnoDB: 128 rollback segment(s) are active.
2019-12-21 17:43:31 54740 [Warning] InnoDB: Creating foreign key constraint system tables.
2019-12-21 17:43:31 54740 [Note] InnoDB: Foreign key constraint system tables created
2019-12-21 17:43:31 54740 [Note] InnoDB: Creating tablespace and datafile system tables.
2019-12-21 17:43:31 54740 [Note] InnoDB: Tablespace and datafile system tables created.
2019-12-21 17:43:31 54740 [Note] InnoDB: Waiting for purge to start
2019-12-21 17:43:31 54740 [Note] InnoDB: 5.6.32 started; log sequence number 0
2019-12-21 17:43:31 54740 [ERROR] Failed to initialize plugins.
2019-12-21 17:43:31 54740 [ERROR] Aborting

2019-12-21 17:43:31 54740 [Note] Binlog end
2019-12-21 17:43:31 54740 [Note] InnoDB: FTS optimize thread exiting.
2019-12-21 17:43:31 54740 [Note] InnoDB: Starting shutdown...
2019-12-21 17:43:33 54740 [Note] InnoDB: Shutdown completed; log sequence number 1600607
2019-12-21 17:43:33 54740 [Note] /app/alisql/bin/mysqld: Shutdown complete
```

执行关闭透明大页面后重新初始化，成功

```bash
./mysql_install_db --user=mysql --basedir=/app/alisql --datadir=/data/alisql --explicit_defaults_for_timestamp
```

安裝日志

```bash
 ./mysql_install_db --user=mysql --basedir=/app/alisql --datadir=/data/alisql --explicit_defaults_for_timestamp
Installing MySQL system tables...2019-12-21 17:48:06 0 [Note] /app/alisql/bin/mysqld (mysqld 5.6.32) starting as process 56391 ...
2019-12-21 17:48:06 56391 [Note] InnoDB: Using atomics to ref count buffer pool pages
2019-12-21 17:48:06 56391 [Note] InnoDB: The InnoDB memory heap is disabled
2019-12-21 17:48:06 56391 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2019-12-21 17:48:06 56391 [Note] InnoDB: Memory barrier is not used
2019-12-21 17:48:06 56391 [Note] InnoDB: Compressed tables use zlib 1.2.3
2019-12-21 17:48:06 56391 [Note] InnoDB: Using CPU crc32 instructions
2019-12-21 17:48:06 56391 [Note] InnoDB: Initializing buffer pool, size = 128.0M
2019-12-21 17:48:06 56391 [Note] InnoDB: Completed initialization of buffer pool
2019-12-21 17:48:06 56391 [Note] InnoDB: Highest supported file format is Barracuda.
2019-12-21 17:48:06 56391 [Note] InnoDB: 128 rollback segment(s) are active.
2019-12-21 17:48:06 56391 [Note] InnoDB: Waiting for purge to start
2019-12-21 17:48:06 56391 [Note] InnoDB: 5.6.32 started; log sequence number 1600607
2019-12-21 17:48:06 56391 [Note] Binlog end
2019-12-21 17:48:06 56391 [Note] InnoDB: FTS optimize thread exiting.
2019-12-21 17:48:06 56391 [Note] InnoDB: Starting shutdown...
2019-12-21 17:48:08 56391 [Note] InnoDB: Shutdown completed; log sequence number 1625987
OK

Filling help tables...2019-12-21 17:48:08 0 [Note] /app/alisql/bin/mysqld (mysqld 5.6.32) starting as process 56438 ...
2019-12-21 17:48:08 56438 [Note] InnoDB: Using atomics to ref count buffer pool pages
2019-12-21 17:48:08 56438 [Note] InnoDB: The InnoDB memory heap is disabled
2019-12-21 17:48:08 56438 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2019-12-21 17:48:08 56438 [Note] InnoDB: Memory barrier is not used
2019-12-21 17:48:08 56438 [Note] InnoDB: Compressed tables use zlib 1.2.3
2019-12-21 17:48:08 56438 [Note] InnoDB: Using CPU crc32 instructions
2019-12-21 17:48:08 56438 [Note] InnoDB: Initializing buffer pool, size = 128.0M
2019-12-21 17:48:08 56438 [Note] InnoDB: Completed initialization of buffer pool
2019-12-21 17:48:08 56438 [Note] InnoDB: Highest supported file format is Barracuda.
2019-12-21 17:48:08 56438 [Note] InnoDB: 128 rollback segment(s) are active.
2019-12-21 17:48:08 56438 [Note] InnoDB: Waiting for purge to start
2019-12-21 17:48:08 56438 [Note] InnoDB: 5.6.32 started; log sequence number 1625987
2019-12-21 17:48:08 56438 [Note] Binlog end
2019-12-21 17:48:08 56438 [Note] InnoDB: FTS optimize thread exiting.
2019-12-21 17:48:08 56438 [Note] InnoDB: Starting shutdown...
2019-12-21 17:48:10 56438 [Note] InnoDB: Shutdown completed; log sequence number 1625997
OK

To start mysqld at boot time you have to copy
support-files/mysql.server to the right place for your system

PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
To do so, start the server, then issue the following commands:

  /app/alisql/bin/mysqladmin -u root password 'new-password'
  /app/alisql/bin/mysqladmin -u root -h C7-1810-ALISQL password 'new-password'

Alternatively you can run:

  /app/alisql/bin/mysql_secure_installation

which will also give you the option of removing the test
databases and anonymous user created by default.  This is
strongly recommended for production servers.

See the manual for more instructions.

You can start the MySQL daemon with:

  cd . ; /app/alisql/bin/mysqld_safe &

You can test the MySQL daemon with mysql-test-run.pl

  cd mysql-test ; perl mysql-test-run.pl

Please report any problems at http://bugs.mysql.com/

The latest information about MySQL is available on the web at

  http://www.mysql.com

Support MySQL by buying support/licenses at http://shop.mysql.com

WARNING: Found existing config file /app/alisql/my.cnf on the system.
Because this file might be in use, it was not replaced,
but was used in bootstrap (unless you used --defaults-file)
and when you later start the server.
The new default config file was created as /app/alisql/my-new.cnf,
please compare it with your file and take the changes you need.

WARNING: Default config file /etc/my.cnf exists on the system
This file will be read by default by the MySQL server
If you do not want to use this, either remove it, or use the
--defaults-file argument to mysqld_safe when starting the server
```

## 5、启动

### 5.1 my.cnf修改

启动配置文件为/etc/my.cnf，根据实际情况编辑文件，主要是数据文件位置等信息，然后启动数据库。

```bash
[mysqld]
basedir = /app/alisql
datadir = /data/alisql
port = 3306
socket = /data/alisql/alisql.sock
server_id = 1
slow-query-log = 1
slow-query-log-file = /data/alisql/logs/slow.log
long_query_time = 0.2
log-bin = /data/alisql/logs/bin.log
relay-log = /data/alisql/logs/relay.log
character-set-server = utf8
collation-server = utf8_general_ci
join_buffer_size = 128M
sort_buffer_size = 2M
read_rnd_buffer_size = 2M
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
[client]
socket = /data/alisql/alisql.sock
default-character-set = utf8
```

* 启动

```bash
cd /app/alisql/bin
./mysqld --user=mysql
```

* 启动日志

```bash
 ./mysqld --user=mysql
2019-12-21 17:56:10 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2019-12-21 17:56:10 0 [Note] ./mysqld (mysqld 5.6.32) starting as process 59370 ...
2019-12-21 17:56:10 59370 [Note] Plugin 'FEDERATED' is disabled.
2019-12-21 17:56:10 59370 [Note] InnoDB: Using atomics to ref count buffer pool pages
2019-12-21 17:56:10 59370 [Note] InnoDB: The InnoDB memory heap is disabled
2019-12-21 17:56:10 59370 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2019-12-21 17:56:10 59370 [Note] InnoDB: Memory barrier is not used
2019-12-21 17:56:10 59370 [Note] InnoDB: Compressed tables use zlib 1.2.3
2019-12-21 17:56:10 59370 [Note] InnoDB: Using CPU crc32 instructions
2019-12-21 17:56:10 59370 [Note] InnoDB: Initializing buffer pool, size = 128.0M
2019-12-21 17:56:10 59370 [Note] InnoDB: Completed initialization of buffer pool
2019-12-21 17:56:10 59370 [Note] InnoDB: Highest supported file format is Barracuda.
2019-12-21 17:56:10 59370 [Note] InnoDB: 128 rollback segment(s) are active.
2019-12-21 17:56:10 59370 [Note] InnoDB: Waiting for purge to start
2019-12-21 17:56:10 59370 [Note] InnoDB: 5.6.32 started; log sequence number 1625997
2019-12-21 17:56:10 59370 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: 1db57ecb-23d8-11ea-91ec-000c29dde7ff.
2019-12-21 17:56:10 59370 [Note] Server hostname (bind-address): '*'; port: 3306
2019-12-21 17:56:10 59370 [Note] IPv6 is available.
2019-12-21 17:56:10 59370 [Note]   - '::' resolves to '::';
2019-12-21 17:56:10 59370 [Note] Server socket created on IP: '::'.
2019-12-21 17:56:10 59370 [Note] Event Scheduler: Loaded 0 events
2019-12-21 17:56:10 59370 [Note] [RDS Diagnose] ./mysqld is using 'bundled jemalloc' malloc library
2019-12-21 17:56:10 59370 [Note] ./mysqld: ready for connections.
Version: '5.6.32'  socket: '/data/alisql/logs/mysql.sock'  port: 3306  Source distribution
```

### 5.2 服务方式启动数据库，并且开机自启动

```bash
cp  support-files/mysql.server  /etc/init.d/mysqld
# 將安裝目录添加系统变量中
vim /etc/profile
# 添加如下内容
export PATH=/app/alisql/bin:/app/alisql/lib:$PATH
# 配置文件生效
source  /etc/profile
# 开机启动
systemctl enable mysqld
```

#### 5.2.1 修改/etc/init.d/mysqld

修改如下三个内容

```
basedir=/app/alisql
datadir=/data/alisql
mysqld_pid_file_path=mysql.pid
```

### 5.2.2 修改/etc/rc.local

添加如下信息，才能实现开机重启才可以启动成功

```bash
if test -f /sys/kernel/mm/redhat_transparent_hugepage/enabled; then
   echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
fi
```

如果上面还无法使用则按照如下操作

```bash
 vi /etc/default/grub
# 修改GRUB_CMDLINE_LINUX="rd.lvm.lv=rhel/root rd.lvm.lv=rhel/swap ... transparent_hugepage=never"
grub2-mkconfig -o /boot/grub2/grub.cfg
# redhat
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
# centos
grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
# 重启
 shutdown -r now
# 查看结果
 cat /proc/cmdline
```

## 7、用户初始化密码及登录数据库

```bash
/app/alisql/bin/mysqladmin -u root password '123456'
/app/alisql/bin/mysqladmin -u root -h C7-1810-ALISQL password '123456'
mysql -uroot -p
```

## 8、创建外部使用账户

```bash
 create user winning@'%' identified by '123456';
 grant all privileges on *.* to  winning@'%' identified by '123456';
 flush privileges;
```

