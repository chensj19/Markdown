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

## 2、类加载子系统

### 2.1 内存结构

* **简图**

![image-20200616221231451](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616221231451.png)

* **详细图**

  ![image-20200616221446679](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616221446679.png)

  ![image-20200616221525570](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616221525570.png)

### 2.2 类加载器与类的加载过程

####  2.2.1  类加载器子系统作用

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
  Constant pool: // 常量池
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


#### 2.2.2 类加载器ClassLoader角色

![image-20200616223606773](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200616223606773.png)

1. class file 存在于本地硬盘上，可以理解为设计师画在纸上的模板，而最终这个模板在执行的时候是需要加载到JVM当中，根据这个文件实例化n个一模一样的实例
2. class file加载到JVM中，被称之为DNA元数据模板，放在方法区中
3. 在.class文件--> JVM -->最终成为元数据模板，此过程需要一个运输工具(类加载器 ClassLoader)，扮演一个快递员的角色

#### 2.2.3 类加载过程

* 简单说明

![image-20200617200935043](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200617200935043.png)

* 详细过程

![image-20200617201012399](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200617201012399.png)

#### 2.2.4 类加载过程--Loading

1. 通过一个类的全限定名获取定义此类的二进制字节流
   1. 来源于文件系统
   2. 来源于网络
   3. 来源于zip包、jar、war
   4. 运行时计算生成，使用最多的是动态代理技术
   5. 由其他文件生成，比如jsp
   6. 由专有数据库读取生成
   7. 从加密文件获取，典型的是防class文件被反编译的保护措施
2. 将这个字节流所代表的的静态存储结构转换为方法区**[永久代(~JDK7)、元数据(JDK8~)]**的运行时数据结构
3. **在内存中生成一个代表此类的java.lang.Class对象**，作为方法区中这个类的各种数据的访问入口

#### 2.2.5 类加载过程--Linking

##### 2.2.5.1 验证(Verify)

* 目的在于确保Class文件的字节流中包含的信息符合当前虚拟机要求，保证被价值类的正确性，不会危害虚拟机的自身安全
* 主要包含四种验证：文件格式验证、元数据验证、字节码验证、符号引用验证
  * 比如class文件 二进制开头为 0xCAFF BABE

##### 2.2.5.2 准备(Prepare)

* 为类变量分配内存并设置该类变量的默认初始值，即零值
* **这里不包含用final修饰的static，因为final在编译的时候已经分配了，准备阶段会显式初始化**
* **这里不会为实例变量分配初始化**，类变量会分配在方法区中，而实例变量会随着对象一起分配到Java Heap中

##### 2.2.5.3 解析(Resolve)

* 将常量池内的符号引用[常量池]转换为直接引用的过程
* 事实上，解析操作往往会伴随JVM执行完初始化后再执行
* 符号引用就是一组符号来描述所引用的目标，符号引用的字面量形式明确定义在**Java虚拟机规范**的Class文件格式中，直接引用就是直接指向目标的指针，相对偏移量或一个间接定位到目标的句柄
* 解析动作主要针对类或者接口、字段、类方法、方法类型等，对应常量池中的CONSTANT_Class_info,CONSTANT_Fieldref_info,CONSTANT_Methodref_info等

#### 2.2.6 类加载过程--Initialization

* 初始化阶段就是执行类构造方法**<clinit>()**的过程

  ```java
  // class version 52.0 (52)
  // access flags 0x21
  public class org/chen/jvm/ch02/ClassInitTest {
  
    // compiled from: ClassInitTest.java
  
    // access flags 0xA
    private static I num
  
    // access flags 0xA
    private static I number
  
    // access flags 0x1
    public <init>()V
     L0
      LINENUMBER 9 L0
      ALOAD 0
      INVOKESPECIAL java/lang/Object.<init> ()V
      RETURN
     L1
      LOCALVARIABLE this Lorg/chen/jvm/ch02/ClassInitTest; L0 L1 0
      MAXSTACK = 1
      MAXLOCALS = 1
  
    // access flags 0x9
    public static main([Ljava/lang/String;)V
     L0
      LINENUMBER 20 L0
      GETSTATIC java/lang/System.out : Ljava/io/PrintStream;
      GETSTATIC org/chen/jvm/ch02/ClassInitTest.num : I
      INVOKEVIRTUAL java/io/PrintStream.println (I)V
     L1
      LINENUMBER 21 L1
      GETSTATIC java/lang/System.out : Ljava/io/PrintStream;
      GETSTATIC org/chen/jvm/ch02/ClassInitTest.number : I
      INVOKEVIRTUAL java/io/PrintStream.println (I)V
     L2
      LINENUMBER 22 L2
      RETURN
     L3
      LOCALVARIABLE args [Ljava/lang/String; L0 L3 0
      MAXSTACK = 2
      MAXLOCALS = 1
  
    // access flags 0x8 类构造方法
    static <clinit>()V
     L0
      LINENUMBER 11 L0
      ICONST_1
      PUTSTATIC org/chen/jvm/ch02/ClassInitTest.num : I
     L1
      LINENUMBER 14 L1
      BIPUSH 20
      PUTSTATIC org/chen/jvm/ch02/ClassInitTest.number : I
     L2
      LINENUMBER 17 L2
      BIPUSH 10
      PUTSTATIC org/chen/jvm/ch02/ClassInitTest.number : I
      RETURN
      MAXSTACK = 1
      MAXLOCALS = 0
  }
  ```

