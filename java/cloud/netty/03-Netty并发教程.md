# Netty 并发教程

> Netty is *an asynchronous event-driven network application framework* 
> for rapid development of maintainable high performance protocol servers & clients.
>
> Netty是一个异步基于事件驱动的网络应用框架，用于快速开发可维护的高性能的协议服务器和客户端
>
> Netty is a NIO client server framework which enables quick and easy development of network applications such as protocol servers and clients. It greatly simplifies and streamlines network programming such as TCP and UDP socket server.
>
> Netty是一个NIO C/S 框架(服务端和客户端均可以使用)，可以快速轻松地开发网络应用程序，比如协议服务器和客户端。它极大地简化和流线化了网络编程，比如TCP和UDP socket server。
>
> 'Quick and easy' doesn't mean that a resulting application will suffer from a maintainability or a performance issue. Netty has been designed carefully with the experiences earned from the implementation of a lot of protocols such as FTP, SMTP, HTTP, and various binary and text-based legacy protocols. As a result, Netty has succeeded to find a way to achieve ease of development, performance, stability, and flexibility without a compromise.
>
> “快速简便”并不意味着最终的应用程序将会遭受到可维护性或性能问题的影响。Netty是经过精心设计，设计包含了具有丰富的协议，比如FTP，SMTP，HTTP以及各种二进制和基于文本的传统协议。因此，Netty成功地找到了一种在不妥协的情况下实现易于开发，性能，稳定性和灵活性的方法。

## 特性 Features

### 设计 Design

* 为多种多样的传输类型提供了统一的API--阻塞或者非阻塞的socket 
* 基于灵活且可扩展的事件模型，可以清晰地分离关注点(separation of concerns)
* 提供了高度可定制化的线程模型-单线程，一个或多个线程池，如SEDA
  * SEDA Staged Event Driven Architecture
  * 阶段事件驱动架构
  * 一个请求的过程分成不同的Staged，每个不同的Staged根据情况来使用不同数量的线程来完成处理，阶段之间是异步进行通信
* 真正的无连接数据报套接字支持（自3.1起）

### 易于使用 Ease of use

* 详细记录的Javadoc，用户指南和示例
* 没有其他依赖项，JDK 5（Netty 3.x）或6（Netty 4.x）就足够了
  * 注意：某些组件（如HTTP / 2）可能有更多要求。 有关更多信息，请参阅 [“要求”页面](https://netty.io/wiki/requirements.html)。

### 性能 Performance

* 更高的吞吐量，更低的延迟
* 减少资源消耗
* 最小化不必要的内存复制

### 安全 Security

* 完整的SSL / TLS和StartTLS支持

### 社区 Community

- 早发布，经常发布
- 自2003年以来，作者一直在编写类似的框架，他仍然发现你的反馈很珍贵！

## Netty 版本

Netty官网的中提供了三个版本`3.x`、`4.0.x`、`4.1.x`，

建议学习使用`4.1.x`版本。

源代码：[GitHub](https://github.com/netty/netty)

源代码结构是基于功能划分。

## 架构

![架构图](https://netty.io/images/components.png)

按照结构划分为三个部分：

* Transport Services 

  传输服务

  * 支持Socket和Datagram
  * HTTP 隧道
  * VM 管道

* Protocol Support

  协议支持

* Core 

  * 可扩展事件模型
  * 统一的通信API
  * 零拷贝的富ByteBuffer

