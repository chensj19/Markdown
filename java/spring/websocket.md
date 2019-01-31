# WebSocket

##  1.简介

WebSocket是HTML5开始提供的一种浏览器与服务器间进行全双工通讯的网络技术。依靠这种技术可以实现客户端和服务器端的长连接，双向实时通信，允许服务器主动发送信息给客户端。
特点:事件驱动、异步，使用ws或者wss协议的客户端socket，能够实现真正意义上的推送功能
缺点：少部分浏览器不支持，浏览器支持的程度与方式有区别。
浏览器端：
websocket允许通过JavaScript建立与远程服务器的连接，从而实现客户端与服务器间双向的通信。

### 1.1 websocket中的方法：
1. send() 向远程服务器发送数据
2. close() 关闭该websocket链接
### 1.2 websocket中的事件
1. onopen 当网络连接建立时触发该事件

2. onerror 当网络发生错误时触发该事件

3. onclose 当websocket被关闭时触发该事件

4. onmessage 当websocket接收到服务器发来的消息的时触发的事件，也是通信中最重要的一个监听事件。

### 1.3 websocket中的属性
1. Socket.readyState

   1. 只读属性 **readyState** 表示连接状态，可以是以下值：

      1.  0 - 表示连接尚未建立。

      2.  1 - 表示连接已建立，可以进行通信。

      3.  2 - 表示连接正在进行关闭。

      4.  3 - 表示连接已经关闭或者连接不能打开。
2. Socket.bufferedAmount
   1. 只读属性 **bufferedAmount** 已被 send() 放入正在队列中等待传输，但是还没有发出的 UTF-8 文本字节数。

### 1.4 Java服务端：
JSR356定义了WebSocket的规范，JSR356 的 WebSocket 规范使用 javax.websocket.*的 API，可以将一个普通 Java 对象（POJO）使用 @ServerEndpoint 注释作为 WebSocket 服务器的端点。

### 1.5 实现原理

​	在实现websocket连线过程中，需要通过浏览器发出websocket连线请求，然后服务器发出回应，这个过程通常称为“握手” 。在 WebSocket API，浏览器和服务器只需要做一个握手的动作，然后，浏览器和服务器之间就形成了一条快速通道。两者之间就直接可以数据互相传送。

