# Java 虚拟机

## 概念 

虚拟机：指以软件的方式模拟具有完整硬件系统功能、运行在一个完全隔离环境中的完整计算机系统 ，是物理机的软件实现。常用的虚拟机有VMWare，Visual Box，Java Virtual Machine（Java虚拟机，简称JVM）。

Java虚拟机阵营：Sun HotSpot VM、BEA JRockit VM、IBM J9 VM、Azul VM、Apache Harmony、Google Dalvik VM、Microsoft JVM…

## 启动流程

![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnvl3V20niczzMEkLJ2F3iarI6oL3IYmXyPC02bgK9q3XThMxHUZZfB5Kg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



## 基本架构

![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrng6rTeDq1kxib5Q5R5HvD60fR4lXjNDZK15TNuFFFZicOeicAFtObKiar7Q/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

Java运行时编译源码(.java)成字节码，由jre运行。jre由java虚拟机（jvm）实现。Jvm分析字节码，后解释并执行。

![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnXkick1997l5aSwJJuic7IMfRfMANJ7icYHJfFGBRkib0Q9AMCMOy8tw1Gg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

JVM由三个主要的子系统构成：

- 1.类加载器子系统
- 2.运行时数据区（内存）
- 3.执行引擎

## 垃圾收集（GC：Garbage Collection）

**1.如何识别垃圾，判定对象是否可被回收？**

- 引用计数法：给每个对象添加一个计数器，当有地方引用该对象时计数器加1，当引用失效时计数器减1。用对象计数器是否为0来判断对象是否可被回收。缺点：无法解决循环引用的问题
- 根搜索算法：也称可达性分析法，通过“GC ROOTs”的对象作为搜索起始点，通过引用向下搜索，所走过的路径称为引用链。通过对象是否有到达引用链的路径来判断对象是否可被回收（可作为GC ROOTs的对象：虚拟机栈中引用的对象，方法区中类静态属性引用的对象，方法区中常量引用的对象，本地方法栈中JNI引用的对象）

**2.Java 中的堆是 GC 收集垃圾的主要区域，GC 分为两种：Minor GC、Full GC ( 或称为 Major GC )。**

- Minor GC：新生代（Young Gen）空间不足时触发收集，由于Java 中的大部分对象通常不需长久存活，新生代是GC收集频繁区域，所以采用复制算法。
- Full GC：老年代（Old Gen ）空间不足或元空间达到高水位线执行收集动作，由于存放大对象及长久存活下的对象，占用内存空间大，回收效率低，所以采用标记-清除算法。

## GC算法

**按照回收策略划分为：标记-清除算法，标记-整理算法，复制算法。**

- 1.标记-清除算法：分为两阶段“标记”和“清除”。首先标记出哪些对象可被回收，在标记完成之后统一回收所有被标记的对象所占用的内存空间。不足之处：1.无法处理循环引用的问题2.效率不高3.产生大量内存碎片（ps：空间碎片太多可能会导致以后在分配大对象的时候而无法申请到足够的连续内存空间，导致提前触发新一轮gc）

  ![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnmpkibhY68rHooAYKqXIY9J8AMItDpbQCYFJktbogRHCIO6setXPhosQ/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

- 2.标记-整理算法：分为两阶段“标记”和“整理”。首先标记出哪些对象可被回收，在标记完成后，将对象向一端移动，然后直接清理掉边界以外的内存。

  ![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnwzQAn0fpAC9QjgGpQVEiaZ3Dglpib2DksR8QAJicdYic1ibs4xwiczFiatcHw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

- 3.复制算法：把内存空间划为两个相等的区域，每次只使用其中一个区域。gc时遍历当前使用区域，把正在使用中的对象复制到另外一个区域中。算法每次只处理正在使用中的对象，因此复制成本比较小，同时复制过去以后还能进行相应的内存整理，不会出现“碎片”问题。不足之处：1.内存利用率问题2.在对象存活率较高时，其效率会变低。

  ![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnFoycBJXhbILMeq6L5qxgiahT1QbRrvp3bF3uom5k24ugjWcL1y5U3Vg/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**按分区对待可分为：增量收集算法，分代收集算法**

- 1.增量收集:实时垃圾回收算法，即：在应用进行的同时进行垃圾回收，理论上可以解决传统分代方式带来的问题。增量收集把对堆空间划分成一系列内存块，使用时先使用其中一部分，垃圾收集时把之前用掉的部分中的存活对象再放到后面没有用的空间中，这样可以实现一直边使用边收集的效果，避免了传统分代方式整个使用完了再暂停的回收的情况。

- 2.分代收集:（商用默认）基于对象生命周期划分为新生代、老年代、元空间，对不同生命周期的对象使用不同的算法进行回收。

  ![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrndj3Um6ZnYrBg5jusc9y4cxMibv2RI3fcT3AaDo5AGA0icfeZibU2xMlzw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**按系统线程可分为：串行收集算法，并行收集算法，并发收集算法**

- 1.串行收集:使用单线程处理垃圾回收工作，实现容易，效率较高。不足之处：1.无法发挥多处理器的优势 2.需要暂停用户线程
- 2.并行收集:使用多线程处理垃圾回收工作，速度快，效率高。理论上CPU数目越多，越能体现出并行收集器的优势。不足之处：需要暂停用户线程
- 3.并发收集:垃圾线程与用户线程同时工作。系统在垃圾回收时不需要暂停用户线程

## GC收集器常用组合

![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnM6icBiaxFeibrYhIqFQp6yZjxJq24PNsVIia2XxLWLsp0qRMSWG9B25QEw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnDMMlPKePZugV11GgnYtuXLfJCicMIjGb0y6YSlwDXCHYPCic7rW88yXg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## JVM性能调优思路

![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrn2sJZeJv8pPtXCK3tyEG1Mllx3ennoCbS3BlfLQFOVbpicbHRk9qJZLw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 理解GC日志

![img](https://mmbiz.qpic.cn/mmbiz_jpg/rtJ5LhxxzwnZn7qgEtupXRcibhJQzGGrnbZObY52vdFytwoY3bh0KZraxr11za0hDEQSKCpOGBfYadKUUBjoNTA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



```
[GC [PSYoungGen: 8192K->1000K(9216K)] 16004K->14604K(29696K), 0.0317424 secs] [Times: user=0.06 sys=0.00, real=0.03 secs][GC [PSYoungGen: 9192K->1016K(9216K)] 22796K->20780K(29696K), 0.0314567 secs] [Times: user=0.06 sys=0.00, real=0.03 secs][Full GC [PSYoungGen: 8192K->8192K(9216K)] [ParOldGen: 20435K->20435K(20480K)] 28627K->28627K(29696K), [Metaspace: 8469K->8469K(1056768K)], 0.1307495 secs] [Times: user=0.50 sys=0.00, real=0.13 secs][Full GC [PSYoungGen: 8192K->8192K(9216K)] [ParOldGen: 20437K->20437K(20480K)] 28629K->28629K(29696K), [Metaspace: 8469K->8469K(1056768K)], 0.1240311 secs] [Times: user=0.42 sys=0.00, real=0.12 secs]
```

## 常见异常

- StackOverflowError:（栈溢出）
- OutOfMemoryError: Java heap space（堆空间不足）
- OutOfMemoryError: GC overhead limit exceeded  （GC花费的时间超过 98%, 并且GC回收的内存少于 2%）