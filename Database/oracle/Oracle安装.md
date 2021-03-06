# Oracle 11gR2安装

## 1、环境配置

### 1.1 主机配置

```bash
#修改主机名
 sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=c7-1810-oracledb/" /etc/sysconfig/network
# 设置主机名
 hostname c7-1810-oracledb
# 添加主机名与IP对应记录
 vi /etc/hosts
 192.168.31.200 c7-1810-oracledb
# 修改OS系统标识
vi /etc/redhat-release
redhat-7
```

### 1.2 selinux和防火墙

```bash
 # 关闭Selinux
  sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config 
  setenforce 0
  # 关闭防火墙
  systemctl stop firewalld
  systemctl disable firewalld
```

### 1.3 安装依赖

```bash
# 依赖安装
yum install binutils-2.* compat-libstdc++-33* elfutils-libelf-0.* elfutils-libelf-devel* gcc-4.* gcc-c++-4.* glibc-2.* glibc-common-2.* glibc-devel-2.* glibc-headers-2.* ksh-2* libaio-0.* libaio-devel-0.* \
 libgcc-4.* libstdc++-4.* libstdc++-devel-4.* make-3.* sysstat.* unixODBC-2.* unixODBC-devel-2.* ksh*
# 依赖检查
rpm -qa binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers glibc-static kernel-headers \
pdksh libaio libaio-devel libgcc libgomp libstdc++ libstdc++-devel libstdc++-static make numactl-devel sysstat unixODBC unixODBC-devel 
```

### 1.4 修改内核参数

```bash
# vi /etc/sysctl.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.rp_filter = 1
fs.file-max = 6815744 #设置最大打开文件数
fs.aio-max-nr = 1048576
kernel.shmall = 2097152 #共享内存的总量，8G内存设置：2097152*4k/1024/1024
kernel.shmmax = 2147483648 #最大共享内存的段大小
kernel.shmmni = 4096 #整个系统共享内存端的最大数
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500 #可使用的IPv4端口范围
net.core.rmem_default = 262144
net.core.rmem_max= 4194304
net.core.wmem_default= 262144
net.core.wmem_max= 1048576
# sysctl -p 生效
```

### 1.5 对oracle用户设置限制，提高软件运行性能

```bash
# vi /etc/security/limits.conf 
oracle  soft  nproc  2047
oracle  hard  nproc  16384
oracle  soft  nofile  1024
oracle  hard  nofile  65536
oracle soft core unlimited
oracle hard core unlimited
oracle soft memlock 50000000
oracle hard memlock 50000000
```

### 1.6 配置登录

```bash
# vi /etc/pam.d/login
session    required    pam_limits.so
```

### 1.7 配置jdk

```bash
# vi /etc/profile
export JAVA_HOME=/usr/java/jdk1.8.0_202-amd64
export JRE_HOME=$JAVA_HOME/jre
export PATH=$JAVA_HOME/bin:$PATH
```

## 2、安装配置

### 2.1 用户配置

```bash
groupadd -g 200 oinstall
groupadd -g 201 dba
useradd -u 440 -g oinstall -G dba oracle
passwd oracle
```

### 2.2 安装目录设置

```bash
mkdir -p /data/oracle 
cd /data/oracle
mkdir oradata oraInventory recovery_data
unzip -d /data/oracle/ p13390677_112040_Linux-x86-64_1of7.zip
unzip -d /data/oracle/ p13390677_112040_Linux-x86-64_2of7.zip
chown -R oracle:oinstall /data/oracle
chmod 775 -R /data/oracle
```

### 2.3 修改Oracle用户环境变量

#### 2.3.1 图形化安装配置

```bash
export ORACLE_BASE=/data/oracle #oracle数据库安装目录
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1 #oracle数据库路径
export ORACLE_SID=orcl #oracle启动数据库实例名
export ORACLE_TERM=xterm #xterm窗口模式安装
export PATH=$ORACLE_HOME/bin:/usr/sbin:$PATH #添加系统环境变量
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib #添加系统环境变量
export LANG=C #防止安装过程出现乱码
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK  #设置Oracle客户端字符集，必须与Oracle安装时设置的字符集保持一致，如：ZHS16GBK，否则出现数据导入导出中文乱码问题
```

#### 2.3.2 静默安装配置

```bash
# vim /home/oracle/.bash_profile
export ORACLE_BASE=/data/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/dbhome_1
export PATH=$PATH:$ORACLE_HOME/bin
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib64:/usr/lib64:/usr/local/lib64:/usr/lib
export ORACLE_SID=orcl
export LANG=C
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH
```

## 3、图形化安装

### 3.1 安装过程

1.图形界面登陆oracle用户：

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092635753.png)

2.启动oralce安装，到/data/oracle/database/目录下，执行runInstaller

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092635754.png)

 3.去掉勾，懒得填，个人使用环境不需要自动接收Oracle的安全更新。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092635755.png)

