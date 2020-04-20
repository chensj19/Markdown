# CentOS

## 一、centos7配置阿里云yum源

1、切换到/etc/yum.repos.d/目录下

```
cd /etc/yum.repos.d
```

  2、将CentOS-Base.repo 改为CentOS-Base.repo.backup

```bash
mv CentOS-Base.repo CentOS-Base.repo.backup
```

3、下载阿里云yum源到/etc/yum.repos.d/目录下

```bash
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

## 二、centos7配置阿里云epel源

1、切换到/etc/yum.repos.d/目录下

```bash
cd /etc/yum.repos.d 
mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
```

2、下载epel源

```bash
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
```

> [ps： yum -y install epel-release也是安装的阿里云的epel源]

三、清楚缓存

```bash
yum clean all && yum makecache
```

> 【上面的yum源和epel源，如果只安装一个，在每一个结束时都要清楚缓存 yum clean all && yum makecache】

## 三、Mariadb.repo

```bash
[mariadb]
name=Mariadb
baseurl=http://mirrors.aliyun.com/mariadb/yum/10.4/centos7-amd64/
gpgkey= http://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgchek=1
```

## 四、zabbix.repo

```bash
[zabbix]
name=Zabbix Official Repository - $basearch
baseurl=https://mirrors.aliyun.com/zabbix/zabbix/4.4/rhel/7/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX-A14FE591
 
[zabbix-non-supported]
name=Zabbix Official Repository non-supported - $basearch
baseurl=https://mirrors.aliyun.com/zabbix/non-supported/rhel/7/$basearch/
enabled=1
gpgkey=http://mirrors.aliyun.com/zabbix/RPM-GPG-KEY-ZABBIX
gpgcheck=1
```

## 五、Grafana 

```bash
[grafana]
name=grafana
baseurl=https://mirrors.tuna.tsinghua.edu.cn/grafana/yum/rpm
repo_gpgcheck=0
enabled=1
gpgcheck=0
```

## 六、docker-ce

```bash
wget -O /etc/yum.repos.d/docker-ce.repo  http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

## 七、Kubernets

```bash
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
```

## 八、pouch.repo

```bash
[pouch-stable]
name=Pouch Stable - $basearch
baseurl=http://mirrors.aliyun.com/opsx/pouch/linux/centos/7/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/opsx/pouch/linux/centos/gpg

[pouch-test]
name=Pouch Test - $basearch
baseurl=http://mirrors.aliyun.com/opsx/pouch/linux/centos/7/$basearch/test
enabled=0
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/opsx/pouch/linux/centos/gpg
```

