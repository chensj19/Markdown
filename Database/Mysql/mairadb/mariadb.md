



# Mariadb 

## CentOS 安装

### 1、配置Mariadb yum源

```bash
vim /etc/yum.repo.d/mariadb.repo
#添加以下内容
[mariadb]
name = MariaDB
baseurl = https://mirrors.aliyun.com/mariadb/yum/10.4/centos7-amd64/
gpgkey=https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
# 缓存
yum clean all && yum makecache -y
```

### 2、卸载mariadb

 CentOS 7已经将默认集成mariadb，所以在新安装的mariadb的时候需要卸载旧版本的mariadb

```bash
# 查看都安装了哪些的mariadb相关的模块
rpm -qa | grep mariadb
# 卸载
rpm -e mariadb-libs-5.5.44-1.el7_1.x86_64
# 清理文件
# 配置文件
rm -f /etc/my.cnf
# 删除数据目录
rm -rf /var/lib/mysql
```

### 3、安装

```bash
yum install MariaDB-server MariaDB-client -y
```

### 4、配置

#### 4.1 配置文件

```bash
# 字符集
vim /etc/my.cnf.d/mysql-clients.cnf
# 在[mysql]下面添加如下内容
default-character-set=utf8
#
vim /etc/my.cnf.d/server.cnf 
[mysqld]
init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
character-set-server=utf8
collation-server=utf8_unicode_ci
skip-character-set-client-handshake
[mariadb]
log_error=/var/log/mysql/mariadb-error.log
general_log
general_log_file=/var/log/mysql/mariadb-query.log
slow_query_log
slow_query_log_file=/var/log/mysql/mariadb-slow.log
```

#### 4.2  MariaDB的相关简单配置 

```bash
mysql_secure_installation
```

 命令进行配置（先退出数据库）：

```bash

首先是设置密码，会提示先输入密码
 
Enter current password for root (enter for none):<–初次运行直接回车
 
设置密码
 
Set root password? [Y/n] <– 是否设置root用户密码，输入y并回车或直接回车
New password: <– 设置root用户的密码
Re-enter new password: <– 再输入一次你设置的密码
 
其他配置
 
Remove anonymous users? [Y/n] <– 是否删除匿名用户，回车
 
Disallow root login remotely? [Y/n] <–是否禁止root远程登录,回车（后面授权配置）
 
Remove test database and access to it? [Y/n] <– 是否删除test数据库，回车
 
Reload privilege tables now? [Y/n] <– 是否重新加载权限表，回车
```

### 5、启动并设置开启启动

```
systemctl enable mariadb
systemctl start mariadb
```

### 6、用户配置

```bash
# 创建用户
create user username@localhost identified by 'password';
# 分配权限
grant all privileges on *.* to username@'%' identified by 'password';
# 刷新权限
flush privileges;
# 查看结果
select host,user,password from mysql.user;
```

## 常用SQL

### 创建数据库

```bash
-- 删除脚本
DROP DATABASE  IF EXISTS ANT;
-- 创建脚本
CREATE DATABASE ANT  DEFAULT CHARACTER SET UTF8 COLLATE UTF8_GENERAL_CI;
CREATE DATABASE cluster default character set utf8mb4 collate utf8mb4_unicode_ci;
```

### 创建用户

```bash
create user winning@'172.16.%.%' identified by 'Maria@win60.DB';
grant all privileges on *.* to winning@'172.16.%.%' identified by 'Maria@win60.DB';
flush privileges;
```

