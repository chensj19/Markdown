# Zipkin

## Zipkin初摸

​		正如 [Ziplin官网](https://zipkin.io/) 所描述，Zipkin是一款分布式的追踪系统，其可以帮助我们收集微服务架构中用于解决延时问题的时序数据，更直白地讲就是可以帮我们追踪调用的轨迹。

​	Zipkin的设计架构如下图所示：

![Zipkin的设计架构](https://upload-images.jianshu.io/upload_images/9824247-d30c7c39fedac161.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/661/format/webp)

要理解这张图，需要了解一下Zipkin的几个核心概念：

- Reporter

在某个应用中安插的用于发送数据给Zipkin的组件称为Report，目的就是用于追踪数据收集

- Span

微服务中调用一个组件时，从发出请求开始到被响应的过程会持续一段时间，将这段跨度称为Span

- Trace

从Client发出请求到完成请求处理，中间会经历一个调用链，将这一个整个过程称为一个追踪（Trace）。一个Trace可能包含多个Span，反之每个Span都有一个上级的Trace。

- Transport

一种数据传输的方式，比如最简单的HTTP方式，当然在高并发时可以换成Kafka等消息队列

看了一下基本概念后，再结合上面的架构图，可以试着理解一下，只有装配有Report组件的Client才能通过Transport来向Zipkin发送追踪数据。追踪数据由Collector收集器进行手机然后持久化到Storage之中。最后需要数据的一方，可以通过UI界面调用API接口，从而最终取到Storage中的数据。可见整体流程不复杂。

Zipkin官网给出了各种常见语言支持的OpenZipkin libraries：

 ![](https://upload-images.jianshu.io/upload_images/9824247-2293db1655e54057.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/971/format/webp)

本文接下来将 **构造微服务追踪的实验场景** 并使用 **Brave** 来辅助完成微服务调用链追踪中心搭建！

## 部署Zipkin服务

利用Docker来部署Zipkin服务再简单不过了：

```
docker run -d -p 9411:9411 \
--name zipkin \
docker.io/openzipkin/zipkin
```

完成之后浏览器打开：`localhost:9411`可以看到Zipkin的可视化界面：

![](https://upload-images.jianshu.io/upload_images/9824247-46f2092bf3e778a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp)

