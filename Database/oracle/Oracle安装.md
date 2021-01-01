# Oracle 11gR2安装

## 1、主机配置

```bash
#修改主机名
 sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME=c7-1810-oracledb/" /etc/sysconfig/network
# 设置主机名
 hostname c7-1810-oracledb
# 添加主机名与IP对应记录
 vi /etc/hosts
 192.168.31.200 c7-1810-oracledb
 # 关闭Selinux
  sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config 
  setenforce 0
  # 关闭防火墙
  systemctl stop firewalld
  systemctl disable firewalld
  # 安装依赖
  yum -y install binutils compat-libcap1 compat-libstdc++-33 gcc gcc-c++ glibc glibc-devel ksh libaio libaio-devel libgcc libstdc++ libstdc++-devel libXi libXtst make sysstat unixODBC unixODBC-devel
```

## 2、用户配置

```bash
groupadd -g 200 oinstall
groupadd -g 201 dba
useradd -u 440 -g oinstall -G dba oracle
passwd oracle
```

## 3、参数配置

```bash
# 修改内核参数
# vi/etc/sysctl.conf  #末尾添加如下
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 536870912
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
# 修改系统资源限制
# vi /etc/security/limits.conf #末尾添加如下
oracle  soft  nproc  2047
oracle  hard  nproc  16384
oracle  soft  nofile  1024
oracle  hard  nofile  65536
oracle soft core unlimited
oracle hard core unlimited
oracle soft memlock 50000000
oracle hard memlock 50000000
#  vi /etc/pam.d/login
session    required    pam_namespace.so  #下面添加一条pam_limits.so
session    required    pam_limits.so
# vi /etc/profile 追加如下内容
if [ $USER = "oracle" ]; then
      if [ $SHELL = "/bin/ksh" ];then
          ulimit -p 16384
          ulimit -n 65536
      else
          ulimit -u 16384 -n 65536
      fi
fi
```

## 4、安装目录设置

```bash
mkdir -p /data/oracle 
cd /data/oracle
mkdir app oradata
unzip -d /data/oracle/ linux.x64_11gR2_database_1of2.zip
unzip -d /data/oracle/ linux.x64_11gR2_database_2of2.zip
chown -R oracle:oinstall /data/oracle
chmod 775 -R /data/oracle
```

## 5、开始安装

### 5.1 配置环境变量

> 将ORACLE_HOME 设置为安装目录product下默认目录

```bash
# vim /etc/profile
#oracle
export ORACLE_HOME=/data/oracle/product/11.2.0/db_1
export ORACLE_SID=orcl
if [ $USER = "oracle" ]; then
      if [ $SHELL = "/bin/ksh" ];then
          ulimit -p 16384
          ulimit -n 65536
      else
          ulimit -u 16384 -n 65536
      fi
fi
```

### 5.2 修改Oracle用户环境变量

```bash
# vim /home/oracle/.bash_profile
export ORACLE_BASE=/data/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db_1
export ORACLE_SID=orcl
export ORACLE_TERM=xterm
export PATH=$ORACLE_HOME/bin:/usr/sbin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export NLS_LANG=AMERICAN_AMERICA.ZHS16GBK

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH
```