4.下一步，只安装数据库软件，个人用不要那些玩意~~

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092635756.png)

5.选择单例安装，前面的所有配置均为单例安装。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678531.png)

6.添加语言

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678532.png)

7.默认安装版本企业版-Enterprise Edition --图没了。

8.确定数据软件的安装路径，自动读取前面[Oracle](https://www.linuxidc.com/topicnews.aspx?tid=12)环境变量中配置的值。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678533.png)

9.理论上要创建Database Operation（OSOPER）Group:oper ,个人用，懒得建，就使用dba用户组

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678534.png)

10.安装检查，按照提示信息一个一个解决。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678535.png)

swap空间不足解决 ：**（要求2.67G 实际2G）**

```bash
[root@localhost oracle]# free -m　　#查看当前虚拟内存
              total        used        free      shared  buff/cache   available
Mem:           1824        1369          93          10         361         250
Swap:          2048          20        2028
[root@localhost oracle]# dd if=/dev/zero of=/home/swap bs=1024 count=1024000　　#将当前swap空间由2048M 增加到 3048M 新增一个2014的swap文件
1024000+0 records in
1024000+0 records out
1048576000 bytes (1.0 GB) copied, 29.4051 s, 35.7 MB/s
[root@localhost oracle]# mkswap /home/swap
Setting up swapspace version 1, size = 1023996 KiB
no label, UUID=5e3d39d7-285e-4c74-b321-1e2b3ffabf83
[root@localhost oracle]# free -m
              total        used        free      shared  buff/cache   available
Mem:           1824        1275          95          10         454         342
Swap:          2048         141        1907
[root@localhost oracle]# swapon /home/swap　　#增加并启用虚拟内容
swapon: /home/swap: insecure permissions 0644, 0600 suggested.
[root@localhost oracle]# free -m　　#再次查看
              total        used        free      shared  buff/cache   available
Mem:           1824        1275          94          10         454         342
Swap:          3048         141        2907 
```

11.一个一个检查package，在准备阶段中漏掉的，此处再安装，有些系统报错是因为现有的包的版本比检测要高，最后忽略即可。**（点击Check_Again 多检查几次）**

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678536.png)

12.准备完毕，fuck “Finish”开始安装。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092678537.png)

13.安装过程是一个漫长的过程，中间有几次卡住，没有出现任何画面，屏幕中间有条小线，尝试多次，发现光标在该线上，右键点击Closed，不知道关闭了啥，又能继续安装了。先装吧，到时看安装日志再说。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092754791.png)

 14.提示安装成功。安装日志懒得看，再说。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092754792.png)

### **3.2 配置监听listener**

1.执行netca 报错

```bash
[Oracle@localhost ~]$ netca

Oracle Net Services Configuration:
#
# An unexpected error has been detected by HotSpot Virtual Machine:
#
#  SIGSEGV (0xb) at pc=0x00007f69a69fcb9d, pid=8033, tid=140092892297024
#
# Java VM: Java HotSpot(TM) 64-Bit Server VM (1.5.0_17-b03 mixed mode)
# Problematic frame:
# C  [libclntsh.so.11.1+0x62ab9d]  snlinGetAddrInfo+0x1b1
#
# An error report file with more information is saved as hs_err_pid8033.log
#
# If you would like to submit a bug report, please visit:
#   http://java.sun.com/webapps/bugreport/crash.jsp
#
/data/oracle/product/11.2.0/db_1/bin/netca: line 178:  8033 Aborted                 (core dumped) $JRE $JRE_OPTIONS -classpath $CLASSPATH oracle.net.ca.NetCA $*
[oracle@localhost ~]$  
```

错误原因：安装操作系统是默认主机名localhost造成错误

解决办法：

```bash
racle]# cat /etc/sysconfig/network
# Created by anaconda

[root@localhost oracle]# vi /etc/sysconfig/network　　#增加HOSTNAME
[root@localhost oracle]# cat /etc/sysconfig/network
# Created by anaconda
HOSTNAME=odb-sonny
[root@localhost oracle]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
[root@localhost oracle]# vi /etc/hosts　　#增加HOSTNAME
[root@localhost oracle]# cat /etc/hosts     
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 odb-sonny
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
[root@localhost oracle]# hostname odb-sonny　　#执行
[root@localhost oracle]#  
```

**最后注销当前oracle用户，重新登陆即可**！！这次发现打开配置界面正常，安装windows下面配置即可。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092754793.png)

### **3.3 创建Oracle数据实例Orcl**

执行dbca命令，启动oracle实例安装界面，剩下的与Windows上安装一样，不废话了：

注意：必须先创建监听，并且监听是启动中，否则报错。

![img](Oracle%E5%AE%89%E8%A3%85.assets/160423092754794.png)

