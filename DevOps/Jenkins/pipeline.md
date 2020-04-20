# Jenkins Pipeline

## Pipeline 简介

通过代码来描述部署流水线

优点：

1. 代码更好的版本化，Pipeline以代码形式实现，通常被检入源代码控制，使团队能够编辑、审查和迭代其CD流程
2. 可持续性：jenkins重启或者中断后不会影响Pipeline Job，方便Job配置迁移与版本迭代
3. 停顿：Pipeline可以选择停止并等待输入或者批准，然后继续Pipeline运行
4. 多功能：Pipeline支持现实世界的复杂CD要求，包括fork/join子进程，循环和并行执行工作的能力
5. 可扩展： Pipeline 插件支持其DSL的自定义扩展以及与其他插件集成的多个选项

Jenkins Pipeline 的定义通常被写入一个文本文件(Jenkinsfile)中，该文件可以被放入源代码控制库中

> Jenkinsfile不一定要叫做Jenkinsfile，可以在源代码中自定义

创建方式：

1. 在Jenkins中使用 Pipeline Scripts
2. 将Jenkinsfile放置到GitHub中

## 一个简单Pipeline

```pipeline
pipeline {
    agent any
    stages {
      stage('build'){
        steps{
          echo "hello echo first pipeline"
        }
      }
    }
}
```

## Pipeline 构成

### Pipeline基本结构

下面的结构是Jenkins Pipeline的基本结构，少一部分Jenkins都会报错

```pipeline
pipeline {
    agent any
    stages {
      stage('build'){
        steps{
          echo "hello echo first pipeline"
        }
      }
    }
}
```

pipeline：代表整条流水线，包含整个流水线的逻辑

stage：阶段，代表流水线的阶段，每个阶段都必须有名称

stages：流水线中多个stage的容器，一个stages必须包含至少一个stage

steps：代表stage中一个或者多个具体步骤的容器，steps部分至少包含一个步骤

agent：指定流水线执行的位置，流水线中每个阶段都必须在某个地方执行，agent部分就是用于指定具体在哪里执行

agent {label '****-slave'}

可选结构：

post：包含的是在整个pipeline或stage完成后的附加步骤

* always: 无论pipeline运行完成状态如何，都会执行的代码
* changes: 只有当前pipeline运行状态与之前的运行状态不同的时候才会触发执行
* failure:当前完成状态为失败时执行
* success:当前状态为成功时执行

pipeline支持的指令

* environment：用于设置环境变量，可定义在stage或者pipeline部分，环境变量可以设置为全局的变量，也可以在stage中设置为局部变量
* tools： 可定义在stage或者pipeline部分,会自动下载并安装我们指定的工具，并将其加入到path中
* input：定义在stage部分，会暂停pipeline，提示输入内容
* options： 用于配置Jenkins Pipeline本身的选项，可定义在stage或者pipeline部分
* parallel：并行执行多个step
* parameters： 与input不同，parameters是执行pipeline之前传入的一些参数
* triggers： 定义执行pipeline的触发器
* when： 当满足when条件的时候，阶段才会触发

注意：指令都是存在自己的作用域，位置不正确，Jenkins会报错

## Pipeline写法

pipeline默认支持两种写法：声明式和脚本式

### 声明式( **Declarative** )

```groovy
pipeline {
    agent any 
    stages {
        stage('Build') { 
            steps {
                println "Build" 
            }
        }
        stage('Test') { 
            steps {
                println "Test" 
            }
        }
        stage('Deploy') { 
            steps {
                println "Deploy" 
            }
        }
    }
}
```

上面是一个Declarative类型的Pipeline，这个，我前面说过，基本上实际开发都采用这个。虽然Scripted模式的Pipeline代码行数精简，很短，上面Declarative有20行代码，如果用Scripted模式，就10行代码。但是Scripted脚本很灵活，不好写，也不好读，维护起来相等困难。我们先来学习Declartive里面代码含义，有些基础知识在Scripted也有，有些却没有。

1）第一行是小写pipeline，然后一对大括{}，学习过代码的人都知道，大括号里面就是代码块，用来和别的代码块隔离出来。pipeline是一个语法标识符，前面我叫关键字。如果是Declarative类型，一定是pipeline {}这样起头的。当然脚本文件，pipeline不要求一定是第一行代码。也就是说pipeline前面可以有其他代码，例如导入语句，和其他功能代码。pipeline是一个执行pipeline代码的入口，jenkins可以根据这个入门开始执行里面不同stage