![](https://images2017.cnblogs.com/blog/1318474/201802/1318474-20180201103651390-1585236943.png)

### 1.6 WebSocket与Socket对比

#### 1.6.1 WebSocket

1. websocket通讯的建立阶段是依赖于http协议的。最初的握手阶段是http协议，握手完成后就切换到websocket协议，并完全与http协议脱离了。
2. 建立通讯时，也是由客户端主动发起连接请求，服务端被动监听。
3. 通讯一旦建立连接后，通讯就是“全双工”模式了。也就是说服务端和客户端都能在任何时间自由得发送数据，非常适合服务端要主动推送实时数据的业务场景。
4. 交互模式不再是“请求-应答”模式，完全由开发者自行设计通讯协议。
5. 通信的数据是基于“帧(frame)”的，可以传输文本数据，也可以直接传输二进制数据，效率高。当然，开发者也就要考虑封包、拆包、编号等技术细节。

#### 1.6.2 Socket

1.  服务端监听通讯，被动提供服务；客户端主动向服务端发起连接请求，建立起通讯。
2. 每一次交互都是：客户端主动发起请求（request），服务端被动应答（response）。
3. 服务端不能主动向客户端推送数据。
4. 通信的数据是基于文本格式的。二进制数据（比如图片等）要利用base64等手段转换为文本后才能传输。



## 2. AJAX轮询与WebSocket对比

![](http://www.runoob.com/wp-content/uploads/2016/03/ws.png)

​	很多网站为了实现推送技术，所用的技术都是 Ajax 轮询。轮询是在特定的的时间间隔（如每1秒），由浏览器对服务器发出HTTP请求，然后由服务器返回最新的数据给客户端的浏览器。这种传统的模式带来很明显的缺点，即浏览器需要不断的向服务器发出请求，然而HTTP请求可能包含较长的头部，其中真正有效的数据可能只是很小的一部分，显然这样会浪费很多的带宽等资源。

​	HTML5 定义的 WebSocket 协议，能更好的节省服务器资源和带宽，并且能够更实时地进行通讯。

## 3.WebSocket 特点 

(1)建立在 TCP 协议之上,服务器端的实现比较容易。 

(2)与 HTTP 协议有着良好的兼容性。默认端口也是80和443,并且握手阶段采用 HTTP 协议,因此握手时不容易屏蔽,能通过各种 HTTP 代理服务器。 

(3)数据格式比较轻量,性能开销小,通信高效。 

(4)可以发送文本,也可以发送二进制数据。 

(5)没有同源限制,客户端可以与任意服务器通信。 

(6)协议标识符是 ws (如果加密,则为 wss ),服务器网址就是 URL。

 ```js
ws://example.com:80/some/path
 ```

![](http://aliyunzixunbucket.oss-cn-beijing.aliyuncs.com/jpg/1fe0bfbec9213af074b8778651e6061d.jpg?x-oss-process=image/resize,p_100/auto-orient,1/quality,q_90/format,jpg/watermark,image_eXVuY2VzaGk=,t_100,g_se,x_0,y_0)

## 4.Java Demo

### 4.1 `pom.xml`

```xml
<dependency>
    <groupId>javax.websocket</groupId>
    <artifactId>javax.websocket-api</artifactId>
    <version>1.1</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>javax</groupId>
    <artifactId>javaee-api</artifactId>
    <version>7.0</version>
    <scope>provided</scope>
</dependency>
```

### 4.2 `WebSocketServer.java`

```java
package com.winning.websocket.server;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import com.alibaba.fastjson.JSONObject;

@ServerEndpoint(value="/ws/{username}")
public class WebSocketServer {

	private static int onlineCount = 0;  
    private static Map<String, WebSocketServer> clients = new ConcurrentHashMap<String, WebSocketServer>();  
    private Session session;  
    private String username;  
      
    @OnOpen  
    public void onOpen(@PathParam("username") String username, Session session) throws IOException {  
  
        this.username = username;  
        this.session = session;  
          
        addOnlineCount();  
        clients.put(username, this);  
        System.out.println("已连接");  
    }  
  
    @OnClose  
    public void onClose() throws IOException {  
        clients.remove(username);  
        subOnlineCount();  
    }  
  
    @OnMessage  
    public void onMessage(String message) throws IOException {  
  
        JSONObject jsonTo = JSONObject.parseObject(message);  
          
        if (!jsonTo.get("To").equals("All")){  
            sendMessageTo("给一个人", jsonTo.get("To").toString());  
        }else{  
            sendMessageAll("给所有人");  
        }  
    }  
  
    @OnError  
    public void onError(Session session, Throwable error) {  
        error.printStackTrace();  
    }  
  
    public void sendMessageTo(String message, String To) throws IOException {  
        // session.getBasicRemote().sendText(message);  
        //session.getAsyncRemote().sendText(message);  
        for (WebSocketServer item : clients.values()) {  
            if (item.username.equals(To) )  
                item.session.getAsyncRemote().sendText(message);  
        }  
    }  
      
    public void sendMessageAll(String message) throws IOException {  
        for (WebSocketServer item : clients.values()) {  
            item.session.getAsyncRemote().sendText(message);  
        }  
    }  
      
      
  
    public static synchronized int getOnlineCount() {  
        return onlineCount;  
    }  
  
    public static synchronized void addOnlineCount() {  
    	WebSocketServer.onlineCount++;  
    }  
  
    public static synchronized void subOnlineCount() {  
    	WebSocketServer.onlineCount--;  
    }  
  
    public static synchronized Map<String, WebSocketServer> getClients() {  
        return clients;  
    }  
}

```

### 4.3 `index.jsp`

```jsp
<%@page pageEncoding="utf-8" language="java" %>
<html>
<body>
<h2>Hello World!</h2>
<div id='content'>

</div>
</body>
<script>
	var websocket = null;
	if ('WebSocket' in window) {  
	    websocket = new WebSocket("ws://" + document.location.host + "/websoket-web-demo/ws/admin");  
	} else {  
	    alert('当前浏览器 Not support websocket')  
	}  
	
	//连接发生错误的回调方法  
	websocket.onerror = function() {  
	    setMessageInnerHTML("WebSocket连接发生错误");  
	};  
	  
	//连接成功建立的回调方法  
	websocket.onopen = function() {  
	    setMessageInnerHTML("WebSocket连接成功");  
	}  
	  
	//接收到消息的回调方法  
	websocket.onmessage = function(event) {  
	    setMessageInnerHTML(event.data);  
	}  
	  
	//连接关闭的回调方法  
	websocket.onclose = function() {  
	    setMessageInnerHTML("WebSocket连接关闭");  
	}  
	  
	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。  
	window.onbeforeunload = function() {  
	    closeWebSocket();  
	}  
	  
	//关闭WebSocket连接  
	function closeWebSocket() {  
	    websocket.close();  
	}  
	
	function setMessageInnerHTML(msg){
		console.log(msg)
		
	}
</script>
</html>
```

## 5、spring boot 集成 websocket

### 5.1 `pom.xml`

```xml
<dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-websocket</artifactId>
</dependency>
```

### 5.2  `WebSocketConfig`

```java
package com.winning.devops.websocket.logger.system.config;

import com.winning.devops.websocket.logger.system.core.LoggerQueue;
import com.winning.devops.websocket.logger.system.model.LoggerMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import javax.annotation.PostConstruct;
import java.util.concurrent.*;

/**
 * @author chensj
 * @title WebSocketConfig配置
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.config
 * @date: 2019-01-30 19:56
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    /**
     *  该registerStompEndpoints()方法注册“/test-info”端点，
     *  启用SockJS后备选项，以便在WebSocket不可用时可以使用替代传输。
     *  SockJS客户端将尝试连接到“/test-sockJs”
     *  并使用可用的最佳传输（websocket，xhr-streaming，xhr-polling等）。
     * @param registry
     */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/logger").setAllowedOrigins("*").withSockJS();
    }

    /**
     *  该configureMessageBroker()方法将重写方法WebSocketMessageBrokerConfigurer来配置消息代理。
     *  它首先调用enableSimpleBroker()一个简单的基于内存的消息代理，将问候消息带回以“/stock”为前缀的客户端。
     *  它还指定了为“ @MessageMapping注解”方法绑定的消息的“/app”前缀。这个前缀将被用来定义所有的消息映射;
     *  例如，“/app/hello”是该GreetingController.greeting()方法被映射为处理的端点。
     * @param registry
     */
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/topic");
        registry.setApplicationDestinationPrefixes("/app");
    }
}

```

### 5.3  `GreetingsController`

```java
package com.winning.devops.websocket.logger.web;

import com.winning.devops.websocket.logger.system.core.LoggerQueue;
import com.winning.devops.websocket.logger.system.model.Greeting;
import com.winning.devops.websocket.logger.system.model.HelloMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

/**
 * @author chensj
 * @title
 * @project spring-boot-websocket
 * @package com.winning.devops.springboot.websocket.web
 * @date: 2019-01-30 14:47
 */
@Controller
public class GreetingController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    private static final Logger LOG = LoggerFactory.getLogger(GreetingController.class);
    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public Greeting greeting(HelloMessage message) throws InterruptedException {
        LOG.info(message.toString());
        Thread.sleep(1000);
        return new Greeting("Hello, " + HtmlUtils.htmlEscape(message.getName()) + "!");
    }
}
```

### 5.4 `index.html`

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hello WebSocket</title>
    <link href="/webjars/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/main.css" rel="stylesheet">
    <script src="/webjars/jquery/jquery.min.js"></script>
    <script src="/webjars/sockjs-client/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/stomp.min.js"></script>
    <script src="/app.js"></script>
    <script src="/layer/layer.js"></script>
</head>
<body>
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being
    enabled. Please enable
    Javascript and reload this page!</h2></noscript>
<div id="main-content" class="container">
    <div class="row">
        <div class="col-md-6">
            <form class="form-inline">
                <div class="form-group">
                    <label for="connect">WebSocket 连接:</label>
                    <button id="connect" class="btn btn-default" type="submit">连接</button>

                    <button id="disconnect" class="btn btn-default" type="submit" disabled="disabled">断开
                    </button>
                    <button id="log" class="btn btn-default" type="submit">日志查看</button>
                </div>
            </form>
        </div>
        <div class="col-md-6">
            <form class="form-inline">
                <div class="form-group">
                    <label for="name">你的姓名是什么?</label>
                    <input type="text" id="name" class="form-control" placeholder="输入你的姓名...">
                </div>
                <button id="send" class="btn btn-default" type="submit">发送</button>
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table id="conversation" class="table table-striped">
                <thead>
                <tr>
                    <th>问候</th>
                </tr>
                </thead>
                <tbody id="greetings">
                </tbody>
            </table>
        </div>
    </div>
</div>
<div id="logdiv" style="display: none">
    <button id="logConnect" class="btn btn-default" type="submit">日志连接</button>
    <div id="log-container" class="container">
        <div>日志内容</div>
    </div>
</div>
</body>
</html>

```

### 5.5 `app.js`

```js
var stompClient = null;

function setConnected(connected) {
    $("#connect").prop("disabled", connected);
    $("#disconnect").prop("disabled", !connected);
    if (connected) {
        $("#conversation").show();
    }
    else {
        $("#conversation").hide();
    }
    $("#greetings").html("");
}

function connect() {
    var socket = new SockJS('/logger');
    stompClient = Stomp.over(socket);
    stompClient.connect({}, function (frame) {
        setConnected(true);
        console.log('Connected: ' + frame);
        stompClient.subscribe('/topic/greetings', function (greeting) {
            showGreeting(JSON.parse(greeting.body).content);
        });
    });
}

function disconnect() {
    if (stompClient !== null) {
        stompClient.disconnect();
    }
    setConnected(false);
    console.log("Disconnected");
}

function sendName() {
    stompClient.send("/app/hello", {}, JSON.stringify({'name': $("#name").val()}));
}

function showGreeting(message) {
    $("#greetings").append("<tr><td>" + message + "</td></tr>");
}

function closeSocket() {
    if (stompClient != null) {
        stompClient.disconnect();
        stompClient = null;
    }
}
$(function () {
    $("form").on('submit', function (e) {
        e.preventDefault();
    });
    $( "#connect" ).click(function() { connect(); });
    $( "#disconnect" ).click(function() { disconnect(); });
    $( "#send" ).click(function() { sendName(); });
});
```

## 6、 基于WebSocket和Spring boot展示web日志页面

将日志推送到主题，客户端自动获取日志

### 6.1 `pom.xml`
```xml
	<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.0.6.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.winning.devops</groupId>
    <artifactId>spring-boot-websocket-logger</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <name>spring-boot-websocket-logger</name>
    <description>基于spring-boot实现websocket日志显示</description>

    <properties>
        <java.version>1.8</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-websocket</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>com.lmax</groupId>
            <artifactId>disruptor</artifactId>
            <version>3.4.2</version>
        </dependency>
        <!-- aop -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-aop</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.49</version>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>webjars-locator-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>sockjs-client</artifactId>
            <version>1.0.2</version>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>stomp-websocket</artifactId>
            <version>2.3.3</version>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>bootstrap</artifactId>
            <version>3.3.7</version>
        </dependency>
        <dependency>
            <groupId>org.webjars</groupId>
            <artifactId>jquery</artifactId>
            <version>3.1.0</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>

</project>

```
### 6.2 `java`

#### 6.2.1 `WebSocketConfig.java`

```java
package com.winning.devops.websocket.logger.system.config;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

/**
 * @author chensj
 * @title WebSocketConfig配置
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.config
 * @date: 2019-01-30 19:56
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    /**
     *  该registerStompEndpoints()方法注册“/logger”端点，
     *  启用SockJS后备选项，以便在WebSocket不可用时可以使用替代传输。
     *  SockJS客户端将尝试连接到“/logger”
     *  并使用可用的最佳传输（websocket，xhr-streaming，xhr-polling等）。
     * @param registry
     */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/logger").setAllowedOrigins("*").addInterceptors().withSockJS();
    }
    /**
     *  该configureMessageBroker()方法将重写方法WebSocketMessageBrokerConfigurer来配置消息代理。
     *  它首先调用enableSimpleBroker()一个简单的基于内存的消息代理，将问候消息带回以“/stock”为前缀的客户端。
     *  它还指定了为“ @MessageMapping注解”方法绑定的消息的“/app”前缀。这个前缀将被用来定义所有的消息映射;
     *  例如，“/app/hello”是该GreetingController.greeting()方法被映射为处理的端点。
     * @param registry
     */
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.enableSimpleBroker("/topic");
        registry.setApplicationDestinationPrefixes("/app");
    }
}
```

#### 6.2.2 `LoggerEvent.java`

```java
/**
 * @author chensj
 * @title 进程日志事件内容载体
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.event
 * @date: 2019-01-31 15:20
 */
