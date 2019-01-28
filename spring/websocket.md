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

