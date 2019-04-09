# Gradle

## 一、创建一个简单的Gradle项目

1. 参考[官方文档](<https://docs.gradle.org/current/userguide/getting_started.html>)，选择[Building Java libraries](https://guides.gradle.org/building-java-libraries/)项目

2. 初始化项目

   ```bash
   $ gradle init --type java-library --project-name gradle-java-demo
   > Task :wrapper
   > Task :init
   
   BUILD SUCCESSFUL in 4s
   2 actionable tasks: 2 executed
   ```

3. 执行完成后目录结构如下

   ```groovy
   .
   ├── build.gradle
   ├── gradle
   │   └── wrapper 
   │       ├── gradle-wrapper.jar
   │       └── gradle-wrapper.properties
   ├── gradlew
   ├── gradlew.bat
   ├── settings.gradle
   └── src
       ├── main
       │   └── java 
       │       └── Library.java
       └── test
           └── java 
               └── LibraryTest.java
   ```

4. 文件树说明

   1. `gradle/wrapper` 是生成的`wrapper` 文件

   2. `src/main/java`  是`java`源代码文件

   3. `src/test/java`   是`java`测试文件

   4. `settings.gradle `

      ```groovy
      rootProject.name = 'gradle-java-demo'
      ```

      1. 这个文件只有一句话，用来说明根项目的名称

   5. `build.gradle` 

      该文件还是具有许多内容，具体内容如下

      ```groovy
      // 构建的插件库，下面使用的是java的基础插件库
      plugins {
          id 'java-library'
      }
      // 公共的仓库地址
      repositories {
          jcenter()
      }
      // 项目依赖
      dependencies {
          // 导出给消费者的依赖关系，在他们的编译类路径上可以找到
          api 'org.apache.commons:commons-math3:3.6.1'
          //依赖关系，在内部使用
          implementation 'com.google.guava:guava:27.0.1-jre'
          // 测试资源
          testImplementation 'junit:junit:4.12'
      }
      
      ```

      