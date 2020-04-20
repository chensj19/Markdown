# [Java分布式跟踪系统Zipkin](http://blog.mozhu.org/categories/zipkin/)

# 一、初识Zipkin

在2010年，谷歌发表了其内部使用的分布式跟踪系统Dapper的论文，讲述了Dapper在谷歌内部两年的演变和设计、运维经验。Twitter也根据该论文开发了自己的分布式跟踪系统Zipkin，并将其开源。
论文地址：<http://static.googleusercontent.com/media/research.google.com/zh-CN/archive/papers/dapper-2010-1.pdf>
译文地址：<http://bigbully.github.io/Dapper-translation/>

分布式跟踪系统还有其他比较成熟的实现，例如：Naver的Pinpoint、Apache的HTrace、阿里的鹰眼Tracing、京东的Hydra、新浪的Watchman，美团点评的CAT，skywalking等。

本系列博文，主要以Zipkin为主，介绍Zipkin的基本使用，原理，以及部分核心源代码的分析，当前Zipkin版本为2.2.1

### 1.1 概述

Zipkin是一款开源的分布式实时数据追踪系统（Distributed Tracking System），基于 Google Dapper的论文设计而来，由 Twitter 公司开发贡献。其主要功能是聚集来自各个异构系统的实时监控数据。

![架构图](http://static.blog.mozhu.org/images/zipkin/architecture-1.png)

如上图所示，各业务系统在彼此调用时，将特定的跟踪消息传递至zipkin，zipkin在收集到跟踪信息后将其聚合处理、存储、展示等，用户可通过web UI方便获得网络延迟、调用链路、系统依赖等等。

Zipkin主要包括四个模块

- **Collector** 接收或收集各应用传输的数据
- **Storage** 存储接受或收集过来的数据，当前支持Memory，MySQL，Cassandra，ElasticSearch等，默认存储在内存中。
- **API（Query）** 负责查询Storage中存储的数据，提供简单的JSON API获取数据，主要提供给web UI使用
- **UI** 提供简单的web界面

`Instrumented Client`和`Instrumented Server`，是指分布式架构中使用了Trace工具的两个应用，Client会调用Server提供的服务，两者都会向Zipkin上报Trace相关信息。在Client 和 Server通过Transport上报Trace信息后，由Zipkin的Collector模块接收，并由Storage模块将数据存储在对应的存储介质中，然后Zipkin提供API供UI界面查询Trace跟踪信息。
`Non-Instrumented Server`，指的是未使用Trace工具的Server，显然它不会上报Trace信息。

### 1.2 流程图

```
┌─────────────┐ ┌───────────────────────┐  ┌─────────────┐  ┌──────────────────┐
│ User Code   │ │ Trace Instrumentation │  │ Http Client │  │ Zipkin Collector │
└─────────────┘ └───────────────────────┘  └─────────────┘  └──────────────────┘
       │                 │                         │                 │
           ┌─────────┐
       │ ──┤GET /foo ├─▶ │ ────┐                   │                 │
           └─────────┘         │ record tags
       │                 │ ◀───┘                   │                 │
                           ────┐
       │                 │     │ add trace headers │                 │
                           ◀───┘
       │                 │ ────┐                   │                 │
                               │ record timestamp
       │                 │ ◀───┘                   │                 │
                             ┌─────────────────┐
       │                 │ ──┤GET /foo         ├─▶ │                 │
                             │X-B3-TraceId: aa │     ────┐
       │                 │   │X-B3-SpanId: 6b  │   │     │           │
                             └─────────────────┘         │ invoke
       │                 │                         │     │ request   │
                                                         │
       │                 │                         │     │           │
                                 ┌────────┐          ◀───┘
       │                 │ ◀─────┤200 OK  ├─────── │                 │
                           ────┐ └────────┘
       │                 │     │ record duration   │                 │
            ┌────────┐     ◀───┘
       │ ◀──┤200 OK  ├── │                         │                 │
            └────────┘       ┌────────────────────────────────┐
       │                 │ ──┤ asynchronously report span     ├────▶ │
                             │                                │
                             │{                               │
                             │  "traceId": "aa",              │
                             │  "id": "6b",                   │
                             │  "name": "get",                │
                             │  "timestamp": 1483945573944000,│
                             │  "duration": 386000,           │
                             │  "annotations": [              │
                             │--snip--                        │
                             └────────────────────────────────┘
```

由上图可以看出，应用的代码（User Code）发起Http Get请求（请求路径`/foo`），经过Trace框架（`Trace Instrumentation`）拦截，并依次经过如下步骤，记录`Trace`信息到`Zipkin`中：

1. 记录tags信息
2. 将当前调用链的Trace信息记录到Http Headers中
3. 记录当前调用的时间戳（timestamp）
4. 发送http请求，并携带Trace相关的Header，如X-B3-TraceId:aa，X-B3-SpandId:6b
5. 调用结束后，记录当次调用所花的时间（duration）
6. 将步骤1-5，汇总成一个Span（最小的Trace单元），异步上报该Span信息给Zipkin Collector

### 1.3 Zipkin的几个基本概念

**Span**：基本工作单元，一次链路调用（可以是RPC，DB等没有特定的限制）创建一个span，通过一个64位ID标识它， span通过还有其他的数据，例如描述信息，时间戳，key-value对的（Annotation）tag信息，parent-id等，其中parent-id 可以表示span调用链路来源，通俗的理解span就是一次请求信息

**Trace**：类似于树结构的Span集合，表示一条调用链路，存在唯一标识，即TraceId

**Annotation**：注解，用来记录请求特定事件相关信息（例如时间），通常包含四个注解信息

- **cs** - Client Start，表示客户端发起请求
- **sr** - Server Receive，表示服务端收到请求
- **ss** - Server Send，表示服务端完成处理，并将结果发送给客户端
- **cr** - Client Received，表示客户端获取到服务端返回信息

**BinaryAnnotation**：提供一些额外信息，一般以key-value对出现

### 1.4 安装

本系列博文使用的Zipkin版本为2.2.1，所需JDK为1.8

下载最新的ZIpkin的jar包，并运行

```bash
wget -O zipkin.jar 'https://search.maven.org/remote_content?g=io.zipkin.java&a=zipkin-server&v=LATEST&c=exec'
java -jar zipkin.jar
```

还可以使用docker，具体操作请参考：

<https://github.com/openzipkin/docker-zipkin>

启动成功后浏览器访问

<http://localhost:9411/>

打开Zipkin的Web UI界面

[![Zipkin Web UI](http://static.blog.mozhu.org/images/zipkin/1_1.png)](http://static.blog.mozhu.org/images/zipkin/1_1.png)

# 二、Brave源码分析-Tracer和Span

Brave是Java版的Zipkin客户端，它将收集的跟踪信息，以Span的形式上报给Zipkin系统。

（Zipkin是基于Google的一篇论文，名为Dapper，Dapper在荷兰语里是“勇敢的”的意思，这也是Brave的命名的原因）

Brave目前版本为4.9.1，兼容zipkin1和2的协议，github地址：<https://github.com/openzipkin/brave>

我们一般不会手动编写Trace相关的代码，Brave提供了一些开箱即用的库，来帮助我们对某些特定的库类来进行追踪，比如servlet，springmvc，mysql，okhttp3，httpclient等，这些都可以在下面页面中找到：

<https://github.com/openzipkin/brave/tree/master/instrumentation>

我们先来看看一个简单的Demo来演示下Brave的基本使用，这对我们后续分析Brave的原理和其他类库的使用有很大帮助

