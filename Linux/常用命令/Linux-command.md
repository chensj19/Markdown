# Linux 常用命令

## 1. 常用命令

### 1.1 解压命令

* `tar.gz` 
  
  * `tar zxvf  ***.tar.gz`
* `tar.xz`
  
  * ` tar xvJf  ***.tar.xz`
* `zip`
  * 压缩命令
    * `zip -r xxx.zip ./*`
  * 解压命令
    * `unzip filename.zip`

* **tar压缩**

  * `tar –cvf jpg.tar *.jpg` 

    将目录里所有jpg文件打包成tar.jpg

  * `tar –czf jpg.tar.gz *.jpg`   

    将目录里所有jpg文件打包成jpg.tar后，并且将其用gzip压缩，生成一个gzip压缩过的包，命名为jpg.tar.gz

  * `tar –cjf jpg.tar.bz2 *.jpg` 

    将目录里所有jpg文件打包成jpg.tar后，并且将其用bzip2压缩，生成一个bzip2压缩过的包，命名为jpg.tar.bz2

  * `tar –cZf jpg.tar.Z *.jpg ` 

     将目录里所有jpg文件打包成jpg.tar后，并且将其用compress压缩，生成一个umcompress压缩过的包，命名为jpg.tar.Z

  * `rar a jpg.rar *.jpg` 

    rar格式的压缩，需要先下载rar for [Linux](http://lib.csdn.net/base/linux)

  * `zip jpg.zip *.jpg` 

    zip格式的压缩，需要先下载zip for [linux](http://lib.csdn.net/base/linux)
    
  * `tar zxvf h2.tar.gz * --exclude=backup`

     打包去除指定目录

* **tar解压**

  * `tar –xvf file.tar `

    解压 tar包

  * `tar -xzvf file.tar.gz` 

    解压tar.gz

  * `tar -xjvf file.tar.bz2`   

    解压 tar.bz2

  * `tar –xZvf file.tar.Z `  

    解压tar.Z

  * `unrar e file.rar` 

    解压rar

  * `unzip file.zip` 

    解压zip  

### 1.2 查询与卸载

* 查询
  * ` rpm -qa | grep jdk` 查询JDK
* 卸载
  * `rpm -e --nodeps ` 加上上面查出来的结果

### 1.3 安装

* deb
  * sudo dpkg -i package deb

### 1.4 拷贝 scp

scp是secure copy的简写，用于在Linux下进行远程拷贝文件的命令，和它类似的命令有cp，不过cp只是在本机进行拷贝不能跨服务器，而且scp传输是加密的。可能会稍微影响一下速度。当你服务器硬盘变为只读 read only system时，用scp可以帮你把文件移出来。另外，scp还非常不占资源，不会提高多少系统负荷，在这一点上，rsync就远远不及它了。虽然 rsync比scp会快一点，但当小文件众多的情况下，rsync会导致硬盘I/O非常高，而scp基本不影响系统正常使用。

#### **1.4.1．命令格式**

scp [参数] [原路径] [目标路径]

#### **1.4.2．命令功能**

scp是 secure copy的缩写, scp是linux系统下基于ssh登陆进行安全的远程文件拷贝命令。linux的scp命令可以在linux服务器之间复制文件和目录。

#### **1.4.3．命令参数**

* -1  强制scp命令使用协议ssh1 
* -2  强制scp命令使用协议ssh2 
* -4  强制scp命令只使用IPv4寻址 
* -6  强制scp命令只使用IPv6寻址 
* -B  使用批处理模式（传输过程中不询问传输口令或短语） 
* -C  允许压缩。（将-C标志传递给ssh，从而打开压缩功能） 
* -p 保留原文件的修改时间，访问时间和访问权限。 
* -q  不显示传输进度条。 
* -r  递归复制整个目录。 
* -v 详细方式显示输出。scp和ssh(1)会显示出整个过程的调试信息。这些信息用于调试连接，验证和配置问题。  
* -c cipher  以cipher将数据传输进行加密，这个选项将直接传递给ssh。  
* -F ssh_config  指定一个替代的ssh配置文件，此参数直接传递给ssh。 
* -i identity_file  从指定文件中读取传输时使用的密钥文件，此参数直接传递给ssh。   
* -l limit  限定用户所能使用的带宽，以Kbit/s为单位。    
* -o ssh_option  如果习惯于使用ssh_config(5)中的参数传递方式，  
* -P port  注意是大写的P, port是指定数据传输用到的端口号  
* -S program  指定加密传输时所使用的程序。此程序必须能够理解ssh(1)的选项。

#### **1.4.4．使用实例**

scp命令的实际应用概述

##### **1.4.4.1 从本地服务器复制到远程服务器：**

1. 复制文件： 

   **命令格式** 
```bash
scp local_file remote_username@remote_ip:remote_folder 
```
   或者 
```bash
scp local_file remote_username@remote_ip:remote_file 
```
   或者 
```bash
scp local_file remote_ip:remote_folder 
```
   或者 
```bash
scp local_file remote_ip:remote_file 
```
   第1,2个指定了用户名，命令执行后需要输入用户密码，第1个仅指定了远程的目录，文件名字不变，第2个指定了文件名 

   第3,4个没有指定用户名，命令执行后需要输入用户名和密码，第3个仅指定了远程的目录，文件名字不变，第4个指定了文件名  

2. 复制目录： 

   **命令格式** 
```bash
scp -r local_folder remote_username@remote_ip:remote_folder 
```
   或者 
```bash
scp -r local_folder remote_ip:remote_folder 
```
   第1个指定了用户名，命令执行后需要输入用户密码； 

   第2个没有指定用户名，命令执行后需要输入用户名和密码；

##### **1.4.4.2 从远程服务器复制到本地服务器：**

从远程复制到本地的scp命令与上面的命令雷同，只要将从本地复制到远程的命令后面2个参数互换顺序就行了。

**实例1：从远处复制文件到本地目录**

**命令：**
```bash
scp root@192.168.120.204:/opt/soft/nginx-0.5.38.tar.gz /opt/soft/
```


**实例2：从远处复制到本地**

**命令：**
```bash
scp -r root@192.168.120.204:/opt/soft/mongodb /opt/soft/
```


**实例3：上传本地文件到远程机器指定目录**

**命令：**
```bash
scp /opt/soft/nginx-0.5.38.tar.gz root@192.168.120.204:/opt/soft/scptest
```

**实例4：上传本地目录到远程机器指定目录**

**命令：**
```bash
scp -r /opt/soft/mongodb root@192.168.120.204:/opt/soft/scptest
```

### 1.5 杀进程

```bash
ps aux| grep 'redis' |grep -v 'grep' |awk '{print $2}'|xargs kill -9
```

所有redis的进程全部杀掉

## 2.CentOS修改默认启动顺序

```bash 
$ systemctl set-default multi-user.target
```

## 3.ftp环境搭建

CentOS 7.0默认使用的是firewall作为防火墙，这里改为iptables防火墙。

### 1、关闭firewall：

```bash
#停止firewall
$ systemctl stop firewalld.service
#禁止firewall开机启动
$ systemctl disable firewalld.service
```

### 2、安装iptables防火墙

```bash
#安装
$ yum install iptables-services

$ vi /etc/sysconfig/iptables 
#编辑防火墙配置文件，添加下面红色部分进入iptables，
#说明：21端口是ftp服务端口；10060到10090是Vsftpd被动模式需要的端口，可自定义一段大于1024的tcp端口
　-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT 
　-A INPUT -m state --state NEW -m tcp -p tcp --dport 10060:10090 -j ACCEPT
#保存退出　
$ :wq! 
```

```bash
#最后重启防火墙使配置生效
systemctl restart iptables.service
#设置防火墙开机启动
systemctl enable iptables.service 
```

### 3、关闭SELINUX

```bash
$ vi /etc/selinux/config
#SELINUX=enforcing #注释掉
#SELINUXTYPE=targeted #注释掉
SELINUX=disabled #增加
$ :wq! #保存退出

$ setenforce 0 #使配置立即生效
```

### 4、安装vsftpd

```bash
#查询vsftpd是否安装
$ rpm -qc vsftpd 
#安装vsftpd
$ yum install -y vsftpd 
#安装vsftpd虚拟用户配置依赖包
$ yum install -y psmisc net-tools systemd-devel libdb-devel perl-DBI  
#启动
$ systemctl start vsftpd.service 
 #设置vsftpd开机启动
$ systemctl enable vsftpd.service
```

### 5、新建系统用户vsftpd

```bash
#用户目录为/home/wwwroot, 用户登录终端设为/bin/false(即使之不能登录系统)
$ useradd vsftpd -d /home/vsftpd -s /bin/false 
# 修改目录归属
$ chown vsftpd:vsftpd /home/vsftpd -R
```

### 6、建立虚拟用户个人Vsftp的配置文件和子账号FTP权限

```bash
$ mkdir /etc/vsftpd/vconf
$ cd /etc/vsftpd/vconf
# 这里创建虚拟用户配置文件
$ touch ftpuser
$ mkdir -p /home/vsftpd/ftpuser
$ touch readme.txt
$ echo 'ftpuser home' > readme.txt 
$ mkdir upload
# 设置FTP上传文件新增权限，最新的vsftpd要求对主目录不能有写的权限所以ftp为755，
# 主目录下面的子目录再设置777权限  
$ chmod -R 755 /home/vsftpd/ftpuser
$ chmod -R 777 /home/vsftpd/ftpuser/*
# 编辑用户ftpuser配置文件，其他的跟这个配置文件类似
$ vi ftpuser 
# 设置FTP账号根目录
  local_root=/home/wwwroot/ftpuser/　　
　write_enable=YES
  anon_world_readable_only=NO
  anon_upload_enable=YES
  anon_mkdir_write_enable=YES
  anon_other_write_enable=YES
```

### **7、配置vsftp服务器**

```bash
# 备份默认配置文件
$ cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf-bak 
```

执行以下命令进行设置:

```bash 
$ sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
$ sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP service./g" '/etc/vsftpd/vsftpd.conf'
# guest_username=vsftpd 此处要和刚刚创建的用户名一致
$ echo -e "use_localtime=YES\nlisten_port=21\nchroot_local_user=YES\nidle_session_timeout=300
\ndata_connection_timeout=1\nguest_enable=YES\nguest_username=vsftpd
\nuser_config_dir=/etc/vsftpd/vconf\nvirtual_use_local_privs=YES
\nallow_writeable_chroot=YES\npasv_min_port=10060\npasv_max_port=10090
\naccept_timeout=5\nconnect_timeout=1" >> /etc/vsftpd/vsftpd.conf
```

配置文件说明：

```bash
anonymous_enable=NO //设定不允许匿名访问
local_enable=YES //设定本地用户可以访问。注：如使用虚拟宿主用户，在该项目设定为NO的情况下所有虚拟用户将无法访问
chroot_list_enable=YES //使用户不能离开主目录
ascii_upload_enable=YES
ascii_download_enable=YES //设定支持ASCII模式的上传和下载功能
pam_service_name=vsftpd   //PAM认证文件名。PAM将根据/etc/pam.d/vsftpd进行认证
#以下这些是关于vsftpd虚拟用户支持的重要配置项，默认vsftpd.conf中不包含这些设定项目，需要自己手动添加
guest_enable=YES //设定启用虚拟用户功能
guest_username=vsftpd //指定虚拟用户的宿主用户，CentOS中已经有内置的ftp用户了,通过映射到vsftpd
user_config_dir=/etc/vsftpd/vuser_conf //设定虚拟用户个人vsftp的CentOS FTP服务文件存放路径。存放虚拟用户个性的CentOS FTP服务文件(配置文件名=虚拟用户名)
```

### **8、建立虚拟用户名单文件**

```
$ touch /etc/vsftpd/virtusers
```

编辑虚拟用户名单文件：（第一行账号，第二行密码，注意：不能使用root做用户名，系统保留）

```bash
# 编辑虚拟用户名单文件 
$ vi /etc/vsftpd/virtusers
web1
123456
#保存退出
$ :wq! 
```

### **9、生成虚拟用户数据文件**

```bash
$ db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db
#设定PAM验证文件，并指定对虚拟用户数据库文件进行读取
$ chmod 600 /etc/vsftpd/virtusers.db
```

### **10、在/etc/pam.d/vsftpd的文件头部加入以下信息（在后面加入无效）**

修改前先备份 

```bash
$ cp /etc/pam.d/vsftpd /etc/pam.d/vsftpdbak
$ vi /etc/pam.d/vsftpd #先注释到vsftpd所有配置，加入下面红色部分

auth    sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers
account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers
```

注意：如果系统为32位，上面改为lib，否则配置失败；

**十、最后重启vsftpd服务器**

```bash
$ systemctl restart vsftpd.service
```

可通过 ` tail -f /var/log/secure` 指令，查看服务器安全日志，便于分析错误问题，设置操作效果一定要仔细.....

### 11 firewall防火墙

```bash
[root@CENTOS7 vconf]# firewall-cmd --zone=public --add-port=21/tcp --permanent
success
[root@CENTOS7 vconf]# firewall-cmd --add-service=ftp --permanent
success
[root@CENTOS7 vconf]# firewall-cmd --reload
success
```



## 4.SSH

```bash
# 安装ssh
$ yum install -y openssl openssh-server
# 启动ssh的服务
$ systemctl start sshd.service
# 设置开机自动启动ssh服务
$ systemctl enable sshd.service
$ vim /etc/ssh/sshd_config
将 下面几行全部释放开
Port 22
#AddressFamily any
ListenAddress 0.0.0.0
ListenAddress ::

PasswordAuthentication yes
# 上述操作既完成ssh的安装
```

## 5、简版vsftpd安装

### 5.1、安装并启动FTP服务

1.查询是否系统已经自带了vsftpd ：rpm -q vsftpd

2.使用 yum 安装vsftpd：yum -y install vsftpd (或者使用rpm安装vsftpd：rpm -ivh vsftpd-3.0.2-22.el7.x86_64)

3.启动vsftpd服务：service vsftpd start  (设置开机启动：systemctl enable vsftpd.service)

检查vsftpd是否开启：ps -e|grep vsftpd 或者 查看21端口是否被监听，netstat -an | grep 21

可以使用netstat -ntpl | grep vsftpd命令查看到系统现在监听的vsftpd的端口为 21

4.开启防火墙

放开21端口：firewall-cmd --zone=public --add-port=21/tcp --permanent

永久开放 ftp 服務：firewall-cmd --add-service=ftp --permanent (关闭ftp服务：firewall-cmd --remove-service=ftp --permanent)

在不改变状态的条件下重新加载防火墙：firewall-cmd --reload

可能用到的命令：

systemctl start firewalld     启动防火墙服务

firewall-cmd --add-service=ftp     暂时开放ftp服务

firewall-cmd --add-service=ftp --permanent    永久开放ftp服務

firewall-cmd --remove-service=ftp --permanent    永久关闭ftp服務

systemctl restart firewalld    重启firewalld服务

firewall-cmd --reload    重载配置文件

firewall-cmd --query-service ftp    查看服务的启动状态

firewall-cmd --list-all    显示防火墙应用列表

firewall-cmd --add-port=8001/tcp    添加自定义的开放端口

iptables -L -n | grep 21    查看设定是否生效

firewall-cmd --state    检测防火墙状态

firewall-cmd --permanent --list-port    查看端口列表

### 5.2、配置 FTP 权限

1、了解 VSFTP 配置

vsftpd 的配置目录为 /etc/vsftpd，包含下列的配置文件：

vsftpd.conf 为主要配置文件

ftpusers 配置禁止访问 FTP 服务器的用户列表

user_list 配置用户访问控制------这里的用户默认情况（即在/etc/vsftpd/vsftpd.conf中设置了userlist_deny=YES）下也不能访问FTP服务器 

2、阻止匿名访问和切换根目录

匿名访问和切换根目录都会给服务器带来安全风险，我们把这两个功能关闭。编辑 /etc/vsftpd/vsftpd.conf，找到下面两处配置并修改：

```bash
anonymous_enable=NO # 禁用匿名用户  YES 改为NO 

chroot_local_user=YES  #  禁止切换根目录 删除

#编辑完成后保存配置，重新启动 FTP 服务 service vsftpd restart

# 其它配置项说明：

anonymous_enable=YES #允许匿名登陆 

local_enable=YES #启动home目录 

write_enable=YES #ftp写的权限 

local_umask=022 

dirmessage_enable=YES #连接打印的消息 

connect_from_port_20=YES #20端口 

xferlog_std_format=YES 

idle_session_timeout=600 

data_connection_timeout=300 

accept_timeout=60 

connect_timeout=60 

ascii_upload_enable=YES #上传 

ascii_download_enable=YES #下载 

chroot_local_user=NO #是否限制用户在主目录活动 

chroot_list_enable=YES #启动限制用户的列表 

chroot_list_file=/etc/vsftpd/chroot_list #每行一个用户名 

allow_writeable_chroot=YES #允许写 

listen=NO 

listen_ipv6=YES 

pasv_min_port=50000 允许ftp工具访问的端口起止端口 

pasv_max_port=60000 

pam_service_name=vsftpd #配置虚拟用户需要的 

userlist_enable=NO #配置yes之后，user_list的用户不能访问ftp 

tcp_wrappers=YES 

chroot_list 文件需要自己建,内容一行一个用户名字 

anon_root=/data/ftp/public #修改匿名用户的访问路径
```

3 创建 FTP 用户

新建一个不能登录系统用户. 只用来登录ftp服务 ,这里如果没设置用户目录。默认是在home下：

useradd ftpuser -s /sbin/nologin

为ftpuser用户设置密码：passwd ftpuser

可能用到：

设置用户的主目录：usermod -d /data/ftp ftpuser

彻底删除用户：#userdel -rf Fuser   //强制删除用户及相关目录文件 

变更用户属性：#usermod -s /sbin/nologinftpuser (/bin/bash：可以登录shell，/bin/false：禁止登录shell )

查看当前服务：#netstat -lntp

### 5.3、下载

```
wget ftp://ftpuser:123456@172.16.9.242/scripts/ansible/common/jar/ansible.zip
```



## 6、设置固定IP

动态ip网络配置可参考我的另一篇博文<http://www.cnblogs.com/albertrui/p/7811868.html>

1、编辑/etc/sysconfig/network-scripts/ifcfg-ens33 ，

​     使用的命令为 `$>sudo  vi  /etc/sysconfig/network-scripts/ifcfg-ens33`

1.1 修改`BOOTPROTO=static`

1.2 修改或添加`IPADDR=192.168.6.120`

(这个根据自己的情况 而定，我的主机的ip是192.168.6.111， 所以我的这个ip可以设置为192.168.6.（1~255之间的，但不能和宿主机的ip重复）)

1.3 修改 或添加`GATEWAY=192.168.6.1`（这个是根据主机的默认网关一致的）

1.4 修改 或添加`ONBOOT="yes"`

1.5 修改 或添加`DNS1=8.8.8.8`,也可以多写几个依次为DNS2,DNS3，

 常用的多是`114.114.114.114`或者`8.8.8.8`或者`8.8.4.4`等

## 7、CentOS 修改主机名

### 7.1 CentOS  6.x

```bash
# 查看当前的hostnmae
[root@centos6 ~]$ hostname
centos6.magedu.com
# 编辑network文件修改hostname行（重启生效）
[root@centos6 ~]$ vim /etc/sysconfig/network  
# 检查修改
[root@centos6 ~]$ cat /etc/sysconfig/network  
NETWORKING=yes
HOSTNAME=centos66.magedu.com
 # 设置当前的hostname(立即生效）
[root@centos6 ~]$ hostname centos66.magedu.com 
 # 编辑hosts文件，给127.0.0.1添加hostname
[root@centos6 ~]$ vim /etc/hosts
# 检查
[root@centos6 ~]$ cat /etc/hosts  
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4 centos66.magedu.com
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6
```

### 7.2 CentOS 7.x

```bash
# 使用这个命令会立即生效且重启也生效
[root@centos7 ~]$ hostnamectl set-hostname centos77.magedu.com  
# 查看下
[root@centos7 ~]$ hostname                                               
centos77.magedu.com
# 编辑下hosts文件， 给127.0.0.1添加hostname
[root@centos7 ~]$ vim /etc/hosts
# 检查
[root@centos7 ~]$ cat /etc/hosts                                         
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 centos77.magedu.com
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

## 8、查看发行版本

### 8.1 lsb_release -a

  对于linux系统而已，有成百上千个发行版。对于发行版的版本号查看方法

如以centos为例。输入**lsb_release -a**即可

**该命令适用于所有的linux，包括Redhat、SuSE、Debian等发行版**

[![如何查看linux系统版本 查看linux系统的位数](https://imgsa.baidu.com/exp/w=500/sign=1923bf0f2b381f309e198da999014c67/730e0cf3d7ca7bcb8d4a4a18bd096b63f624a8d0.jpg)](http://jingyan.baidu.com/album/215817f7e360bd1edb142362.html?picindex=1)

### 8.2 cat /etc/xxx-release

如果如上图，没有这个命令

可以通过查看 cat /etc/xxx-release XX为发行版名称。如 **centos-release**

[![如何查看linux系统版本 查看linux系统的位数](https://imgsa.baidu.com/exp/w=500/sign=e64698a3452309f7e76fad12420e0c39/11385343fbf2b2113a1f0879c98065380cd78ed0.jpg)](http://jingyan.baidu.com/album/215817f7e360bd1edb142362.html?picindex=2)

### 8.3 cat /etc/issue

也可以通过查看**/etc/issue**文件查看发行版版本号

[![如何查看linux系统版本 查看linux系统的位数](https://imgsa.baidu.com/exp/w=500/sign=bf97a6108982b9013dadc333438da97e/10dfa9ec8a13632712bb4f04928fa0ec08fac7b7.jpg)](http://jingyan.baidu.com/album/215817f7e360bd1edb142362.html?picindex=3)

## 9、firewall 常用操作

### 9.1 firewalld的基本使用

启动： ```systemctl start firewalld```

查看状态：``` systemctl status firewalld ``` 

停止： ``` systemctl disable firewalld``` 

禁用： ``` systemctl stop firewalld``` 

### 9.2 systemctl

systemctl是CentOS7的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。

启动一个服务：``` systemctl start firewalld.service``` 

关闭一个服务：``` systemctlstop firewalld.service``` 

重启一个服务：``` systemctlrestart firewalld.service``` 

显示一个服务的状态：``` systemctlstatus firewalld.service``` 

在开机时启用一个服务：``` systemctlenable firewalld.service``` 

在开机时禁用一个服务：``` systemctldisable firewalld.service``` 

查看服务是否开机启动：``` systemctlis-enabled firewalld.service``` 

查看已启动的服务列表：``` systemctllist-unit-files|grep enabled``` 

查看启动失败的服务列表：``` systemctl--failed``` 

### 9.3 配置firewalld-cmd

查看版本：```  firewall-cmd --version``` 

查看帮助： ``` firewall-cmd --help``` 

显示状态： ``` firewall-cmd --state``` 

查看所有打开的端口：```  firewall-cmd--zone=public --list-ports``` 

更新防火墙规则： ``` firewall-cmd --reload``` 

查看区域信息: ```  firewall-cmd--get-active-zones``` 

查看指定接口所属区域：```  firewall-cmd--get-zone-of-interface=eth0``` 

拒绝所有包：``` firewall-cmd --panic-on``` 

取消拒绝状态： ``` firewall-cmd --panic-off``` 

查看是否拒绝： ``` firewall-cmd --query-panic``` 

添加

```bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
#（--permanent永久生效，没有此参数重启后失效）
```

重新载入
```bash
firewall-cmd --reload
````

查看

```bash
firewall-cmd --zone=public --query-port=80/tcp
```

删除

```bash
firewall-cmd --zone=public --remove-port=80/tcp --permanent
```

添加服务

```bash
firewall-cmd --zone=public --add-service=http --permanent
```

查看firewall是否运行,下面两个命令都可以

```bash
systemctl status firewalld.service

firewall-cmd --state
```

查看当前开了哪些端口

其实一个服务对应一个端口，每个服务对应/usr/lib/firewalld/services下面一个xml文件。

```bash
firewall-cmd --list-services
```

查看还有哪些服务可以打开

```bash
firewall-cmd --get-services
```

查看所有打开的端口

```
firewall-cmd --zone=public --list-ports
```

更新防火墙规则

```bash
firewall-cmd --reload
```

## 10、shell脚本问题

### 10.1 ：bin/sh^M: bad interpreter: No such file or directory

原因：.sh脚本在[windows](http://www.2cto.com/special/xtxz/)[系统](http://www.2cto.com/os/)下用记事本文件编写的。不同系统的编码格式引起的。

解决方法：修改.sh文件格式

   （1）使用vi工具

```bash
vi test.sh
```

​    （2）利用如下命令查看文件格式 

```bash
:set ff
:set fileformat 
```

​     可以看到如下信息 

```bash
fileformat=[dos]
fileformat=unix
```

​     （3） 利用如下命令修改文件格式 

```bash
:set ff=unix
:set fileformat=unix 
:wq 
```

注：其实，在windows下通过git bash可以直接编写unix格式.sh！

## 11、问题集合

### 11.1 Transaction Check Error

安装erlang的时候出现问题：

```bash
# yum install erlang-22.0.1-1.el7.x86_64
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos.ustc.edu.cn
 * epel: mirrors.tuna.tsinghua.edu.cn
 * extras: centos.ustc.edu.cn
 * updates: ap.stykers.moe
Resolving Dependencies
--> Running transaction check
---> Package erlang.x86_64 0:22.0.1-1.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

==================================================================================================================================================================== Package                            Arch                               Version                                    Repository                                   Size
====================================================================================================================================================================Installing:
 erlang                             x86_64                             22.0.1-1.el7                               rabbitmq_erlang                              18 M

Transaction Summary
====================================================================================================================================================================Install  1 Package

Total size: 18 M
Installed size: 33 M
Is this ok [y/d/N]: y
Downloading packages:
Running transaction check
Running transaction test


Transaction check error:
  file /usr/lib64/erlang/bin/epmd from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/erl from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/erlc from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/escript from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/run_erl from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/to_erl from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/no_dot_erlang.boot from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/start from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/start.boot from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/start.script from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/start_clean.boot from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/start_erl from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/bin/start_sasl.boot from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/driver_int.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_driver.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_drv_nif.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_fixed_size_int_types.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_int_sizes_config.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_memory_trace_parser.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_nif.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_nif_api_funcs.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/lib/liberts.a from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/lib/liberts_r.a from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/ei.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/ei_connect.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/eicode.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/include/erl_interface.h from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/lib/libei.a from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/lib/libei_st.a from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/lib/liberl_interface.a from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/usr/lib/liberl_interface_st.a from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64  file /usr/lib64/erlang/releases/RELEASES from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/releases/RELEASES.src from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64
  file /usr/lib64/erlang/releases/start_erl.data from install of erlang-22.0.1-1.el7.x86_64 conflicts with file from package erlang-erts-R16B-03.18.el7.x86_64

Error Summary
-------------
```

错误原因：

本机之前安装了`erlang-erts-R16B-03.18.el7.x86_64`这个软件，并没有卸载干净，导致冲突

解决方法：

```bash
# yum
$ yum remove erlang-erts-R16B-03.18.el7.x86_64
# rpm
$ rpm -e erlang-erts-R16B-03.18.el7.x86_64
```

## 12、Centos7创建用户并授予sudo权限

1. 创建用户： 
```bash
useradd username
```
2. 设置密码： 

```bash
passwd username 
```
   回车，顺序录入新密码及确认密码
   授权sudo权限，需要修改sudoers文件。 

3.  首先找到文件位置，示例中文件在/etc/sudoers位置。 
```bash
whereis sudoers
```

4. 强调内容 修改文件权限，一般文件默认为只读。 
```bash
ls -l /etc/sudoers #查看文件权限 
chmod -v u+w /etc/sudoers #修改文件权限为可编辑
```
5. 修改文件，在如下位置增加一行，保存退出。 
   vim /etc/sudoers 进入文件编辑器 
   文件内容改变如下： 
```bash
root ALL=(ALL) ALL #已有行 
username ALL=(ALL) ALL #新增行
```
6. 记得将文件权限还原回只读。 
```bash
ls -l /etc/sudoers #查看文件权限 
chmod -v u-w /etc/sudoers #修改文件权限为只读
```

## 13、配置Java软连接

### Centos

```bash
 alternatives --install /usr/bin/java java /opt/jdk1.8.0_181/bin/java 2
 alternatives --config java
 2
 alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_181/bin/jar 2
 alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_181/bin/javac 2
 alternatives --set jar /opt/jdk1.8.0_181/bin/jar
 alternatives --set javac /opt/jdk1.8.0_181/bin/javac
```

### Ubuntu

```bash
sudo update-alternatives --install /usr/bin/java  java  /opt/jdk1.8.0_181/bin/java 300   
sudo update-alternatives --install /usr/bin/javac  javac  /opt/jdk1.8.0_181/bin/javac 300 
sudo update-alternatives --install /usr/bin/jar  jar  /opt/jdk1.8.0_181/bin/jar 300   
```



## 14、更换Mirrors

### 更换阿里源

```bash
cd /etc/yum.repos.d/
mkdir repo_bak
mv *.repo repo_bak/
ls
repo_bak
```

```bash
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

```bash
yum clean all && yum makecache
```

### 安装EPEL源

```bash
yum list | grep epel-release
epel-release.noarch                         7-11                        extras   
yum install -y epel-release
```

#### 1、备份(如有配置其他epel源)

```bash
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
```

#### 2、下载新repo 到/etc/yum.repos.d/

epel(RHEL 7)

	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
epel(RHEL 6)

	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
epel(RHEL 5)

	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo
```bash
yum clean all && yum makecache
```

### 查看源

```bash
#查看启用的仓库
yum repolist enabled
 #查看所有的仓库
yum repolist all
```

## 15、CentOS7设置笔记本合盖不休眠

### 找到配置文件

我们找到CentOS7下对应配置文件，目录为：`/etc/systemd/logind.conf`，使用vim命令打开

```shell
vim  /etc/systemd/logind.conf
```

### 修改配置

配置文件中找到我们要修改的配置项：

> HandlePowerKey 按下电源键后的行为，默认power off
> HandleSleepKey 按下挂起键后的行为，默认suspend
> HandleHibernateKey 按下休眠键后的行为，默认hibernate
> HandleLidSwitch 合上笔记本盖后的行为，默认suspend

我们把HandleLidSwitch后面的suspend修改为lock，即：

```shell
HandleLidSwitch=lock
```

注意，如果配置项前面有#号，要删掉，#是注释的意思

其中，后面的配置项的可选范围为：

> `ignore` 忽略，跳过
> `power off` 关机
> `eboot` 重启
> `halt` 挂起
> `suspend` shell内建指令，可暂停目前正在执行的shell。若要恢复，则必须使用SIGCONT信息。所有的进程都会暂停，但不是消失（halt是进程关闭）
> `hibernate` 让笔记本进入休眠状态
> `hybrid-sleep` 混合睡眠，主要是为台式机设计的，是睡眠和休眠的结合体，当你选择Hybird时，系统会像休眠一样把内存里的数据从头到尾复制到硬盘里 ，然后进入睡眠状态，即内存和CPU还是活动的，其他设置不活动，这样你想用电脑时就可以快速恢复到之前的状态了，笔记本一般不用这个功能。
> `lock` 仅锁屏，计算机继续工作。

### 应用生效

必须要使用如下命令才能使上面的配置生效

```shell
systemctl restart systemd-logind
```