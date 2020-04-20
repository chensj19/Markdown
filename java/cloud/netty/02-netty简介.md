# [Netty 简介](https://www.jianshu.com/p/a4e03835921a)

## 1、IO编程

`SocketServer`

```java
public class SocketServerModule {
    public static void main(String[] args){
        server();
    }

    private static void server() {
        ServerSocket serverSocket = null;
        InputStream in = null;
        OutputStream out = null;
        Socket clientSocket = null;
        try {
            serverSocket = new ServerSocket(8080);
            int receiveMessageSize = 0;
            byte[] recvBuf = new byte[1024];
            while (true) {
                System.out.println("server将一直等待连接的到来");
                clientSocket = serverSocket.accept();
                // 获取访问的连接
                SocketAddress clientAddress = clientSocket.getRemoteSocketAddress();
                System.out.println("Handling client at " + clientAddress);
                // 建立好连接后，从socket中获取输入流，并建立缓冲区进行读取
                in = clientSocket.getInputStream();
                while ((receiveMessageSize = in.read(recvBuf)) != -1) {
                    byte[] temp = new byte[receiveMessageSize];
                    System.arraycopy(recvBuf, 0, temp, 0, receiveMessageSize);
                    System.out.println("客户端信息："+new String(temp,"UTF-8"));
                }
                // 从socket中获取输出流
                out = clientSocket.getOutputStream();
                // 向输出流写入数据
                String format = DateFormatUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss.SSS");
                out.write(("Hello Client,I get the message. @ "+format).getBytes("UTF-8"));
                // 清空输出流
                out.flush();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            NioUtils.close(in, out, clientSocket,serverSocket);
        }
    }
}
```

`SocketClient`

```java
public class SocketClientModule {
    private static final int PORT = 8080;
    private static final int BUFFER_SIZE = 1024;

    public static void main(String[] args) {
        int i = 0;
        while (true){
            i++;
            client();
            System.out.println(i);
        }

    }
    private static void client() {
        Socket socket = null;
        OutputStream out = null;
        InputStream in = null;
        try {
            // 休息 2s
            TimeUnit.SECONDS.sleep(2);
            socket = new Socket(InetAddress.getLocalHost(), PORT);
            // 建立连接后获得输出流
            out = socket.getOutputStream();
            String format = DateFormatUtils.format(new Date(), "yyyy-MM-dd HH:mm:ss.SSS");
            String message = "你好 SocketServer , @ " + format;
            out.write(message.getBytes(StandardCharsets.UTF_8));
            out.flush();
            // 通过shutdownOutput高速服务器已经发送完数据，后续只能接受数据
            socket.shutdownOutput();
            // 从socket中获取输入流
            in = socket.getInputStream();
            // 接收数据缓冲区
            byte[] bytes = new byte[BUFFER_SIZE];
            // 接收数据大小
            int receiveSize = 0;
            while ((receiveSize = in.read(bytes)) != -1) {
                byte[] temp = new byte[receiveSize];
                System.arraycopy(bytes, 0, temp, 0, receiveSize);
                System.out.println("服务端信息：" + new String(temp, "UTF-8"));
                // 判断是否最后一次，如果是则接收读取操作
                if(receiveSize < BUFFER_SIZE){
                    break;
                }
            }
            System.out.println("socket end");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            NioUtils.close(in, out, socket);
        }
    }
}
```

从服务端代码中我们可以看到，在传统的IO模型中，每个连接创建成功之后都需要一个线程来维护，每个线程包含一个while死循环，那么1w个连接对应1w个线程，继而1w个while死循环，这就带来如下几个问题：

1. 线程资源受限：线程是操作系统中非常宝贵的资源，同一时刻有大量的线程处于阻塞状态是非常严重的资源浪费，操作系统耗不起
2. 线程切换效率低下：单机cpu核数固定，线程爆炸之后操作系统频繁进行线程切换，应用性能急剧下降。
3. 除了以上两个问题，IO编程中，我们看到数据读写是以字节流为单位，效率不高。

## 2、NIO编程

java 1.4 之后提出NIO，详细文章参考[01-NIO](01-NIO.md)，下面来说明NIO如何解决上面三个问题

### 2.1 线程资源受限

NIO编程模型中，新来一个连接不再创建一个新的线程，而是可以把这条连接直接绑定到某个固定的线程，然后这条连接所有的读写都由这个线程来负责，那么他是怎么做到的？我们用一幅图来对比一下IO与NIO

