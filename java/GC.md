# Java垃圾回收机制

## 自动垃圾回收

自动垃圾回收是一种在堆内存中找出哪些对象在被使用，还有哪些没被使用，并且将后者删掉的机制。所谓使用中的对象(已引用对象)，指的是程序中有指针指向的对象；而未使用中的对象(未引用对象)，则没有被任何指针给指向，因此占用的内存也就可以被回收掉。

在使用C之类的编程语言时，程序员需要手动分配和释放内存。而Java不一样，它有垃圾回收器，释放内存由回收器负责。

## 垃圾回收步骤

### 第一步：标记

垃圾回收的第一步是标记。垃圾回收器此时会找出哪些内存在使用中，哪些不是。

![标记](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdFn5Hk6jQ853PIemicupMUfXvRYQRLf5SqWC35xscZx5oqn2YWnPh6rg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

图中：蓝色表示已引用对象，橙色表示未引用对象。垃圾回收器要检查所有的对象，才能够知道哪些有被引用，哪些没。如果系统中所有的对象都需要检查，这一步将会非常耗时间

### 第二步：清除

这一步就是清除标记出未引用对象

![清除](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdABDae5sEpGF2Xicz4VLjpE5KQeJc1bFicRx0hZoPu7fialR8qfgic9INNw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

上图是清除完成后图示

> 内存分配器持有对空闲空间的引用列表，并在需要分配时搜索空闲空间

### 压缩

为了提升性能，删除了未引用对象后，还可以将剩下的已引用对象放在一起(压缩)，这样就能更简单快捷地分配新的对象。

![删除和压缩](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdrgsGMq4AibxXvX9lOVqpX0OORJKb4L5bibvXFyDrRCRTqrB3hnRXqictA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

上图中为删除并压缩

> 内存分配器持有对空闲空间开始的引用，然后依次分配内存

## 分代垃圾回收

在标记中就曾说过，如果全部查看的话，将会非常消耗时间，它需要逐一标记和压缩JVM里面的所有对象，非常低效；并且分配的对象越多，垃圾回收耗时越久。但在实际使用中，大部分的对象，其实用了没多久就不在使用了。

下面是一个样例，横轴代表程序运行时间，竖轴代表已分配的字节

![样例](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdhMZrfk4MGxobJTGlBiaegxbibp6BBkQypY4lTmv8cLlJaEhogQyQkvIA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

上图可见，存活（没被释放）的对象随运行时间越来越少。而图中左侧的那些峰值，也表明了大部分对象其实都挺短命的

> Minor collections:  小集合
>
> Major collections: 主要集合

### JVM分代

根据上面的规律，就可以用来提升JVM的效率，方法就是通过把堆分为几个部分(**就是分代**)，分别是**新生代(Young Generation)**、**老年代(Old Generation)**和**永生代(Permanent Generation)**三种。

![Hotspot堆结构](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdHUqoGTl5Rn9eSpWibawtONrL2ASp4YOdEXZGYCRA6WBFLxOiamPmaaCg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

新的对象会被分配到**新生代**内存，一旦新生代内存满了，就会开始对死掉的对象(未引用对象)，进行所谓的**小垃圾回收**过程。一片新生代内存中，死掉的对象越多，回收过程就越快；至于哪些还活着的对象，此时就会老化，并最终进入**老年代**内存中。

**Stop the World 事件** —— 小型垃圾回收属于一种叫 "Stop the World" 的事件。在这种事件发生时，所有的程序线程都要暂停，直到事件完成（比如这里就是完成了所有回收工作）为止。

**老年代**用来保存长时间存活的对象。通常，设置一个阈值，当达到该年龄时，年轻代对象会被移动到老年代。最终老年代也会被回收。这个事件成为**Major GC**。

**Major GC**也会触发**STW（Stop the World）**。通常，Major GC会慢很多，因为它涉及到所有存活对象。所以，对于响应性的应用程序，应该尽量避免Major GC。还要注意，Major GC的STW的时长受年老代垃圾回收器类型的影响。

**永久代**包含JVM用于描述应用程序中类和方法的元数据。永久代是由JVM在运行时根据应用程序使用的类来填充的。此外，Java SE类库和方法也存储在这里。

如果JVM发现某些类不再需要，并且其他类可能需要空间，则这些类可能会被回收。

### 世代垃圾收集过程

现在你已经理解了为什么堆被分成不同的代，现在是时候看看这些空间是如何相互作用的。 后面的图片将介绍JVM中的对象分配和老化过程。

首先，将任何新对象分配给`Eden`空间。 两个`survivor`空间都是空的。

![](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdBMI3DhvLFA95ZSSaOuWyh6CHBUj6kYPdHJM8MPjojPsRUtrmDhVmeQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

当`Eden`空间填满时，会触发轻微的垃圾收集。

![](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdwn3hTATNgjqXgH0olbaZ9NbAShmaNzH0V8l5loyFLdA9pY1WdIE2AQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

引用的对象被移动到第一个`survivor`空间。 清除`Eden`空间时，将删除未引用的对象

![](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdpDYjBgA7JOJhAQ1m4QVqd0MwmibPpd7yyQovTZqiaMic7grlZ2RIribBLA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在下一次`Minor GC`中，`Eden`区也会做同样的操作。删除未被引用的对象，并将被引用的对象移动到`Survivor`区。然而，这里，他们被移动到了第二个`Survivor`区（`S1`）。此外，第一个Survivor区（`S0`）中，在上一次`Minor GC`幸存的对象，会增加年龄，并被移动到`S1`中。待所有幸存对象都被移动到`S1`后，`S0`和`Eden`区都会被清空。注意，`Survivor`区中有了不同年龄的对象。

![对象年代](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOd6UpeOWFgSVaLjtMQl7oXZiaEnRbS93BEwvBj4rgr5sq1j91WsHTKrJA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在下一次`Minor GC`中，会重复同样的操作。不过，这一次`Survivor`区会交换。被引用的对象移动到`S0`,。幸存的对象增加年龄。`Eden`区和`S1`被清空。

![](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdQEZAZIWKdrqxCvx9ibuDA3icUjhNYxrfSmxjAzFCIIeNdxLfH3UJb4ng/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

此幻灯片演示了 对象世代演变的过程。 在较小的GC之后，当老化的物体达到一定的年龄阈值（在该示例中为8）时，它们从年轻一代晋升到老一代。

![](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdYopicC8P5YSr5T5erTpibxAhUJkYfm5SRYaiaz8OZx8GMKqp4KepRIQoA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

随着较小的GC持续发生，对象将继续被推广到老一代空间。

![年代升级](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdbAmWU2Ap9rdpbxWs8ot8hwyvSD99dibvy7rZlEkLgwxT8SNiaj9CicFvQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

所以这几乎涵盖了年轻一代的整个过程。 最终，将主要对老一代进行GC，清理并最终压缩该空间。

![](https://mmbiz.qpic.cn/mmbiz_png/tO7NEN7wjr5IciciayWA47pcHiboenrxgOdQARhjO4ah7ibM3TejGnlMAWj42N1CJkPic94v8t87alPgW5YzpQX0l4w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)