# Docker-常用命令

## 1、镜像

### 1.1 获取镜像

```bash
$ docker pull ubuntu:18.04
```

### 1.2 运行镜像

```bash
$ docker run -it --rm ubuntu:18.04 bash
```

### 1.3 镜像列表

```bash
docker image ls
```

### 1.4 镜像体积

```bash
$ docker system df
```

###  1.5 虚悬镜像

* 查看虚悬镜像

```bash
$ docker image ls -f dangling=true
```

* 删除虚悬镜像

```bash
$ docker image prune
```

### 1.6 删除镜像

```bash
$ docker image rm f09
```

## 2、容器

### 2.1 容器列表

```bash
$ docker container ls -a
```

### 2.2 启动容器

```bash
$ docker run -it ubuntu:18.04 /bin/echo 'Hello world'
$ docker run -d ubuntu:18.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
# 启动已关闭容器
$ docker container restart
```

### 2.3 关闭容器

```bash
 $ docker container stop 64cbac550abc
```

### 2.4 进入容器

* `docker attach`

  * ```bash
    $ docker attach 3749
    ```

  * 使用exit退出的时候，将会关闭容器

* `docker exec` 

  * ```bash
    $ docker exec -it 64cbac550abc bash
    ```

### 2.5 删除容器

* 可以使用`docker container rm` 来删除一个处于终止状态的容器
* 可以清理掉所有处于终止状态的容器`docker container prune`

## 3、docker安装

### 3.1 CentOS

#### 卸载旧版本

```bash
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```



#### 安装需要的文件

```bash
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

#### 设置docker的源

```bash
# 官方源
$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
# 阿里源
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

#### 安装

```bash
$ sudo yum install docker-ce docker-ce-cli containerd.io
```

#### 查看可安装版本

```bash
$ yum list docker-ce --showduplicates | sort -r

# 安装指定版本

$ sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io
```

#### 启动Docker

```bash
$ sudo systemctl start docker
$ sudo systemctl enable docker
```

### 3.2 Ubuntu

#### 卸载旧版本

```bash
$ sudo apt-get remove docker docker-engine docker.io containerd runc

```

#### 更新APT

```bash
$ sudo apt-get update

```

#### 安装需要的文件

```bash
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```

#### 获取Docker的官方GPG密钥

```bash
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

存在一种情况，访问不到。。。。使用阿里源

##### **添加Docker的阿里镜像GPG key**

```bash
$ curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -

```

#### **验证该key是否安装成功(一般提示ok就不用验证了）**

```bash
$ sudo apt-key fingerprint 0EBFCD88
```

#### **设置stable存储库**

```bash
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

或者 科大

```bash
$ sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
```

或者 阿里

```bash
$ sudo add-apt-repository \
    "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
```

#### **再次更新apt包索引**

```bash
$ sudo apt-get update
```

#### **列出可用的版本并安装自己想要的版本**

```bash
$ sudo apt-cache madison docker-ce
```

#### 安装

```bash
$ sudo apt-get install -y docker-ce
```

#### 启动与检查

```bash
# 开启docker服务
$ sudo systemctl start docker
# 重启docker服务
$ sudo service docker restart
#  验证docker 显示active表示已经启动
$ systemctl status docker
```

## 4、修改加速器

```json
{
  "registry-mirrors": ["https://registry.docker-cn.com","http://f1361db2.m.daocloud.io","https://0vtdrvzb.mirror.swr.myhuaweicloud.com"]
}
```

