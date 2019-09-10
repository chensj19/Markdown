# Python 安装

## CentOS7安装python3.7

### 1. 安装依赖

```bash
yum install gcc openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel libffi-devel tk-devel wget curl-devel
```

### 2. 去官网找下载链接

```bash
先进入下载目录
cd /opt
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tgz
```

### 3. 解压对应的文件

```bash
tar -zxvf Python-3.7.4.tgz 
```

### 4. 为你的Python3盖一栋房子

```
mkdir /usr/local/python3
```

### 5. 然后编译

```
Python-3.7.4/configure --prefix=/usr/local/python3/
```

如果报了这个↓错误，哪说明没有gcc

```bash
configure: error: no acceptable C compiler found in $PATH
```

那么安装一个

```bash
yum install gcc
```

安装完gcc再编译一下吧
 如果出现 没有模块_ctypes  那么用第一条的下载libffi-devel然后再编译一次！！

### 6. 然后make一下 (这命令都是在干嘛)

```bash
make && make install
```

### 7. 建一个软链接方便使用

```
ln -s /usr/local/python3/bin/python3 /usr/bin/python3
```

好了直接输入python3就可以运行了

### 8. 为你的pip3也建一个软连接吧

```
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
```