### 3.4 问题处理

#### 3.4.1 安装oracle时，如何指定jdk 或者如何解决提示框显示不全

./runInstaller -jreLoc JRE_LOCATION

```bash
[oracle@localhost Desktop]$ ls -lrt /usr/bin/java
lrwxrwxrwx. 1 root root 22 Nov 27 02:54 /usr/bin/java -> /etc/alternatives/java
[oracle@localhost Desktop]$ ls -lrt /etc/alternatives/java
lrwxrwxrwx. 1 root root 70 Nov 27 02:54 /etc/alternatives/java -> /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.65-3.b17.el7.x86_64/jre/bin/java1234
```

JRE_LOCATION 使用这个地址 ./runInstaller -jreLoc /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.65-3.b17.el7.x86_64/jre

#### 3.4.2  INFO: make[1]: Leaving directory

> `/u01/app/oracle/product/11.2.0.3/sysman/lib’ INFO: make: [emdctl]
> Error 2

解决方法：

```bash
vi $ORACLE_HOME/sysman/lib/ins_emagent.mk1
搜索以下行：
$(MK_EMAGENT_NMECTL)
改变为：
$(MK_EMAGENT_NMECTL) -lnnz11
```

#### 3.4.3 ERROR: ORA-09925:

> Unable to create audit trail file Linux Error: 2:
>
> No such file or directory Additional information: 9925 ORA-01075: you
> are currently logged on

解决方案：

```bash
    [oracle@Allen adump]$ ps -ef |grep smon
    oracle    2479    1  0 02:52 ?        00:00:00 ora_smon_allen
    oracle  27854    1  0 08:43 ?        00:00:00 ora_smon_prod
    oracle  27946 27885  0 08:48 pts/6    00:00:00 grep smon
    [oracle@Allen adump]$ kill -9 2785412345
```

#### 3.4.4 ERROR:ORA-00845

> MEMORY_TARGET not supported on this system

```bash
    [root@aaaprod-db ~]# cat /etc/fstab | grep tmpfs
    tmpfs                  /dev/shm              tmpfs  defaults,size=8g      0 0
    [root@aaaprod-db ~]#
    [root@aaaprod-db ~]# mount -o remount,size=16G /dev/shm
    [root@aaaprod-db ~]#
    [root@aaaprod-db ~]# cat /etc/fstab | grep tmpfs
    tmpfs                  /dev/shm              tmpfs  defaults,size=8g      0 0
    [root@aaaprod-db ~]# vi /etc/fstab
    /dev/rootvg/LogVol02  /                      ext3  defaults      1 1
    /dev/rootvg/LogVol01  /tmp                  ext3  defaults      1 2
    /dev/rootvg/lvol0    /ebao                  ext3  defaults      1 2
    /dev/rootvg/lvol1    /backup                ext3  defaults      1 2
    LABEL=/boot            /boot                  ext3  defaults      1 2
    tmpfs                  /dev/shm              tmpfs  defaults,size=16g      0 0
    devpts                /dev/pts              devpts gid=5,mode=620 0 0
    sysfs                  /sys                  sysfs  defaults      0 0
    proc                  /proc                  proc  defaults      0 0
    /dev/rootvg/LogVol00  swap                  swap  defaults      0 0
    "/etc/fstab" 10L, 769C written
    [root@aaaprod-db ~]# df -h|grep shm
    tmpfs                16G    0  16G  0% /dev/shm
