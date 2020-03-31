

# Dos 命令

Disk Operating System 磁盘操作系统，或者就是windows的文件结构

## 常用命令

### 目录操作

* md 创建目录

```bash
# 新建目录
md test	
# 新建多个目录
md test1 test2
```

* cd 切换目录

```bash
# 切换目录
cd d:\test
```

* dir 显示文件列表 

相当于Linux中的ls

```bash
dir
```

* rd  删除目录

```bash
# 删除空目录
rd test
# 删除目录及其子目录和文件  不询问
rd /q/s test
# 删除目录及其子目录和文件 询问
rd /s test
```

### 文件操作

* 创建文件

```bash
# 追加内容到指定文件中 创建文件
echo hello > d:\test\aa.txt
```

* 移动文件

```bash
# 移动
move d:\test\aa.txt d:\
# 移动并重命名
move d:\test\aa.txt d:\a.txt
```


* 复制文件

```bash
#复制
copy d:\test\aa.txt d:\
# 复制并重命名
copy d:\test\aa.txt d:\test\aa1.txt
```

* 删除文件

```bash
# 删除文件
del d:\test\aa.txt
# 删除txt后缀的文件
del d:\test\*.txt
```

### 其他

* 清屏

```bash
cls
```

