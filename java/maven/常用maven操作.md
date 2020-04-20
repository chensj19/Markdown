# 常用maven操作

## 1、多模块指定一个模块打包

### 1.1 打包并放入本地仓库

```bash
mvn clean package install -pl 指定的模块名 -am
```

### 1.2 打包

```bash
mvn clean package  -pl 指定的模块名 -am
```

## 2、下载sources和javadocs

```bash
mvn dependency:sources -DdownloadSources=true -DdownloadJavadocs=true
```

> 使用参数下载源码包与doc包：
> -DdownloadSources=true 下载源代码jar
> -DdownloadJavadocs=true 下载javadoc包