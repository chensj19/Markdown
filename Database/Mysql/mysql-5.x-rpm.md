# CentOS7安装MySQL5.7

1. 下载 MySQL 所需要的安装包

   网址：https://dev.mysql.com/downloads/mysql/

2. Select Operating System: 选择 Red Hat ，CentOS 是基于红帽的，Select OS Version: 选择 linux 7

3. 选择下面几个rpm文件下载即可
   1. mysql-community-common-5.7.26-1.el7.x86_64.rpm
   2. mysql-community-libs-5.7.26-1.el7.x86_64.rpm 
   3. mysql-community-client-5.7.26-1.el7.x86_64.rpm  
   4. mysql-community-server-5.7.26-1.el7.x86_64.rpm  

4. 上传文件到linux系统

5. 上传完成后ssh到服务器准备安装

6. 通过 rpm -qa | grep mariadb 命令查看 mariadb 的安装包

7. 通过 rpm -e mariadb-libs-5.5.56-2.el7.x86_64 --nodeps 命令装卸 mariadb

8. 安装mysql，执行如下命令

   ```bash
   rpm -ivh mysql-community-common-5.7.26-1.el7.x86_64.rpm --nodeps --force
   rpm -ivh mysql-community-libs-5.7.26-1.el7.x86_64.rpm --nodeps --force
   rpm -ivh mysql-community-client-5.7.26-1.el7.x86_64.rpm  --nodeps --force
   rpm -ivh mysql-community-server-5.7.26-1.el7.x86_64.rpm  --nodeps --force
   ```

9. mysql初始化

   ```bash
    mysqld --initialize --user=mysql --explicit_defaults_for_timestamp
   ```

10. 启动mysql和开机启动

    ```bash
    systemctl start mysqld
    systemctl enable mysqld
    ```

11. 用户配置

    从`/var/log/mysqld.log`获取登录密码

    ```bash
    cat /var/log/mysqld.log| grep password
    ```

    通过` mysql -uroot -p `敲回车键进入数据库登陆界面

    ```bash
    mysql -uroot -p
    ```

    输入刚刚查到的密码，进行数据库的登陆，复制粘贴就行，MySQL 的登陆密码也是不显示的

    ```bash
    mysql -uroot -p
    Enter password: 
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 2
    Server version: 5.7.26
    
    Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.
    
    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    L
    mysql> 
    ```

    通过 `alter user 'root'@'localhost' identified by '123456';` 命令来修改密码

    ```sql
    alter user 'root'@'localhost' identified by '123456';
    ```

    通过 exit; 命令退出 MySQL，然后通过新密码再次登陆

    ```bash
    mysql -uroot -p
    ```
    
    创建远程用户
    
    ```bash
    create user 'root'@'%'  IDENTIFIED BY '123456' ;
    grant all on *.* to  'root'@'%' ;
    grant all privileges  on *.* to  'root'@'%'  IDENTIFIED BY '123456' ;
    flush privileges;
    ```
    
12. 防火墙配置

    ```bash
    firewall-cmd --zone=public --add-port=3306/tcp --permanent
    firewall-cmd --add-service=mysql --permanent
    firewall-cmd --reload
    ```

