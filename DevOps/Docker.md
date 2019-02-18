

# Docker

## 虚拟化与Docker 对比

![传统虚拟化](http://hainiubl.com/images/2016/virtualization.png)

![Docker](http://hainiubl.com/images/2016/docker.png)

对比图：

![](https://images2015.cnblogs.com/blog/663847/201607/663847-20160703190439265-1566952969.jpg)

## Docker引擎

docker 是一个c/s结构的应用，主要组件如下：

![docker主要组件](http://hainiubl.com/images/2016/engine-components-flow.png)

- Server是一个常驻进程
- REST API 实现了client和server间的交互协议
- CLI 实现容器和镜像的管理，为用户提供统一的操作界面

## Docker架构

Docker使用C/S架构，Client 通过接口与Server进程通信实现容器的构建，运行和发布。client和server可以运行在同一台集群，也可以通过跨主机实现远程通信。

![Docker架构](http://hainiubl.com/images/2016/architecture.jpg)

## Docker 核心概念

### 镜像 (Images)

- Docker 镜像

  Docker 镜像（Image）就是一个只读的模板。例如：一个镜像可以包含一个完整的操作系统环境，里面仅安装了 Apache 或用户需要的其它应用程序。镜像可以用来创建 Docker 容器，一个镜像可以创建很多容器。Docker 提供了一个很简单的机制来创建镜像或者更新现有的镜像，用户甚至可以直接从其他人那里下载一个已经做好的镜像来直接使用。

  镜像（Image）就是一堆只读层（read-only layer）的统一视角，也许这个定义有些难以理解，看看下面这张图：

  ![docker镜像](http://hainiubl.com/images/2016/image_ufs.png)

  右边我们看到了多个只读层，它们重叠在一起。除了最下面一层，其它层都会有一个指针指向下一层。这些层是Docker内部的实现细节，并且能够在docker宿主机的文件系统上访问到。统一文件系统（`Union File System`）技术能够将不同的层整合成一个文件系统，为这些层提供了一个统一的视角，这样就隐藏了多层的存在，在用户的角度看来，只存在一个文件系统。

* 分层存储
  因为镜像包含操作系统完整的 root 文件系统，其体积往往是庞大的，因此在Docker 设计时，就充分利用 `Union FS` 的技术，将其设计为分层存储的架构。所以严格来说，镜像并非是像一个 ISO 那样的打包文件，镜像只是一个虚拟的概念，其实际体现并非由一个文件组成，而是由一组文件系统组成，或者说，由多层文件系统联合组成。
  镜像构建时，会一层层构建，前一层是后一层的基础。每一层构建完就不会再发生改变，后一层上的任何改变只发生在自己这一层。比如，删除前一层文件的操作，实际不是真的删除前一层的文件，而是仅在当前层标记为该文件已删除。在最终容器运行的时候，虽然不会看到这个文件，但是实际上该文件会一直跟随镜像。因
  此，在构建镜像的时候，需要额外小心，每一层尽量只包含该层需要添加的东西，任何额外的东西应该在该层构建结束前清理掉。

  分层存储的特征还使得镜像的复用、定制变的更为容易。甚至可以用之前构建好的镜像作为基础层，然后进一步添加新的层，以定制自己所需的内容，构建新的镜像

### 仓库 (Repository)

​	仓库（Repository）是集中存放镜像文件的场所。有时候会把仓库和仓库注册服务器（Registry）混为一谈，并不严格区分。实际上，仓库注册服务器上往往存放着多个仓库，每个仓库中又包含了多个镜像，每个镜像有不同的标签（tag）。

​	仓库分为公开仓库（Public）和私有仓库（Private）两种形式。最大的公开仓库是 Docker Hub，存放了数量庞大的镜像供用户下载。国内的公开仓库包括 时速云 、网易云 等，可以提供大陆用户更稳定快速的访问。当然，用户也可以在本地网络内创建一个私有仓库。

​	当用户创建了自己的镜像之后就可以使用 push 命令将它上传到公有或者私有仓库，这样下次在另外一台机器上使用这个镜像时候，只需要从仓库上 pull 下来就可以了。

​	Docker 仓库的概念跟 Git 类似，注册服务器可以理解为 GitHub 这样的托管服务。

### 注册中心 (Docker Registry)

​	镜像构建完成后，可以很容易的在当前宿主机上运行，但是，如果需要在其它服务器上使用这个镜像，我们就需要一个集中的存储、分发镜像的服务，Docker Registry 就是这样的服务。

​	一个 Docker Registry 中可以包含多个仓库（ Repository ）；每个仓库可以包含多个标签（ Tag ）；每个标签对应一个镜像。

​	通常，一个仓库会包含同一个软件不同版本的镜像，而标签就常用于对应该软件的各个版本。我们可以通过 <仓库名>:<标签> 的格式来指定具体是这个软件哪个版本的镜像。如果不给出标签，将以 latest 作为默认标签。

### 容器 (Container)

​	镜像（ Image ）和容器（ Container ）的关系，就像是面向对象程序设计中的类 和 实例 一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等。

​	容器的实质是进程，但与直接在宿主执行的进程不同，容器进程运行于属于自己的独立的 命名空间。因此容器可以拥有自己的 root 文件系统、自己的网络配置、自己的进程空间，甚至自己的用户 ID 空间。容器内的进程是运行在一个隔离的环境里，使用起来，就好像是在一个独立于宿主的系统下操作一样。这种特性使得容器封装的应用比直接在宿主运行更加安全。

​	Docker 利用容器（Container）来运行应用。容器是从镜像创建的运行实例。它可以被启动、开始、停止、删除。每个容器都是相互隔离的、保证安全的平台。可以把容器看做是一个简易版的 Linux 环境（包括root用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。

​	容器的定义和镜像几乎一模一样，也是一堆层的统一视角，唯一区别在于容器的最上面那一层是可读可写的。

![容器](http://hainiubl.com/images/2016/container-ufs.png)

一个运行态容器被定义为一个可读写的统一文件系统加上隔离的进程空间和包含其中的进程。下面这张图片展示了一个运行中的容器。

![示例](http://hainiubl.com/images/2016/container-running.png)

正是文件系统隔离技术使得Docker成为了一个非常有潜力的虚拟化技术。一个容器中的进程可能会对文件进行修改、删除、创建，这些改变都将作用于可读写层

## Docker 修改镜像加速器

国内从 Docker Hub 拉取镜像有时会遇到困难，此时可以配置镜像加速器。Docker
官方和国内很多云服务商都提供了国内加速器服务，例如：

* Docker 官方提供的中国 registry mirror https://registry.docker-cn.com
* 阿里云加速器(需登录账号获取)
* 七牛云加速器 https://reg-mirror.qiniu.com/
> 当配置某一个加速器地址之后，若发现拉取不到镜像，请切换到另一个加速器地址。
> 国内各大云服务商均提供了 Docker 镜像加速服务，建议根据运行 Docker 的云平台选择对应的镜像加速服务。
我们以 Docker 官方加速器 https://registry.docker-cn.com 为例进行介绍。
### Ubuntu 14.04、Debian 7 Wheezy
对于使用 upstart 的系统而言，编辑 /etc/default/docker 文件，在其中的DOCKER_OPTS 中配置加速器地址：
```bash
DOCKER_OPTS="--registry-mirror=https://registry.docker-cn.com"
```
重新启动服务。
```bash 
sudo service docker restart
```
### Ubuntu 16.04+、Debian 8+、CentOS 7
对于使用 `systemd`的系统，请在` /etc/docker/daemon.json`中写入如下内容（如果文件不存在请新建该文件）
```json
{
    "registry-mirrors": [
    "https://registry.docker-cn.com"
    ]
}
```
注意，一定要保证该文件符合 json 规范，否则 Docker 将不能启动。之后重新启动服务。
```bash 
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```
注意：如果您之前查看旧教程，修改了 docker.service 文件内容，请去掉
您添加的内容（ --registry-mirror=https://registry.docker-cn.com ），这里不再赘述。
### Windows 10
对于使用 Windows 10 的系统，在系统右下角托盘 Docker 图标内右键菜单选择
Settings ，打开配置窗口后左侧导航菜单选择 Daemon 。在 Registry
mirrors 一栏中填写加速器地址 https://registry.docker-cn.com ，之后点
击 Apply 保存后 Docker 就会重启并应用配置的镜像地址了。
### macOS
对于使用 macOS 的用户，在任务栏点击 Docker for mac 应用图标 ->
Perferences... -> Daemon -> Registry mirrors。在列表中填写加速器地址
https://registry.docker-cn.com 。修改完成之后，点击 Apply &
Restart 按钮，Docker 就会重启并应用配置的镜像地址了。
### 检查加速器是否生效
命令行执行 docker info ，如果从结果中看到了如下内容，说明配置成功。
```bash
Registry Mirrors:
    https://registry.docker-cn.com/
```

## Docker 镜像使用

### 1、获取镜像

```docker
docker pull ubuntu:18.04
18.04: Pulling from library/ubuntu
6cf436f81810: Pull complete
987088a85b96: Pull complete
b4624b3efe06: Pull complete
d42beb8ded59: Pull complete
Digest: sha256:7a47ccc3bbe8a451b500d2b53104868b46d60ee8f5b35a24b41a86077c650210
Status: Downloaded newer image for ubuntu:18.04
```

​	上面的命令中没有给出 `Docker` 镜像仓库地址，因此将会从` Docker Hub` 获取镜像。而镜像名称是` ubuntu:18.04` ，因此将会获取官方镜像 `library/ubuntu`仓库中标签为 `18.04` 的镜像。

### 2、运行镜像

有了镜像后，我们就能够以这个镜像为基础启动并运行一个容器。以上面的`ubuntu:18.04 `为例，如果我们打算启动里面的 `bash` 并且进行交互式操作的话，可以执行下面的命令

```bash
docker run -it --rm ubuntu:18.04 bash
```

> docker run 就是运行容器的命令
>
> -it ：这是两个参数，一个是 -i ：交互式操作，一个是 -t 终端。我们
> 这里打算进入 bash 执行一些命令并查看返回结果，因此我们需要交互式终
> 端。
> --rm ：这个参数是说容器退出后随之将其删除。默认情况下，为了排障需
> 求，退出的容器并不会立即删除，除非手动 docker rm 。我们这里只是随便
> 执行个命令，看看结果，不需要排障和保留结果，因此使用 --rm 可以避免
> 浪费空间。
> ubuntu:18.04 ：这是指用 ubuntu:18.04 镜像为基础来启动容器。
> bash ：放在镜像名后的是命令，这里我们希望有个交互式 Shell，因此用的
> 是 bash 

```bash
root@46f2f912a209:/# cat /etc/os-release
NAME="Ubuntu"
VERSION="18.04.1 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.1 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```

###  3、镜像列表

```bash
docker image ls
```

```bash
docker image ls
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
<none>                       <none>              fef204746f63        2 hours ago         0B
nginx                        latest              f09fe80eb0e7        11 days ago         109MB
ubuntu                       18.04               47b19964fb50        12 days ago         88.1MB
centos                       7.0.1406            59b15a9def8d        4 months ago        210MB
dockerinaction/hello_world   latest              a1a9a5ed65e9        3 years ago         2.43MB
```

> 列表包含了 仓库名 、 标签 、 镜像 ID 、 创建时间 以及 所占用的空间 。其中仓库名、标签在之前的基础概念章节已经介绍过了。镜像 ID 则是镜像的唯一标识，一个镜像可以对应多个标签。

### 4、镜像体积

如果仔细观察，会注意到，这里标识的所占用空间和在 Docker Hub 上看到的镜像大小不同。比如，ubuntu:18.04 镜像大小，在这里是 127 MB ，但是在Docker Hub 显示的却是 50 MB 。这是因为 Docker Hub 中显示的体积是压缩后的体积。在镜像下载和上传过程中镜像是保持着压缩状态的，因此 Docker Hub 所显示的大小是网络传输中更关心的流量大小。而 docker image ls 显示的是镜像下载到本地后，展开的大小，准确说，是展开后的各层所占空间的总和，因为镜像到本地后，查看空间的时候，更关心的是本地磁盘空间占用的大小。

`docker image ls` 列表中的镜像体积总和并非是所有镜像实际硬盘消耗。由于 `Docker` 镜像是多层存储结构，并且可以继承、复用，因此不同镜像可能会因为使用相同的基础镜像，从而拥有共同的层。由于 `Docker`使用 `Union FS`，相同的层只需要保存一份即可，因此实际镜像硬盘占用空间很可能要比这个列表镜像大小的总和要小的多

你可以通过`docker system df`命令来便捷的查看镜像、容器、数据卷所占用的空间。

```bash
λ docker system df
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              5                   2                   410MB               298.4MB (72%)
Containers          2                   0                   2B                  2B (100%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
```

### 5、虚悬镜像

上面的镜像列表中，还可以看到一个特殊的镜像，这个镜像既没有仓库名，也没有标签，均为 <none>

```bahs
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
<none>                       <none>              fef204746f63        2 hours ago         0B
```

这种镜像原本是有镜像名和标签的，假设原来为 mongo:3.2 ，随着官方镜像维护，发布了新版本后，重新 docker pull mongo:3.2 时， mongo:3.2 这个镜像名被转移到了新下载的镜像身上，而旧的镜像上的这个名称则被取消，从而成为了<none> 。除了 docker pull 可能导致这种情况， docker build 也同样可以导致这种现象。由于新旧镜像同名，旧镜像名称被取消，从而出现仓库名、标签均为 <none> 的镜像。这类无标签镜像也被称为**虚悬镜像(dangling image) **

* 查看虚悬镜像

```bash
docker image ls -f dangling=true
```

* 删除虚悬镜像

```bash
docker image prune
```

```ba
docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Deleted Images:
deleted: sha256:fef204746f639eb94136888d03ae730f4d3b301040efd53cf6b299b3d45988d7

Total reclaimed space: 0B
```

### 6、中间层镜像

​	为了加速镜像构建、重复利用资源，Docker 会利用中间层镜像。所以在使用一段时间后，可能会看到一些依赖的中间层镜像。默认的 docker image ls 列表中只会显示顶层镜像，如果希望显示包括中间层镜像在内的所有镜像的话，需要加 -a 参数。

```bash
docker image ls -a
```


​	这样会看到很多无标签的镜像，与之前的虚悬镜像不同，这些无标签的镜像很多都是中间层镜像，是其它镜像所依赖的镜像。这些无标签镜像不应该删除，否则会导致上层镜像因为依赖丢失而出错。实际上，这些镜像也没必要删除，因为之前说过，相同的层只会存一遍，而这些镜像是别的镜像的依赖，因此并不会因为它们被列出来而多存了一份，无论如何你也会需要它们。只要删除那些依赖它们的镜像后，这些依赖的中间层镜像也会被连带删除

### 7、镜像查看(命令集合)

```bash
docker image ls      			# 查看所有的顶级镜像
docker image ls -a   			# 查看所有的镜像 包含中间层镜像
docker image ls ubuntu 			# 查看所有的仓库名称为ubuntu的镜像
docker image ls ubuntu:18.04   	# 列出特定的某个镜像，也就是说指定仓库名和标签
# 使用过滤器过滤  使用--filter 或者 -f
docker image ls -f since=mongo:3.2 # 在 mongo:3.2 之后建立的镜像 since 为之后，before 为之前
# 如果镜像构建时，定义了 LABEL ，还可以通过 LABEL 来过滤
docker image ls -f label=com.example.version=0.1
```

* 特定格式展示信息

  默认情况下， `docker image ls` 会输出一个完整的表格，但是我们并非所有时候都会需要这些内容。比如，刚才删除虚悬镜像的时候，我们需要利用 `docker image ls` 把所有的虚悬镜像的 ID 列出来，然后才可以交给 `docker image rm` 命令作为参数来删除指定的这些镜像，这个时候就用到了` -q` 参数。

  ```bash
  docker image ls -q
  f09fe80eb0e7
  47b19964fb50
  59b15a9def8d
  a1a9a5ed65e9
  ```

  * Go的模板语法

    * 下面的命令会直接列出镜像结果，并且只包含镜像ID和仓库名

    ```bash
     docker image ls --format "{{.ID}}: {{.Repository}}"
    f09fe80eb0e7: nginx
    47b19964fb50: ubuntu
    59b15a9def8d: centos
    a1a9a5ed65e9: dockerinaction/hello_world
    ```

    * 打算以表格等距显示，并且有标题行，和默认一样

    ```bash
    docker image ls --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"
    IMAGE ID            REPOSITORY                   TAG
    f09fe80eb0e7        nginx                        latest
    47b19964fb50        ubuntu                       18.04
    59b15a9def8d        centos                       7.0.1406
    a1a9a5ed65e9        dockerinaction/hello_world   latest
    ```



### 8、删除本地镜像

* 命令

  * `docker image rm [选项]  <镜像1> [<镜像2>....]`
  * 镜像 可以是 镜像短ID、 镜像长ID、镜像名或者镜像摘要 。

* 常用命令组合

  * `docker image ls`

  ```bash
  REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
  nginx                        latest              f09fe80eb0e7        11 days ago         109MB
  ubuntu                       18.04               47b19964fb50        12 days ago         88.1MB
  centos                       7.0.1406            59b15a9def8d        4 months ago        210MB
  dockerinaction/hello_world   latest              a1a9a5ed65e9        3 years ago         2.43MB
  ```

  * 镜像短ID

  ```bash
  $ docker image rm f09
  $ docker rmi 10d
  Untagged: nginx:v2
  Deleted: sha256:10db61ad8d1c838bce07314952a00fce0512d05bd215fc50b93d58146c3904fe
  Deleted: sha256:e9f43fdd03385cfc0bf14a04ce7838778c3773d9c033cc74170c4b74586668fd
  ```

  * 镜像长ID

  ```bash
  docker image rm f09fe80eb0e7
  ```

  * 镜像名

  ```bash
  docker image rm nginx
  ```

  * 镜像摘要

  ```bash
  docker image ls --digests
  REPOSITORY                   TAG                 DIGEST                                                                    IMAGE ID            CREATED             SIZE
  nginx                        latest              sha256:dd2d0ac3fff2f007d99e033b64854be0941e19a2ad51f174d9240dda20d9f534   f09fe80eb0e7        12 days ago         109MB
  ubuntu                       18.04               sha256:7a47ccc3bbe8a451b500d2b53104868b46d60ee8f5b35a24b41a86077c650210   47b19964fb50        12 days ago         88.1MB
  centos                       7.0.1406            sha256:e06b6eef24eaf8b531e18691f6d8af5b0610b5b637438be7151930c283b6261f   59b15a9def8d        4 months ago        210MB
  dockerinaction/hello_world   latest              sha256:cfebf86139a3b21797765a3960e13dee000bcf332be0be529858fca840c00d7f   a1a9a5ed65e9        3 years ago         2.43MB
  # 删除镜像
  docker image rm dockerinaction/hello_world@sha256:cfebf86139a3b21797765a3960e13dee000bcf332be0be529858fca840c00d7f   a1a9a5ed65e9
  ```

* `Untagged` 和 `Deleted`

  ​	如果观察上面这几个命令的运行输出信息的话，你会注意到删除行为分为两类，一类是 `Untagged` ，另一类是 `Deleted` 。我们之前介绍过，镜像的唯一标识是其ID 和摘要，而一个镜像可以有多个标签。因此当我们使用上面命令删除镜像的时候，实际上是在要求删除某个标签的镜像。所以首先需要做的是将满足我们要求的所有镜像标签都取消，这就是我们看到的`Untagged` 的信息。因为一个镜像可以对应多个标签，因此当我们删除了所指定的标签后，可能还有别的标签指向了这个镜像，如果是这种情况，那么 `Delete`行为就不会发生。所以并非所有的 `docker image rm` 都会产生删除镜像的行为，有可能仅仅是取消了某个标签而已。
  ​	当该镜像所有的标签都被取消了，该镜像很可能会失去了存在的意义，因此会触发删除行为。镜像是多层存储结构，因此在删除的时候也是从上层向基础层方向依次进行判断删除。镜像的多层结构让镜像复用变动非常容易，因此很有可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。直到没有任何层依赖当前层时，才会真实的删除当前层。这就是为什么，有时候会奇怪，为什么明明没有别的标签指向这个镜像，但是它还是存在的原因，也是为什么有时候会发现所删除的层数和自己 `docker pull` 看到的层数不一样的源。

  ​	除了镜像依赖以外，还需要注意的是容器对镜像的依赖。如果有用这个镜像启动的容器存在（即使容器没有运行），那么同样不可以删除这个镜像。之前讲过，容器是以镜像为基础，再加一层容器存储层，组成这样的多层存储结构去运行的。因此删除本地镜像该镜像如果被这个容器所依赖的，那么删除必然会导致故障。如果这些容器是不需要的，应该先将它们删除，然后再来删除镜像。

* 用 `docker image ls` 命令来配合
  像其它可以承接多个实体的命令一样，可以使用` docker image ls -q` 来配合使用`docker image rm` ，这样可以成批的删除希望删除的镜像。我们在“镜像列表”章节介绍过很多过滤镜像列表的方式都可以拿过来使用。
  比如，我们需要删除所有仓库名为 redis 的镜像：

  ```bash 
  	$ docker image rm $(docker image ls -q redis) 
  ```
  或者删除所有在 mongo:3.2 之前的镜像：
  ```bash 
  $ docker image rm $(docker image ls -q -f before=mongo:3.2)
  ```
  充分利用你的想象力和 Linux 命令行的强大，你可以完成很多非常赞的功能

### 9、镜像组成(使用`commit`理解)

> docker commit 命令处理学习以外，还有一些特殊使用的场合，比如被入侵后保存现场等，但是不能使用docker commit 定制镜像，定制镜像还是需要使用Dockerfile来完成

​	镜像是容器的基础，每次执行 docker run 的时候都会指定哪个镜像作为容器运行的基础。在之前的例子中，我们所使用的都是来自于 Docker Hub 的镜像。直接使用这些镜像是可以满足一定的需求，而当这些镜像无法直接满足需求时，我们就需要定制这些镜像。接下来的几节就将讲解如何定制镜像。
​	回顾一下之前我们学到的知识，镜像是多层存储，每一层是在前一层的基础上进行的修改；而容器同样也是多层存储，是在以镜像为基础层，在其基础上加一层作为容器运行时的存储层

* 定制一个Web服务器

```bash
docker run --name webServer -d -p 80:80 nginx
```

​	用 nginx 镜像启动一个容器，命名为 webserver ，并且映射了 80端口，这样我们可以用浏览器去访问这个 nginx 服务器,可以使用http://localhost访问，可以看到Nginx的欢迎页面

* 进入容器修改

```bash  
docker exec -it webServer bash
root@f1fb4b6cae37:/usr/share/nginx/html# echo '<h1>Hello Docker!</h1>' > index.html
root@f1fb4b6cae37:/usr/share/nginx/html# more index.html
<h1>Hello Docker!</h1>
```

页面内容变为Hello Docker

* 查看容器文件变动

  ```bash
  docker diff webServer
  ```

  ```bash
   docker diff webServer
  C /var
  C /var/cache
  C /var/cache/nginx
  A /var/cache/nginx/scgi_temp
  A /var/cache/nginx/uwsgi_temp
  A /var/cache/nginx/client_temp
  A /var/cache/nginx/fastcgi_temp
  A /var/cache/nginx/proxy_temp
  C /run
  A /run/nginx.pid
  C /usr
  C /usr/share
  C /usr/share/nginx
  C /usr/share/nginx/html
  C /usr/share/nginx/html/index.html
  C /root
  A /root/.bash_history
  ```

  现在我们定制好了变化，我们希望能将其保存下来形成镜像。
  要知道，当我们运行一个容器的时候（如果不使用卷的话），我们做的任何文件修改都会被记录于容器存储层里。而 Docker 提供了一个 docker commit 命令，可以将容器的存储层保存下来成为镜像。换句话说，就是在原有镜像的基础上，再叠加上容器的存储层，并构成新的镜像。以后我们运行这个新镜像的时候，就会拥有
  原有容器最后的文件变化。

  docker commit 的语法格式为：

  ```bash
  docker commit [选项] <容器ID或容器名> [<仓库名>[:<标签>
  ```

* 保存上面的镜像

  ```bash
  $ docker commit --author "chenshijie1988@yeah.net" --message "修改默认的网页" webServer nginx:v2
  
  sha256:10db61ad8d1c838bce07314952a00fce0512d05bd215fc50b93d58146c3904fe
  ```
* 在 `docker image ls` 中看到这个新定制的镜像
  ```bash
  $ docker image ls
  REPOSITORY                   TAG                 IMAGE ID            CREATED              SIZE
  nginx                        v2                  10db61ad8d1c        About a minute ago   109MB
  nginx                        latest              f09fe80eb0e7        12 days ago          109MB
  ubuntu                       18.04               47b19964fb50        12 days ago          88.1MB
  centos                       7.0.1406            59b15a9def8d        4 months ago         210MB
  dockerinaction/hello_world   latest              a1a9a5ed65e9        3 years ago          2.43MB
  ```

* `docker history` 具体查看镜像内的历史记录，如果比较nginx:latest 的历史记录，我们会发现新增了我们刚刚提交的这一层

```bash
$ docker history nginx:v2
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
10db61ad8d1c        3 minutes ago       nginx -g daemon off;                            171B                修改默认的网页
f09fe80eb0e7        12 days ago         /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>           12 days ago         /bin/sh -c #(nop)  STOPSIGNAL SIGTERM           0B
<missing>           12 days ago         /bin/sh -c #(nop)  EXPOSE 80                    0B
<missing>           12 days ago         /bin/sh -c ln -sf /dev/stdout /var/log/nginx…   22B
<missing>           12 days ago         /bin/sh -c set -x  && apt-get update  && apt…   53.9MB
<missing>           12 days ago         /bin/sh -c #(nop)  ENV NJS_VERSION=1.15.8.0.…   0B
<missing>           12 days ago         /bin/sh -c #(nop)  ENV NGINX_VERSION=1.15.8-…   0B
<missing>           12 days ago         /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
<missing>           12 days ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           12 days ago         /bin/sh -c #(nop) ADD file:5a6d066ba71fb0a47…   55.3MB
```

* 运行定制的镜像

```bash
$ docker run --name web -d -p 81:80 nginx:v2
```

命名为新的服务为 web2 ，并且映射到 81 端口。如果是 Docker for Mac/Windows 或 Linux 桌面的话，我们就可以直接访问 http://localhost:81 看到结果，其内容应该和之前修改后的 webserver 一样

> 慎用 docker commit
>
> 使用 docker commit 命令虽然可以比较直观的帮助理解镜像分层存储的概念，但是实际环境中并不会这样使用。首先，如果仔细观察之前的 docker diff webserver 的结果，你会发现除了真正想要修改的 /usr/share/nginx/html/index.html 文件外，由于命令的执行，还有很多文件被改动或添加了。这还仅仅是最简单的操作，如果是安装软件包、编译构建，那会有大量的无关内容被添加进来，如果不小心清理，将会导致镜像极为臃肿。
>
> 此外，使用 docker commit 意味着所有对镜像的操作都是黑箱操作，生成的镜像也被称为黑箱镜像，换句话说，就是除了制作镜像的人知道执行过什么命令、怎么生成的镜像，别人根本无从得知。而且，即使是这个制作镜像的人，过一段时间后也无法记清具体在操作的。虽然 docker diff 或许可以告诉得到一些线索，
> 但是远远不到可以确保生成一致镜像的地步。这种黑箱镜像的维护工作是非常痛苦的。
>
> 而且，回顾之前提及的镜像所使用的分层存储的概念，除当前层外，之前的每一层都是不会发生改变的，换句话说，任何修改的结果仅仅是在当前层进行标记、添加、修改，而不会改动上一层。如果使用 docker commit 制作镜像，以及后期修改的话，每一次修改都会让镜像更加臃肿一次，所删除的上一层的东西并不会丢失，会一直如影随形的跟着这个镜像，即使根本无法访问到。这会让镜像更加臃肿。



### 10、Dockerfile定制镜像

镜像定制：实际上就是定制镜像每一层所添加的配置、文件。

如果我们可以把每一层修改、安装、构建、操作的命令都写入一个脚本，用这个脚本来构建、定制镜像，那么之前提及的无法重复的问题、镜像构建透明性的问题、体积的问题就都会解决。这个脚本就是`Dockerfile`。

#### Dockerfile 

Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。

#### 使用Dockerfile定制`commit`的镜像

* 在一个空白目录中，建立一个文本文件，并命名为 Dockerfile ：

```bash
$ mkdir nginx
$ cd nginx
$ touch Dockerfile
```

内容为：

```dockerfile
FROM nginx
RUN echo '<h1>Hello Docker!</h1>' > /usr/share/nginx/html/index.html
```

* FROM 指定基础镜像

  所谓定制镜像，那一定是以一个镜像为基础，在其上进行定制，就像我们之前运行了一个 nginx 镜像的容器，再进行修改一样，基础镜像是必须指定的。而FROM 就是指定基础镜像，因此一个 Dockerfile 中 FROM 是必备的指令，并
  且必须是第一条指令。

  在 Docker Hub 上有非常多的高质量的官方镜像，有可以直接拿来使用的服务类的镜像，如 nginx 、 redis 、 mongo 、 mysql 、 httpd 、 php 、 tomcat等；也有一些方便开发、构建、运行各种语言应用的镜像，如node 、 openjdk 、 python 、 ruby 、 golang 等。可以在其中寻找一个最符合我们最终目标的镜像为基础镜像进行定制。
  如果没有找到对应服务的镜像，官方镜像中还提供了一些更为基础的操作系统镜像，如 ubuntu 、 debian 、 centos 、 fedora 、 alpine 等，这些操作系统的软件库为我们提供了更广阔的扩展空间。
  除了选择现有镜像为基础镜像外，Docker 还存在一个特殊的镜像，名为scratch 。这个镜像是虚拟的概念，并不实际存在，它表示一个空白的镜像。

  如果你以 scratch 为基础镜像的话，意味着你不以任何镜像为基础，接下来所写的指令将作为镜像第一层开始存在。

* RUN 执行命令

  RUN 指令是用来执行命令行命令的。由于命令行的强大能力RUN 指令在定制镜像时是最常用的指令之一。其格式有两种：

  * shell 格式： RUN <命令> ，就像直接在命令行中输入的命令一样。刚才写的Dockerfile 中的 RUN 指令就是这种格式。

  ```bash 
    RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
  ```

  * exec 格式： RUN ["可执行文件", "参数1", "参数2"] ，这更像是函数调用中的格式。

* 样例

```dockerfile
FROM debian:stretch
RUN apt-get update
RUN apt-get install -y gcc libc6-dev make wget
RUN wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz"
RUN mkdir -p /usr/src/redis
RUN tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1
RUN make -C /usr/src/redis
RUN make -C /usr/src/redis install
```

之前说过，Dockerfile 中每一个指令都会建立一层， RUN 也不例外。每一个RUN 的行为，就和刚才我们手工建立镜像的过程一样：新建立一层，在其上执行这些命令，执行结束后， commit 这一层的修改，构成新的镜像。
而上面的这种写法，创建了 7 层镜像。这是完全没有意义的，而且很多运行时不需要的东西，都被装进了镜像里，比如编译环境、更新的软件包等等。结果就是产生非常臃肿、非常多层的镜像，不仅仅增加了构建部署的时间，也很容易出错。 这是很多初学 Docker 的人常犯的一个错误

Union FS 是有最大层数限制的，比如 AUFS，曾经是最大不得超过 42 层，现在是不得超过 127 层。
上面的 Dockerfile 正确的写法应该是这样：

```dockerfile
FROM debian:stretch
RUN buildDeps='gcc libc6-dev make wget' \
&& apt-get update \
&& apt-get install -y $buildDeps \
&& wget -O redis.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
&& mkdir -p /usr/src/redis \
&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
&& make -C /usr/src/redis \
&& make -C /usr/src/redis install \
&& rm -rf /var/lib/apt/lists/* \
&& rm redis.tar.gz \
&& rm -r /usr/src/redis \
&& apt-get purge -y --auto-remove $buildDeps
```

​	首先，之前所有的命令只有一个目的，就是编译、安装 redis 可执行文件。因此没有必要建立很多层，这只是一层的事情。因此，这里没有使用很多个 RUN 对一一对应不同的命令，而是仅仅使用一个 RUN 指令，并使用 && 将各个所需命令串联起来。将之前的 7 层，简化为了 1 层。在撰写 Dockerfile 的时候，要经常提醒自己，这并不是在写 Shell 脚本，而是在定义每一层该如何构建。

​	并且，这里为了格式化还进行了换行。Dockerfile 支持 Shell 类的行尾添加 \ 的命令换行方式，以及行首 # 进行注释的格式。良好的格式，比如换行、缩进、注释等，会让维护、排障更为容易，这是一个比较好的习惯。

​	此外，还可以看到这一组命令的最后添加了清理工作的命令，删除了为了编译构建所需要的软件，清理了所有下载、展开的文件，并且还清理了 apt 缓存文件。这是很重要的一步，我们之前说过，镜像是多层存储，每一层的东西并不会在下一层被删除，会一直跟随着镜像。因此镜像构建时，一定要确保每一层只添加真正需要添加的东西，任何无关的东西都应该清理掉。

​	很多人初学 Docker 制作出了很臃肿的镜像的原因之一，就是忘记了每一层构建的最后一定要清理掉无关文件

#### 构建镜像

```bash
$ docker build -t nginx:v3 .
Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM nginx
 ---> f09fe80eb0e7
Step 2/2 : RUN echo '<h1>Hello Docker!</h1>' > /usr/share/nginx/html/index.html
 ---> Running in 883ebb41a656
Removing intermediate container 883ebb41a656
 ---> 9d07eff28834
Successfully built 9d07eff28834
Successfully tagged nginx:v3
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.
```

```bash
docker build [选项] <上下文路径/URL/->
```

##### 镜像构建上下文路径

如果注意上面的执行的命令，你会看到 docker build 命令最后有一个`.`, 表示当前目录，而Dockerfile 就在当前目录，因此不少初学者以为这个路径是在指定Dockerfile 所在路径，这么理解其实是不准确的。如果对应上面的命令格式，你可能会发现，这是在指定上下文路径.

* 上下文路径
* 











































































## 常用命令

### 获取镜像

```php
docker pull
```

从仓库获取所需要的镜像。

使用示例：

```php
docker pull centos:centos6
```

实际上相当于 docker pull registry.hub.docker.com/centos:centos6命令，即从注册服务器 registry.hub.docker.com 中的 centos 仓库来下载标记为 centos6 的镜像。
有时候官方仓库注册服务器下载较慢，可以从其他仓库下载。 从其它仓库下载时需要指定完整的仓库注册服务器地址。

### 查看镜像列表

```php
docker images
```

列出了所有顶层（top-level）镜像。实际上，在这里我们没有办法区分一个镜像和一个只读层，所以我们提出了top-level镜像。只有创建容器时使用的镜像或者是直接pull下来的镜像能被称为顶层（top-level）镜像，并且每一个顶层镜像下面都隐藏了多个镜像层。

使用示例：

```php
$ docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
centos                   centos6             6a77ab6655b9        8 weeks ago         194.6 MB
ubuntu                   latest              2fa927b5cdd3        9 weeks ago         122 MB
```

在列出信息中，可以看到几个字段信息

- 来自于哪个仓库，比如 ubuntu
- 镜像的标记，比如 14.04
- 它的 ID 号（唯一）
- 创建时间
- 镜像大小

### 利用 Dockerfile 来创建镜像[ ](http://hainiubl.com/topics/13#%E5%88%A9%E7%94%A8-Dockerfile-%E6%9D%A5%E5%88%9B%E5%BB%BA%E9%95%9C%E5%83%8F)

```php
docker build
```

	使用 docker commit 来扩展一个镜像比较简单，但是不方便在一个团队中分享。我们可以使用docker build 来创建一个新的镜像。为此，首先需要创建一个 Dockerfile，包含一些如何创建镜像的指令。新建一个目录和一个 Dockerfile。

```php
mkdir hainiu
cd hainiu
touch Dockerfile
```

Dockerfile 中每一条指令都创建镜像的一层，例如：

```php
FROM centos:centos6
MAINTAINER sandywei <sandy@hainiu.tech>
# move all configuration files into container

RUN yum install -y httpd
EXPOSE 80
CMD ["sh","-c","service httpd start;bash"]
```

Dockerfile 基本的语法是

- 使用#来注释
- FROM 指令告诉 Docker 使用哪个镜像作为基础
- 接着是维护者的信息
- RUN开头的指令会在创建中运行，比如安装一个软件包，在这里使用yum来安装了一些软件

更详细的语法说明请参考 [Dockerfile](https://docs.docker.com/engine/reference/builder/)

编写完成 Dockerfile 后可以使用 docker build 来生成镜像。

```php
$ docker build -t hainiu/httpd:1.0 .

Sending build context to Docker daemon 2.048 kB
Step 1 : FROM centos:centos6
 ---> 6a77ab6655b9
Step 2 : MAINTAINER sandywei <sandy@hainiu.tech>
 ---> Running in 1b26493518a7
 ---> 8877ee5f7432
Removing intermediate container 1b26493518a7
Step 3 : RUN yum install -y httpd
 ---> Running in fe5b6f1ef888

 .....

 Step 5 : CMD sh -c service httpd start
 ---> Running in b2b94c1601c2
 ---> 5f9aa91b0c9e
Removing intermediate container b2b94c1601c2
Successfully built 5f9aa91b0c9e
```

其中 -t 标记来添加 tag，指定新的镜像的用户信息。 “.” 是 Dockerfile 所在的路径（当前目录），也可以替换为一个具体的 Dockerfile 的路径。注意一个镜像不能超过 127 层。

### 用docker images 查看镜像列表

```php
$ docker images
REPOSITORY                 TAG               IMAGE ID            CREATED             SIZE
hainiu/httpd               1.0               5f9aa91b0c9e        3 minutes ago       292.4 MB
centos                   centos6             6a77ab6655b9        8 weeks ago         194.6 MB
ubuntu                   latest              2fa927b5cdd3        9 weeks ago         122 MB
```

细心的朋友可以看到最后一层的ID（5f9aa91b0c9e）和 image id 是一样的

### 上传镜像

```php
docker push
```

用户可以通过 docker push 命令，把自己创建的镜像上传到仓库中来共享。例如，用户在 Docker Hub 上完成注册后，可以推送自己的镜像到仓库中。

运行实例：

```php
$ docker push hainiu/httpd:1.0
```

### 创建容器

```php
docker create <image-id>
```

docker create 命令为指定的镜像（image）添加了一个可读写层，构成了一个新的容器。注意，这个容器并没有运行。

docker create 命令提供了许多参数选项可以指定名字，硬件资源，网络配置等等。

运行示例：

创建一个centos的容器，可以使用仓库＋标签的名字确定image，也可以使用image－id指定image。返回容器id

```php
＃查看本地images列表
$ docker images

＃用仓库＋标签
$ docker create -it --name centos6_container centos:centos6

＃使用image－id
$ docker create -it --name centos6_container 6a77ab6655b9 bash
b3cd0b47fe3db0115037c5e9cf776914bd46944d1ac63c0b753a9df6944c7a67

#可以使用 docker ps查看一件存在的容器列表,不加参数默认只显示当前运行的容器
$ docker ps -a
```

可以使用 -v 参数将本地目录挂载到容器中。

```php
$ docker create -it --name centos6_container -v /src/webapp:/opt/webapp centos:centos6
```

这个功能在进行测试的时候十分方便，比如用户可以放置一些程序到本地目录中，来查看容器是否正常工作。本地目录的路径必须是绝对路径，如果目录不存在 Docker 会自动为你创建它。

### 启动容器

```php
docker start <container-id>
```

Docker start命令为容器文件系统创建了一个进程隔离空间。注意，每一个容器只能够有一个进程隔离空间。

运行实例：

```php
#通过名字启动
$ docker start -i centos6_container

＃通过容器ID启动
$ docker start -i b3cd0b47fe3d
```

### 进入容器

```php
docker exec <container-id>
```

在当前容器中执行新命令，如果增加 -it参数运行bash 就和登录到容器效果一样的。

```php
docker exec -it centos6_container bash
```

### 停止容器

```php
docker stop <container-id>
```

### 删除容器

```php
docker rm <container-id>
```

### 运行容器

```php
docker run <image-id>
```

docker run就是docker create和docker start两个命令的组合,支持参数也是一致的，如果指定容器
名字是，容器已经存在会报错,可以增加 --rm 参数实现容器退出时自动删除。

运行示例:

```php
docker create -it --rm --name centos6_container centos:centos6
```

### 查看容器列表

```php
docker ps
```

docker ps 命令会列出所有运行中的容器。这隐藏了非运行态容器的存在，如果想要找出这些容器，增加 -a 参数。

### 删除镜像

```php
docker rmi <image-id>
```

删除构成镜像的一个只读层。你只能够使用docker rmi来移除最顶层（top level layer）
（也可以说是镜像），你也可以使用-f参数来强制删除中间的只读层。

### commit容器

```php
docker commit <container-id>
```

将容器的可读写层转换为一个只读层，这样就把一个容器转换成了不可变的镜像。

### 镜像保存

```php
docker save <image-id>
```

创建一个镜像的压缩文件，这个文件能够在另外一个主机的Docker上使用。和export命令不同，这个命令
为每一个层都保存了它们的元数据。这个命令只能对镜像生效。

使用示例:

```php
#保存centos镜像到centos_images.tar 文件
$ docker save  -o centos_images.tar centos:centos6

＃或者直接重定向
$ docker save  -o centos_images.tar centos:centos6 > centos_images.tar
```

### 容器导出

```php
docker export <container-id>
```

创建一个tar文件，并且移除了元数据和不必要的层，将多个层整合成了一个层，只保存了当前统一视角看到
的内容。expoxt后的容器再import到Docker中，只有一个容器当前状态的镜像；而save后的镜像则不同，
它能够看到这个镜像的历史镜像。

### inspect

```php
docker inspect <container-id> or <image-id>
```
docker inspect命令会提取出容器或者镜像最顶层的元数据