2）第二行agent any，agent是一个语法关键字，any是一个option类型。agent是代理的意思，这个和选择用jenkins平台上那一台机器去执行任务构建有关。我当然jenkins只有一个master节点，没有添加第二个节点机器，后面文章，等我们专门学习agent这个指令的时候，再来介绍如何添加一个节点。等添加了新节点，我们这个地方就可以选择用master还是一个从节点机器来执行任务，所以any是指任意一个可用的机器，当然我环境就是master。

3）第三行stages{}, stages是多个stage的意思，也就是说一个stages可以包含多个stage，从上面代码结果你也可以看出来。上面写了三个stage，根据你任务需要，你可以写十多个都可以。

4）第四行stage('Build') {}, 这个就是具体定义一个stage,一般一个stage就是指完成一个业务场景。‘Build’是认为给这个任务取一个名字。这个名称可以出现在Jenkins任务的页面上，在我前面一篇文章结尾处的图片可以显示着三个stage的名称，分别是Build,Test，和Deploy。

5）第五行steps{},字面意思就是很多个步骤的意思。这里提一下，看到了steps，当然还有step这个指令。一般来说，一个steps{}里面就写几行代码，或者一个try catch语句。

6）第六行，这个地方可以定义变量，写调用模块代码等。这里，我就用Groovy语法，写了一个打印语句。如果你机器没有安装groovy，你安装了python，你可以写python的打印语句，或者用linux的shell，例如sh "echo $JAVA_HOME"

后面的stage含义就是一样的，上面写了三个state,描述了三个业务场景，例如打包build,和测试Test,以及部署，这三个串联起来就是一个典型的CD Pipeline流程。实际的肯定不是这么写，因为Test就包含很多个阶段，和不同测试类型。这些不同测试类型，都可以细分成很多个stage去完成。

### 脚本式( **Scripted** )

```groovy

node {  
    stage('Build') { 
        // 
    }
    stage('Test') { 
        // 
    }
    stage('Deploy') { 
        // 
    }
}
```

这个代码，有两点和上面不同。第一个是Scripted模式是node{}开头，并没有pipeline{},这个区别好知道。第二个要指出的是，scripted模式下没有stages这个关键字或者指令，只有stage。上面其实可以node('Node name') {}来开头，Node name就是从节点或master节点的名称。

​		基本代码含义就讲解到这里，很简单，需要把这几个常见的指令熟记就行。不管哪种模式，你都要注意一对{}，特别是多层嵌套，不要丢了或者少了一些结束大括号。再提一个注释语法，由于pipeline是采用groovy语言设计的，而groovy是依赖java的，所以上面//表示注释的意思。

## Pipeline语法

1.Pipeline语法引用官网地址

接下来的Pipeline语法和部分练习代码都来着官网，地址是：https://jenkins.io/doc/book/pipeline/syntax/

我个人认为官网的文章组织不适合初学者，有些Pipeline代码穿插了很多docker的知识进去，但是我们没有学docker，这样给初学者造成很大的学习压力和负担。

2.Declarative Pipeline概述

所有有效的Declarative Pipeline必须包含在一个pipeline块内，例如：
```groovy
pipeline {

    /* insert Declarative Pipeline here */

}
```
Declarative Pipeline中有效的基本语句和表达式遵循与Groovy语法相同的规则 ，但有以下例外：

Pipeline的顶层必须是块，具体来说是：pipeline { }
没有分号作为语句分隔符。每个声明必须在自己的一行
块只能包含章节， 指令，步骤或赋值语句。
属性引用语句被视为无参数方法调用。所以例如，input被视为input（）
第一点，前面文章解释过，就是一个代码块范围的意思，很好理解。第二个以后可能经常会犯这个，分号写了也是多余的。Groovy代码还可以写分号，Jenkins Pipeline代码就不需要，每行只写一个声明语句块或者调用方法语句。第三点，只能包含Sections, Directives, Steps或者赋值语句，其中的Sections 和Directives后面语法会解释。指令和步骤，前面文章我介绍过，例如steps, stage, agent等。最后一句话，我也不确定，没有理解透彻。

