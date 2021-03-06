# SonarQube安装

## 1、安装PostgreSql

## 2、安装SonarQube

### 2.1 准备和下载文件

```bash
# jdk
su root
yum install -y java-11-openjdk java-11-openjdk-devel
# 创建用户
useradd sonar
passwd sonar
su sonar
cd 
# 下载文件
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.1.34397.zip
# 解压
unzip sonarqube-8.3.1.34397.zip
# es 数据
mkdir -p /home/sonar/sonarqueue/data
mkdir -p /home/sonar/sonarqueue/temp
```

### 2.2 修改配置

#### sonar.properties

```bash
# User credentials.
# Permissions to create tables, indices and triggers must be granted to JDBC user.
# The schema must be created first.
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
#----- PostgreSQL 9.3 or greater
# By default the schema named "public" is used. It can be overridden with the parameter "currentSchema".
sonar.jdbc.url=jdbc:postgresql://10.0.0.97/sonar?currentSchema=public
# Binding IP address. For servers with more than one IP address, this property specifies which
# address will be used for listening on the specified ports.
# By default, ports will be used on all IP addresses associated with the server.
sonar.web.host=0.0.0.0

# Web context. When set, it must start with forward slash (for example /sonarqube).
# The default value is root context (empty value).
#sonar.web.context=
# TCP port for incoming HTTP connections. Default value is 9000.
sonar.web.port=9000
# Defaults are respectively <installation home>/data and <installation home>/temp
sonar.path.data=/home/sonar/sonarqueue/data
sonar.path.temp=/home/sonar/sonarqueue/temp
```

#### 系统配置

```bash
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
# etc/security/limits.conf 
*   -   nofile   65536
*   -   nproc    4096
# 生效
sysctl -p
```

### 2.3 启动

```bash
sh /home/sonar/sonarqube-8.3.1.34397/bin/linux-x86-64/start.sh start
```