public class LoggerEvent {
    /**
     * 事件(Event)就是通过 Disruptor 进行交换的数据类型。
     */
    private LoggerMessage message;

    public LoggerMessage getMessage() {
        return message;
    }

    public void setMessage(LoggerMessage message) {
        this.message = message;
    }
}
```
#### 6.2.3 `LoggerEventFactory.java`
```java
/**
 * @author chensj
 * @title 进程日志事件工厂类
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.event
 * @date: 2019-01-31 15:22
 * 事件工厂(Event Factory)定义了如何实例化前面第1步中定义的事件(Event)，
 * 需要实现接口 com.lmax.disruptor.EventFactory<T>。
 * Disruptor 通过 EventFactory 在 RingBuffer 中预创建 Event 的实例。
 */
public class LoggerEventFactory implements EventFactory<LoggerEvent> {

    @Override
    public LoggerEvent newInstance() {
        return new LoggerEvent();
    }
}
```

#### 6.2.4 `LoggerEventHandler.java`
```java
/**
 * @author chensj
 * @title  进程日志事件处理器
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.event
 * @date: 2019-01-31 15:24
 * @descript  定义事件处理的具体实现
 */
@Component
public class LoggerEventHandler implements EventHandler<LoggerEvent> {

    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    /**
     * 通过实现接口 com.lmax.disruptor.EventHandler<T> 定义事件处理的具体实现。
     * @throws Exception
     */
    @Override
    public void onEvent(LoggerEvent loggerEvent, long l, boolean b) throws Exception {
        // 日志推送到/topic/pulllogger中
        simpMessagingTemplate.convertAndSend("/topic/pullLogger",loggerEvent.getMessage());
    }
}
```

#### 6.2.5 `LoggerDistruptorQueue.java`
```java

