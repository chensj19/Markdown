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

