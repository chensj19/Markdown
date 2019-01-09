# nodejs 学习笔记

##  1. Node.js 介绍

### 1.1为什么学nodejs

- 企业需求
  - 具有服务端开发经验更好

  - front-end

  - back-end

  - 全栈开发工程师

    - 全干

###  1.2Nodejs是什么

+ Node.js is a javascript runtime build on Chrome V8 engine
  + Node.js 不是一门语言
  + Node.js不是库、不是框架
  + Node.js 是一个JavaScript运行时环境
  + 简单说Node.js可以解析和执行JavaScript代码
  + 以前只有浏览器可以解析执行JavaScript代码
  + 现在JavaScript可以完全脱离浏览器来运行，一切归功于Node.js
+ 构建于 Chrome的V8浏览器引擎之上
  + js引擎

    + 1） [Mozilla](http://firefox.966266.com/)
      + Rhino，由Mozilla基金会管理，开放源代码，完全以Java编写。
      + SpiderMonkey，第一款JavaScript引擎，由BrendanEich在NetscapeCommunications时编写，用于[Mozilla ](http://firefox.966266.com/)[Firefox](http://firefox.966266.com/)1.0～3.0版本。
      + TraceMonkey，基于实时编译的引擎，其中部份代码取自Tamarin引擎，用于 Mozilla Firefox 3.5～3.6版本。
      + JägerMonkey，（JägerMonkey，也有人拼写成[JagerMonkey](http://www.966266.com/jishu/jagermonkey.html)）德文Jäger原意为猎人，结合追踪和组合码技术大幅提高效能，部分技术借凿了[V8](http://www.966266.com/jishu/v8.html)、JavaScriptCore、[WebKit](http://www.966266.com/jishu/53.html)，用于[Mozilla Firefox 4.0](http://firefox.966266.com/)以上版本。
     + 2）[Google](http://chrome.966266.com/)
        + [V8](http://www.966266.com/jishu/v8.html)，开放源代码，由Google丹麦开发，是[Google Chrome](http://chrome.966266.com/)的一部分。

     + 3）[微软](http://ie.966266.com/)
        +  [Chakra](http://www.966266.com/jishu/chakra.html)，中文译名为查克拉，用于[Internet Explorer 9](http://ie.966266.com/soft-down/ie9-win7-32.html)。
        + [JScript ](http://www.966266.com/jishu/jscript.html)是由微软公司开发的活动脚本语言，是微软对ECMAScript规范的实现.[IE](http://ie.966266.com/) 3.0-[IE8.0](http://ie.966266.com/soft-down/ie8-xp.html)使用的JS引擎

     + 4）其它
         	+ KJS，KDE的ECMAScript/JavaScript引擎，最初由Harri Porten开发，用于KDE项目的 Konqueror网页浏览器中。
          + Narcissus，开放源代码，由BrendanEich编写（他也参与编写了第一个SpiderMonkey）。
          + Tamarin，由AdobeLabs编写，Flash Player 9所使用的引擎。
          + Nitro（原名SquirrelFish），为[Safari](http://safari.966266.com/) 4编写。
          + Carakan，由[Opera软件公司](http://opera.966266.com/)编写，自[Opera](http://opera.966266.com/)10.50版本开始使用。 

  + 浏览器内核 

    + Trident(IE内核) 
    + Gecko(Firefox内核) 
    + Presto(Opera前内核)  
    + Webkit(Safari内核,Chrome内核原型,开源) 
    + Blink（Google和Opera Software开发的浏览器排版引擎）

  + 代码只是具有特定格式的字符串而已

  + 引擎可以认识它，解析和执行它
+ 浏览器中的JavaScript
  + EcmaScript
    + 基本语法
    + if
    + var
    + function
    + Object
    + Array
    + 

  + BOM

  + DOM 
+ Node.js中的JavaScript
  + 没有BOM、DOM

  + EcmaScript

  + 在Node这个JavaScript执行环境中为JavaScript提供了一系列服务器级别的操作API

    + 例如文件读写
    + 网络服务构建
    + 网络通信
    + http服务器
    + 等处理。。。。
+ Node.js is uses an event-driven,non-blocking I/O model that makes it lightweight and effcient

  + event-driven 事件驱动

  + non-blocking I/O model 非阻塞IO模型(异步)

  + ightweight and effcient 轻量和高效

  + 随着课程慢慢学习你会明白什么是事件驱动和非阻塞IO模型
+ Node.js package ecosystem，npm is the largest ecosystem of open source libraries in the world
  + npm是世界上最大的开源生态系统
  + 绝大数JavaScript相关的包都存放在npm上，这样做的目的是为了让开发人员更方便的去下载和使用
  + `npm install jquery`

###   1.3 Node.js 能做什么

+ Web 服务器后台
+ 命令行工具 
  + cnpm npm
  + git(C语言)
  + 
+ 游戏服务器
+ 对于前端工程师来说，接触最多的是它的命令行工具
  + webpack
  + gulp
  + npm
###    1.4 预备知识

+ HTML
+ CSS
+ JavaScript
+ 简单的命令行操作
+ 具有服务端开发经验最好

###   1.5 主要学到什么

+ B/S编程模型

+ 模块化编程
  + RequireJs
  + SeaJs
  + 

+ Node常用API

+ 异步编程

+ Express开发框架

+ Ecmascript6

+ 学习Node.js不仅仅会帮助打开服务端黑盒子，同时也会帮助你学习以后的前端高级内容

  + Vue.js

  + React

  + angular

## 2. 起步

### 2.1 node安装

* 查看当前node.js环境的版本号

  ```bash
  node -v
  npm -v
  ```

* 下载：https://nodejs.org/en/

* 安装

* 确认安装成功

  ```bash
  C:\Users\chensj>node -v
  v10.15.0
  
  C:\Users\chensj>npm -v
  6.4.1
  ```

* 环境变量

  ```bash
  npm config set prefix "D:\software\nodejs\node_global"
  npm config set cache "D:\software\nodejs\node_cache"
  ```

  - 在`【系统变量】`下新建`【NODE_PATH】`，输入
    `【D:\software\nodejs\node_global\node_modules】`
  - 将`【用户变量】`下的`【Path】`修改为`【D:\software\nodejs\node_global】`

### 2.2 HelloWorld

* 解析执行JavaScript

  ```js
  console.log('hello world!');
  ```

  ```bash
  node helloworld.js
  hello world!
  ```

* 读写文件

  1. 引入`fs`模块

     ```js
     const fs = require('fs')
     ```

  2. 读取文件

     ```javascript
     // 第一个参数为文件路径
     // 第二个参数为回调函数
     //  error 读取错误
     //  data  读取的数据
     fs.readFile('./helloworld.js', (err, data) => {
         if (err) {
             console.log('文件读取报错')
         } else {
             // 获取的是16进制的数据
             console.log(data)
             // 转化为可以识别的代码
             console.log(data.toString())
         }
     })
     ```

   3. 写文件

      ```javascript
      const fs = require('fs')
      /**
       * 第一个参数 文件路径
       * 第二个参数 文件写入内容
       * 第三个参数 回调函数
       */
      fs.writeFile('./data/a.txt', '这是文件内容', (err) => {
          if (err) {
              console.log('文件写入报错')
          }
          console.log('文件写入成功')
      })
      ```

* http

  * 简单服务器

    ```js
    const http = require('http')
    const url = require('url')
    
    const app = http.createServer((req, res) => {
        const path = req.url
        //console.log(req);
        console.log(path);
        //转换url
        const result = url.parse(path, true) //第一个参数为地址，第二个参数true表示将get传值转换为对象
        console.log(result);
        res.end('Hello Node.js!');
    })
    
    app.listen(8080)
    
    console.log('Server running at http://127.0.0.1:8080')
    ```


## 3.Node中的JavaScript

* EcmaScript

  * 与浏览器不一样：没有BOM DOM 

* 核心模块

* 第三方模块

* 用户自定义模块

### 3.1 核心模块

​	Node为JavaScript提供了许多服务器级别的API，这些API绝大多数都被包装到一个具名的核心模块中，比如 `fs` `http` `os` `path`

```js
const fs = require('fs')
```

### 3.2 用户自定义模块

* require

* exports

### 3.3 第三方模块



## 4.Node中模块系统