![IO&NIO](https://upload-images.jianshu.io/upload_images/1357217-1c856423372e7d5a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/755/format/webp)

如上图所示，IO模型中，一个连接来了，会创建一个线程，对应一个while死循环，死循环的目的就是不断监测这条连接上是否有数据可以读，大多数情况下，1w个连接里面同一时刻只有少量的连接有数据可读，因此，很多个while死循环都白白浪费掉了，因为读不出啥数据。

而在NIO模型中，他把这么多while死循环变成一个死循环，这个死循环由一个线程控制，那么他又是如何做到一个线程，一个while死循环就能监测1w个连接是否有数据可读的呢？
 这就是NIO模型中selector的作用，一条连接来了之后，现在不创建一个while死循环去监听是否有数据可读了，而是直接把这条连接注册到selector上，然后，通过检查这个selector，就可以批量监测出有数据可读的连接，进而读取数据，下面我再举个非常简单的生活中的例子说明IO与NIO的区别。

在一家幼儿园里，小朋友有上厕所的需求，小朋友都太小以至于你要问他要不要上厕所，他才会告诉你。幼儿园一共有100个小朋友，有两种方案可以解决小朋友上厕所的问题：

1. 每个小朋友配一个老师。每个老师隔段时间询问小朋友是否要上厕所，如果要上，就领他去厕所，100个小朋友就需要100个老师来询问，并且每个小朋友上厕所的时候都需要一个老师领着他去上，这就是IO模型，一个连接对应一个线程。
2. 所有的小朋友都配同一个老师。这个老师隔段时间询问所有的小朋友是否有人要上厕所，然后每一时刻把所有要上厕所的小朋友批量领到厕所，这就是NIO模型，所有小朋友都注册到同一个老师，对应的就是所有的连接都注册到一个线程，然后批量轮询。

这就是NIO模型解决线程资源受限的方案，实际开发过程中，我们会开多个线程，每个线程都管理着一批连接，相对于IO模型中一个线程管理一条连接，消耗的线程资源大幅减少

### 2.2 线程切换效率低下

由于NIO模型中线程数量大大降低，线程切换效率因此也大幅度提高

### 2.3 字节流

NIO解决这个问题的方式是数据读写不再以Byte为单位，而是以BufferByte为单位。IO模型中，每次都是从操作系统底层一个字节一个字节地读取数据，而NIO维护一个缓冲区，每次可以从这个缓冲区里面读取一块的数据，
 这就好比一盘美味的豆子放在你面前，你用筷子一个个夹（每次一个），肯定不如要勺子挖着吃（每次一批）效率来得高。

简单讲完了JDK NIO的解决方案之后，我们接下来使用NIO的方案替换掉IO的方案，我们先来看看，如果用JDK原生的NIO来实现服务端，该怎么做

### 2.4 示例

#### 2.4.1 NioServer

```java
public class NioServer {
    /**
     * 端口
     * 用于端口监听
     */
    public static final Integer PORT = 8080;
    /**
     * 过期时间
     * 用于selector 阻塞
     */
    public static final Long TIME_OUT = 3000L;
    /**
     * 缓冲区大小
     * 用于ByteBuffer分配
     */
    public static final Integer BUFFER_SIZE = 1024;

    public static void main(String[] args) throws IOException {
        // socket server 使用的selector
        Selector serverSelector = Selector.open();
        // socket client 使用的selector
        Selector clientSelector = Selector.open();
        // 创建serverSelector轮询线程
        // 负责轮询是否有新的连接 SelectionKey.OP_ACCEPT
        new Thread(() -> {
            try {
                ServerSocketChannel listenChannel = ServerSocketChannel.open();
                // 指定监听端口
                listenChannel.socket().bind(new InetSocketAddress(PORT));
                // 设置为非阻塞
                listenChannel.configureBlocking(false);
                // 注册selector到channel，并指定监听事件
                listenChannel.register(serverSelector, SelectionKey.OP_ACCEPT);
                while (true) {
                    // 监测是否有新的连接，这里的1指的是阻塞的时间为3000ms
                    if (serverSelector.select(TIME_OUT) == 0) {
                        System.out.println("连接还没有就绪，请稍候.....");
                        continue;
                    }
                    // 循环SelectionKey
                    Iterator<SelectionKey> iterator = serverSelector.selectedKeys().iterator();
                    while (iterator.hasNext()) {
                        SelectionKey key = iterator.next();
                        // 判断是否是新来的连接
                        if (key.isAcceptable()) {
                            try {
                                // 新来的连接，直接注册到clientSelector来处理
                                SocketChannel clientSocketChannel = (SocketChannel) key.channel();
                                clientSocketChannel.configureBlocking(false);
                                clientSocketChannel.register(clientSelector, SelectionKey.OP_READ);
                            } finally {
                                // 移除当前的key
                                iterator.remove();
                            }
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();

        // 创建clientSelector轮询线程
        // 轮询连接是否有数据可读 SelectionKey.OP_READ
        new Thread(() -> {
            try {
                while (true) {
                    // 批量轮询是否有哪些连接有数据可读，这里的1指的是阻塞的时间为3000ms
                    if (clientSelector.select(TIME_OUT) == 0) {
                        System.out.println("还没有需要处理的SelectionKey.OP_READ事件数据，继续等待.....");
                        continue;
                    }

                    Iterator<SelectionKey> iterator = clientSelector.selectedKeys().iterator();
                    while (iterator.hasNext()) {
                        SelectionKey key = iterator.next();
                        // 判断是否是数据可读
                        if (key.isReadable()) {
                            try {
                                // 数据可读连接
                                SocketChannel clientChannel = (SocketChannel) key.channel();
                                // 设置缓冲区
                                ByteBuffer buffer = ByteBuffer.allocate(BUFFER_SIZE);
                                // 读取数据 按照以块为单位批量读取
                                clientChannel.read(buffer);
                                // 缓存区状态变化，指定需要处理的数据的position和limit
                                buffer.flip();
                                // 输出结果
                                System.out.println(
                                        Charset.defaultCharset().newDecoder().decode(buffer).toString()
                                );
                            } finally {
                                // 移除当前的key
                                iterator.remove();
                                // 指定当前这个key 继续关注的事件类型
                                key.interestOps(SelectionKey.OP_READ);
                            }
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
```

相信大部分没有接触过NIO的同学应该会直接跳过代码来到这一行：原来使用JDK原生NIO的API实现一个简单的服务端通信程序是如此复杂!

复杂得我都没耐心解释这一坨代码的执行逻辑(开个玩笑)，我们还是先对照NIO来解释一下几个核心思路

1. NIO模型中通常会有两个线程，每个线程绑定一个轮询器selector，在我们这个例子中`serverSelector`负责轮询是否有新的连接，`clientSelector`负责轮询连接是否有数据可读
2. 服务端监测到新的连接之后，不再创建一个新的线程，而是直接将新连接绑定到`clientSelector`上，这样就不用IO模型中1w个while循环在死等，参见(1)
3.  `clientSelector`被一个while死循环包裹着，如果在某一时刻有多条连接有数据可读，那么通过 `clientSelector.select(1)`方法可以轮询出来，进而批量处理，参见(2)
4. 数据的读写以内存块为单位，参见(3)

其他的细节部分，我不愿意多讲，因为实在是太复杂，你也不用对代码的细节深究到底。总之，强烈不建议直接基于JDK原生NIO来进行网络开发，下面是我总结的原因

1、JDK的NIO编程需要了解很多的概念，编程复杂，对NIO入门非常不友好，编程模型不友好，ByteBuffer的api简直反人类
 2、对NIO编程来说，一个比较合适的线程模型能充分发挥它的优势，而JDK没有给你实现，你需要自己实现，就连简单的自定义协议拆包都要你自己实现
 3、JDK的NIO底层由epoll实现，该实现饱受诟病的空轮训bug会导致cpu飙升100%
 4、项目庞大之后，自行实现的NIO很容易出现各类bug，维护成本较高，上面这一坨代码我都不能保证没有bug

正因为如此，我客户端代码都懒得写给你看了==!，你可以直接使用`IOClient.java`与`NIOServer.java`通信

JDK的NIO犹如带刺的玫瑰，虽然美好，让人向往，但是使用不当会让你抓耳挠腮，痛不欲生，正因为如此，Netty横空出世！

## 3、 Netty

那么Netty到底是何方神圣？
 用一句简单的话来说就是：Netty封装了JDK的NIO，让你用得更爽，你不用再写一大堆复杂的代码了。
 用官方正式的话来说就是：Netty是一个异步事件驱动的网络应用框架，用于快速开发可维护的高性能服务器和客户端。

下面是我总结的使用Netty不使用JDK原生NIO的原因

1. 使用JDK自带的NIO需要了解太多的概念，编程复杂，一不小心bug横飞
2. Netty底层IO模型随意切换，而这一切只需要做微小的改动，改改参数，Netty可以直接从NIO模型变身为IO模型
3. Netty自带的拆包解包，异常检测等机制让你从NIO的繁重细节中脱离出来，让你只需要关心业务逻辑
4. Netty解决了JDK的很多包括空轮询在内的bug
5. Netty底层对线程，selector做了很多细小的优化，精心设计的reactor线程模型做到非常高效的并发处理
6. 自带各种协议栈让你处理任何一种通用协议都几乎不用亲自动手
7. Netty社区活跃，遇到问题随时邮件列表或者issue
8. Netty已经历各大rpc框架，消息中间件，分布式通信中间件线上的广泛验证，健壮性无比强大

### 3.1 改写样例

#### 3.1.1 NettyServer

```java
public class NettyServer {

    public static void main(String[] args) {

        ServerBootstrap serverBootstrap = new ServerBootstrap();
        // 接受新连接线程，主要负责创建新连接
        // 与SocketServerNioServer中serverSelector线程对应
        NioEventLoopGroup boots = new NioEventLoopGroup();
        // 负责读取数据的线程，主要用于读取数据以及业务逻辑处理
        // 与SocketServerNioServer中clientSelector线程对应
        NioEventLoopGroup worker = new NioEventLoopGroup();

        serverBootstrap.group(boots, worker)
                .channel(NioServerSocketChannel.class)
                .childHandler(new ChannelInitializer<NioSocketChannel>() {
                    @Override
                    protected void initChannel(NioSocketChannel nsh) throws Exception {
                        nsh.pipeline().addLast(new StringDecoder());
                        nsh.pipeline().addLast(new SimpleChannelInboundHandler<String>() {
                            @Override
                            protected void channelRead0(ChannelHandlerContext channelHandlerContext,
                                                        String msg) throws Exception {
                                System.out.println(msg);
                            }
                        });
                    }
                }).bind(Constants.PORT);

    }
}
```

这么一小段代码就实现了我们前面NIO编程中的所有的功能，包括服务端启动，接受新连接，打印客户端传来的数据，怎么样，是不是比JDK原生的NIO编程优雅许多？

初学Netty的时候，由于大部分人对NIO编程缺乏经验，因此，将Netty里面的概念与IO模型结合起来可能更好理解

1.`boots`对应，`NioServer.java`中的接受新连接线程，主要负责创建新连接
 2.`worker`对应 `NioServer.java`中的负责读取数据的线程，主要用于读取数据以及业务逻辑处理

#### 3.1.2 NettyClient

```java
public class NettyClient {

    public static void main(String[] args) throws UnknownHostException, InterruptedException {
       Bootstrap bootstrap = new Bootstrap();
        // Socket 启动的线程
        NioEventLoopGroup group = new NioEventLoopGroup();

        bootstrap.group(group)
                .channel(NioSocketChannel.class)
                .handler(new ChannelInitializer<Channel>() {
                    @Override
                    protected void initChannel(Channel channel) throws Exception {
                        channel.pipeline().addLast(new StringEncoder());
                    }
                });
        Channel channel = bootstrap.connect(InetAddress.getLocalHost(), Constants.PORT).channel();
        while (true){
            channel.writeAndFlush("Netty Client @"+ DateFormatUtils.format(new Date(),"yyyy-MM-dd HH:mm:ss.SSS") +" : hello world");
            TimeUnit.SECONDS.sleep(3);
        }
    }
}
```

在客户端程序中，`group`对应了我们`SocketClientNioModule.java`中main函数起的线程，剩下的逻辑我在后面的文章中会详细分析，现在你要做的事情就是把这段代码拷贝到你的IDE里面，然后运行main函数，最后回到`NettyServer.java`的控制台，你会看到效果。

使用Netty之后是不是觉得整个世界都美好了，一方面Netty对NIO封装得如此完美，写出来的代码非常优雅，另外一方面，使用Netty之后，网络通信这块的性能问题几乎不用操心，尽情地让Netty榨干你的CPU吧。