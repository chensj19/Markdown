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
