# Maven 常用命令

```bash
# 下载源码 
mvn dependency:sources
# 下载Javadoc
mvn dependency:resolve -Dclassifier=javadoc
# 编译spring-boot
mvn clean install -U -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Dmaven.compile.fork=true -Dskip.springboot.package=true -T12
```

