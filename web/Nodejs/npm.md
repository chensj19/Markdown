# npm

## 一、什么是npm

npm是node的**包管理工具**，是**前端模块化**下的一个标志性产物

简单地地说，就是**通过npm下载模块，复用已有的代码，提高工作效率**

1.**从社区的角度**：把针对某一特定问题的模块发布到npm的服务器上，供社区里的其他人下载和使用，同时自己也可以在社区里寻找特定的模块的资源，解决问题

2.**从团队的角度**：有了npm这个包管理工具，复用团队既有的代码也变的更加地方便

## 二、**利用npm安装包**

### 2.1 **npm安装的方式——本地安装和全局安装**

#### 2.1.1 **什么时候用本地／全局安装？**

1.当你试图安装命令行工具的时候，例如 grunt CLI的时候，使用全局安装

全局安装的方式：npm install -g 模块名称

2.当你试图通过npm install 某个模块，并通过require('XXX')的方式引入的时候，使用本地安装

本地安装的方式：npm install 模块名称

#### 2.1.2 **你很可能遇到的问题**

在你试图本地安装的时候一般都会遇到permission deny的问题

例如我这里第一次尝试全局安装express，输入npm install -g express

![](https://images2015.cnblogs.com/blog/1060770/201706/1060770-20170609201942418-242164591.png)

【吐槽】而且让人无语的是在安装了许多依赖后才提醒你权限不够...

**解决方式：**

**1.** **sudo npm install -g XXX ，以管理员的身份安装**

评价：每次都要输入账号和密码，非常繁琐，且官方并不推荐（ You could also try using sudo, but this should be avoided）

**2.** **sudo chown -R 你的账号名 npm所在目录的路径 /{lib/node_modules,bin,share}**

评价：官方推荐的做法，chown全称为change owner，即将npm目录的所有者指定为你的名字（授予权限），-R表示对指定目录下所有的子目录和文件也都采取同种操作。

**<1>**首先，通过 npm config get prefix获取npm所在目录的路径，例如像这样：

![img](https://images2015.cnblogs.com/blog/1060770/201706/1060770-20170609202020403-1849902170.png)

**<2>**在命令行输入 sudo chown -R 你的账号名 npm所在目录的路径 /{lib/node_modules,bin,share}，例如：

![img](https://images2015.cnblogs.com/blog/1060770/201706/1060770-20170609202153637-337797609.png)

【注意】{lib/node_modules,bin,share}中的大括号是要写上去的

再次全局安装express：输入npm install -g express

![](https://images2015.cnblogs.com/blog/1060770/201706/1060770-20170609202238168-910572638.png)

安装成功

**3.sudo chmod 777 npm所在目录（不推荐）**

评价：这是网上经常能够看到的解决方式，但，官方教程里没有对此有任何提及。chmod代表change mode更改读写模式，对该目录授予最高权限，任何人可读可写，这是很危险的

 