3. sections

Declarative Pipeline 代码中的Sections指的是必须包含一个或者多个指令或者步骤的代码区域块。Sections不是一个关键字或者指令，只是一个逻辑概念。

4.agent

该agent部分指定整个Pipeline或特定阶段将在Jenkins环境中执行的位置，具体取决于该agent 部分的放置位置。该部分必须在pipeline块内的顶层定义 ，但阶段级使用是可选的。

简单来说，agent部分主要作用就是告诉Jenkins，选择那台节点机器去执行Pipeline代码。这个指令是必须要有的，也就在你顶层pipeline {…}的下一层，必须要有一个agent{…},agent这个指令对应的多个可选参数，本篇文章会一一介绍。这里注意一点，在具体某一个stage {…}里面也可以使用agent指令。这种用法不多，一般我们在顶层使用agent，这样，接下来的全部stage都在一个agent机器下执行代码。

为了支持Pipeline作者可能拥有的各种用例，该agent部分支持几种不同类型的参数。这些参数可以应用于pipeline块的顶层，也可以应用在每个stage指令内。

为了支持写Pipeline代码的人可能遇到的各种用例场景，agent部分支持几种不同类型的参数。这些参数可以应用于pipeline块的顶层，也可以应用在每个stage指令内。

参数1：any

作用：在任何可用的代理上执行Pipeline或stage。

代码示例
```groovy
pipeline {
    agent any
}
```
上面这种是最简单的，如果你Jenkins平台环境只有一个master，那么这种写法就最省事情.

参数2：none

作用：当在pipeline块的顶层应用时，将不会为整个Pipeline运行分配全局代理，并且每个stage部分将需要包含其自己的agent部分。

代码示例：
```groovy
pipeline {
    agent none
    stages {
        stage(‘Build’){
	    agent {
               label ‘具体的节点名称’
            }
        }
    }
}
```
参数3：label

作用：使用提供的标签在Jenkins环境中可用的代理机器上执行Pipeline或stage内执行。

代码示例：
```groovy
pipeline {
    agent {
       label ‘具体一个节点label名称’
    }
}
```
参数4：node

作用：和上面label功能类似，但是node运行其他选项，例如customWorkspace

代码示例：
```groovy
pipeline {
    agent {
        node {
            label ‘xxx-agent-机器’
            customWorkspace "${env.JOB_NAME}/${env.BUILD_NUMBER}"
        }
    }
}
```
目前来说，这种node类型的agent代码块，在实际工作中使用可能是最多的一个场景。我建议你分别测试下有和没有customWorkspace的区别，前提你要有自己Jenkins环境，能找到"${env.JOB_NAME}/${env.BUILD_NUMBER}"这个具体效果。

其实agent相关的还有两个可选参数，分别是docker和dockerfile。目前，我不想把docker加入进来，给我们学习Pipeline增加复杂度。但是docker又是很火的一个技术栈，以后如果你项目中需要docker，请去官网找到这两个参数的基本使用介绍。

如果你认真花了时间在前面两篇，那么你就知道如何测试上面的每一段代码。你可以在Jenkins UI上贴上面代码，也可以写入jenkinsfile，走github拉去代码。下面，我写一个测试代码，结合上面node的代码，放在Jenkins UI上进行测试。

代码如下：
```groovy
pipeline {
    agent {
        node {
            label ‘xxx-agent-机器’
            customWorkspace "${env.JOB_NAME}/${env.BUILD_NUMBER}"
        }
   }
   stages {
       stage (‘Build’) {
           bat “dir” // 如果jenkins安装在windows并执行这部分代码
           sh “pwd”  //这个是Linux的执行
       }

       stage (‘Test’) {
           bat “dir” // 如果jenkins安装在windows并执行这部分代码
           sh “echo ${JAVA_HOME}”  //这个是Linux的执行
       }
   }
}
```
拷贝上面代码在Jenkins job的pipeline设置页面，保存，启动测试。

![](https://img-blog.csdn.net/20181022203017378?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTE1NDE5NDY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 

注意 :以上代码的agent中label的值，如果你不会配置在Jenkins上添加节点，那么你就改成agent any来跳过这部分，后面我会写一篇文章介绍，如何在Jenkins上添加一个agent节点的详细过程。
