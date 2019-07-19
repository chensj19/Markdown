# CentOS7安装MySQL8.0图文教程

## 安装步骤

1. 下载 MySQL 所需要的安装包

   网址：https://dev.mysql.com/downloads/mysql/

2. Select Operating System: 选择 Red Hat ，CentOS 是基于红帽的，Select OS Version: 选择 linux 7

3. 选择 RPM Bundle 点击 Download

4. 点击 No thanks, just start my download. 进行下载

5. 下载好了

![](https://img-blog.csdn.net/20180702081953475?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

6. 打开 VMware，选中要使用的虚拟机，点击开启此虚拟机

![](https://img-blog.csdn.net/20180702082612799?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

7. 最小化虚拟机，不用管他了

![](https://img-blog.csdn.net/20180702083153143?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

8. 打开 xshell，选择虚拟机 ip 所对应的会话，点击连接

![](https://img-blog.csdn.net/20180702083255571?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

9. 连接成功

![](https://img-blog.csdn.net/20180702083404154?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

10. 查看 mariadb 的安装包

```bash
rpm -qa | grep mariadb 
```

11. 装卸 mariadb

    卸载上面命令查看到的mariadb

    ```bash
     rpm -e mariadb-libs-5.5.56-2.el7.x86_64 --nodeps 
    ```

12. 再次查看 mariadb 的安装包，确定卸载成功

    ```bash
     rpm -qa | grep mariadb 
    ```

13. 创建目录，这个目录是放一些本地的共享资源的

    ```bash
     cd /usr/local/ 
     mkdir /usr/local/mysql
    ```

14. 通过ftp将文件上传到服务器上，或者通过xshell工具中的`传输文件`功能将文件上传到服务器

15. 解压文件

    ```bash
    tar -xvf mysql-8.0.11-1.el7.x86_64.rpm-bundle.tar
    ```

16. 安装mysql

    ```bash
    # 安装 common
    rpm -ivh mysql-community-common-8.0.11-1.el7.x86_64.rpm --nodeps --force
    # 安装 libs
    rpm -ivh mysql-community-libs-8.0.11-1.el7.x86_64.rpm --nodeps --force 
    # 安装 client
    rpm -ivh mysql-community-client-8.0.11-1.el7.x86_64.rpm --nodeps --force
    # 安装 server
    rpm -ivh mysql-community-server-8.0.11-1.el7.x86_64.rpm --nodeps --force 
    ```

    上面四个的安装顺序不能更改，必须按照这个顺序来完成安装

17. 查看 mysql 的安装包

    ```bash
    rpm -qa | grep mysql
    ```

    安装结果应该显示已经安装成功四个包

![](https://img-blog.csdn.net/20180702091647545?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

18. 通过以下命令，完成对 mysql 数据库的初始化和相关配置

```bash
mysqld --initialize --user=mysql    # mysql 初始化 指定用户 
chown mysql:mysql /var/lib/mysql -R # 目录权限修改
systemctl start mysqld # 启动mysql
systemctl enable mysqld # 开机启动mysql
```

19. 查看数据库的密码

    ```bash
     cat /var/log/mysqld.log | grep password
    ```

![](https://img-blog.csdn.net/20180702092223911?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjI2NjYwNg==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

20. 进入数据库登陆界面,并输入上面获取的密码

    输入刚刚查到的密码，进行数据库的登陆，复制粘贴就行，MySQL 的登陆密码也是不显示的

    ```bash
     mysql -uroot -p
    ```

21. 修改root账户密码

    ```bash
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
    exit;
    ```

    如果不修改用户密码，什么都无法操作

    修改完成后，退出后使用新密码登陆

22. 通过以下命令创建远程操作账户，进行远程访问的授权

```sql
create user 'root'@'%' identified with mysql_native_password by '123456';
grant all privileges on *.* to 'root'@'%' with grant option;
flush privileges;
```

23. 设置root账户密码不过期

    MySql8.0 版本 和 5.0 的加密规则不一样，而现在的可视化工具只支持旧的加密方式

    ```sql
     ALTER USER 'root'@'localhost' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;
     flush privileges; 
    ```

## 防火墙配置

###  iptables

#### 关闭firewall

```bash
systemctl stop firewalld.service;
systemctl disable firewalld.service;
systemctl mask firewalld.service;
```

#### 安装/启动iptables

```bash
yum -y install iptables-services
systemctl enable iptables;
systemctl start iptables;
```

#### 配置iptables

```bash
vim /etc/sysconfig/iptables
```

在相关位置，写入以下内容

```bash
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8090 -j ACCEPT
```

重启iptables，设置开机启动

```bash
systemctl restart iptables.service
systemctl enable iptables.service
```

### firewall配置

```bash
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --add-service=mysql --permanent
firewall-cmd --reload
```