/**
 * @author chensj
 * @title Disruptor 环形队列
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.core
 * @date: 2019-01-31 15:29
 */
@Component
public class LoggerDistruptorQueue {
    /**
     * 创建线程池，用于事件处理的线程池
     */
    ExecutorService executor = Executors.newCachedThreadPool();
    /**
     * 创建日志事件工厂
     */
    EventFactory<LoggerEvent> eventFactory = new LoggerEventFactory();
    /**
     * RingBuffer 大小，必须是 2 的 N 次方；
     */
    int ringBufferSize =  1024 * 1024;
    /**
     * 构造器初始化Disruptor
     */
    @SuppressWarnings("deprecation")
    private Disruptor<LoggerEvent> disruptor = new Disruptor<LoggerEvent>(eventFactory, ringBufferSize, executor);
    /**
     * 静态变量 环形的缓冲区
     * 负责对通过 Disruptor 进行交换的数据（事件）进行存储和更新
     */
    private static RingBuffer<LoggerEvent> ringBuffer;

    @Autowired
    LoggerDistruptorQueue(LoggerEventHandler eventHandler){
        System.out.println("init LoggerDistruptorQueue");
        disruptor.handleEventsWith(eventHandler);
        this.ringBuffer = disruptor.getRingBuffer();
        disruptor.start();
    }

