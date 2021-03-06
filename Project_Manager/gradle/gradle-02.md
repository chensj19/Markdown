# Gradle 

## Groovy

### Groovy高效特性

```groovy
// 1 可选类型定义
def version = 1

// 2 assert
//assert version == 2

// 3 括号可选
println version

// 4 字符串
// 普通字符串
def s1 = 'chen'
// 可以添加变量的字符串
def s2 = "gradle version is ${version}"
// 带格式的字符串
def s3 = '''my
name
is
chen
'''

println s1
println s2
println s3

// 5 集合api
// list
def buildTools = ['ant','maven','gradle']
// 添加元素
buildTools << 'Gant'
// 验证
assert buildTools.getClass() == ArrayList
assert buildTools.size() == 4
// map
def buildYear = ['ant':2000,'maven':2004]
// 添加元素
buildYear.gradle = 2009

println buildYear.ant
println buildYear['gradle']
println buildYear.getClass()

// 6 闭包
// 定义一个带参数的闭包
def c1 = {
    v -> println v
}
// 定义一个不带参数的闭包
def c2 = {
    println 'hello'
}
// 定义一个调用使用参数的闭包的方法
def method1(Closure closure) {
    closure('param')
}
// 定义一个调用不使用参数的闭包的方法
def method2(Closure closure) {
    closure()
}

method1 (c1)
method2 (c2)
```

## build.gradle

```groovy
// 构建脚本都有一个默认的Project的实例
// Project 方法 plugins
plugins {
    id 'java'
}
// Project 属性 group
group 'org.chen.gradle'
// Project 属性 version
version '1.0-SNAPSHOT'

sourceCompatibility = 1.8

// Project 方法 repositories 闭包参数
repositories {
    mavenCentral()
}

// Project 方法 dependencies 闭包参数
dependencies {
    testCompile group: 'junit', name: 'junit', version: '4.12'
}
```

## 构建脚本

### 构建块

gradle构建中的两个基本概念是项目(**Project**)和任务(**Task**)，每个构建至少包含一个项目，项目中包含一个或者多个任务，在多项目构建中，一个项目可以依赖其他项目；类似的，任务可以形成一个依赖关系图来确保他们的执行顺序

### 项目

一个项目代表一个正在构建的组件(比如一个jar文件)，当构建启动后，Gradle会基于build.gradle实例化一个`org.gradle.api.Project`类，并能够通过project变量使其隐式可用

#### 常见属性

* group：groupId     组
* name：artifactId   名称
* version：version    版本号

通过上面三个属性基本上可以确定一个jar包的位置

#### 常用方法

* plugins: 定义使用的方法
* repositories： 依赖仓库
* dependencies：项目依赖
* task： 任务

#### 属性

ext、gradle.properties

### task

任务对应的是`org.gradle.api.Task`，主要包括任务动作和任务依赖。任务动作定义一个最小的工作单元，可以定义依赖其他任务、动作序列和执行条件

#### 常用方法

* dependsOn 声明依赖其他任务
* doFirst、doLast <<  简写，前者在最前方添加，后者是在最后添加

## 构建生命周期

任何Gradle的构建过程都分为三部分：初始化阶段、配置阶段和执行阶段。

### 初始化阶段

初始化阶段的任务是创建项目的层次结构，并且为每一个项目创建一个`Project`实例。
 与初始化阶段相关的脚本文件是`settings.gradle`（包括`/.gradle/init.d`目录下的所有.gradle脚本文件，这些文件作用于本机的所有构建过程）。一个`settings.gradle`脚本对应一个`Settings`对象，我们最常用来声明项目的层次结构的`include`就是`Settings`类下的一个方法，在Gradle初始化的时候会构造一个`Settings`实例对象，它包含了下图中的方法，这些方法都可以直接在`settings.gradle`中直接访问。

