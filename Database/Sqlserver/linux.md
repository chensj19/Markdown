# sqlserver linux

## 一、SqlServer 2017 安装

1. 环境配置

   ```bash
   # 安装python2
   yum install python2
   # 设置默认python
   sudo alternatives --config python
   ```

2. 下载yum源

   ```bash
   # centos 7
   sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo
   # centos 8
   sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/8/mssql-server-2017.repo
   ```

3. 安装

   ```bash
   sudo yum install -y mssql-server
   ```

4. 配置

   ```bash
   sudo /opt/mssql/bin/mssql-conf setup
   ```

5. 防火墙

   ```bash
   sudo firewall-cmd --zone=public --add-port=1433/tcp --permanent
   sudo firewall-cmd --reload
   ```

## 二、command-line tools

1. 下载yum源

   ```bash
   # centos 7
   sudo curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/7/prod.repo
   # centos 8
   sudo curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/8/prod.repo
   ```

2. 卸载旧版本**mssql-tools**

   ```bash
   sudo yum remove unixODBC-utf16 unixODBC-utf16-devel
   ```

3. 安装

   ```bash
   sudo yum install -y mssql-tools unixODBC-devel
   ```

4. 环境变量

   ```bash
   echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
   echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
   source ~/.bashrc
   ```

5. 连接

   ```bash
   sqlcmd -S localhost -U SA -P '<YourPassword>'
   ```

6. 测试SQL

   ```sql
   SELECT Name from sys.Databases
   ```

   > 使用go触发sql执行