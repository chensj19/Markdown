# JVM虚拟机

学习JVM原因：

* 面试需要
* 中高级必备技能
  * 项目需要、调优的需要
* 追求极客精神
  * 垃圾算法、JIT、底层原理

## 1.JVM和Java体系结构

### 1.1 Idea 插件 JProfile

注册信息

```bash
# Name填写
脚本之家
#Company填写 
www.jb51.net
# 序列号
L-J11-Everyone#speedzodiac-327a9wrs5dxvz#463a59
A-J11-Everyone#admin-3v7hg353d6idd5#9b4
```

[下载地址](http://fenghuoyunji.jb51.net:81/201903/tools/jprofiler_macos_11_jb51.dmg)

### 1.2 参考书籍

* [Java 8虚拟机规范](https://docs.oracle.com/javase/specs/index.html)

* Java 虚拟机规范(Java SE 8版)

* 深入Java虚拟机
  * JVM高级特性和最佳实践(第二版、第三版)

* 实战Java虚拟机

* Java虚拟机精讲

### 1.3 Java和JVM简介

#### 语言排行

![语言排行榜](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200613215539172.png)

#### JVM：跨语言平台

![image-20200613220321390](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200613220321390.png)

#### 字节码

Java字节码：用Java语言编译成的字节码，准确来说：任何能在jvm平台上执行的字节码格式都是一样

不同的编译器，可以编译出相同的字节码文件，字节码文件也可以在不同的JVM上运行

Java虚拟机与Java语言并没有必然的联系，它是与特定的二进制文件格式-Class文件格式所关联，Class文件中包含了Java虚拟机指令集（或称为字节码）

#### 多语言混合编程

Java平台上的多语言混合编程正成为主流，通过特定领域语言去解决特定领域的问题。

#### JVM位置

##### 系统层面

![image-20200615194043930](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200615194043930.png)

JVM是运行在操作系统之上，与硬件没有直接的交互

##### JDK、JRE、JVM

![image-20200613174822245](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200613174822245.png)

#### JVM整体结构

![image-20200615194534652](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200615194534652.png)

#### Java代码执行流程

![Java代码执行流程](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200615201318339.png)

##### 详细流程

![Java执行详细流程](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200615201454497.png)

#### JVM架构模型

Java编译器输入的指令流基本上是一种基于**栈的指令集架构**，另一种指令集架构则是基于**寄存器的指令集架构**

两者对比：

* **基于栈式架构的特点**
  * 设计和实现比较简单，适用于资源受限的系统
  * 避开了寄存器的分配难题：使用零地址指令方式分配
  * 指令流中的指令大部分是零地址指令，其执行过程依赖于操作栈。指令集更小，编译器容易实现
  * 不需要硬件支持，可移植性更好，更好实现跨平台
* **基于寄存器架构的特点**
  * 典型的应用是x86的二进制指令集：比如PC和Android的Davlik虚拟机
  * 指令集架构完全依赖硬件，可移植性差
  * 性能优秀和执行更高效
  * 花费更少的指令去完成一项操作
  * 在大部分情况下，基于寄存器架构的指令集往往都以一地址指令、二地址指令和三地址指令为主，而基于栈式架构的指令集却是以零地址指令为主

总结：

由于跨平台性的设计，Java的指令都是采用栈来设计，跨平台性、指令集小、指令多；执行性能比寄存器差

#### JVM的生命周期

##### 启动

Java虚拟机的启动时依赖引导类加载器(Bootstrap Class Loader)创建一个初始类(initial class)来完成的，这个类是由虚拟机的具体实现来指定的

##### 运行

* 一个运行中的Java虚拟机有着一个清晰的任务，执行Java程序
* 程序开始执行时它才允许，程序结束时它就停止
* **执行一个所谓的Java程序的时候，真真正正在执行的是一个Java虚拟机的进程**

##### 结束

* 程序正常执行结束
* 程序执行过程中遇到了异常或者错误而终止
* 系统出现问题导致Java虚拟机终止
* System.exit()或者Runtime.getRunTime().exit() 结束
* JNI 规范中提供的API的实现退出

#### JVM发展过程

* Sun Classic VM  

  * 第一款商用Java虚拟机
  * Java 1.4 移除
  * 只提供了解释器，JIT需要外挂，并且只能二选一使用

* Exact VM

  * 为了解决上一代虚拟机，Java 1.2 时提供了此虚拟机
  * Exact Memory Management ：准确式内存管理
    * 虚拟机可以知道内存中某个位置的数据具体是什么类型
  * 具有现代性能虚拟机的雏形
    * 热点探测
    * 编译器和解释器混合工作模式
  * 只能Solaris平台使用，其他平台还是使用第一代虚拟机
    * 被Hotspot替代

* Hotspot 虚拟机 内置(Sun Classic VM)

  * Java 1.3时，Hotspot VM称为默认虚拟机

  ![image-20200615213238247](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200615213238247.png)
  
  * Oracle JDK、OpenJDK的默认虚拟机,（JRockit和J9中就没有方法区概念）
  * Hotspot 指的是热点代码探测技术
    * 通过计数器找到最具编译价值的代码，触发即时编译或者栈上替换
    * 通过编译器和解释器协同工作，在最优化的程序时间和最佳执行性能中取得平衡
  
* JRockit VM 

  * BEA公司，专注于服务端应用，不注重程序启动速度，**JRockit内部不包含解释器实现**，全部代码都是使用即时编译器后执行
  * 优势是:全面的Java运行时解决方案组合
    * JRockit 面向延迟敏感型应用解决方案JRockit Real Time提供以毫秒或者微秒级的JVM响应时间，适合财务、军事指挥、电信网络的需要
    * MissionControl 服务组件，以极低的开销来监控、管理和分析生产环境中的应用程序的工具

* IBM J9 VM 

  * IBM Technology for Java Virutal Machine，简称IT4J，内部代号：J9
  * 市场定位与Hotspot接近，服务器端、桌面应用、嵌入式等多用途VM
  * 广泛用于IBM的各种产品中
  * 三大商用虚拟机之一
  * 2017年，IBM开源J9 VM，命名为OpenJ9，交给Eclipse基金会管理，也被称为Eclipse OpenJ9

* KVM、CDC、CLDC

  * 针对于Java ME 产品线开发的虚拟机CDC/CLDC Hotspot Implementation VM
  * KVM 是CLDC-HI早期产品

* Azul VM/BEA Liquid VM

  * 与特定硬件平台绑定，软硬件配合的专有虚拟机
  * Azul VM
    * 运行于Azul Systems公司的专有虚拟机
  * Liquid VM
    * BEA 公司开发，直接运行在自己的Hyperisor系统

* Apache Harmony

  * 与JDK 1.5和JDK 1.6兼容的运行平台Apache Harmony
  * IBM和Intel联合开发的开源JVM，于2011退役，IBM转向参与OpenJDK
  * 无大规模商用案例，但是Java类库代码被吸纳进Android SDK

* Microsoft VM 和Taobao VM

  * Microsoft VM
    * 在IE中更好的支持Java Applets，开发了Microsoft JVM
    * 只能在Windows平台运行，是当时Windows下性能最佳的Java VM
  * Taobao JVM
    * AliJVM团队发布，基于OpenJDK开发了自己的定制版本AlibabaJDK，简称AJDK
    * 基于OpenJDK Hotspot VM发布的国内第一个优化，深度定制且开源的高性能服务器版Java虚拟机
    * 创新的GCIH(GC invisible heap)技术实现了off-heap，即将生命周期较长的Java对象从heap中移到heap外，并且GC不能管理GCIH内部的Java对象，以此降低GC的回收频率和提升GC的回收效率的目的
    * GCIH中的对象可以在多个虚拟机进程中实现共享

* Dalvik VM

  * 谷歌开发，应用于Android系统，并在Android 2.2提供了JIT，发展迅速
  * 未遵循Java虚拟机规范
  * 不能直接执行Java的字节码文件
  * 基于寄存器架构，不是JVM栈架构
  * 执行编译后的dex文件，
  * Android 5.0 使用支持提前编译(AOT)的ART VM替换了Dalvik VM

* Graal VM

  * Oracle labs 公布了Graal VM
  * 跨语言 全栈虚拟机
  * 支持不同语言中混用对方的接口和对象

## 3、类加载子系统

### 3.1 内存结构

* **简图**

![image-20200616221231451](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616221231451.png)

* **详细图**

  ![image-20200616221446679](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616221446679.png)

  ![image-20200616221525570](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616221525570.png)

### 3.2 类加载器与类的加载过程

####  3.2.1  类加载器子系统作用

![image-20200616222417933](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616222417933.png)

* 类加载子系统负责从文件系统或者网络中加载class文件，class文件在文件开头有特定的文件标识

* ClassLoader只负责class文件的加载，至于它是否可以运行，则由Execution Engine决定

* 加载的类信息存放于一块称之为方法区的内存空间中。除了类的信息外，方法区中还会存放运行时常量池信息，可能还包含字符串字面量和数字常量(这部分常量信息是Class文件常量池部分的内存映射)

  ```java
  Classfile /Users/chenshijie/Code/self/gitee/java/tmts_code/jvm-code/target/classes/org/chen/jvm/ch01/StackStructorTest.class
    Last modified 2020-6-15; size 518 bytes
    MD5 checksum dc2c6692680c74b3cea6c133ae24424d
    Compiled from "StackStructorTest.java"
  public class org.chen.jvm.ch01.StackStructorTest
    minor version: 0
    major version: 52
    flags: ACC_PUBLIC, ACC_SUPER
  Constant pool: // 常量
     #1 = Methodref          #3.#22         // java/lang/Object."<init>":()V
     #2 = Class              #23            // org/chen/jvm/ch01/StackStructorTest
     #3 = Class              #24            // java/lang/Object
     #4 = Utf8               <init>
     #5 = Utf8               ()V
     #6 = Utf8               Code
     #7 = Utf8               LineNumberTable
     #8 = Utf8               LocalVariableTable
     #9 = Utf8               this
    #10 = Utf8               Lorg/chen/jvm/ch01/StackStructorTest;
    #11 = Utf8               main
    #12 = Utf8               ([Ljava/lang/String;)V
    #13 = Utf8               args
    #14 = Utf8               [Ljava/lang/String;
    #15 = Utf8               i
    #16 = Utf8               I
    #17 = Utf8               j
    #18 = Utf8               h
    #19 = Utf8               k
    #20 = Utf8               SourceFile
    #21 = Utf8               StackStructorTest.java
    #22 = NameAndType        #4:#5          // "<init>":()V
    #23 = Utf8               org/chen/jvm/ch01/StackStructorTest
    #24 = Utf8               java/lang/Object
  {
    public org.chen.jvm.ch01.StackStructorTest();
      descriptor: ()V
      flags: ACC_PUBLIC
      Code:
        stack=1, locals=1, args_size=1
           0: aload_0
           1: invokespecial #1                  // Method java/lang/Object."<init>":()V
           4: return
        LineNumberTable:
          line 8: 0
        LocalVariableTable:
          Start  Length  Slot  Name   Signature
              0       5     0  this   Lorg/chen/jvm/ch01/StackStructorTest;
  
    public static void main(java.lang.String[]);
      descriptor: ([Ljava/lang/String;)V
      flags: ACC_PUBLIC, ACC_STATIC
      Code:
        stack=2, locals=5, args_size=1
           0: iconst_5
           1: istore_1
           2: iload_1
           3: istore_2
           4: bipush        6
           6: istore_3
           7: iload_2
           8: iload_3
           9: iadd
          10: istore        4
          12: return
        LineNumberTable:
          line 10: 0
          line 11: 2
          line 12: 4
          line 13: 7
          line 14: 12
        LocalVariableTable:
          Start  Length  Slot  Name   Signature
              0      13     0  args   [Ljava/lang/String;
              2      11     1     i   I
              4       9     2     j   I
              7       6     3     h   I
             12       1     4     k   I
  }
  SourceFile: "StackStructorTest.java"
  ```


#### 3.2.2 类加载器ClassLoader角色

![image-20200616223606773](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616223606773.png)

1. class file 存在于本地硬盘上，可以理解为设计师画在纸上的模板，而最终这个模板在执行的时候是需要加载到JVM当中，根据这个文件实例化n个一模一样的实例
2. class file加载到JVM中，被称之为DNA元数据模板，放在方法区中
3. 在.class文件--> JVM -->最终成为元数据模板，此过程需要一个运输工具(类加载器 ClassLoader)，扮演一个快递员的角色




## 4、运行时数据区

## 5、执行引擎

## 6、stringTable

## 7、垃圾回收