![img](https:////upload-images.jianshu.io/upload_images/4780870-f6b4ceb230538cac.png?imageMogr2/auto-orient/strip|imageView2/2/w/500/format/webp)
 比如可以通过如下代码向Gradle的构建过程添加监听：

```java
gradle.addBuildListener(new BuildListener() {
  void buildStarted(Gradle var1) {
    println '开始构建'
  }
  void settingsEvaluated(Settings var1) {
    println 'settings评估完成（settins.gradle中代码执行完毕）'
    // var1.gradle.rootProject 这里访问Project对象时会报错，还未完成Project的初始化
  }
  void projectsLoaded(Gradle var1) {
    println '项目结构加载完成（初始化阶段结束）'
    println '初始化结束，可访问根项目：' + var1.gradle.rootProject
  }
  void projectsEvaluated(Gradle var1) {
    println '所有项目评估完成（配置阶段结束）'
  }
  void buildFinished(BuildResult var1) {
    println '构建结束 '
  }
})
```

执行`gradle build`，打印结果如下：

```ruby
settings评估完成（settins.gradle中代码执行完毕）
项目结构加载完成（初始化阶段结束）
初始化结束，可访问根项目：root project 'GradleTest'
所有项目评估完成（配置阶段结束）
:buildEnvironment

------------------------------------------------------------
Root project
------------------------------------------------------------

classpath
No dependencies

BUILD SUCCESSFUL

Total time: 0.959 secs
构建结束 
```

### 配置阶段

配置阶段的任务是执行各项目下的`build.gradle`脚本，完成Project的配置，并且构造`Task`任务依赖关系图以便在执行阶段按照依赖关系执行`Task`。
 该阶段也是我们最常接触到的构建阶段，比如应用外部构建插件`apply plugin: 'com.android.application'`，配置插件的属性`android{ compileSdkVersion 25 ...}`等。每个`build.gralde`脚本文件对应一个`Project`对象，在初始化阶段创建，`Project`的[接口文档](https://link.jianshu.com?t=https%3A%2F%2Fdocs.gradle.org%2Fcurrent%2Fjavadoc%2Forg%2Fgradle%2Fapi%2FProject.html)。
 配置阶段执行的代码包括`build.gralde`中的各种语句、闭包以及`Task`中的配置段语句，在根目录的`build.gradle`中添加如下代码：

```java
println 'build.gradle的配置阶段'

// 调用Project的dependencies(Closure c)声明项目依赖
dependencies {
    // 闭包中执行的代码
    println 'dependencies中执行的代码'
}

// 创建一个Task
task test() {
  println 'Task中的配置代码'
  // 定义一个闭包
  def a = {
    println 'Task中的配置代码2'
  }
  // 执行闭包
  a()
  doFirst {
    println '这段代码配置阶段不执行'
  }
}

println '我是顺序执行的'
```

调用`gradle build`，得到如下结果：

```css
build.gradle的配置阶段
dependencies中执行的代码
Task中的配置代码
Task中的配置代码2
我是顺序执行的
:buildEnvironment

------------------------------------------------------------
Root project
------------------------------------------------------------

classpath
No dependencies

BUILD SUCCESSFUL

Total time: 1.144 secs
```

**一定要注意，配置阶段不仅执行`build.gradle`中的语句，还包括了`Task`中的配置语句。**从上面执行结果中可以看到，在执行了dependencies的闭包后，直接执行的是任务test中的配置段代码（`Task`中除了Action外的代码段都在配置阶段执行）。
 另外一点，无论执行Gradle的任何命令，**初始化阶段和配置阶段的代码都会被执行**。
 同样是上面那段Gradle脚本，我们执行帮助任务`gradle help`，任然会打印出上面的执行结果。我们在排查构建速度问题的时候可以留意，是否部分代码可以写成任务Task，从而减少配置阶段消耗的时间。

### 执行阶段

在配置阶段结束后，Gradle会根据任务[Task](https://link.jianshu.com?t=https%3A%2F%2Fdocs.gradle.org%2Fcurrent%2Fjavadoc%2Forg%2Fgradle%2Fapi%2FTask.html)的依赖关系创建一个有向无环图，可以通过`Gradle`对象的`getTaskGraph`方法访问，对应的类为[TaskExecutionGraph](https://link.jianshu.com?t=https%3A%2F%2Fdocs.gradle.org%2Fcurrent%2Fjavadoc%2Forg%2Fgradle%2Fapi%2Fexecution%2FTaskExecutionGraph.html)，然后通过调用`gradle <任务名>`执行对应任务。

下面我们展示如何调用子项目中的任务。

1. 在根目录下创建目录subproject，并添加文件build.gradle
2. 在settings.gradle中添加`include ':subproject'`
3. 在subproject的build.gradle中添加如下代码

```java
task grandpa {
  doFirst {
    println 'task grandpa：doFirst 先于 doLast 执行'
  }
  doLast {
    println 'task grandpa：doLast'
  }
}

task father(dependsOn: grandpa) {
  doLast {
    println 'task father：doLast'
  }
}

task mother << {
  println 'task mother 先于 task father 执行'
}

task child(dependsOn: [father, mother]){
  doLast {
    println 'task child 最后执行'
  }
}

task nobody {
  doLast {
    println '我不执行'
  }
}
// 指定任务father必须在任务mother之后执行
father.mustRunAfter mother
```

它们的依赖关系如下：



```ruby
:subproject:child
+--- :subproject:father
|    \--- :subproject:grandpa
\--- :subproject:mother
```

执行`gradle :subproject:child`，得到如下打印结果：



```css
:subproject:mother
task mother 先于 task father 执行
:subproject:grandpa
task grandpa：doFirst 先于 doLast 执行
task grandpa：doLast
:subproject:father
task father：doLast
:subproject:child
task child 最后执行

BUILD SUCCESSFUL

Total time: 1.005 secs
```

因为在配置阶段，我们声明了任务mother的优先级高于任务father，所以mother先于father执行，而任务father依赖于任务grandpa，所以grandpa先于father执行。任务nobody不存在于child的依赖关系中，所以不执行。

### Hook点

Gradle提供了非常多的钩子供开发人员修改构建过程中的行为，为了方便说明，先看下面这张图。

![Gradle构建周期中的Hook点](https:////upload-images.jianshu.io/upload_images/4780870-aa344276a97f09cb.png?imageMogr2/auto-orient/strip|imageView2/2/w/586/format/webp)


 Gradle在构建的各个阶段都提供了很多回调，我们在添加对应监听时要注意，**监听器一定要在回调的生命周期之前添加**，比如我们在根项目的build.gradle中添加下面的代码就是错误的：

```java
gradle.settingsEvaluated { setting ->
  // do something with setting
}

gradle.projectsLoaded { 
  gradle.rootProject.afterEvaluate {
    println 'rootProject evaluated'
  }
}
```

当构建走到build.gradle时说明初始化过程已经结束了，所以上面的回调都不会执行，把上述代码移动到settings.gradle中就正确了。

## 依赖管理

几乎所有的基于jvm的软件项目都是需要依赖外部类库来重用现有功能。自动化的依赖管理可以明确依赖的版本，可以解决因传递性依赖带来的版本冲突

### 关键概念

* 工件坐标 group、name、version

* 常用仓库 ：

  * mavenCenter、jcenter、mavenLocal
  * 自定义maven仓库
  * 文件仓库

* 依赖传递性

  * B依赖A、如果C依赖B，那么C依赖A

  * 依赖阶段配置

    * compile、runtime
    * testCompile、testRuntime

    

  

  

  

  