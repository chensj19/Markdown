# Dynamic Proxy & Standard Proxy

## **一、引言**

众所周知，一旦提到AOP，相信大家都是条件反射的想到JDK代理和CGLib代理，没错，这两个代理都是在**运行时**内存中临时生成代理类，故而又称作**运行时增强——动态代理**。世间万物都不是绝对的，既然有动态代理，那么，是否有想过：是不是存在静态代理呢？

## **二、LTW（Load Time Weaving）**

其实，除了运行时织入切面的方式外，我们还有一种途径进行切面织入，它可以在**类加载期通过字节码转换**，进而将目标织入切入点（目标类），这种方式就是LTW，即**静态代理**（静待代理也被称作**编译时增强**，后面会有相关代码样例）。

LTW在Java5的时候就被引入了，想要了解其原理，先要了解一个知识——Instrument包。

## **三、java.lang.instrument包的工作原理**

JDK5.0时引入了此包，目的就是为了能对JVM底层组建进行访问。如何访问？其实说来个人觉得还挺麻烦的，就是需要通过JVM的启动参数**-javaagent**在启动时获取JVM内部组件的引用。参数格式如下：

> -javaagent:<jarpath>[=options]
>
> 此处先卖个关子，不急着解释参数中的jarpath和options，后面的运行代码及结果的样例中会进行针对使用红框标记说明，效果更好。

**那么，它和AOP有和关系呢？**

因为它在JVM启动时会装配并应用ClassTransformer，对类字节码进行转换，进而实现AOP的功能。

下面说一下instrument包下的两个重要接口：

- **ClassFileTransformer**

它是Class文件转换器接口，这个接口有且仅有一个方法，如图所示：

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicaqWYqIltXG2IF5pAqTAR9BnibEtvTC7sdK9bD5XgibI5EuUHdlpyGPV2g/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicaa1uHPIcZ994CW8mhRpcg4liblg55hf82Nic61OeVUF0o85Qg0ZGCedAQ/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

注意：transform方法会有一个返回值，类型是byte[]，表示转换后的字节码，但是如果返回为空，则表示不进行节码转换处理，千万不要当作是把原先类的字节码清空。

- **Instrumentation**

这个接口提供了很多方法，我们主要注意一个方法即可，即：addTransformer方法，它的作用就是把一些ClassFileTransformer注册到JVM内部，接口如图所示：

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicaRm5gn36cvseNJbnZp0RZgsGnP9J3ZAHhyFV1SY63zzQQ1UrHkerdWA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**具体工作原理是这样的：**

① ClassFileTransformer实例注册到JVM之后，JVM在加载Class文件时，就会先调用ClassFileTransformer的transform()方法进行字节码转换；

② 若注册了多个ClassFileTransformer实例，则按照注册时的顺序进行一次调用。

这样也就实现了从JVM层面截获字节码，进而织入操作者自己希望添加的逻辑，即实现AOP效果。

## **四、代码及演示效果**

说了这么多，来点干货，下面用代码给大家演示一下如何向JVM中注册转换器实现AOP的。为了方便大家阅读，**重要的说明笔者已经写在代码的注释上或者图片空白处，大家注意查看。**

- **首先，我们实现一个自己的转换器，用于模拟需要切入的功能**

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzica4sDkvPiaYPZ7PHDraHkmia5CdLibrsYfOg8vZBk8ibiaot5ibhD7bdlJ79icQ/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

> 注意，这里再强调下，代码中的return null;并不是将加载类的字节码置空。

- **其次，我们再实现一个代理类**

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicahLQlIaPOBfvYWBQZWKsXiaZCIOjKdgK55X60MUaic8lkPXtFsTVlxhyA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

为什么要实现代理类内，因为不是动态代理呀。。。

- **最后，我们写一个主函数，代表程序入口**

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicahicxYSboiagNQ1wRvIibIl1iaY0ic7sdYqHia7uC15S1AUzwcjPjgrtPm1aA/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

到此为止，我们的Demo算是完成了，先来看一下运行的结果：

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicaVBrJXD5FkGJHnfx16TIBN9aNaeAhrjdljgNAbttib2zRaTkVbFlPKGw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## **五、打jar的时候需要注意的地方**

大家看到执行结果的截图中，cmd界面下运行javaagent参数时指定了一个myTransformer.jar，这个jar是我们自己需要打出来的，可以直接使用eclipse具体步骤如下图所示，注意图中说明：

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicaNpARWPxiaicz8Hy9yvMSQM1IuTvq3H1TyrTrZjxy2WlLcbOwJud7YweQ/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_jpg/UtWdDgynLda55B9icrFicGibTvMRjrWJzicaq8BD2tlIT0ngeia5eFxTa5dbDyicPYUK9n1wbJdTIR3lY7byXujVhy7w/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## **六、总结**

大家可以看到，其实使用此类代理并没有动态代理方便，甚至转换器可能会对JVM所有类都产生影响，操作起来更新相对麻烦，实际生产部署时会有很多不便。

但是，写这些是为了让大家更好、更多的去了解AOP，我们所熟知的AOP其实还有很多东西有待我们自身去学习和发现，其实Spring在"操作麻烦"这方面还是做了不少事的，提供了一些xml的配置化管理（此处就不再说了，因为感觉一说又是一大长篇，有兴趣的大家可以自己去看看，多了解写东西总没有坏处），很多情况下已经不需要再配置javaagent参数了。