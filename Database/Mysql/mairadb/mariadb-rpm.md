# Mariadb RPM制作

## SPEC文件

```bash
Name:           mariadb
Version:        10.4.11
Release:        winning
Summary:        A community developed branch of MySQL

Group:		Applications/Databases
License:        GPLv2 with exceptions and LGPLv2 and BSD
URL:            http://mariadb.org
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc gcc-c++ perl perl-DBI
Requires:       perl perl-DBI
Packager:       Winning Health
# 定义用户 在mysql编译有用，这里没什么用户
%define MYSQL_USER winning
%define MYSQL_GROUP winning

%description
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.
# 编译前操作
%prep
%setup -q
mkdir -p /winning/winmid/mariadb
mkdir -p /winning/winmid/mariadb/logs
mkdir -p /winning/winmid/mariadb/data
mkdir -p /winning/winmid/mariadb/tmp
# 编译
%build
cmake . -DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/winning/winmid/mariadb \
-DMYSQL_UNIX_ADDR=/winning/winmid/mariadb/tmp/mariadb.sock \
-DMYSQL_DATADIR=/winning/winmid/mariadb/data \
-DSYSCONFDIR=/etc \
-DWITHOUT_TOKUDB=1 \
-DEXTRA_CHARSETS=all \
-DMYSQL_USER=winning \
-DDEFAULT_CHARSET=utf8  \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWIYH_SSL=system \
-DVITH_ZLIB=system \
-DWITH_LOBWRAP=0 \
-DMYSQL_TCP_PORT=3306 \
-DENABLE_DOWNLOADS=1 \
-DSKIP_TESTS=ON  
make %{?_smp_mflags}

# 打包
%install
make install DESTDIR=$RPM_BUILD_ROOT

# 安装前操作
%pre
id winning &>/dev/null||useradd -m -s /bin/bash winning &>/dev/null
mkdir -p /winning/winmid/mariadb/logs
mkdir -p /winning/winmid/mariadb/tmp
chown -R winning: /winning/winmid/mariadb
touch /etc/my.cnf
mkdir -p /etc/my.cnf.d
touch /etc/my.cnf.d/mysql-clients.cnf
cat << EOF > /etc/my.cnf
[client]
port            = 3306
socket          = /winning/winmid/mariadb/tmp/mariadb.sock
default-character-set=utf8

[mysqld]
port            = 3306
socket          = /winning/winmid/mariadb/tmp/mariadb.sock
symbolic-links=0
datadir = /winning/winmid/mariadb/data

skip-external-locking
skip-name-resolve

key_buffer_size = 512M
max_allowed_packet = 500M
table_open_cache = 512
sort_buffer_size = 2M
net_buffer_length = 8K
read_buffer_size = 2M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 64M
thread_cache_size = 8
max_connections=1500
query_cache_size= 256M
query_cache_limit= 1M
innodb_buffer_pool_size=2048M
innodb_log_file_size = 2047M
innodb_log_buffer_size = 32M
innodb_page_size = 32K
innodb_file_per_table
expire_logs_days = 1
long_query_time= 2
slow-query-log-file= /winning/winmid/mariadb/logs/slowquery.log

connect_timeout = 30
net_read_timeout = 30

[mysqld_safe]
log-error=/winning/winmid/mariadb/logs/mariadb.log
pid-file=/winning/winmid/mariadb/logs/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d

EOF

cat << EOF >  /etc/my.cnf.d/mysql-clients.cnf
#
# These groups are read by MariaDB command-line tools
# Use it for options that affect only one utility
#

[mysql]

[mysql_upgrade]

[mysqladmin]

[mysqlbinlog]

[mysqlcheck]

[mysqldump]

[mysqlimport]

[mysqlshow]

[mysqlslap]

EOF

# 安装过程
%post
chown -R winning: /winning/winmid/mariadb
/winning/winmid/mariadb/scripts/mysql_install_db  --basedir=/winning/winmid/mariadb --user=winning  --datadir=/winning/winmid/mariadb/data &>/dev/null
#chown -R winning: /winning/winmid/mariadb
#cp /winning/winmid/mariadb/support-files/my*.cnf /etc/my.cnf
cp -f /winning/winmid/mariadb/support-files/mysql.server  /etc/init.d/mariadb
sed -i 's/$bindir\/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path"/$bindir\/mysqld_safe --user=winning --datadir="$datadir" --pid-file="$mysqld_pid_file_path"/' /etc/init.d/mariadb
sed -i "s/user='mysql'/user='winning'/"   /etc/init.d/mariadb
#sed -i '0,/mysqld_pid_file_path=/s/mysqld_pid_file_path=/mysqld_pid_file_path=mariad.pid/' /etc/init.d/mariadb
echo export PATH=/winning/winmid/mariadb/bin:/winning/winmid/mariadb/lib:\$PATH >> /etc/profile
source /etc/profile

chkconfig --add mariadb &>/dev/null
chkconfig mariadb on &>/dev/null
service mariadb start &>/dev/null
# 卸载前操作
%preun
service mariadb stop &>/dev/null
chkconfig mariadb off &>/dev/null
chkconfig --del mariadb &>/dev/null
rm -rf /etc/init.d/mariadb &>/dev/null
# 卸载后操作
%postun
userdel -r winning &>/dev/null
rm -fr /data/mariadb &>/dev/null
rm -fr /winning/winmid/mariadb &>/dev/null
rm -fr /etc/my.cnf
rm -fr /etc/my.cnf.d
systemctl daemon-reload
sed -i 's/export PATH=\/winning\/winmid\/mariadb\/bin\:\/winning\/winmid\/mariadb\/lib\:\$PATH//' /etc/profile
source /etc/profile

# 文件夹
%files
%defattr(-,root,root,-)
/winning/winmid/mariadb
/winning/winmid/mariadb/bin
/winning/winmid/mariadb/data
/winning/winmid/mariadb/include
/winning/winmid/mariadb/lib
/winning/winmid/mariadb/scripts
/winning/winmid/mariadb/share
/winning/winmid/mariadb/support-files
/winning/winmid/mariadb/README.md
#/winning/winmid/mariadb/docs
/winning/winmid/mariadb/man
%exclude /winning/winmid/mariadb/COPYING
%exclude /winning/winmid/mariadb/mysql-test
%exclude /winning/winmid/mariadb/sql-bench




%changelog
```

## 坑点

### 1.my.cnf

mariadb提供的源码文件与mysql提供的并不是一样的，在mariadb中是wsrep.cnf

```bash
# mysql
cp /winning/winmid/mariadb/support-files/my*.cnf /etc/my.cnf
# mariadb
cp /winning/winmid/mariadb/support-files/wsrep.cnf /etc/my.cnf
```

### 2.mysql.server

在mariadb中使用的如果替换了user=mysql，那么针对下面这一句也是需要指定用户，否则无法启动

```bash
# 原来
$bindir/mysqld_safe --datadir="$datadir" --pid-file="$mysqld_pid_file_path"
# 修改后
$bindir/mysqld_safe --datadir="$datadir" --user=winning --pid-file="$mysqld_pid_file_path"
```

### 3.权限

虽然在安装之前也做了文件夹变更，但是在%post还需要再做一次，安装的过程中产生的文件夹是执行安装用户的

```bash
%post
chown -R winning: /winning/winmid/mariadb
```

