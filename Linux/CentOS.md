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
```

2、下载epel源

```bash
 wget https://mirrors.aliyun.com/repo/epel-7.repo
 wget http://mirrors.aliyun.com/repo/epel-6.repo
```

> [ps： yum -y install epel-release也是安装的阿里云的epel源]

三、清楚缓存

```bash
yum clean all && yum makecache
```

> 【上面的yum源和epel源，如果只安装一个，在每一个结束时都要清楚缓存 yum clean all && yum makecache】

