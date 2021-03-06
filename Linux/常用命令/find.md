# find命令使用

## 1、查找指定文件大小文件

```bash
find . -type f -size +100M
```

## 2、查找指定后缀名称的文件

```bash
find . -name '*.zip' -type f -print -exec rm -f {} \;
```

3、快速清空目录

```bash
rsync --delete-before -a -H -v --progress --stats aaa  xxx
# aaa 指定目录，一般是一个新建的空目录
# xxx 目标目录，一般是一个需要清理的目录
```

4、统计

```bash
# 查看当前目录下的文件数量（不包含子目录中的文件）
ls -l|grep "^-"| wc -l
# 查看当前目录下的文件数量（包含子目录中的文件） 注意：R，代表子目录
ls -lR|grep "^-"| wc -l
# 查看当前目录下的文件夹目录个数（不包含子目录中的目录），同上述理，如果需要查看子目录的，加上R
ls -l|grep "^d"| wc -l
# 查询当前路径下的指定前缀名的目录下的所有文件数量
# 例如：统计所有以“20161124”开头的目录下的全部文件数量
ls -lR 20161124*/|grep "^-"| wc -l

#grep "^d"表示目录，"^-"表示文件

```

