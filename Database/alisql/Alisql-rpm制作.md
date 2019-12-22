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

在`rpmbuild/SPECS`目录下执行`rpmdev-newspec -o alisql.spec`，会在当前目录下生成名为`alisql.spec`的模板文件

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

## 7、spec 文件规范

​		能熟练掌握以上命令以及部分参数含义，管理日常的rpm软件包就不成问题了。然而随着Linux风靡全球，越来越多的开发者喜欢采用RPM格式来发布自己的软件包。那么RPM软件包是怎样制作的呢？对大多数Linux开发工程师来说是比较陌生的。

​		其实，制作RPM软件包并不是一件复杂的工作，其中的关键在于编写SPEC软件包描述文件。要想制作一个rpm软件包就必须写一个软件包描述文件（SPEC）。这个文件中包含了软件包的诸多信息，如软件包的名字、版本、类别、说明摘要、创建时要执行什么指令、安装时要执行什么操作、以及软件包所要包含的文件列表等等。

### 7.1 文件头

一般的spec文件头包含以下几个域：

1. Summary：用一句话概括该软件包尽量多的信息。
2. Name：软件包的名字，最终RPM软件包是用该名字与版本号，释出号及体系号来命名软件包的。
3. Version：软件版本号。仅当软件包比以前有较大改变时才增加版本号。
4. Release：软件包释出号。一般我们对该软件包做了一些小的补丁的时候就应该把释出号加1。
5. Vendor：软件开发者的名字。
6. Copyright：软件包所采用的版权规则。具体有：GPL（自由软件），BSD，MIT，Public Domain（公共域），Distributable（贡献），commercial（商业），Share（共享）等，一般的开发都写GPL。
7. Group：软件包所属类别，
   1. 具体类别有：

> Amusements/Games （娱乐/游戏）Amusements/Graphics（娱乐/图形）
>
> Applications/Archiving （应用/文档）Applications/Communications（应用/通讯
>
> Applications/Databases （应用/数据库）Applications/Editors （应用/编辑器）
>
> Applications/Emulators （应用/仿真器）Applications/Engineering （应用/工程）
>
> Applications/File （应用/文件）Applications/Internet （应用/因特网）
>
> Applications/Multimedia（应用/多媒体）Applications/Productivity （应用/产品）
>
> Applications/Publishing（应用/印刷）Applications/System（应用/系统）
>
> Applications/Text （应用/文本）Development/Debuggers （开发/调试器）
>
> Development/Languages （开发/语言）Development/Libraries （开发/函数库）
>
> Development/System （开发/系统）Development/Tools （开发/工具）
>
> Documentation （文档）System Environment/Base（系统环境/基础）
>
> System Environment/Daemons （系统环境/守护）System Environment/Kernel （系统环境/内核）
>
> System Environment/Libraries （系统环境/函数库）System Environment/Shells （系统环境/接口）
>
> User Interface/Desktops（用户界面/桌面）User Interface/X （用户界面/X窗口）
>
> User Interface/X Hardware Support （用户界面/X硬件支持）

 

8. Source：源程序软件包的名字。如 stardict-2.0.tar.gz。
9. %description：软件包详细说明，可写在多个行上。

### 7.2 %prep段

 这个段是预处理段，通常用来执行一些解开源程序包的命令，为下一步的编译安装作准备。%prep和下面的%build，%install段一样，除了可以执行RPM所定义的宏命令（以%开头）以外，还可以执行SHELL命令，命令可以有很多行，如我们常写的tar解包命令。

### 7.3 build段

本段是建立段，所要执行的命令为生成软件包服务，如make 命令。

### 7.4 %install段

本段是安装段，其中的命令在安装软件包时将执行，如make install命令。

### 7.5 %files段

本段是文件段，用于定义软件包所包含的文件，分为三类--说明文档（doc），配置文件（config）及执行程序，还可定义文件存取权限，拥有者及组别。

### 7.6 %changelog段 

本段是修改日志段。你可以将软件的每次修改记录到这里，保存到发布的软件包中，以便查询之用。每一个修改日志都有这样一种格式：第一行是：* 星期 月 日 年 修改人电子信箱。其中：星期、月份均用英文形式的前3个字母，用中文会报错。接下来的行写的是修改了什么地方，可写多行。一般以减号开始，便于后续的查阅。
