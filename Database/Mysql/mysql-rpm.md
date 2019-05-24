# CentOS7安装MySQL8.0图文教程

## 1.下载 MySQL 所需要的安装包

网址：https://dev.mysql.com/downloads/mysql/

![](https://img-blog.csdn.net/20180702080547795?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 2.Select Operating System: 选择 Red Hat ，CentOS 是基于红帽的，Select OS Version: 选择 linux 7

![](https://img-blog.csdn.net/2018070208105260?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 3.选择 RPM Bundle 点击 Download

![](https://img-blog.csdn.net/20180702081440319?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 4.点击 No thanks, just start my download. 进行下载

![](https://img-blog.csdn.net/20180702081658164?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 5.下载好了

![](https://img-blog.csdn.net/20180702081953475?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 6.打开 VMware，选中要使用的虚拟机，点击开启此虚拟机

![](https://img-blog.csdn.net/20180702082612799?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 7.最小化虚拟机，不用管他了

![](https://img-blog.csdn.net/20180702083153143?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 8.打开 xshell，选择虚拟机 ip 所对应的会话，点击连接

![](https://img-blog.csdn.net/20180702083255571?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 9.连接成功

![](https://img-blog.csdn.net/20180702083404154?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 10.通过 rpm -qa | grep mariadb 命令查看 mariadb 的安装包

![](https://img-blog.csdn.net/20180702083627400?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 11.通过 rpm -e mariadb-libs-5.5.56-2.el7.x86_64 --nodeps 命令装卸 mariadb

![](https://img-blog.csdn.net/20180702083946388?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 12.通过 rpm -qa | grep mariadb 命令再次查看 mariadb 的安装包

![](https://img-blog.csdn.net/20180702084038412?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 13.通过 cd /usr/local/ 命令进入根目录下的usr目录下的local目录，这个目录是放一些本地的共享资源的

![](https://img-blog.csdn.net/20180702084257723?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 14.通过 ll 命令查看一下当前目录下的目录结构

![](https://img-blog.csdn.net/20180702084349145?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 15.通过 mkdir mysql 命令 在当前目录下创建一个名为 mysql 的目录

![](https://img-blog.csdn.net/20180702084504573?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 16.通过 ll 命令查看一下当前目录下的目录结构，刚创建的 mysql 目录有了

![](https://img-blog.csdn.net/20180702084628298?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 17.通过 cd mysql 命令进入 mysql 目录

![](https://img-blog.csdn.net/20180702084742822?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 18.通过 ll 命令查看一下当前目录下的目录结构

![](https://img-blog.csdn.net/20180702084818464?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 19.点击 窗口 -->> 传输新建文件，通过 ftp 协议来把刚下载好的 mysql 安装包传输到 CentOS7 系统中

![](https://img-blog.csdn.net/20180702085033703?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 20.在左边找到你 mysql 安装包的下载目录

![](https://img-blog.csdn.net/20180702085500900?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 21.在你想要传输的文件上单机右键，点击传输

![](https://img-blog.csdn.net/2018070208563572?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 22.上传成功后，关闭 ftp 传输工具

 ![](https://img-blog.csdn.net/20180702090143754?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 23.通过 ll 命令查看一下当前目录下的目录结构

![](https://img-blog.csdn.net/20180702090248911?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 24.通过 tar -xvf mysql-8.0.11-1.el7.x86_64.rpm-bundle.tar  命令解压 tar 包

![](https://img-blog.csdn.net/20180702090417371?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 25.通过 clear 命令清一下屏

![](https://img-blog.csdn.net/20180702090831671?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 26.通过 rpm -ivh mysql-community-common-8.0.11-1.el7.x86_64.rpm --nodeps --force 命令安装 common

![](https://img-blog.csdn.net/2018070209090330?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 27.通过 rpm -ivh mysql-community-libs-8.0.11-1.el7.x86_64.rpm --nodeps --force 命令安装 libs

![](https://img-blog.csdn.net/201807020911480?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 28.通过 rpm -ivh mysql-community-client-8.0.11-1.el7.x86_64.rpm --nodeps --force 命令安装 client

![](https://img-blog.csdn.net/20180702091323255?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 29.通过 rpm -ivh mysql-community-server-8.0.11-1.el7.x86_64.rpm --nodeps --force 命令安装 server

![](https://img-blog.csdn.net/20180702091524631?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 30.通过 rpm -qa | grep mysql 命令查看 mysql 的安装包

![](https://img-blog.csdn.net/20180702091647545?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 31.通过以下命令，完成对 mysql 数据库的初始化和相关配置

```
mysqld --initialize;
chown mysql:mysql /var/lib/mysql -R;
systemctl start mysqld.service;
systemctl  enable mysqld;
```

![](https://img-blog.csdn.net/20180702091927123?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 32.通过 cat /var/log/mysqld.log | grep password 命令查看数据库的密码

![](https://img-blog.csdn.net/20180702092223911?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 33.通过 mysql -uroot -p 敲回车键进入数据库登陆界面

![](https://img-blog.csdn.net/20180702092458144?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 34.输入刚刚查到的密码，进行数据库的登陆，复制粘贴就行，MySQL 的登陆密码也是不显示的

![](https://img-blog.csdn.net/20180702092657412?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 35.通过 ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456'; 命令来修改密码

![](https://img-blog.csdn.net/20180702095054657?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 36.通过 exit; 命令退出 MySQL，然后通过新密码再次登陆

![](https://img-blog.csdn.net/20180702095324452?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 37.通过以下命令，进行远程访问的授权

```
create user 'root'@'%' identified with mysql_native_password by '123456';
grant all privileges on *.* to 'root'@'%' with grant option;
flush privileges;
```

![](https://img-blog.csdn.net/20180702112020394?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 38.通过 ALTER USER 'root'@'localhost' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER; 命令修改加密规则，MySql8.0 版本 和 5.0 的加密规则不一样，而现在的可视化工具只支持旧的加密方式。

 ![](https://img-blog.csdn.net/20180702112250796?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



## 39.通过 flush privileges; 命令刷新修该后的权限

![](https://img-blog.csdn.net/2018070211235486?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 40.通过 exit; 命令退出 MySQL

![](https://img-blog.csdn.net/20180702112426214?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 41.通过以下命令，关闭 firewall

```
systemctl stop firewalld.service;
systemctl disable firewalld.service;
systemctl mask firewalld.service;
```

## 42.通过 yum -y install iptables-services  命令安装 iptables 防火墙

![](https://img-blog.csdn.net/20180702104316756?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 43.通过以下命令启动设置防火墙

```
systemctl enable iptables;
systemctl start iptables;
```

![](https://img-blog.csdn.net/20180702104627718?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 44.通过 vim /etc/sysconfig/iptables 命令编辑防火墙，添加端口

![](https://img-blog.csdn.net/2018070210480710?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 45.点击 i 键进入插入模式

![](https://img-blog.csdn.net/20180702105334825?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 46.在相关位置，写入以下内容

```
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8090 -j ACCEPT
```

![](https://img-blog.csdn.net/20180702105636833?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 47.点击 ESC 键退出插入模式

![](https://img-blog.csdn.net/20180702105837902?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 48.点击 : 键，输入 wq 敲回车键保存退出，: 为英文状态下的

![](https://img-blog.csdn.net/20180702105914437?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 49.通过 systemctl restart iptables.service 命令重启防火墙使配置生效

![](https://img-blog.csdn.net/20180702110041263?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 50.通过 systemctl enable iptables.service 命令设置防火墙开机启动

![](https://img-blog.csdn.net/20180702110139314?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 51.通过 ifconfig 命令查看 ip

![](https://img-blog.csdn.net/20180702110426133?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 52.新建 SQLyog  的连接

![](https://img-blog.csdn.net/20180702112710720?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

## 53.连接成功

![](https://img-blog.csdn.net/20180702112753380?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



## 54.使用firewall配置

```bash
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --add-service=mysql --permanent
firewall-cmd --reload
```

