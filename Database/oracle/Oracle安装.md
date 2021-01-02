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
./runInstaller-silent -responseFile /home/oracle/response/db_install.rsp
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
# 编辑
vi /home/oracle/response/dbca.rsp
```

