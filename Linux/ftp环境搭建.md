# 虚拟账户FTP环境搭建

## ftp环境搭建

CentOS 7.0默认使用的是firewall作为防火墙，

### 1、可以改用iptables防火墙。

#### 1、关闭firewall：

```bash
#停止firewall
$ systemctl stop firewalld.service
#禁止firewall开机启动
$ systemctl disable firewalld.service
```

#### 2、安装iptables防火墙

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

### 2、使用firewall防火墙

```bash
[root@CENTOS7 vconf]# firewall-cmd --zone=public --add-port=21/tcp --permanent
success
[root@CENTOS7 vconf]# firewall-cmd --add-service=ftp --permanent
success
[root@CENTOS7 vconf]# firewall-cmd --reload
success
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
$ touch /home/vsftpd/readme.txt
$ echo 'ftpuser home' > /home/vsftpd/readme.txt
# 设置FTP上传文件新增权限，最新的vsftpd要求对主目录不能有写的权限所以ftp为755，
# 主目录下面的子目录再设置777权限  
$ chmod -R 755 /home/vsftpd
$ chmod -R 777 /home/vsftpd/ftpuser
# 编辑用户ftpuser配置文件，其他的跟这个配置文件类似
$ vi ftpuser 
# 设置FTP账号根目录
local_root=/home/vsftpd/ftpuser
write_enable=YES
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
```

### **7、配置vsftp服务器**

```bash
# 备份默认配置文件
$ cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak 
```

执行以下命令进行设置:

```bash 
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP service./g" '/etc/vsftpd/vsftpd.conf'
# guest_username=vsftpd 此处要和刚刚创建的用户名一致
echo -e "use_localtime=YES\nlisten_port=21\nchroot_local_user=YES\nidle_session_timeout=30000
\ndata_connection_timeout=1\nguest_enable=YES\nguest_username=vsftpd
\npasv_enable=YES\nreverse_lookup_enable=NO
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

# 简版FTP环境搭建

## 1、SELinux 处理

```bash
$ setenforce 0 #让SELinux进入Permissive模式（宽容模式）
```

设置SELiunx：

```bash
$ /usr/sbin/sestatus -v     #查看SELinux状态
SELinux status:                 enabled    #启用
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
setenforce 0 #暂时让SELinux进入Permissive模式
```

我们尝试访问一下ftp目录，发现能够正常访问。我们查看一下权限：

```bash
$ getsebool -a | grep ftp
ftpd_anon_write --> off
ftpd_connect_all_unreserved --> off
ftpd_connect_db --> off
ftpd_full_access --> off
ftpd_use_cifs --> off
ftpd_use_fusefs --> off
ftpd_use_nfs --> off
ftpd_use_passive_mode --> off
httpd_can_connect_ftp --> off
httpd_enable_ftp_server --> off
tftp_anon_write --> off
tftp_home_dir --> off
```

**ftp_home_dir和allow_ftpd_full_access必须为on 才能使vsftpd 具有访问ftp根目录，以及文件传输等权限。**

```bash
$ setsebool -P tftp_home_dir 1
$ setsebool -P allow_ftpd_full_access 1
```

让我们再回到强制模式：

```bash
$ setenforce 1 #进入Enforcing模式
```

## 2、安装vsftpd

```bash
# 查看是否已经安装了vsftpd
$ vsftpd -version
# 安装vsftpd
$ yum install -y vsftpd
# 创建ftpuser用户目录，也可以在创建用户的时候指定
# 第一种方法
$ mkdir /home/vsftpd
$ useradd -d /home/vsftpd -s /usr/sbin/nologin ftpuser
$ passwd ftpuser
# 第二种方法
$ useradd -d /home/vsftpd -s /usr/sbin/nologin ftpuser
$ passwd ftpuser
# 由于上面设置用户 -s /usr/sbin/nologin,但是在/etc/shells中并没有这个目录，此时登录会报错，解决方法就是将/usr/sbin/nologin添加到/etc/shells即可
$ vim /etc/shells
```

## 3、配置文件修改

* `vim /etc/vsftpd/vsftpd.conf`

```bash
$ cp  /etc/vsftpd/vsftpd.conf  /etc/vsftpd/vsftpd.conf.bak
$ vim /etc/vsftpd/vsftpd.conf
```

* 配置文件修改

```bash
# 去掉前面的注释
chroot_local_user=YES

ascii_upload_enable=YES
ascii_download_enable=YES

# 文件末尾添加
allow_writeable_chroot=YES
```

## 4、防火墙

```bash
$ firewall-cmd --permanent --zone=public --add-service=ftp
$ firewall-cmd --reload
```

## 5、重启vsftpd

```bash
# 设置开机启动：
$ systemctl enable vsftpd.service
# 启动vsftpd服务
$ systemctl start  vsftpd.service
```

禁止ftp用户通过22端口登录ftp服务器：

由于需要限制ftp用户在自己的目录，在21端口下没有问题，但当ftp用户用sftp登录时，还是可以访问上级目录，于是禁止ftp用户ssh登录，切断22端口的通信。

首先，执行如下命令，找到nologin的[shell](https://www.centos.bz/category/shell/)：

```bash
vi /etc/shells
```

可以看到禁止登录的[shell](https://www.centos.bz/tag/shell/)文件为/usr/sbin/nologin，然后执行如下命令：

```bash
usermod -s /usr/sbin/nologin tomas
```

如果要恢复tomas的ssh登录，执行如下命令：

```bash
usermod -s /bin/bash tomas
```