```

## 4、静默安装

[参考](https://blog.csdn.net/weixin_30877493/article/details/97643809)

### 4.1 配置文件修改

到达解压目录下，找到 response文件夹

```bash
cd database/response/
[root@c7-2009-oracledb response]# ll
total 108
-rwxr-xr-x 1 oracle oinstall 44533 Aug 27  2013 dbca.rsp
-rw-r--r-- 1 oracle oinstall 25324 Jan  2 15:45 db_install.rsp
-rwxr-xr-x 1 oracle oinstall  5871 Aug 27  2013 netca.rsp
```

#### 4.1.2 修改db_install.rsp文件

```bash
# 备份一下文件
cp -a db_install.rsp db_install.rsp.bak
# 创建目录
mkdir -p /home/oracle/response
cp db_install.rsp /home/oracle/response/
```

> 下面把主要修改的地方贴出来，具体详细文件

```bash
oracle.install.option=INSTALL_DB_SWONLY
ORACLE_HOSTNAME=DB_m2
UNIX_GROUP_NAME=oinstall
INVENTORY_LOCATION=/data/oracle/oraInventory
SELECTED_LANGUAGES=en,zh_CN
ORACLE_HOME=/datalv/app/oracle/product/11.2.0/dbhome_1
ORACLE_BASE=/datalv/app/oracle
oracle.install.db.InstallEdition=EE
oracle.install.db.DBA_GROUP=dba
oracle.install.db.OPER_GROUP=oinstall
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=/data/oracle/oradata
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=/data/oracle/recovery_data
DECLINE_SECURITY_UPDATES=true //一定要设为true
```

#### 4.1.3 登录oracle用户，执行安装

```bash
./runInstaller -silent -responseFile /home/oracle/response/db_install.rsp  -jreLoc /usr/java/jdk1.8.0_202-amd64/jre
```

#### 4.1.4 运行脚本

> As a root user, execute the following script(s):
>  	1. /data/oracle/oraInventory/orainstRoot.sh
>  	2. /data/oracle/product/11.2.0/dbhome_1/root.sh

#### 4.1.5 存在问题

> Exception String: Error in invoking target 'agent nmhs' of makefile '/data/oracle/product/11.2.0/dbhome_1/sysman/lib/ins_emagent.mk'. See '/data/oracle/oraInventory/logs/installActions2021-01-02_03-46-51PM.log' for details

```bash
vi $ORACLE_HOME/sysman/lib/ins_emagent.mk
# 搜索以下行：
$(MK_EMAGENT_NMECTL)
# 改变为：
$(MK_EMAGENT_NMECTL) -lnnz11
```

### 4.2 配置监听

```bash
# 复制响应文件模板netca.rsp 到指定位置
cp  netca.rsp /home/oracle/response/
# 执行netca 命令
netca -silent -responsefile /home/oracle/response/netca.rsp
Parsing command line arguments:
    Parameter "silent" = true
    Parameter "responsefile" = /home/oracle/response/netca.rsp
Done parsing command line arguments.
Oracle Net Services Configuration:
Profile configuration complete.
Oracle Net Listener Startup:
    Running Listener Control: 
      /data/oracle/product/11.2.0/dbhome_1/bin/lsnrctl start LISTENER
    Listener Control complete.
    Listener started successfully.
