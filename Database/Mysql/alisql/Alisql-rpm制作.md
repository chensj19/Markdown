# ALiSQL RPM制作

环境：CentOS 7.6.1810

软件：rpmbuild

源码包：[AliSQL 5.6.32](https://github.com/alibaba/AliSQL/releases/tag/AliSQL-5.6.32-9)

## 1、源码包准备

```bash
wget https://github.com/alibaba/AliSQL/archive/AliSQL-5.6.32-9.tar.gz
tar zxvf AliSQL-5.6.32-9.tar.gz
mv AliSQL-AliSQL-5.6.32-9 alisql-5.6.32
tar czvf alisql-5.6.32.tar.gz alisql-5.6.32
```

## 2、安装需要软件

```bash
yum install rpmbuild -y
yum install rpm* rpm-build rpmdev* –y
# 生成制作rpm的目录结构
rpmdev-setuptree
# 查看目录结构
tree rpmbuild/
```

## 3、移动源码包数据到`SOURCE`目录

```bash
mv alisql-5.6.32.tar.gz /root/rpmbuild/SOURCE
```

## 4、编写配置文件

在`rpmbuild/SPECS`目录下执行`rpmdev-newspec -o alisql.spec`，会在当前目录下生成名为`al模板文件

```bash
rpmdev-newspec -o alisql.spec
```

根据修改alisql.spec文件，修改后的内容如下

```bash
Name:           alisql
Version:        5.6.32
Release:        1%{?dist}
Summary:        alisql

Group:          Applications/Databases
License:        GPL
URL:            https://github.com/alibaba/AliSQL
Source0:        %{name}-%{version}.tar.gz
BuildRequires:  gcc gcc-c++
Requires:       ncurses-devel bison perl autoconf

%define MYSQL_USER mysql
%define MYSQL_GROUP mysql


%description    
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.


%prep
%setup -q
#useradd mysql
mkdir -p /usr/local/mysql
mkdir -p /data/mysqldb

%build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8   -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DMYSQL_DATADIR=/data/mysqldb -DMYSQL_TCP_PORT=3306 -DENABLE_DOWNLOADS=1

make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -name '*.la' -exec rm -f {} ';'

%pre
id mysql  &>/dev/null||useradd -m -s /bin/bash mysql &>/dev/null
mkdir -p /data/mysqldb
chown -R mysql: /data/mysqldb

%clean
rm -rf $RPM_BUILD_ROOT


%post 
/usr/local/mysql/scripts/mysql_install_db  --basedir=/usr/local/mysql --user=mysql  --datadir=/data/mysqldb &>/dev/null
cp -f /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf 
sed -i 's/^# basedir.*/basedir=\/usr\/local\/mysql/g' /etc/my.cnf
sed -i 's/^# datadir.*/datadir=\/data\/mysqldb/g' /etc/my.cnf
sed -i 's/^# socket.*/socket= \/tmp\/mysql.sock/g' /etc/my.cnf
cp -f /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
echo export PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH >> /etc/profile
source /etc/profile
chkconfig --add mysqld &>/dev/null
chkconfig mysqld on &>/dev/null


%preun
chkconfig --del mysqld &>/dev/null
rm -rf /etc/init.d/mysqld &>/dev/null

%postun 
userdel -r mysql &>/dev/null
rm -fr /data/mysqldb &>/dev/null
rm -fr /usr/local/mysql &>/dev/null

%files
%defattr(-,mysql,mysql,-)
/usr/local/mysql/bin
/usr/local/mysql/data
/usr/local/mysql/include
/usr/local/mysql/lib
/usr/local/mysql/scripts
/usr/local/mysql/share
/usr/local/mysql/support-files
/usr/local/mysql/README
/usr/local/mysql/docs
/usr/local/mysql/man
%exclude /usr/local/mysql/COPYING
%exclude /usr/local/mysql/mysql-test 
%exclude /usr/local/mysql/sql-bench


%changelog
```

自定义安装alisql.spec

```bash
Name:           alisql
Version:        5.6.32
Release:        1%{?dist}
Summary:        alisql

Group:          Applications/Databases
License:        GPL
URL:            https://github.com/alibaba/AliSQL
Source0:        %{name}-%{version}.tar.gz
BuildRequires:  gcc gcc-c++
Requires:       ncurses-devel bison perl autoconf

%define MYSQL_USER mysql
%define MYSQL_GROUP mysql

%description
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.


%prep
%setup -q
#useradd mysql
mkdir -p /winning/winmid/mysql
mkdir -p /data/mysqldb

%build
cmake -DCMAKE_INSTALL_PREFIX=/winning/winmid/mysql -DMYSQL_UNIX_ADDR=/winning/winmid/mysql/logs/mysql.sock -DDEFAULT_CHARSET=utf8   -DDEFAULT_COLLATION=utf8_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DMYSQL_DATADIR=/data/mysqldb -DMYSQL_TCP_PORT=3306 -DENABLE_DOWNLOADS=1

make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
find $RPM_BUILD_ROOT -name '*.la' -exec rm -f {} ';'

%pre
id mysql  &>/dev/null||useradd -m -s /bin/bash mysql &>/dev/null
mkdir -p /data/mysqldb
chown -R mysql: /data/mysqldb
#chown -R mysql: /winning/winmid/mysql

%clean
rm -rf $RPM_BUILD_ROOT

%post
/winning/winmid/mysql/scripts/mysql_install_db  --basedir=/winning/winmid/mysql --user=mysql  --datadir=/data/mysqldb &>/dev/null
cp -f /winning/winmid/mysql/support-files/my-default.cnf /etc/my.cnf
sed -i 's/^# basedir.*/basedir=\/winning\/winmid\/mysql/g' /etc/my.cnf
sed -i 's/^# datadir.*/datadir=\/data\/mysqldb/g' /etc/my.cnf
sed -i 's/^# socket.*/socket= \/winning\/winmid\/mysql\/logs\/mysql.sock/g' /etc/my.cnf
cp -f /winning/winmid/mysql/support-files/mysql.server  /etc/init.d/mysqld
echo export PATH=/winning/winmid/mysql/bin:/winning/winmid/mysql/lib:$PATH >> /etc/profile
source /etc/profile
chkconfig --add mysqld &>/dev/null
chkconfig mysqld on &>/dev/null

%preun
chkconfig --del mysqld &>/dev/null
rm -rf /etc/init.d/mysqld &>/dev/null

%postun
userdel -r mysql &>/dev/null
rm -fr /data/mysqldb &>/dev/null
rm -fr /winning/winmid/mysql &>/dev/null
echo 'log-error=/winning/winmid/mysql/logs/error.log' >>  /etc/my.cnf
echo 'slow-query-log=1' >>  /etc/my.cnf
echo 'slow-query-log-file=/winning/winmid/mysql/logs/slow.log' >>  /etc/my.cnf
echo 'long_query_time=0.2' >>  /etc/my.cnf
echo 'log-bin=/winning/winmid/mysql/logs/bin.log' >>  /etc/my.cnf
echo 'relay-log=/winning/winmid/mysql/logs/relay.log' >>  /etc/my.cnf
echo 'character-set-server=utf8' >>  /etc/my.cnf
echo 'collation-server=utf8_general_ci' >>  /etc/my.cnf
echo 'default-character-set=utf8' >>  /etc/my.cnf
echo '[client]' >>  /etc/my.cnf
echo 'port=3306' >>  /etc/my.cnf
echo 'socket=/winning/winmid/mysql/logs/mysql.sock' >>  /etc/my.cnf
echo 'default-character-set=utf8' >>  /etc/my.cnf


%files
%defattr(-,mysql,mysql,-)
/winning/winmid/mysql/bin
/winning/winmid/mysql/data
/winning/winmid/mysql/include
/winning/winmid/mysql/lib
/winning/winmid/mysql/scripts
/winning/winmid/mysql/share
/winning/winmid/mysql/support-files
/winning/winmid/mysql/README
/winning/winmid/mysql/docs
/winning/winmid/mysql/man
%exclude /winning/winmid/mysql/COPYING
%exclude /winning/winmid/mysql/mysql-test
%exclude /winning/winmid/mysql/sql-bench

%changelog

```

## 5、安装打包编译需要的软件

### 5.1 安装编译所需要的软件

```bash
yum install gcc gcc-c++ ncurses-devel perl autoconf -y
```

### 5.2 安装cmake

```bash
yum install cmake -y
```

### 5.3 安装bison

```bash
yum install bison -y
```

## 6、制作

```bash
rpmbuild -bb /root/rpmbuild/SPECS/alisql.spec
```

等待软件打包成功，此时会在rpmbuild/RPMS/x86_64文件夹下生成rpm软件包。
