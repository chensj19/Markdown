[TOC]

# Jenkins-使用说明

## 一、Jenkins安装

### 1、安装说明

#### (1) WAR文件

Jenkins的Web应用程序ARchive（WAR）文件版本可以安装在任何支持Java的操作系统或平台上。

**要下载并运行Jenkins的WAR文件版本，请执行以下操作:**

1. https://jenkins.io/download/thank-you-downloading-windows-installer-stable
2. 将[最新的稳定Jenkins WAR包](http://mirrors.jenkins.io/war-stable/latest/jenkins.war) 下载到您计算机上的相应目录。
3. 在下载的目录内打开一个终端/命令提示符窗口到。
4. 运行命令java -jar jenkins.war
5. 浏览http://localhost:8080并等到*Unlock Jenkins*页面出现。
6. 继续使用[Post-installation setup wizard](https://jenkins.io/zh/doc/book/installing/#setup-wizard)后面步骤设置向导。

将[最新的稳定Jenkins WAR包](http://mirrors.jenkins.io/war-stable/latest/jenkins.war)下载到您计算机上的相应目录。

**Notes:**

- 不像在Docker中下载和运行有Blue Ocean的Jenkins，这个过程不会自动安装Blue Ocean功能， 这将分别需要在jenkins上通过 [**Manage Jenkins**](https://jenkins.io/zh/doc/book/managing) > [**Manage Plugins**](https://jenkins.io/zh/doc/book/managing/plugins/)安装。 在[Getting started with Blue Ocean](https://jenkins.io/zh/doc/book/blueocean/getting-started/)有关于安装Blue Ocean的详细信息 。.
- 您可以通过`--httpPort`在运行`java -jar jenkins.war`命令时指定选项来更改端口。例如，要通过端口9090访问Jenkins，请使用以下命令运行Jenkins： `java -jar jenkins.war --httpPort=9090`

```bash
$ java -jar jenkins.war --httpPort=9090
```

* 可以通过指定环境变量`JENKINS_HOME`，来设置Jenkins的工作目录

#### (2) 其他方式

- 官网

  https://jenkins.io

- 下载

  - centos

    - 配置仓库

    ```bash
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    ```

    - 安装

    ```bash
    yum install jenkins
    ```

- 启动

  > [Download Jenkins](http://mirrors.jenkins.io/war-stable/latest/jenkins.war).
  >
  > Open up a terminal in the download directory.
  >
  > Run `java -jar jenkins.war --httpPort=8080`.
  >
  > Browse to `http://localhost:8080`.
  >
  > Follow the instructions to complete the installation.

- 端口修改

  jenkins.xml中修改httpPort

  ```xml
  --httpPort=8000 
  ```

- Linux 修改端口

```bash
$ vim /etc/default/jenkins
```

- 清华源

```bash
https://mirrors.tuna.tsinghua.edu.cn/jenkins/redhat/
# plugin
http://mirror.xmission.com/jenkins/updates/update-center.json   # 推荐
http://mirrors.shu.edu.cn/jenkins/updates/current/update-center.json
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
```

#### (3) nginx 代理

```bash
location / {
      proxy_pass http://127.0.0.1:8080;
      proxy_redirect off;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
}
```

```
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
```

### 2、安装后设置向导

下载安装并运行Jenkins后，即将开始进入安装向导。

此安装向导会引导您完成几个快速“一次性”步骤来解锁Jenkins， 使用插件对其进行自定义，并创建第一个可以继续访问Jenkins的管理员用户。

#### (1) 解锁 Jenkins

当您第一次访问新的Jenkins实例时，系统会要求您使用自动生成的密码对其进行解锁。

1. 浏览到 `http://localhost:8080`（或安装时为Jenkins配置的任何端口），并等待 **解锁 Jenkins** 页面出现。

![](https://jenkins.io/zh/doc/book/resources/tutorials/setup-jenkins-01-unlock-jenkins-page.jpg)

2. 从Jenkins控制台日志输出中，复制自动生成的字母数字密码（在两组星号之间）。

   ![](https://jenkins.io/zh/doc/book/resources/tutorials/setup-jenkins-02-copying-initial-admin-password.png)

   

3. 在 **解锁Jenkins** 页面上，将此 **密码** 粘贴到管理员密码字段中，然后单击 **继续** 

**Notes:**

- 如果您以分离模式在Docker中运行Jenkins，则可以从Docker日志（[above](https://jenkins.io/zh/doc/book/installing/#accessing-the-jenkins-console-log-through-docker-logs)） 访问Jenkins控制台日志。
- Jenkins控制台日志显示可以获取密码的位置（在Jenkins主目录中）。 必须在新Jenkins安装中的安装向导中输入此密码才能访问Jenkins的主UI。 如果您在设置向导中跳过了后续的用户创建步骤， 则此密码还可用作默认admininstrator帐户的密码（使用用户名“admin”）

#### (2) 自定义jenkins插件

[解锁 Jenkins](https://jenkins.io/zh/doc/book/installing/#unlocking-jenkins)之后，在 **Customize Jenkins** 页面内， 您可以安装任何数量的有用插件作为您初始步骤的一部分。

两个选项可以设置:

- **安装建议的插件** - 安装推荐的一组插件，这些插件基于最常见的用例.
- **选择要安装的插件** - 选择安装的插件集。当你第一次访问插件选择页面时，默认选择建议的插件。

> 如果您不确定需要哪些插件，请选择 **安装建议的插件** 。 您可以通过Jenkins中的[**Manage Jenkins**](https://jenkins.io/zh/doc/book/managing) > [**Manage Plugins**](https://jenkins.io/zh/doc/book/managing/plugins/) 页面在稍后的时间点安装（或删除）其他Jenkins插件 。

设置向导显示正在配置的Jenkins的进程以及您正在安装的所选Jenkins插件集。这个过程可能需要几分钟的时间

#### (3) 创建第一个管理员用户

最后，在[customizing Jenkins with plugins](https://jenkins.io/zh/doc/book/installing/#customizing-jenkins-with-plugins)之后，Jenkins要求您创建第一个管理员用户。 . 出现“ **创建第一个管理员用户** ”页面时， 请在各个字段中指定管理员用户的详细信息，然后单击 **保存完成** 。 . 当 **Jenkins准备好了** 出现时，单击*开始使用 Jenkins*。

**Notes:** * 这个页面可能显示 **Jenkins几乎准备好了!** 相反，如果是这样，请单击 **重启** 。 * 如果该页面在一分钟后不会自动刷新，请使用Web浏览器手动刷新页面。如果需要，请使用您刚刚创建的用户的凭据登录到Jenkins，并准备好开始使用Jenkins！

## 二、构建项目

### 1、安装插件

* VSTS    
  * Team Foundation Server
  * VS Team Services Continuous Deployment
* Gitee
  * Gitee
* NodeJS
  * NodeJS

### 2、项目构建

#### (1) Node.js项目

* 系统中需要安装好NodeJS、Tar打包工具

* Jenkins配置

  * 配置NodeJS 

    * 在`系统管理\全局工具配置`配置NodeJS的环境参数

    ![NodeJS](https://img-blog.csdnimg.cn/20190322223317411.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

  * 项目创建

    * 新建任务  输入任务名称
    * 选择**构建一个自由风格的软件项目**
    * 选择**源代码管理器**

    ![源码管理](https://img-blog.csdnimg.cn/20190322223450147.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

    * `Workspace name` 注意修改这个参数，使用TFS的时候需要进行自定义，避免报错

    * **构建触发器** 输入自定义的构建参数

    * **构建环境** 选择`Provide Node & npm bin/ folder to PATH`并且将前面配置的`NodeJS`选好

    * **构建** 根据使用操作系统，选择不同的构建方式

      * windows

        * **执行 Windows 批处理命令** 

        ```bash
        $ cnpm i &cnpm run build & tar -cvf mbk.tar mbk
        ```

#### (2) Java项目

* 系统需要配置Java、Maven、Gradle

* Jenkins配置

  * 配置Java、Maven、Gradle

    * 在`系统管理\全局工具配置`配置Java、Maven、Gradle的环境参数

      * JDK

      ![JDK](https://img-blog.csdnimg.cn/20190322223516536.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

      * Maven

        ![Maven](https://img-blog.csdnimg.cn/2019032222354636.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

      * Gradle

      ![ Gradle](https://img-blog.csdnimg.cn/20190322223604498.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

    

  * 项目构建

    * 创建任务

    ![创建任务](https://img-blog.csdnimg.cn/20190322223624927.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

    * 配置任务

      * 项目描述和JDK选择

      ![项目描述和JDK选择](https://img-blog.csdnimg.cn/20190322223920455.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

      * **源码管理**

        ![源码管理](https://img-blog.csdnimg.cn/20190322223937696.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

        * 在输入`Project Path`的时候会出现错误，这个时候可以不用管它，继续操作

          ![错误](https://img-blog.csdnimg.cn/20190322224044525.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

      * **构建**

        * 根据项目类型选择Maven、Gradle、Ant等项目

        * ![项目类型](https://img-blog.csdnimg.cn/20190322224121566.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

        * ```bash
          clean -DskipTests install -P prod
          ```

        > -P 为自定义参数，指定使用环境参数

    * 测试任务

      * 保存任务，立即构建，检查是否存在问题，出现下面的信息，代表创建成功

      ![测试任务](https://img-blog.csdnimg.cn/20190322224140799.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2NzajEzNjU1NTUyNDc4,size_16,color_FFFFFF,t_70)

## 三、Linux下开机启动配置

切换目录到`/etc/init.d/`位置，创建脚本`jenkins`:

```bash
#!/usr/bin/env bash
# chkconfig: 2345 20 80
#description: start and stop server
JENKINS_ROOT=/opt/jenkins
JENKINSFILENAME=jenkins.war
case $1 in
    start)
        echo "Starting $JENKINSFILENAME ..."  
        nohup $JENKINS_ROOT/startup.sh >> $JENKINS_ROOT/jenkins-run.log 2>&1 &
        ;;
    stop)
        echo "stopping $$JENKINSFILENAME ..."
        ps -ef|grep $JENKINSFILENAME |awk '{print $2}'|while read pid  
        do
           kill -9 $pid
           echo " $pid kill"  
        done
        ;;
    restart)
        "$0" stop
        sleep 3
        "$0" start
        ;;
    status)
        ps -ef|grep $JENKINSFILENAME*
        ;;
    *)
        printf 'Usage: %s {start|stop|restart|status}\n' "$prog"
        ;;
esac
```

**`startup.sh`**:

```bash
#!/bin/bash
JENKINS_ROOT=/opt/jenkins
export JENKINS_HOME=/opt/jenkins_home
/opt/jdk1.8.0_181/bin/java -jar $JENKINS_ROOT/jenkins.war --httpPort=9090
```

**配置开机项**

```bash
$ chkconfig --add jenkins
```

完成上述配置即可实现开机启动`Jenkins`

## 四、Docker中使用

```dockerfile
FROM centos
ADD jdk-8u181-linux-x64.tar.gz /usr/local/
ADD node-v10.15.3-linux-x64.tar.xz /usr/local/
#ADD apache-tomcat-9.0.17.tar.gz /usr/local/
ADD apache-maven-3.6.0-bin.tar.gz /usr/local/
ADD gradle-5.3.tar.gz /usr/local/
CMD mkdir /opt/jenkins
CMD mkdir /opt/jenkins_home
ADD jenkins.war /opt/jenkins/
ENV JAVA_HOME /usr/local/jdk1.8.0_181
#ENV CATALINA_HOME /usr/local/apache-tomcat-9.0.17
#ENV CATALINA_BASE /usr/local/apache-tomcat-9.0.17
ENV GRADLE_HOME /usr/local/gradle-5.3
ENV MAVEN_HOME /usr/local/apache-maven-3.6.0
ENV NODE_HOME /usr/local/node-v10.15.3-linux-x64
ENV JENKINS_ROOT /opt/jenkins
ENV JENKINS_HOME /opt/jenkins_home
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
#ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin:$GRADLE_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin
ENV PATH $PATH:$JAVA_HOME/bin:$GRADLE_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin
EXPOSE 8080
#CMD yum install -y git
CMD java -jar $JENKINS_ROOT/jenkins.war >> $JENKINS_ROOT/jenkins-run.log
```



## 五、**jenkins解决构建完成后自动杀掉衍生进程**

在存在子进程的情况下会使用nohup等shell命令会照成进程卡死的状态，主要是由于**jenkins解决构建完成后自动杀掉衍生进程**

解决方法

```bash
# 添加启动参数 -Dhudson.util.ProcessTree.disable=true
java -Dhudson.util.ProcessTree.disable=true -jar jenkins.war
# 对于rpm安装的jenkins 则需要修改
vim  /etc/sysconfig/jenkins
# 在JENKINS_JAVA_OPTIONS修改为如下参数
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Dhudson.util.ProcessTree.disable=true "
```

## 六、Nginx 无法转发

```bash
setsebool -P httpd_can_network_connect 1
```

## 七、 jenkins反向代理配置

### 7.1 根路径

```bash
location / {
    proxy_pass http://localhost:8080;
    proxy_read_timeout  90;
    proxy_set_header X-Forwarded-Host $host:$server_port;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### 7.2 指定前缀

假设指定前缀为`/jenkins`

#### 配置Jenkins

修改`/etc/sysconfig/jenkins`，在`JENKINS_ARGS`参数中添加：

```bash
--prefix=/jenkins
```

重启Jenkins:

```bash
systemctl restart jenkins
```
运行`systemctl status jenkins -l`查看JENKINS_ARGS是否生效。

在浏览器中访问`http://<server_ip>:<jenkins_port>/jenkins`，打开`Manage Jenkins/Configure System`，将Jenkins URL后添加`/jenkins`

#### 配置nginx

```nginx
location /jenkins/ {
    proxy_pass http://localhost:8080/jenkins/;
    proxy_read_timeout  90;
    proxy_set_header X-Forwarded-Host $host:$server_port;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
}
```

## 八、 更新慢

```bash
cd cd {你的Jenkins工作目录}/updates  #进入更新配置位置
#将default.json中内容替换
http://updates.jenkins-ci.org/download/
http://mirrors.tuna.tsinghua.edu.cn/jenkins/

http://www.google.com/ 
https://www.baidu.com/
sed -i 's/updates.jenkins.io/mirrors.tuna.tsinghua.edu.cn\/jenkins\/updates/g' hudson.model.UpdateCenter.xml
sed -i 's/www.google.com/www.baidu.com/g' default.json
sed -i 's/updates.jenkins-ci.org\/download/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json
sed -i 's/updates.jenkins.io\/download/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
```

## 九、Jenkins Control Plugin 

idea 安装 Jenkins Control Plugin 

在 Intellij 中设置Jenkins 服务器，确保测试成功。

<img src="https://img-blog.csdnimg.cn/20190108170759307.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3NpbmF0XzM2NzEwNDU2,size_16,color_FFFFFF,t_70"/>

建议：如果启用 CSRF的话（默认启用），到 系统管理 -> Configure Global Security（全局安全配置）中, 勾选下图选项.

![](https://img-blog.csdnimg.cn/20190108164848985.png)

注意：如果你用的是 jenkins 2, 并且启用了 CSRF(防止跨站点请求伪造），需要填 Crumb Data， 这个可以通过以下url获取:

```bash
curl -s 'http://admin:admin@localhost:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
Jenkins-Crumb:78dcf95a78567cf3a88e073e906081f57b2b389a9d63a4b8d0e6a45a6938bc61
```

> 注意 在使用账号与密码、账号与API TOKEN的时候产生的Crumb Data 是不一样的

