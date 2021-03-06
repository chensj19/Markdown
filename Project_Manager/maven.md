# Maven 常用配置

## settings.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <!--指定本地仓库-->  
  <localRepository>/home/chensj/maven_repo</localRepository>
  <pluginGroups>
  </pluginGroups>
  <proxies>
  </proxies>
  <servers>
  </servers>
  <mirrors>
    <!--指定默认使用的仓库-->  
    <mirror>
      <id>ali-nexus</id>
      <mirrorOf>*</mirrorOf> 
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
    </mirror>
  </mirrors>
  <profiles>
  </profiles>
</settings>
```

## 常用仓库

* 阿里Maven仓库  统一仓库
  * `http://maven.aliyun.com/nexus/content/groups/public/`
  * 阿里 spring仓库
    * `https://maven.aliyun.com/repository/spring`
  * 阿里central仓库
    * `https://maven.aliyun.com/repository/central`
* spring 仓库
  * `milestone`
    * `https://repo.spring.io/milestone`

## 源码与文档

```bash
# 源码
$ mvn dependency:sources
# 文档
$ mvn dependency:resolve -Dclassifier=javadoc
```

## 多mirror切换

我们知道 settings.xml 中可以使用变量，可以尝试使用变量解决。

```xml
<mirrors>
  <mirror>
    <id>aliyun</id>
    <url>https://maven.aliyun.com/repository/public</url>
	<mirrorOf>${aliyun}</mirrorOf>
  </mirror>
  <mirror>
    <id>netease</id>
    <url>http://mirrors.163.com/maven/repository/maven-public/</url>
    <mirrorOf>${netease}</mirrorOf>
  </mirror>
   <mirror>
    <id>default</id>
    <url>http://192.168.0.100/nexus/repository/maven-public/</url>
    <mirrorOf>central</mirrorOf>
  </mirror>
</mirrors>
```

我们知道，默认情况下配置多个mirror的情况下，只有第一个生效。那么我们可以将最后一个作为默认值，前面配置的使用环境变量动态切换。

默认情况下，执行： mvn help:effective-settings 可以看到使用的是私服。

如果希望使用阿里云镜像，如下执行：

```
mvn help-effective-settings -Daliyun=central
```

同样的道理，使用网易镜像，则执行：

```
mvn help:effective-settings -Dnetease=central
```

测试无误。

