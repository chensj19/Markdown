# JDK

## JDK 配置

```bash
export JAVA_HOME=/usr/local/jdk1.8.0_181
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
```



## 在Centos下用alternative命令切换各个版本的jdk的方法

```bash
alternatives --install /usr/bin/java java /usr/local/jdk1.8.0_181/bin/java 1
alternatives --install /usr/bin/javac javac /usr/local/jdk1.8.0_181/javac 1
alternatives --install /usr/bin/jar jar /usr/local/jdk1.8.0_181/bin/jar 1
```

运行 alternatives --config java 会出现1个jdk让我选

```bash
alternatives --config java

There is 1 program that provides 'java'.

  Selection    Command
-----------------------------------------------
*+ 1           /usr/local/jdk1.8.0_181/bin/java

Enter to keep the current selection[+], or type selection number: 1
```


