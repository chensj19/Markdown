# MySQL 安装笔记

## 1、解压文件

```bash
 tar xvJf mysql-8.0.14-linux-glibc2.12-x86_64.tar.xz
```

## 2、移动文件

```bash
sudo mv mysql-8.0.14-linux-glibc2.12-x86_64 /opt/mysql/
```

## 3、MySQL配置

```bash
cd /opt/mysql/
sudo vim /etc/my.cnf
```

* `my.cnf`

```bash
[mysqld]
user=mysql
server-id=1
port=3306
mysqlx_port=33060
mysqlx_socket=/tmp/mysqlx.sock
basedir=/opt/mysql
datadir=/opt/mysql/data
socket=/tmp/mysql.sock
pid-file=/tmp/mysqld.pid
log-error=/opt/mysql/log/error.log
slow-query-log=1
slow-query-log-file=/opt/mysql/log/slow.log
long_query_time=0.2
log-bin=/opt/mysql/log/bin.log
relay-log=/opt/mysql/log/relay.log
binlog_format=ROW
relay_log_recovery=1
character-set-client-handshake=FALSE
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
init_connect ='SET NAMES utf8mb4'
innodb_buffer_pool_size=1G
join_buffer_size=128M
sort_buffer_size=2M
read_rnd_buffer_size=2M
log_timestamps = SYSTEM
lower_case_table_names = 1
default-authentication-plugin=mysql_native_password
#skip-grant-tables
```

* `log`创建

```bash
cd /opt/mysql/
sudo mkdir log
sudo mkdir data
cd log
sudo touch error.log
sudo touch slow.log
sudo touch bin.log
sudo touch relay.log
```



## 4、创建用户

```bash
# 创建组
sudo groupadd mysql
# 创建用户
sudo useradd mysql -g mysql
# 修改文件夹归属
sudo chown mysql:mysql /opt/mysql/
# 修改文件夹权限
sudo chmod -R 775 /opt/mysql
```



## 5、MySQL安装

```bash
# 链接mysql
sudo ln -s /opt/mysql/bin/mysql /usr/local/bin
# 链接mysqld
sudo ln -s /opt/mysql/bin/mysqld /usr/local/bin
# MySQL 安装
sudo mysqld --initialize --console
# 获取密码
cat log/error.log |grep password
# 登录MySQL
mysql -p -S /tmp/mysql.sock
```



## 6、MySQL设置

```sql
mysql> alter user root@'localhost' identified by '123456';
Query OK, 0 rows affected (0.12 sec)

mysql> select version();
+-----------+
| version() |
+-----------+
| 8.0.12    |
+-----------+
1 row in set (0.00 sec)

mysql>  show variables like '%valid%pass%';
Empty set (0.01 sec)

增加用户，用于远程访问 

mysql> create user root@'%' identified by '123456';
Query OK, 0 rows affected (0.09 sec)

mysql> grant all privileges on *.* to root@'%' with grant option;
Query OK, 0 rows affected (0.15 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.06 sec)

mysql>  show variables like 'character_set_%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8mb4                    |
| character_set_connection | utf8mb4                    |
| character_set_database   | utf8mb4                    |
| character_set_filesystem | binary                     |
| character_set_results    | utf8mb4                    |
| character_set_server     | utf8mb4                    |
| character_set_system     | utf8                       |
| character_sets_dir       | /opt/mysql/share/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)
```



## 7、mysql service

```bash
cp support-files/mysql.server /etc/init.d/mysql
# 配置/etc/init.d/mysql
basedir=/opt/mysql
datadir=/opt/mysql/data

# 设置开机启动
sudo systemctl enable mysql

```

