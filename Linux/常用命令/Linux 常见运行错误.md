# Linux常见运行错误

## 1. systemctl服务部署错误：code=exited, status=217/USER

```bash
跑服务的时候报错了：

Process: 2451 ExecStart=/home/.virtualenvs/bin/python /home/xxx.py (code=exited, status=217/USER)

仔细一看原来原来service文件的用户名没改，难怪提示217/USER错误呢，把用户名改对就好了，服务顺利跑起来了

[Unit]
Description=xxx
After=network.target

[Service]
WorkingDirectory=/home/deploy/server
User=xxx
ExecStart=/home/.virtualenvs/bin/python /home/deploy/server/xxx.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

- 编辑配置文件
   vi /etc/sysconfig/network-scripts/ifcfg-eno0
   该路径为自己电脑上的路径，可能结尾不是0，进入编辑状态，并修改配置

  ![img](https:////upload-images.jianshu.io/upload_images/9450186-6295f2e80de7fa22.png?imageMogr2/auto-orient/strip|imageView2/2/w/425/format/webp)

  修改配置

:wq保存并退出编辑状态

- 重启网络服务
   /etc/init.d/network restart
   或
   service network restart

  ![img](https:////upload-images.jianshu.io/upload_images/9450186-86ea565e2f1f7112.png?imageMogr2/auto-orient/strip|imageView2/2/w/553/format/webp)

  重启网卡服务

- 查看ip
   ip addr
   确认ip修改成功

  ![img](https:////upload-images.jianshu.io/upload_images/9450186-9ccc550082e465a9.png?imageMogr2/auto-orient/strip|imageView2/2/w/757/format/webp)

  确认ip

  

#### 配置说明

- 静态配置



```bash
BOOTPROTO="static"
```

BOOTPROTO="dhcp"改为"static"动态改为静态

- 其他配置



```undefined
BROADCAST=192.168.0.255
IPADDR=192.168.0.40
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
```

BROADCAST 设置局域网广播地址
 IPADDR     静态ip
 NETMASK  子网掩码
 GATEWAY   网关或路由地址
 NETWORK  局域网网络号(不需要配置，ifcalc自动计算)

#### 配置dns

配置成功后需要重新设置dns，否者无法ping通域名

- 配置地址
   /etc/resolv.conf

  ![img](https:////upload-images.jianshu.io/upload_images/9450186-31daa814907c6742.png?imageMogr2/auto-orient/strip|imageView2/2/w/449/format/webp)

  配置地址

- 配置内容

  ![img](https:////upload-images.jianshu.io/upload_images/9450186-e078e2325b8f9450.png?imageMogr2/auto-orient/strip|imageView2/2/w/277/format/webp)

  配置内容

  文件中增加nameserver指定dns服务器地址即可
   该配置立即生效