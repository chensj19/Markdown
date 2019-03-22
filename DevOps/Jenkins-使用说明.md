[TOC]

# Jenkins-使用说明

## 一、Jenkins安装

### 1、安装说明

#### (1) WAR文件

Jenkins的Web应用程序ARchive（WAR）文件版本可以安装在任何支持Java的操作系统或平台上。

**要下载并运行Jenkins的WAR文件版本，请执行以下操作:**

1. 将[最新的稳定Jenkins WAR包](http://mirrors.jenkins.io/war-stable/latest/jenkins.war) 下载到您计算机上的相应目录。
2. 在下载的目录内打开一个终端/命令提示符窗口到。
3. 运行命令java -jar jenkins.war
4. 浏览http://localhost:8080并等到*Unlock Jenkins*页面出现。
5. 继续使用[Post-installation setup wizard](https://jenkins.io/zh/doc/book/installing/#setup-wizard)后面步骤设置向导。

将[最新的稳定Jenkins WAR包](http://mirrors.jenkins.io/war-stable/latest/jenkins.war)下载到您计算机上的相应目录。

**Notes:**

- 不像在Docker中下载和运行有Blue Ocean的Jenkins，这个过程不会自动安装Blue Ocean功能， 这将分别需要在jenkins上通过 [**Manage Jenkins**](https://jenkins.io/zh/doc/book/managing) > [**Manage Plugins**](https://jenkins.io/zh/doc/book/managing/plugins/)安装。 在[Getting started with Blue Ocean](https://jenkins.io/zh/doc/book/blueocean/getting-started/)有关于安装Blue Ocean的详细信息 。.
- 您可以通过`--httpPort`在运行`java -jar jenkins.war`命令时指定选项来更改端口。例如，要通过端口9090访问Jenkins，请使用以下命令运行Jenkins： `java -jar jenkins.war --httpPort=9090`

```bash
$ java -jar jenkins.war --httpPort=9090
```

* 可以通过指定环境变量`JENKINS_HOME`，来设置Jenkins的工作目录

#### (2) 其他方式

请[**参考文档**](https://jenkins.io/zh/doc/book/installing/#%E5%AE%89%E8%A3%85%E5%B9%B3%E5%8F%B0)，包含Docker、Windows，Mac、Linux

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

### 2、项目构建

