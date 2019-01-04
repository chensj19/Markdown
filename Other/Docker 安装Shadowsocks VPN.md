@[TOC](Docker 安装Shadowsocks VPN)

# 准备工作

1.可以访问国外网站的服务器或者VPS，笔者使用的是搬瓦工VPS。
2.Linux系统环境搭建，笔者安装的是Centos7。

# Docker安装
 1.**安装 Docker**

    yum install docker -y

2.**启动 Docker 服务**

    service docker start
    chkconfig docker on

3.**检查 Docker 版本**

    docker -version

# Docker镜像安装

笔者和大部分网上资料一样，选择了Github上的ShadowSocks VPN Docker镜像进行安装。安装语句如下

    docker pull oddrationale/docker-shadowsocks

# 运行Docker镜像

    docker run -d -p 19929:19929 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 19929 -k laosiji-m aes-256-cfb
>-d参数允许 Docker 常驻后台运行
-p来指定要映射的端口，这里端口号统一保持一致即可。例如：19929
-s服务器 IP 地址，不用改动
-k后面设置你的 VPN 的密码，比如：laosiji
-m指定加密方式（aes-256-cfb）
    
执行完成后查看容器是否创建成功并运行

    docker ps -a

# 防火墙端口设置
>1.文件位置
>`/etc/sysconfig/iptables`
>2.添加语句
>`-A INPUT -p tcp -m tcp --dport 19929 -j ACCEPT`
>3.重启服务
>`service iptables restart`

如果嫌vi操作麻烦，1、2步操作可以合并为：

    iptables -I INPUT -p tcp --dport 19929 -j ACCEPT

# ShadowSocks 客户端
重点来了，网上的资源很多都被和谐了，还是挺难找的。但是在我坚(dao)持(chu)不(qiu)懈(ren)下，还是搞到了。具体配置的含义我就不再赘述，可以上网了解下。具体配置如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/2018112315004876.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NmNzk4NjE1OTQ2,size_16,color_FFFFFF,t_70)
下面是百度网盘下载链接：
链接：https://pan.baidu.com/s/1YyQmy0Xw539_pVaU8pwFVQ 
密码：c43e