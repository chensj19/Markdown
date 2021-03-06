# 环境初始化

## 1、homebrew

由于使用github上面过于慢，使用国内源会更加快，所以采用gitee上面的提供的脚本来安装

```shell
# 仓库地址
https://gitee.com/cunkai/HomebrewCN
# 安装命令
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
# 测试结果
brew install wget unzip vim autojump
```

## 2、oh-my-zsh

依然如上，采用国内源的方式安装

```shell
# 仓库地址
https://gitee.com/mirrors/oh-my-zsh
# 下载安装脚本
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
# 修改安装脚本中仓库地址为gitee的地址
# Default settings
ZSH=${ZSH:-~/.oh-my-zsh}
REPO=${REPO:-mirrors/oh-my-zsh}
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
BRANCH=${BRANCH:-master}
```

> 修改安装脚本中仓库地址为gitee的地址

找到以下部分

```sh
# Default settings
ZSH=${ZSH:-~/.oh-my-zsh}
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}
```

把

```sh
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
```

替换为

```sh
REPO=${REPO:-mirrors/oh-my-zsh}
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
```

编辑后保存, 运行安装即可. (运行前先给install.sh权限)

> 插件安装
>
> 从gitee上找到插件按照如下命令替换安装，然后修改.zshrc即可

```bash
git clone https://gitee.com/null_454_5218/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

![image-20210306155342770](macos.assets/image-20210306155342770.png)

## 3、JAVA开发环境

```bash
# 设置 JDK 8  Mac默认 
export JAVA_8_HOME=`/usr/libexec/java_home -v 1.8`  
# 设置 JDK 11   
export JAVA_11_HOME=`/usr/libexec/java_home -v 11`  
# 设置 JDK 15  
export JAVA_15_HOME=`/usr/libexec/java_home -v 15`  
  
#默认JDK 8  
export JAVA_HOME=$JAVA_8_HOME  

#alias命令动态切换JDK版本  
alias jdk8="export JAVA_HOME=$JAVA_8_HOME"
alias jdk11="export JAVA_HOME=$JAVA_11_HOME"  
alias jdk15="export JAVA_HOME=$JAVA_15_HOME"

# 工具配置
export M2_HOME=/Users/chenshijie/tools/maven_home
export GRADLE_HOME=/Users/chenshijie/tools/gradle_home
export GRADLE_USER_HOME=/Users/chenshijie/tools/gradle_repo
export NODE_HOME=/Users/chenshijie/tools/node_home

export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$GRADLE_HOME/bin:$NODE_HOME/bin:$PATH
```