    /**
     * 事件发布
     * @param log
     */
    public static void publishEvent(LoggerMessage log) {
        // 请求下一个事件序号；
        long sequence = ringBuffer.next();
        try {
            // //获取该序号对应的事件对象；
            LoggerEvent event = ringBuffer.get(sequence);
            // 设置事件
            event.setMessage(log);  // Fill with data
        } finally {
            // 发布事件；
            ringBuffer.publish(sequence);
        }
    }
}
```
#### 6.2.6 `LogFilter.java`
```java
/**
 * @author chensj
 * @title 日志过滤器
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.springbootwebsocketlogger.system.core
 * @date: 2019-01-30 16:04
 */
@Service
public class LogFilter extends Filter<ILoggingEvent> {
    @Override
    public FilterReply decide(ILoggingEvent event) {
        String exception = "";
        IThrowableProxy iThrowableProxy1 = event.getThrowableProxy();
        if (iThrowableProxy1 != null) {
            exception = "<span class='excehtext'>" + iThrowableProxy1.getClassName() + " " + iThrowableProxy1.getMessage() + "</span></br>";
            for (int i = 0; i < iThrowableProxy1.getStackTraceElementProxyArray().length; i++) {
                exception += "<span class='excetext'>" + iThrowableProxy1.getStackTraceElementProxyArray()[i].toString() + "</span></br>";
            }
        }
        LoggerMessage loggerMessage = new LoggerMessage(
                event.getMessage()
                , DateFormat.getDateTimeInstance().format(new Date(event.getTimeStamp())),
                event.getThreadName(),
                event.getLoggerName(),
                event.getLevel().levelStr,
                exception,
                ""
        );
//        System.out.println(loggerMessage);
        // LoggerQueue.getInstance().push(loggerMessage);
        LoggerDistruptorQueue.publishEvent(loggerMessage);
        return FilterReply.ACCEPT;
    }
}
```
#### 6.2.7 `LoggerMessage.java`
```java
/**
 * @author chensj
 * @title 日志消息实体
 * @project spring-boot-websocket-logger
 * @package com.winning.devops.websocket.logger.system.model
 * @date: 2019-01-30 16:07
 */
