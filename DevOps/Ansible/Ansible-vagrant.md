# Ansible vagrant

## 环境搭建

### 1、VirtualBox 安装

从virtualbox.org的官网下载系统对应的文件，比如采用环境为CentOS7.1810版本，则是从[下载地址](https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo)获取repo文件，文件内容如下：

```bash
[virtualbox]
name=Oracle Linux / RHEL / CentOS-$releasever / $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc
```

安装需要的依赖：

```bash
yum install -y  kernel-devel gcc
```

安装：

```
yum install VirtualBox-6.0 -y
```

配置：

```bash
# 查看版本
VBoxManage --version
# 初始化
sudo /sbin/vboxconfig
# 日志
vboxdrv.sh: Stopping VirtualBox services.
vboxdrv.sh: Starting VirtualBox services.
vboxdrv.sh: Building VirtualBox kernel modules.
```

### 2、vagrant安装

从官网下载vagrant文件

```bash
wget https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.rpm
```

安装：

```bash
rpm -ivh vagrant_2.2.5_x86_64.rpm
```

### 3、创建Ubuntu虚拟机

```bash
cd /opt
mkdir playbooks
cd playbooks
# 初始化
vagrant init ubuntu/trusty64
# 上面的操作步骤会在当前位置创建一个 Vagrantfile 文件
# 启动 接下来就会下载虚拟机
vagrant up
```

### 4、vagrant常用操作

```bash
# 查看已经安装的虚拟机
vagrant box list
# 卸载虚拟机
vagrant box remove box_name
# 新增本地virtual box
# centos7 别名 自己定义的虚拟机名称
# virtualbox.box 本地box名称
vagrant box add centos7 virtualbox.box
```

## 虚拟机安装

### 1、下载box

从[官网](https://app.vagrantup.com/boxes/search)下载box

```bash
# CentOS
https://vagrantcloud.com/centos/boxes/7/versions/1905.1/providers/virtualbox.box
# ubuntu
http://cloud-images.ubuntu.com/vagrant/trusty/20190514/trusty-server-cloudimg-amd64-vagrant-disk1.box
```

### 2、添加box

```bash
vagrant box add centos7 virtualbox.box
vagrant box add ubuntu/trusty trusty-server-cloudimg-amd64-vagrant-disk1.box
```

### 3、初始化

```
vagrant init centos7
vagrant init ubuntu/trusty
```

### 4、启动虚拟机

```bash
vagrant up
```

### 5、登录虚拟机

```bash
vagrant ssh
```