* 此方法不需要定义，是javac编译器自动收集类中的所有类变量的赋值动作和静态代码块中的语句合并而来

  * 如果不存在类变量的赋值和静态代码块则不会有类构造方法**<clinit>()**

* 构造器方法中指令按照语句在源文件中出现的顺序执行

  ```java
    private static int num = 1;
  
      static {
          number = 20;
      }
  
      private static int number = 10; // prepare 0 init 20 --> 10
  
      public static void main(String[] args) {
          System.out.println(num);
          System.out.println(number);
      }
  // 字节码
  static <clinit>()V
     L0
      LINENUMBER 11 L0
      ICONST_1
      PUTSTATIC org/chen/jvm/ch02/ClassInitTest.num : I
     L1
      LINENUMBER 14 L1
      BIPUSH 20
      PUTSTATIC org/chen/jvm/ch02/ClassInitTest.number : I
     L2
      LINENUMBER 17 L2
      BIPUSH 10
      PUTSTATIC org/chen/jvm/ch02/ClassInitTest.number : I
      RETURN
      MAXSTACK = 1
      MAXLOCALS = 0
  ```

* **<clinit>()不同于类的构造方法**（从虚拟机角度来看，类的构造方法就是 <init>()方法）

* 若该类具有父类，JVM会保证子类的**<clinit>()**执行前，父类的**<clinit>()**已经执行完毕

  ```java
  public class ClassInit01Test {
  
       static class Father {
           public static int A = 1;
           static {
               A = 2;
           }
       }
  
       static class Son extends Father {
           public static int B = 2 ;
       }
  
      public static void main(String[] args) {
          System.out.println(Son.B);
      }
  }
  ```

* 虚拟机必须保证一个类的**<clinit>()**方法在多线程下被同步加锁的

  ```java
  public class DeadThreadTest {
  
      public static void main(String[] args) {
          Runnable r = () -> {
              System.out.println(Thread.currentThread().getName() + "   开始初始化");
              DeadThread thread = new DeadThread();
              System.out.println(Thread.currentThread().getName() + "   初始化结束");
          };
          Thread t1 = new Thread(r, "T1");
          Thread t2 = new Thread(r, "T2");
          t1.start();
          t2.start();
      }
  }
  
  
  class DeadThread {
      static {
          // 初始化时候会被锁，导致其他线程无法访问
          if (true) {
              System.out.println(Thread.currentThread().getName() + "   DeadThread 开始初始化");
              while (true) {
              }
          }
      }
  }
  ```

### 2.3 类加载器分类

#### 2.3.1 类加载器简介

* JVM支持两种类型的类加载器，一种是**引导类加载器(Bootstrap ClassLoader)**，一种是**自定义的类加载器(User-Defined ClassLoader)**

  * 从概念上来说，自定义类加载器是程序开发人员自定义的一种类加载器，不是由Java虚拟机提供的，不存在于Java虚拟机规范中，而是**将所有派生于抽象类ClassLoader的类加载器都划分为自定义加载器，简单来说实现ClassLoader的类加载器都归属于自定义加载器**,下图中除了Bootstrap ClassLoader，其他的都是自定义类加载器

  ![image-20200617234141884](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200617234141884.png)

  > 上面这四种加载器之间的关系是包含关系，并不是上下层，也不是父子类的继承关系

* 无论类加载器类型怎么划分，在程序中最常见的类加载器就只有三个

  * Bootstrap ClassLoader
  * Extension ClassLoader
  * System/Application ClassLoader

  ```java
  public class ClassLoaderTest {
      public static void main(String[] args) {
          // 获取系统类加载器
          ClassLoader systemClassloader = ClassLoader.getSystemClassLoader();
          System.out.println(systemClassloader);
          // 获取扩展类加载器,获取其上级类加载器
          ClassLoader extClassLoader = systemClassloader.getParent();
          System.out.println(extClassLoader);
          // 获取扩展类加载器的上层 获取不到引导类加载器
          ClassLoader bootstrap = extClassLoader.getParent();
          System.out.println(bootstrap); // null
  
          // 用户自定义类来说它的类加载器是哪个？sun.misc.Launcher$AppClassLoader@18b4aac2
          ClassLoader userClassLoader = ClassLoaderTest.class.getClassLoader();
          System.out.println(userClassLoader);
  
          // string 类加载器是哪个  null --> Bootstrap ClassLoader 引导类加载器加载
          // 系统核心类库都是使用引导类加载器加载
          //
          ClassLoader classLoader = String.class.getClassLoader();
          System.out.println(classLoader); // null
      }
  }
  ```