public class LoggerMessage {

    private String body;
    private String timestamp;
    private String threadName;
    private String className;
    private String level;
    private String exception;
    private String cause;

    public LoggerMessage() {
    }

    public LoggerMessage(String body, String timestamp, String threadName, String className, String level, String exception, String cause) {
        this.body = body;
        this.timestamp = timestamp;
        this.threadName = threadName;
        this.className = className;
        this.level = level;
        this.exception = exception;
        this.cause = cause;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getThreadName() {
        return threadName;
    }

    public void setThreadName(String threadName) {
        this.threadName = threadName;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getException() {
        return exception;
    }

    public void setException(String exception) {
        this.exception = exception;
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }

    @Override
    public String toString() {
        return "LoggerMessage{" +
                "body='" + body + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", threadName='" + threadName + '\'' +
                ", className='" + className + '\'' +
                ", level='" + level + '\'' +
                ", exception='" + exception + '\'' +
                ", cause='" + cause + '\'' +
                '}';
    }
}
```

#### 6.2.8 `SpringBootWebsocketLoggerApplication.java`
```java
@SpringBootApplication
@EnableScheduling
@RestController
public class SpringBootWebsocketLoggerApplication {

    private static final Logger LOG = LoggerFactory.getLogger(SpringBootWebsocketLoggerApplication.class);
    public static void main(String[] args) {
        SpringApplication.run(SpringBootWebsocketLoggerApplication.class, args);
    }

    int info = 1;
    @Scheduled(fixedRate = 1000)
    public void logger(){
        LOG.info("logger info : "+ ++info);
    }

    @RequestMapping("/hello")
    public String hello() {
        LOG.debug("访问了hello");
        return "hello!";
    }
}
```
### 6.3  `logback.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration scan="true">
    <include resource="org/springframework/boot/logging/logback/defaults.xml" />
    <property name="LOG_FILE"
              value="${LOG_FILE:-${LOG_PATH:-${LOG_TEMP:-${java.io.tmpdir:-/tmp}}/}spring.log}" />
    <include resource="org/springframework/boot/logging/logback/file-appender.xml" />
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${CONSOLE_LOG_PATTERN}</pattern>
            <charset>utf8</charset>
        </encoder>
        <filter class="com.winning.devops.websocket.logger.system.core.LogFilter"></filter>
    </appender>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${CONSOLE_LOG_PATTERN}</pattern>
            <charset>utf8</charset>
        </encoder>
    </appender>
    <root level="INFO">
        <appender-ref ref="FILE" />
        <appender-ref ref="CONSOLE" />
    </root>
</configuration>
```

### 6.4  `index.html`

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hello WebSocket</title>
    <link href="/webjars/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="/webjars/jquery/jquery.min.js"></script>
    <script src="/webjars/sockjs-client/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/stomp.min.js"></script>
    <script src="/layer/layer.js"></script>
</head>
<body>
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being
    enabled. Please enable
    Javascript and reload this page!</h2></noscript>
<div id="main-content" class="container">
    <h1>jvm进程内的日志</h1>
    <div class="row">
        <button onclick="openSocket()">开启日志</button><button onclick="closeSocket()">关闭日志</button>
    </div>
    <div id="log-container" style="height: 300px; overflow-y: scroll; background: #333; color: #aaa; padding: 10px;">
        <div></div>
    </div>
</div>
</body>
<script>
    var stompClient = null;
    $(document).ready(openSocket());

    /**
     * 创建连接
     */
    function openSocket(){
        if(stompClient == null){
            var scoket = new SockJS('http://localhost:8080/logger?token=kl');
            stompClient = Stomp.over(scoket)
            stompClient.connect({token:"kl"},function (iframe) {
                console.log(iframe);
                stompClient.subscribe('/topic/pullLogger',function (event) {
                    var content=JSON.parse(event.body);
                    $("#log-container div").append(content.timestamp +" "+ content.level+" --- ["+ content.threadName+"] "+ content.className+"   :"+content.body).append("<br/>");
                    $("#log-container").scrollTop($("#log-container div").height() - $("#log-container").height());
                },{
                    token:"kltoen"
                })
            })
        }
    }

    /**
     * 关闭连接
     */
    function closeSocket(){
        if(stompClient != null){
            stompClient.disconnect();
            stompClient = null;
        }
    }
</script>
</html>
```