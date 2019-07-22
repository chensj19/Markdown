@[TOC](Docker 安装Shadowsocks VPN)

# Shadowsocks VPN安装与使用
## Docker镜像

### 准备工作

1.可以访问国外网站的服务器或者VPS，笔者使用的是搬瓦工VPS。
2.Linux系统环境搭建，笔者安装的是Centos7。

### Docker安装
 1.**安装 Docker**

    yum install docker -y

2.**启动 Docker 服务**

    service docker start
    chkconfig docker on

3.**检查 Docker 版本**

    docker -version

Docker镜像安装

笔者和大部分网上资料一样，选择了Github上的ShadowSocks VPN Docker镜像进行安装。安装语句如下

    docker pull oddrationale/docker-shadowsocks

### 运行Docker镜像

    docker run -d -p 12345:12345 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 12345 -k laosiji -m aes-256-cfb
>-d参数允许 Docker 常驻后台运行
-p来指定要映射的端口，这里端口号统一保持一致即可。例如：12345
-s服务器 IP 地址，不用改动
-k后面设置你的 VPN 的密码，比如：laosiji
-m指定加密方式（aes-256-cfb）

执行完成后查看容器是否创建成功并运行

    docker ps -a

### 防火墙端口设置
>1.文件位置
>`/etc/sysconfig/iptables`
>2.添加语句
>`-A INPUT -p tcp -m tcp --dport 12345 -j ACCEPT`
>3.重启服务
>`service iptables restart`

如果嫌vi操作麻烦，1、2步操作可以合并为：

    iptables -I INPUT -p tcp --dport 12345 -j ACCEPT

## pip 安装方式

### 安装Shadowsocks服务端

#### 安装pip

使用包管理工具pip安装python版本的Shadowsocks，先安装pip

```bash
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
```

#### 安装配置Shadowsocks服务端

安装Shadowsocks，此版本的 shadowsocks 已发布到pip上，直接使用pip安装。

```bash
pip install --upgrade pip
pip install shadowsocks
```

安装完成后，再创建一个shadowsocks.json文件，通过读取这个文件的配置来启动，就不用每次启动都输入所有的配置信息。

##### 多端口配置

```bash
vim /etc/shadowsocks.json
```

```json
{
  "server": "0.0.0.0",
  "local_address": "127.0.0.1",
  "local_port": 1080,
  "port_password": {
    "123456": "填写密码",
    "123457": "填写密码"
  },
  "timeout": 600,
  "method": "rc4-md5"
}
```

> 其中server为你的云服务器的私有地址、私有地址、私有地址(说三遍)
> method为加密方法，有多种选择，
>
> 推荐使用rc4-md5，这种方式，加密开销小些。
>


#####  单端口配置

```json
{
    "server": "0.0.0.0",
    "server_port": 12345,
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "password": "cowbeer",
    "timeout": 300,
    "method": "rc4-md5",
    "fast_open": false
```

#### 配置自启动

编辑shadowsocks服务的启动脚本文件

```bash
 vim /etc/systemd/system/shadowsocks.service
```

内容如下

```bash
[Unit]
Description=Shadowsocks

[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/ssserver -c /etc/shadowsocks.json

[Install]
WantedBy=multi-user.target
```

执行以下命令启动 shadowsocks服务：

```bash
 systemctl enable shadowsocks
 systemctl start shadowsocks
```

检查 shadowsocks 服务是否已成功启动，可以执行以下命令查看服务的状态：

```bash
systemctl status shadowsocks -l
```

#### 检查防火墙

安装无误后，若开启了防火墙，配置防火墙规则，开放你配置的端口：

```bash
 firewall-cmd --zone=public --add-port=123456/tcp --permanent
 firewall-cmd --zone=public --add-port=123457/tcp --permanent
 firewall-cmd --reload
```



## ShadowSocks 客户端

### 配置客户端

安装配置完后，就可以用`shdowsocks`客户端进行连接了。

Windows版本的客户端下载地址：

https://github.com/shadowsocks/shadowsocks-windows/releases

具体配置的含义我就不再赘述，可以上网了解下。具体配置如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/2018112315004876.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NmNzk4NjE1OTQ2,size_16,color_FFFFFF,t_70)
