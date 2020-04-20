# Linux 修改swap空间大小

以下的操作都要在root用户下进行，使用free -m 查询当前swap空间大小。

```bash
[root@c6-186-87 ~]# free -m
              total        used        free      shared  buff/cache   available
Mem:            503          82          19          32         401         362
Swap:           131           0         131
```

修改的步骤如下：首先先建立一个分区，采用dd命令比如

```bash
[root@c6-186-87 ~]# dd if=/dev/zero of=/home/swap bs=1024 count=1024000
1024000+0 records in
1024000+0 records out
1048576000 bytes (1.0 GB) copied, 2.75033 s, 381 MB/s
```

这样就会创建/home/swap这么一个分区文件。文件的大小是1024000个block，一般情况下1个block为1K，所以这里空间是1G。这里的bs代表单位。***如果已经修改过一次，则会报下面这个错误，这时候就必须先关闭swap分区（命令 swapoff -a)，修改完成后再开启swap分区(命令：swapon -a )***

> [root@localhost Desktop]# dd if=/dev/zero of=/home/swap bs=1024 count=1024000
> dd: opening `/home/swap': Text file busy

关闭swap分区的命令如下（***注：第一次修改不需要执行关闭操作\***）：关闭成功后再执行下面的操作

> [root@localhost Desktop]# swapoff -a 

接着再把这个分区变成swap分区。

```bash
[root@c6-186-87 ~]# /sbin/mkswap /home/swap
Setting up swapspace version 1, size = 1023996 KiB
no label, UUID=93894267-de95-42b8-b105-7d821c9c992d
```

再接着使用这个swap分区。使其成为有效状态。

> [root@c6-186-87 ~]#  /sbin/swapon /home/swap
> swapon: /home/swap: insecure permissions 0644, 0600 suggested

现在再用free -m命令查看一下内存和swap分区大小，就发现增加了512M的空间了。不过当计算机重启了以后，发现swap还是原来那么大，新的swap没有自动启动，还要手动启动。那我们需要修改/etc/fstab文件，增加如下一行

```bash
/home/swap swap swap defaults 0 0
```

你就会发现你的机器自动启动以后swap空间也增大了。