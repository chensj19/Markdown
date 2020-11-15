# npm和yarn配置

## npm配置

### 1、修改全局依赖包下载路径

默认情况下，我们在执行`npm install -g XXXX`下载全局包时，这个包的默认存放路径位`C:\Users\用户名\AppData\Roaming\npm\node_modules下`，可以通过`CMD`指令`npm root -g`查看

```undefined
C:\Users\liaijie\AppData\Roaming\npm\node_modules
```

但是有时候我们不想让全局包放在这里，我们可以自定义存放目录,在`CMD`窗口执行以下两条命令修改默认路径：

```swift
npm config set prefix "C:\node\node_global"
```

```bash
npm config set cache "C:\node\node_cache"
```

或者打开`c:\node\node_modules\npm\.npmrc`文件，修改如下：

```
prefix =C:\node\node_global
cache = C:\node\node_cache
```

以上操作表示，修改全局包下载目录为`C:\node\node_global`,缓存目录为`C:\node\node_cache`,并会自动创建`node_global`目录，而`node_cache`目录是缓存目录，会在你下载全局包时自动创建

![img](https:////upload-images.jianshu.io/upload_images/14070366-522ef9a1631f8db4?imageMogr2/auto-orient/strip|imageView2/2/w/596/format/webp)

在这里插入图片描述

### 2、配置环境变量

因为我们修改了全局包的下载路径，那么自然而然，我们下载的全局包就会存放在`c:\node\node_global\node_modules`，而其对应的`cmd`指令会存放在`c:\node\node_global`

## yarn配置

### 1、全局配置

控制台输入命令, 正常显示版本表示安装成功

```powershell
$ yarn -v		# 查看yarn版本
```

查看yarn的所有配置

```powershell
$ yarn config list		# 查看yarn配置
```

修改yarn的源镜像为淘宝源

```powershell
$ yarn config set registry https://registry.npm.taobao.org/
```

修改全局安装目录, 先创建好目录(global), 我放在了Yarn安装目录下(D:\RTE\Yarn\global)

```powershell
$ yarn config set global-folder "D:\RTE\Yarn\global"		# 具体目录请改成自己的
```

修改全局安装目录的bin目录位置, bin目录需要自己创建, 而且需要把此目录加到系统环境变量(D:\RTE\Yarn\global\bin), 添加环境变量请参考: [环境变量](https://blog.csdn.net/VXadmin/article/details/89399422)

```powershell
$ yarn config set prefix "D:\RTE\Yarn\global\"		# 会自动设置成*\global\bin 
```

修改全局缓存目录, 先创建好目录(cache), 和global放在同一层目录下

```powershell
$ yarn config set cache-folder "D:\RTE\Yarn\cache"			# 具体目录请改成自己的
```

查看所有配置

```powershell
yarn config list
```

查看当前yarn的bin的位置

```powershell
$ yarn global bin
```

查看当前yarn的全局安装位置

```powershell
$ yarn global dir
```