Listener configuration complete.
Oracle Net Services configuration successful. The exit code is 0
# 启动监听
lsnrctl start
LSNRCTL for Linux: Version 11.2.0.4.0 - Production on 02-JAN-2021 16:41:59
Copyright (c) 1991, 2013, Oracle.  All rights reserved.
TNS-01106: Listener using listener name LISTENER has already been started
# 检查监听启动状态
netstat -tlnp|grep 1521
Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp6       0      0 :::1521                 :::*                    LISTEN      56034/tnslsnr 
```

### 4.3 创建数据库

```bash
# 复制响应文件模板dbca.rsp 到指定位置
cp  dbca.rsp /home/oracle/response/
# 编辑 详见下一个文件
vi /home/oracle/response/dbca.rsp
# 执行命令
dbca -silent -responseFile /home/oracle/response/dbca.rsp
```

```bash
# 版本信息，不能更改
RESPONSEFILE_VERSION = "11.2.0"
# 操作类型
OPERATION_TYPE = "createDatabase"
# 全局数据库的名字=SID+主机域名
GDBNAME = "orcl"
# 对应的实例名字
SID = "orcl"
# //建库用的模板文件
TEMPLATENAME = "General_Purpose.dbc"
# 数据文件存放目录
DATAFILEDESTINATION = /data/oracle/oradata
# 恢复数据存放目录
RECOVERYAREADESTINATION=/data/oracle/recovery_data
# 字符集，重要!!! 建库后一般不能更改，所以建库前要确定清楚 （ZHS16GBK）
CHARACTERSET = "AL32UTF8"
# oracle内存5120MB
TOTALMEMORY = "4096"
```

### 4.4 db_install.rsp详解

```bash
####################################################################
## Copyright(c) Oracle Corporation1998,2008. All rights reserved. ##
## Specify values for the variables listedbelow to customize your installation. ##
## Each variable is associated with acomment. The comment ##
## can help to populate the variables withthe appropriate values. ##
## IMPORTANT NOTE: This file contains plaintext passwords and ##
## should be secured to have readpermission only by oracle user ##
## or db administrator who owns thisinstallation. ##
##对整个文件的说明，该文件包含参数说明，静默文件中密码信息的保密 ##
####################################################################
#------------------------------------------------------------------------------
# Do not change the following system generatedvalue. 
# 标注响应文件版本，这个版本必须和要#安装的数据库版本相同，安装检验无法通过,不能更改
#------------------------------------------------------------------------------
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v11_2_0
#------------------------------------------------------------------------------
# Specify the installation option.
# It can be one of the following:
# 1. INSTALL_DB_SWONLY
# 2. INSTALL_DB_AND_CONFIG
# 3. UPGRADE_DB
#选择安装类型：1.只装数据库软件 2.安装数据库软件并建库 3.升级数据库
#-------------------------------------------------------------------------------
oracle.install.option=INSTALL_DB_SWONLY
#-------------------------------------------------------------------------------
# Specify the hostname of the system as setduring the install. It can be used
# to force the installation to use analternative hostname rather than using the
# first hostname found on the system.(e.g., for systems with multiple hostnames
# and network interfaces)指定操作系统主机名，通过hostname命令获得
#-------------------------------------------------------------------------------
ORACLE_HOSTNAME=ora11gr2
#-------------------------------------------------------------------------------
# Specify the Unix group to be set for theinventory directory.
#指定oracle inventory目录的所有者，通常会是oinstall或者dba
#-------------------------------------------------------------------------------
UNIX_GROUP_NAME=oinstall
#-------------------------------------------------------------------------------
# Specify the location which holds theinventory files.
#指定产品清单oracle inventory目录的路径,如果是Win平台下可以省略
#-------------------------------------------------------------------------------
INVENTORY_LOCATION=/u01/app/oracle/oraInventory
#-------------------------------------------------------------------------------
# Specify the languages in which thecomponents will be installed.
# en : English ja : Japanese
# fr : French ko : Korean
# ar : Arabic es : Latin American Spanish
# bn : Bengali lv : Latvian
# pt_BR: Brazilian Portuguese lt : Lithuanian
# bg : Bulgarian ms : Malay
# fr_CA: Canadian French es_MX: Mexican Spanish
# ca : Catalan no : Norwegian
# hr : Croatian pl : Polish
# cs : Czech pt : Portuguese
# da : Danish ro : Romanian
# nl : Dutch ru : Russian
# ar_EG: Egyptian zh_CN: Simplified Chinese
# en_GB: English (Great Britain) sk :Slovak
# et : Estonian sl : Slovenian
# fi : Finnish es_ES: Spanish
# de : German sv : Swedish
# el : Greek th : Thai
# iw : Hebrew zh_TW:Traditional Chinese
# hu : Hungarian tr : Turkish
# is : Icelandic uk : Ukrainian
# in : Indonesian vi :Vietnamese
# it : Italian
# Example : SELECTED_LANGUAGES=en,fr,ja
#指定数据库语言，可以选择多个，用逗号隔开。选择en, zh_CN(英文和简体中文)
#------------------------------------------------------------------------------
SELECTED_LANGUAGES=en,zh_CN
#------------------------------------------------------------------------------
# Specify the complete path of the OracleHome.设置ORALCE_HOME的路径
#------------------------------------------------------------------------------
ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
#------------------------------------------------------------------------------
# Specify the complete path of the OracleBase. 设置ORALCE_BASE的路径
#------------------------------------------------------------------------------
ORACLE_BASE=/u01/app/oracle
#------------------------------------------------------------------------------
# Specify the installation edition of thecomponent.
# The value should contain only one ofthese choices.
# EE : EnterpriseEdition
# SE : Standard Edition
# SEONE Standard Edition One
# PE : Personal Edition (WINDOWS ONLY)
#选择Oracle安装数据库软件的版本（企业版，标准版，标准版1），不同的版本功能不同
#详细的版本区别参考附录D
#------------------------------------------------------------------------------
oracle.install.db.InstallEdition=EE
#------------------------------------------------------------------------------
# This variable is used to enable ordisable custom install.
# true : Components mentioned as part of 'customComponents' property
#are considered for install.
# false : Value for 'customComponents' isnot considered.
#是否自定义Oracle的组件，如果选择false，则会使用默认的组件
#如果选择true否则需要自己在下面一条参数将要安装的组件一一列出。
#安装相应版权后会安装所有的组件，后期如果缺乏某个组件，再次安装会非常的麻烦。
#------------------------------------------------------------------------------
oracle.install.db.isCustomInstall=true
#------------------------------------------------------------------------------
# This variable is considered only if'IsCustomInstall' is set to true.
# Description: List of Enterprise EditionOptions you would like to install.
# The following choices areavailable. You may specify any
# combination of thesechoices. The components you chooseshould
# be specified in the form"internal-component-name:version"
# Below is a list of components youmay specify to install.
# oracle.rdbms.partitioning:11.2.0.1.0- Oracle Partitioning
# oracle.rdbms.dm:11.2.0.1.0- Oracle Data Mining
# oracle.rdbms.dv:11.2.0.1.0- Oracle Database Vault
# oracle.rdbms.lbac:11.2.0.1.0- Oracle Label Security
# oracle.rdbms.rat:11.2.0.1.0- Oracle Real Application Testing
# oracle.oraolap:11.2.0.1.0- Oracle OLAP
# oracle.install.db.isCustomInstall=true的话必须手工选择需要安装组件的话
#------------------------------------------------------------------------------
oracle.install.db.customComponents=oracle.server:11.2.0.1.0,oracle.sysman.ccr:10.2.7.0.0,oracle.xdk:11.2.0.1.0,oracle.rdbms.oci:11.2.0.1.0,oracle.network:11.2.0.1.0,oracle.network.listener:11.2.0.1.0,oracle.rdbms:11.2.0.1.0,oracle.options:11.2.0.1.0,oracle.rdbms.partitioning:11.2.0.1.0,oracle.oraolap:11.2.0.1.0,oracle.rdbms.dm:11.2.0.1.0,oracle.rdbms.dv:11.2.0.1.0,orcle.rdbms.lbac:11.2.0.1.0,oracle.rdbms.rat:11.2.0.1.0
###############################################################################
# PRIVILEGED OPERATING SYSTEM GROUPS
# Provide values for the OS groups to whichOSDBA and OSOPER privileges #
# needs to be granted. If the install isbeing performed as a member of the #
# group "dba", then that will beused unless specified otherwise below. #
#指定拥有OSDBA、OSOPER权限的用户组，通常会是dba组
###############################################################################
#------------------------------------------------------------------------------
# The DBA_GROUP is the OS group which is tobe granted OSDBA privileges.
#------------------------------------------------------------------------------
oracle.install.db.DBA_GROUP=dba
#------------------------------------------------------------------------------
# The OPER_GROUP is the OS group which isto be granted OSOPER privileges.
#------------------------------------------------------------------------------
oracle.install.db.OPER_GROUP=oinstall
#------------------------------------------------------------------------------
# Specify the cluster node names selectedduring the installation.
#如果是RAC的安装，在这里指定所有的节点
#------------------------------------------------------------------------------
oracle.install.db.CLUSTER_NODES=
#------------------------------------------------------------------------------
# Specify the type of database to create.
# It can be one of the following:
# - GENERAL_PURPOSE/TRANSACTION_PROCESSING
# - DATA_WAREHOUSE
#选择数据库的用途，一般用途/事物处理，数据仓库
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
#------------------------------------------------------------------------------
# Specify the Starter Database GlobalDatabase Name. 指定GlobalName
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.globalDBName=ora11g
#------------------------------------------------------------------------------
# Specify the Starter Database SID.指定SID
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.SID=ora11g
#------------------------------------------------------------------------------
# Specify the Starter Database characterset.
# It can be one of the following:
# AL32UTF8, WE8ISO8859P15, WE8MSWIN1252,EE8ISO8859P2,
# EE8MSWIN1250, NE8ISO8859P10,NEE8ISO8859P4, BLT8MSWIN1257,
# BLT8ISO8859P13, CL8ISO8859P5,CL8MSWIN1251, AR8ISO8859P6,
# AR8MSWIN1256, EL8ISO8859P7, EL8MSWIN1253,IW8ISO8859P8,
# IW8MSWIN1255, JA16EUC, JA16EUCTILDE,JA16SJIS, JA16SJISTILDE,
# KO16MSWIN949, ZHS16GBK, TH8TISASCII,ZHT32EUC, ZHT16MSWIN950,
# ZHT16HKSCS, WE8ISO8859P9, TR8MSWIN1254,VN8MSWIN1258
#选择字符集。不正确的字符集会给数据显示和存储带来麻烦无数。
#通常中文选择的有ZHS16GBK简体中文库，建议选择unicode的AL32UTF8国际字符集
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.characterSet=AL32UTF8
#------------------------------------------------------------------------------
# This variable should be set to true ifAutomatic Memory Management
# in Database is desired.
# If Automatic Memory Management is notdesired, and memory allocation
# is to be done manually, then set it tofalse.
#11g的新特性自动内存管理，也就是SGA_TARGET和PAG_AGGREGATE_TARGET都#不用设置了，Oracle会自动调配两部分大小。
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.memoryOption=true
#------------------------------------------------------------------------------
# Specify the total memory allocation forthe database. Value(in MB) should be
# at least 256 MB, and should not exceedthe total physical memory available on the system.
# Example:oracle.install.db.config.starterdb.memoryLimit=512
#指定Oracle自动管理内存的大小，最小是256MB
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.memoryLimit=
#------------------------------------------------------------------------------
# This variable controls whether to loadExample Schemas onto the starter
# database or not.是否载入模板示例
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.installExampleSchemas=false
#------------------------------------------------------------------------------
# This variable includes enabling auditsettings, configuring password profiles
# and revoking some grants to public. Thesesettings are provided by default.
# These settings may also be disabled. 是否启用安全设置
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.enableSecuritySettings=true
###############################################################################
# Passwords can be supplied for thefollowing four schemas in the #
# starter database: #
# SYS #
# SYSTEM #
# SYSMAN (used by Enterprise Manager) #
# DBSNMP (used by Enterprise Manager) #
# Same password can be used for allaccounts (not recommended) #
# or different passwords for each accountcan be provided (recommended) #
#设置数据库用户密码
###############################################################################
#------------------------------------------------------------------------------
# This variable holds the password that isto be used for all schemas in the
# starter database.
#设定所有数据库用户使用同一个密码，其它数据库用户就不用单独设置了。
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.password.ALL=oracle
#-------------------------------------------------------------------------------
# Specify the SYS password for the starterdatabase.
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.password.SYS=
#-------------------------------------------------------------------------------
# Specify the SYSTEM password for thestarter database.
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.password.SYSTEM=
#-------------------------------------------------------------------------------
# Specify the SYSMAN password for thestarter database.
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.password.SYSMAN=
#-------------------------------------------------------------------------------
# Specify the DBSNMP password for thestarter database.
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.password.DBSNMP=
#-------------------------------------------------------------------------------
# Specify the management option to beselected for the starter database.
# It can be one of the following:
# 1. GRID_CONTROL
# 2. DB_CONTROL
#数据库本地管理工具DB_CONTROL，远程集中管理工具GRID_CONTROL
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.control=DB_CONTROL
#-------------------------------------------------------------------------------
# Specify the Management Service to use ifGrid Control is selected to manage
# the database. GRID_CONTROL需要设定grid control的远程路径URL
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=
#-------------------------------------------------------------------------------
# This variable indicates whether toreceive email notification for critical
# alerts when using DB control.是否启用Email通知, 启用后会将告警等信息发送到指定邮箱
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.dbcontrol.enableEmailNotification=false
#-------------------------------------------------------------------------------
# Specify the email address to which thenotifications are to be sent.设置通知EMAIL地址
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.dbcontrol.emailAddress=
#-------------------------------------------------------------------------------
# Specify the SMTP server used for emailnotifications.设置EMAIL邮件服务器
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.dbcontrol.SMTPServer=
###############################################################################
# SPECIFY BACKUP AND RECOVERY OPTIONS #
# Out-of-box backup and recovery optionsfor the database can be mentioned #
# using the entries below. #
#安全及恢复设置（默认值即可）out-of-box（out-of-box experience）缩写为OOBE
#产品给用产品给用户良好第一印象和使用感受
###############################################################################
#------------------------------------------------------------------------------
# This variable is to be set to false ifautomated backup is not required. Else
# this can be set to true.设置自动备份，和OUI里的自动备份一样。
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.automatedBackup.enable=false
#------------------------------------------------------------------------------
# Regardless of the type of storage that ischosen for backup and recovery, if
# automated backups are enabled, a job willbe scheduled to run daily at
# 2:00 AM to backup the database. This jobwill run as the operating system
# user that is specified in this variable.自动备份会启动一个job，指定启动JOB的系统用户ID
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.automatedBackup.osuid=
#-------------------------------------------------------------------------------
# Regardless of the type of storage that ischosen for backup and recovery, if
# automated backups are enabled, a job willbe scheduled to run daily at
# 2:00 AM to backup the database. This jobwill run as the operating system user
# specified by the above entry. Thefollowing entry stores the password for the
# above operating system user.自动备份会开启一个job，需要指定OSUser的密码
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.automatedBackup.ospwd=
#-------------------------------------------------------------------------------
# Specify the type of storage to use forthe database.
# It can be one of the following:
# - FILE_SYSTEM_STORAGE
# - ASM_STORAGE
#自动备份，要求指定使用的文件系统存放数据库文件还是ASM
#------------------------------------------------------------------------------
oracle.install.db.config.starterdb.storageType=
#-------------------------------------------------------------------------------
# Specify the database file location whichis a directory for datafiles, control
# files, redo logs.
# Applicable only when oracle.install.db.config.starterdb.storage=FILE_SYSTEM
#使用文件系统存放数据库文件才需要指定数据文件、控制文件、Redo log的存放目录
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=
#-------------------------------------------------------------------------------
# Specify the backup and recovery location.
# Applicable only whenoracle.install.db.config.starterdb.storage=FILE_SYSTEM
#使用文件系统存放数据库文件才需要指定备份恢复目录
#-------------------------------------------------------------------------------
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=
#-------------------------------------------------------------------------------
# Specify the existing ASM disk groups tobe used for storage.
# Applicable only whenoracle.install.db.config.starterdb.storage=ASM
#使用ASM存放数据库文件才需要指定存放的磁盘组
#-------------------------------------------------------------------------------
oracle.install.db.config.asm.diskGroup=
#-------------------------------------------------------------------------------
# Specify the password for ASMSNMP user ofthe ASM instance.
# Applicable only whenoracle.install.db.config.starterdb.storage=ASM_SYSTEM
#使用ASM存放数据库文件才需要指定ASM实例密码
#-------------------------------------------------------------------------------
oracle.install.db.config.asm.ASMSNMPPassword=
#------------------------------------------------------------------------------
# Specify the My Oracle Support AccountUsername.
# Example :MYORACLESUPPORT_USERNAME=metalink
#指定metalink账户用户名
#------------------------------------------------------------------------------
MYORACLESUPPORT_USERNAME=
#------------------------------------------------------------------------------
# Specify the My Oracle Support AccountUsername password.
# Example : MYORACLESUPPORT_PASSWORD=password
# 指定metalink账户密码
#------------------------------------------------------------------------------
MYORACLESUPPORT_PASSWORD=
#------------------------------------------------------------------------------
# Specify whether to enable the user to setthe password for
# My Oracle Support credentials. The valuecan be either true or false.
# If left blank it will be assumed to befalse.
# Example : SECURITY_UPDATES_VIA_MYORACLESUPPORT=true
# 用户是否可以设置metalink密码
#------------------------------------------------------------------------------
SECURITY_UPDATES_VIA_MYORACLESUPPORT=
#------------------------------------------------------------------------------
# Specify whether user wants to give anyproxy details for connection.
# The value can be either true or false. Ifleft blank it will be assumed to be false.
# Example : DECLINE_SECURITY_UPDATES=false
# False表示不需要设置安全更新，注意，在11.2的静默安装中疑似有一个BUG
# Response File中必须指定为true，否则会提示错误,不管是否正确填写了邮件地址
#------------------------------------------------------------------------------
DECLINE_SECURITY_UPDATES=true
#------------------------------------------------------------------------------
# Specify the Proxy server name. Lengthshould be greater than zero.
#代理服务器名
# Example : PROXY_HOST=proxy.domain.com
#------------------------------------------------------------------------------
PROXY_HOST=
#------------------------------------------------------------------------------
# Specify the proxy port number. Should beNumeric and atleast 2 chars.
#代理服务器端口
# Example : PROXY_PORT=25
#------------------------------------------------------------------------------
PROXY_PORT=
#------------------------------------------------------------------------------
# Specify the proxy user name. LeavePROXY_USER and PROXY_PWD
# blank if your proxy server requires noauthentication.
#代理服务器用户名
# Example : PROXY_USER=username
#------------------------------------------------------------------------------
PROXY_USER=
#------------------------------------------------------------------------------
# Specify the proxy password. LeavePROXY_USER and PROXY_PWD
# blank if your proxy server requires noauthentication.
#代理服务器密码
# Example : PROXY_PWD=password
#------------------------------------------------------------------------------
PROXY_PWD=
```

### 4.5 database already mounted

> ORA-01503: CREATE CONTROLFILE failed
> ORA-01158: database already mounted

oracle 的概念跟别的数据库不同，oracle一台机器上就只有一个数据库，是通过用户(schema)来区分不同业务的。

```bash
cd $ORACLE_HOME/dbs
# 将包含新建库名的文件全部删除
# 比如我的是win60pdb1
[oracle@c7-oracle-11gr2 dbs]$ ll                   
total 60
-rw-rw---- 1 oracle oinstall 1544 Jan  3 01:50 hc_orcl.dat
-rw-rw---- 1 oracle oinstall 1544 Jan  3 01:50 hc_win60.dat
-rw-rw---- 1 oracle oinstall 1544 Jan  3 01:32 hc_win60pdb.dat
-rw-rw---- 1 oracle oinstall 1544 Jan  3 01:52 hc_win60pdb1.dat
-rw-r--r-- 1 oracle oinstall 2851 May 15  2009 init.ora
-rw-r--r-- 1 oracle oinstall 2866 Jan  3 02:02 initwin60pdb1.ora
-rw-r----- 1 oracle oinstall   24 Jan  3 01:10 lkORCL
-rw-r----- 1 oracle oinstall   24 Jan  3 01:13 lkWIN60
-rw-r----- 1 oracle oinstall   24 Jan  3 01:30 lkWIN60PDB
-rw-r----- 1 oracle oinstall 1536 Jan  3 01:11 orapworcl
-rw-r----- 1 oracle oinstall 1536 Jan  3 01:14 orapwwin60
-rw-r----- 1 oracle oinstall 1536 Jan  3 01:31 orapwwin60pdb
-rw-r----- 1 oracle oinstall 2560 Jan  3 01:51 spfileorcl.ora
-rw-r----- 1 oracle oinstall 2560 Jan  3 01:51 spfilewin60.ora
-rw-r----- 1 oracle oinstall 3584 Jan  3 01:32 spfilewin60pdb.ora
# 执行删除
[oracle@c7-oracle-11gr2 dbs]$ rm -rf spfilewin60pdb.ora 
[oracle@c7-oracle-11gr2 dbs]$ rm -rf hc_win60pdb*
[oracle@c7-oracle-11gr2 dbs]$ rm -rf lkWIN60PDB
[oracle@c7-oracle-11gr2 dbs]$ rm -rf orapwwin60pdb
# dbca 重新创建win60pdb1
[oracle@c7-oracle-11gr2 dbs]$ dbca -silent -responseFile /home/oracle/response/win60pdb1.dbca.rsp
```

