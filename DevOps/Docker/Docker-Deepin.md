# Docker --Deepin篇

## 一、简介

Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口。

## 二、关于Deepin中的Docker

深度官方deepin的应用仓库已经集成了docker，不过类似docker-ce这种最新版。要想使用最新版可以参考官网 debian 安装教程安装，不过由于深度15.4基于 sid 版本开发，通过 **$(lsb_release -cs)** 获取的版本信息为 **unstable**，而docker官方源并没提供 sid 这种**unstable**版本的docker，所以使用官方教程是安装不成功的。

## 三、在Deepin中安装最新Docker的方法

### 1.如果以前安装过老版本，可以先卸载以前版本

```bash
sudo apt-get remove docker.io docker-engine
```

### 2.安装docker-ce与密钥管理与下载相关的工具

**说明：** 这里主要是提供curl命令、add-apt-repository和密钥管理工具。 **更正：**这里还需要software-properties-common包提供**add-apt-repository**工具。

```bash
sudo apt-get install apt-transport-https ca-certificates curl python-software-properties software-properties-common
```

### 3.下载并安装密钥

> 鉴于国内网络问题，强烈建议使用国内源，官方源请在注释中查看。 国内源可选用[清华大学开源软件镜像站](https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/) 或 [中科大开源镜像站](http://mirrors.ustc.edu.cn/)，示例选用了中科大的。

为了确认所下载软件包的合法性，需要添加软件源的 GPG 密钥。

```bash
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -
// 官方源，能否成功可能需要看运气。
// curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

### 4.查看密钥是否安装成功

```bash
sudo apt-key fingerprint 0EBFCD88
```

如果安装成功，会出现如下内容：

```bash
  pub   4096R/0EBFCD88 2017-02-22              Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88  
  uid     Docker Release (CE deb) <docker@docker.com>  
  sub   4096R/F273FCD8 2017-02-22
```

### 5.添加docker官方仓库

然后，我们需要向 source.list 中添加 Docker CE 软件源：

```bash
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian wheezy stable"
//官方源
// sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/debian wheezy stable"
```

**Note：** 这点很奇怪，官方在 wheezy 位置使用的是 **$(lsb_release -cs)**，而在deepin下执行**lsb_release -cs**这个命令时，而deepin显示的是**unstable**，而默认debian根据正式发行版本会显示是 **jessie** 或者**wheezy** 这个如果不更改成特定版本信息，在**sudo apt-get update**更新时就不起作用。
**更正：** 之所以获取的 unstable 不成功，是因为docker官方没有提供sid版本的docker。想安装必须将该部分替换成相应版本。**Note：**这里例子的debian的版本代号是`wheezy`，应该替换成deepin基于的debian版本对应的代号，查看版本号命令：`cat /etc/debian_version`，再根据版本号对应的代号替换上面命令的`wheezy`即可。

例如对于deepin15.5，我操作上面的命令得到debain版本是8.0，debian 8.0的代号是jessie，把上面的wheezy替换成 jessie，就可以正常安装docker,当前docker的版本为17.12.0-ce.

deepin15.9.2基于debian 9.0 , debian 9.0的代号为stretch, 所以deepin15.9.2上完整的添加信息为:

```bash
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian stretch stable"
```

### 6.更新仓库

```bash
sudo apt-get update
```

### 7.安装docker-ce

由于网络不稳定，可能会下载失败。如果下载失败了，可以多试几次或者找个合适的时间继续。

```bash
sudo apt-get install docker-ce
```

在安装完后启动报错，查看docker.service的unit文件，路径为/lib/systemd/system/docker.service，把ExecStart=/usr/bin/dockerd -H fd:// 修改为ExecStart=/usr/bin/dockerd，则可以正常启动docker,启动 命令为 `systemctl start docker`

#### 7.1 查看安装的版本信息

```bash
docker version
```

#### 7.2 验证docker是否被正确安装并且能够正常使用

```bash
sudo docker run hello-world
```

如果能够正常下载，并能够正常执行，则说明docker正常安装。

### 8. 问题

Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.39/images/json: dial unix /var/run/docker.sock: connect: permission denied

```bash
$ sudo gpasswd -a ${USER} docker
```

