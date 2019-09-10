# Jenkins

* 官网

  https://jenkins.io

* 下载

  * windows

    * https://jenkins.io/download/thank-you-downloading-windows-installer-stable

  * centos

    * 配置仓库

    ```bash
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    ```

    * 安装

    ```bash
    yum install jenkins
    ```

* 启动

  > [Download Jenkins](http://mirrors.jenkins.io/war-stable/latest/jenkins.war).
  >
  > Open up a terminal in the download directory.
  >
  > Run `java -jar jenkins.war --httpPort=8080`.
  >
  > Browse to `http://localhost:8080`.
  >
  > Follow the instructions to complete the installation.

* 端口修改

  jenkins.xml中修改httpPort

  ```xml
  --httpPort=8000 
  ```

* Linux 修改端口

```bash
$ vim /etc/default/jenkins
```

```
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
```

