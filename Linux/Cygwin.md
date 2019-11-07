# Cygwin 

## 安装

从[官网]( http://www.cygwin.com/ )下载，或者从下面的网址下载

```bash
http://www.cygwin.com/setup-x86_64.exe
```

### 选择Cygwin的安装方式

点击安装setup.exe 点击“下一步”，出现“Choose installation type”界面：

![img](https://img-blog.csdn.net/20161116152637709)

其中有三个选项：

- 从网上下载（下载下来的文件，也可以将来再用）

  其意思是，从网上下载的文件，存在本地硬盘后，以后万一遇到诸如某个模块被破坏了，不能用了，则可以再通过此setup.exe去重新安装一下，但是选择的是下面要说的第三项，即选择从本地某个文件夹安装，即此处之前下载好了的，效果相当于，windows中安装程序的修复功能。

  关于如何从网上下载安装，接下来会详细解释。

- 只下载不安装,当网速特别慢的时候推荐此选项，为了先完全下载下来，然后方便选择性的安装自己需要的模块吧。

- 为选择从本地安装

  上面已经提到了，其前提是，之前已经下载过了对应的所需的各个安装模块了，此时可以选择此项，去全新安装或者修复式安装某个模块。

### 选择Cygwin的安装目录



![img](https://img-blog.csdn.net/20161116152645799)



其中Root Directory，指的是你所要将Cygwin安装到哪个目录。

默认为C:\cygwin，此处可以改为自己所要的路径，也可以用默认值，都可以。

我此处改为我所要的路径：E:\DevTools\Cygwin\cygwin_install

然后对于Install for，有两种选择：

- All User(RECOMMENDED) 为windows当前所有用户都有效。

- Just Me 只对当前的windows用户有效。

此处选择默认的，对所有用户都有效，即可。

### 选择网络连接方式

然后就进入”Select Connection“Type的界面了：

![img](https://img-blog.csdn.net/20161116152701269)



- Direct Connection 一般多数用户都是这种直接连接的网络，所以都是直接使用默认设置即可。

- Use Internet Explorer Proxy Settings 使用IE代理设置，如果你本身上网是通过代理上的，且IE中已经设置好了代理，那么就可以用此种设置了。

- Use HTTP/FTP Proxy 使用HTTP或FTP类型的代理。同理，如果有需要，自己选择此项后，设置对应的代理地址和端口，即可。

### 需要选择一个服务器

之后就是从该服务器下载对应的安装所需的模块文件了。点击”下一步“后，其会自动去下载一个服务器的列表，然后跳转到”Choose A Download Site“的界面：

![img](https://img-blog.csdn.net/20161116152707100)

因此，此处如果选择的服务器不合适的话，尽管你的网络本身速度很快，但是此处下载速度很慢。

在Use URL处，输入：http://mirrors.aliyun.com/cygwin/

### 选择需要安装的模块（安装包）

点击“下一步”后，其会解析一下，然后进入”Select Package“的界面：

![img](https://img-blog.csdn.net/20161116152712800)

此界面，才是整个Cygwin安装过程中的最重要，最需要详细讲解的部分。

### Cygwin中模块的分类

先来说说，那一堆的列表。

可以看到，其有Accesibility，Base，Devel，Editors，Math等很多的部分。

这些，是总体的分类，对于Cygwin中所包含的N个模块的分门别类。

此处，对于安装Cygwin来说，就是安装各种各样的模块而已。

具体安装什么模块，则是根据你自己的需要，去选择不同的模块:

![img](https://img-blog.csdn.net/20161116152717662)

对于新手，很多不清楚各个模块的作用：

那么最简单的做法是，全部都选上。

当然觉得全部都选上，又太浪费下载时间和安装后的空间的话，那么最为开发用途的cygwin，则至少可以把

***Base，Devel，Libs，Net，System，Utils\***

等这几个最基本的分类下面的模块都选上。

即点击

***Base，Devel，Libs，Net，System，Utils\***

的Default，使其都变成Install即可。

而对于大多数人，尤其是不熟悉的人，其实，最核心的，要记住的一点，那就是，记住一定要安装Devel这个部分的模块，其中包含了各种开发所用到的工具或模块。

而对于其他部分的设置，如果不熟悉，那么可以直接使用默认配置即可。

## apt-cyp

### 下载 apt-cyg 

```bash
wget -O apt-cyp.tar.gz https://codeload.github.com/transcode-open/apt-cyg/tar.gz/v1
```

###  安装apt-cyg 

```bash
tar zxvf apt-cyp.tar.gz 
cd apt-cyg-1
mv apt-cyg /usr/local/bin/
```

### 设置mirror

```bash
# 配置apt-cyg的镜像源
apt-cyg mirror http://mirrors.aliyun.com/cygwin/
# 更新源
apt-cyg update apt-cyg
```

## 配置

### 显示

 调整 `${HOME}/.bashrc` 文件，把注释掉别名打开： 

```bash
alias df = 'df -h'
alias du = 'du -h'
alias whence= 'type -a'                         # where, of a sort
alias grep = 'grep --color'                      # show differences in colour
alias egrep = 'egrep --color=auto'               # show differences in colour
alias fgrep = 'fgrep --color=auto'               # show differences in colour
alias ls = 'ls -h --color=tty'                  # classify files in colour
alias dir = 'ls --color=auto --format=vertical'
alias vdir = 'ls --color=auto --format=long'
alias ll= 'ls -l'                               # long list
alias la= 'ls -A'                               # all but . and ..
alias l= 'ls -CF'                               #
alias wch= 'which -a' # 简化which的输入，列出各个目录中找到命令
alias vi =vim # 映射vi命令到vim
```

这样调整后，可以 `ls` 、 `grep` 、 `dir` 输出彩色显示。

另外加上命令的 `-h` 选项，这样文件大小以K、M、G显示，方便人阅读。

`git` 输出（比如 `log` 、 `status` ）彩色显示，使用下面的命令配置：

```bash
git config --global color.ui auto
```

### vi 配置

在 `${HOME}/.vimrc` 文件中加上：

没有 `.vimrc` 文件就新建。

```bash
set number
set hlsearch
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set tabstop=4
set shiftwidth=4
syntax enable
set nocompatible
set backspace=indent,eol,start
```

说明：

- `set number` ：显示行号。如果使用过程中要关掉，可以使用 `:set nonu` 来关掉。
- `set hlsearch` ：搜索到内容高亮。
- `set fileencoding` 和 `set fileencodings` ：缺省文件编码和自动识别文件编码顺序
- `set tabstop` 和 `set shiftwidth` ： 设置 `Tab` 宽度，缺省是8。
- `syntax enable` ：打开语法高亮。 `cygwin` 缺省 `vim` 没有打开。
- `set nocompatible` 和 `set backspace` ：配置backspace键，缺省backspace不起作用。

### 配置盘符的链接

 到D盘，要 `/cygdrive/d` ，可以新建符号链接 `/d` ，这样可以减少录入（ [MSYS](http://www.mingw.org/wiki/MSYS) 的做法） 

```bash
ln -s /cygdrive/c /c
ln -s /cygdrive/d /d
ln -s /cygdrive/e /e
```

### 自动补全不区分大小写

 `~/.bashrc` 文件中添加： 

```bash
shopt -s nocaseglob
```

`~/.inputrc` 文件中添加：

```bash
set completion-ignore-case on
```

### 配置按单词移动/删除

.inputrc 文件中添加：

```bash
"\e[1;5C" : forward-word
"\e[1;5D" : backward-word
"\e[3;5~" : kill -word
"\C-_" : backward- kill -word
```