#### 2.3.2 加载器说明

##### 虚拟机自带加载器

###### 启动类加载器 Bootstrap ClassLoader

* 这个类是使用C/C++语言实现的，嵌套在JVM之中
* 它是用来加载Java核心类库($JAVA_HOME/jre/lib/rt.jar、resources.jar或sun.boot.class.path路径下的内容)，用于提供JVM自身需要的类
* 并不继承java.lang.ClassLoader，没有父加载器
* 加载扩展类和应用程序类加载器，并指定其父类加载器
* 出于安全考虑，Bootstrap启动类加载器只加载包名为java/javax/sun等开头的类

###### 扩展类加载器 Extension ClassLoader

* **Java语言编写**，由sun.misc.Launcher$ExtClassLoader实现
* **派生于ClassLoader类**
* 父类加载器为启动类加载器
* 从**java.ext.dirs**系统属性所指定的目录中加载类库，或从**JDK安装目录jre/lib/ext**子目录下加载类库。**如果用户创建的jar放在此目录，也会由扩展类加载器加载**

###### 系统/应用加载器 System/Application ClassLoader

* **Java语言编写**，由sun.misc.Launcher$AppClassLoader实现
* **派生于ClassLoader**
* 父类加载器为Extension ClassLoader
* 它负责加载**环境变量classpath**或者系统属性**java.class.path**指定路径下的类库
* 该类加载器是程序中默认的类加载器，一般来说，Java应用的类都是由它完成加载
* 通过ClassLoader#getSystemClassLoader()方法可以获取该类加载器

###### 获取加载路径

```java
public class ClassLoader01Test {
    public static void main(String[] args) {
        System.out.println("获取启动类加载器");
        // 获取Bootstrap ClassLoader 加载类路径
        URL[] urLs = Launcher.getBootstrapClassPath().getURLs();
        for (URL urL : urLs) {
            System.out.println(urL.toExternalForm());
        }

        // 扩展类加载器
        System.out.println("扩展类加载器");
        String extPath = System.getProperty("java.ext.dirs");
        for (String path : extPath.split(":")) {
            System.out.println(path);
        }

        // 应用类加载器
        System.out.println("应用类加载器");
        String classPath = System.getProperty("java.class.path");
        for (String path : classPath.split(":")) {
            System.out.println(path);
        }
    }
}
```

##### 用户自定义类加载器

* 在Java开发的过程中，类的加载几乎都是由上述三种加载器互相配合执行 ，在必要情况下，还可以通过自定义类加载器，来定制类的加载方式
* 自定义类加载器使用场景
  * 隔离加载类
  * 修改类加载方式
  * 扩展加载源
  * 防止源码泄露
* 实现步骤
  * 开发人员通过继承抽象类ClassLoader的方式，实现自己的类加载器，从而达到一些特殊的需求
  * 在JDK1.2之前，在自定义类加载器时，总会去继承ClassLoader并重写loadClass()方法，从而实现自定义的类加载器，但是在之后已不在建议用户去覆盖这个方法，而是建议把自定义的类加载逻辑写在findClass()方法中
  * 在编写自定义类加载器时，如果没有太过于复杂的需求，可以直接继承URLClassLoader类，这样可以避免自己去写findClass()方法及获取字节码流的方法，使自定义类加载器编写更加简洁

#### 2.3.3 关于ClassLoader

ClassLoader类，是一个抽象类，其后所有的类加载器都继承自这个类(不包含Boostrap ClassLoader)

| 方法名称                                          | 方法说明                                                     |
| ------------------------------------------------- | ------------------------------------------------------------ |
| getParent()                                       | 返回该类加载器的超类加载器                                   |
| loadClass(String name)                            | 加载名称为name的类，返回结果为java.lang.Class类的实例        |
| findClass(String name)                            | 查找名称为name的类，返回结果为java.lang.Class类的实例        |
| findLoadedClass(String name)                      | 查找名称为name的已加载过的类，返回结果为java.lang.Class类的实例 |
| defineClass(String name,byte[] b,int off,int len) | 把字节数组b中内容转换为一个Java类，返回结果为java.lang.Class类的实例 |
| resolveClass(Class<?> c)                          | 连接指定的一个Java类                                         |

![image-20200618222230371](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200618222230371.png)

**sun.msic.Launcher**，它是一个Java虚拟机的入口应用

## 4、运行时数据区

## 5、执行引擎

## 6、stringTable

## 7、垃圾回收



