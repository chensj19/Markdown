# [Ansible学习路径](https://blog.csdn.net/liumiaocn/article/category/6334627)

## 1、Hello World

> 知识点：Ansible安装与设定 
> 知识点：第一个Helloworld

### 安装Ansible

> 在指定机器上安装ansible

```bash
[root@host31 local]# yum -y install epel-release
[root@host31 local]# yum -y install ansible
```

> 安装情况检查

```bash
[root@HF-SERVER17 ~]# ansible --version
ansible 2.4.2.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Apr  9 2019, 14:30:50) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
```

### 设定ssh通路和ansible

> 分别在两台机器上生成ssh的key

```bash
[root@host31 ~]# ssh-keygen
```

> 复制秘钥

```bash
# ssh-copy-id -i ~/.ssh/id_rsa.pub 172.17.17.194
```

> 或者通过设定/etc/hosts来指定ip名称

```bash
[root@host31 ~]# grep host31 /etc/hosts
192.168.32.31 host31
[root@host31 ~]# ssh-copy-id -i host31
```

> 在ansible所安装的机器上，追加机器信息到/etc/ansible/hosts中

```bash
[root@HF-SERVER17 ~]# grep 172.17 /etc/ansible/hosts |grep -v '#'
172.17.17.194
```

> 确认ansible正常动作

```bash
[root@HF-SERVER17 ~]# ansible localhost -m ping
localhost | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m ping
172.17.17.194 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

### Hello World 样例

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "echo hello world |tee /tmp/helloworld"
172.17.17.194 | SUCCESS | rc=0 >>
hello world

[root@HF-SERVER17 ~]# 
```

>使用说明： 
>172.17.17.194: host名称需要在/etc/ansible/hosts中设定，或者在inventory中设定，ansible是基于ssh通路的python实现，此处应该理解为ansible的操作对象机器 
>-m：指定ansible所用到的module，ansible支持很多的module，而且还在不断的增长中，ansible2.1的版本已经增加到500个以上。 
>整体这句ansible语句的语义为，在172.17.17.194上执行后其会执行echo hello world并且将结果输出到172.17.17.194的/tmp/helloworld中
查看输出结果

```bash
[root@HF-SERVER17 ~]# ssh 172.17.17.194
Last login: Thu Jun 20 10:32:39 2019 from 172.17.1.242
[root@centos7 ~]# ll /tmp/helloworld
-rw-r--r--. 1 root root 12 Jun 20 10:32 /tmp/helloworld
[root@centos7 ~]# cat /tmp/helloworld
hello world
[root@centos7 ~]# 
```

## 2.从Helloworld深度解析Ansible执行原理

> 知识点：-v -vv -vvv选项 
> 知识点：ansible执行原理 
> ansible与puppet等相比，其号称是agentless的，而且这个也确实在很多台机器上进行运维时不用一台一台安装或者升级客户端确实带来了一定的便利。Ansible为什么能够实现不需要agent呢，原理在于其将要执行的命令或者脚本通过sftp的方式传到要执行的对象机器，然后通过ssh远程执行，执行之后清理现场将sftp传过去的文件删除，好像一切都没有发生过的一样，这个就是ansible不需要agent的原理。 

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a "echo hello world" -v
Using /etc/ansible/ansible.cfg as config file
172.17.17.194 | SUCCESS | rc=0 >>
hello world

[root@HF-SERVER17 ~]# 
```

> 这是一个更为简单的helloworld，-v的选项是显示出详细信息。ansible支持三种显示信息的方式 
> -v 
> -vv 
> -vvv 
> 我们接下来使用-vvv来再看ansible是如何动作的

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a "echo hello world" -vvv
ansible 2.4.2.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Apr  9 2019, 14:30:50) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
Using /etc/ansible/ansible.cfg as config file
Parsed /etc/ansible/hosts inventory source with ini plugin
META: ran handlers
Using module file /usr/lib/python2.7/site-packages/ansible/modules/commands/command.py
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 172.17.17.194 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<172.17.17.194> (0, '/root\n', '')
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 172.17.17.194 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744 `" && echo ansible-tmp-1560998177.48-118548207739744="` echo /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744 `" ) && sleep 0'"'"''
<172.17.17.194> (0, 'ansible-tmp-1560998177.48-118548207739744=/root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744\n', '')
<172.17.17.194> PUT /tmp/tmpObUivS TO /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py
<172.17.17.194> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 '[172.17.17.194]'
<172.17.17.194> (0, 'sftp> put /tmp/tmpObUivS /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py\n', '')
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 172.17.17.194 '/bin/sh -c '"'"'chmod u+x /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/ /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py && sleep 0'"'"''
<172.17.17.194> (0, '', '')
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 -tt 172.17.17.194 '/bin/sh -c '"'"'/usr/bin/python /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py; rm -rf "/root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/" > /dev/null 2>&1 && sleep 0'"'"''
<172.17.17.194> (0, '\r\n{"changed": true, "end": "2019-06-20 10:40:02.136623", "stdout": "hello world", "cmd": ["echo", "hello", "world"], "rc": 0, "start": "2019-06-20 10:40:02.132713", "stderr": "", "delta": "0:00:00.003910", "invocation": {"module_args": {"warn": true, "executable": null, "_uses_shell": false, "_raw_params": "echo hello world", "removes": null, "creates": null, "chdir": null, "stdin": null}}}\r\n', 'Shared connection to 172.17.17.194 closed.\r\n')
172.17.17.194 | SUCCESS | rc=0 >>
hello world

META: ran handlers
META: ran handlers
```

### 日志分析

```bash
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 172.17.17.194 '/bin/sh -c '"'"'echo ~ && sleep 0'"'"''
<172.17.17.194> (0, '/root\n', '')
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 172.17.17.194 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744 `" && echo ansible-tmp-1560998177.48-118548207739744="` echo /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744 `" ) && sleep 0'"'"''
<172.17.17.194> (0, 'ansible-tmp-1560998177.48-118548207739744=/root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744\n', '')
<172.17.17.194> PUT /tmp/tmpObUivS TO /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py
```

> 上面的日志显示完成两件事情
>
> 1、建立SSH连接，保证通路的畅通 
>
> 2、将将要执行的命令内容(echo hello world)放到了一个文件中

```bash
<172.17.17.194> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 '[172.17.17.194]'
<172.17.17.194> (0, 'sftp> put /tmp/tmpObUivS /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py\n', '')
```

> 到此处可以看到通过sftp传送到172.17.17.194

```bash
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 172.17.17.194 '/bin/sh -c '"'"'chmod u+x /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/ /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py && sleep 0'"'"''
<172.17.17.194> (0, '', '')
<172.17.17.194> ESTABLISH SSH CONNECTION FOR USER: None
<172.17.17.194> SSH: EXEC ssh -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/b4fd8114f4 -tt 172.17.17.194 '/bin/sh -c '"'"'/usr/bin/python /root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/command.py; rm -rf "/root/.ansible/tmp/ansible-tmp-1560998177.48-118548207739744/" > /dev/null 2>&1 && sleep 0'"'"''
<172.17.17.194> (0, '\r\n{"changed": true, "end": "2019-06-20 10:40:02.136623", "stdout": "hello world", "cmd": ["echo", "hello", "world"], "rc": 0, "start": "2019-06-20 10:40:02.132713", "stderr": "", "delta": "0:00:00.003910", "invocation": {"module_args": {"warn": true, "executable": null, "_uses_shell": false, "_raw_params": "echo hello world", "removes": null, "creates": null, "chdir": null, "stdin": null}}}\r\n', 'Shared connection to 172.17.17.194 closed.\r\n')
```

> 1、通过ssh远程执行
>
> 2、执行之后清理现场将sftp传过去的文件删除



### 总结

Ansible是非常强大的工具，但是归根到底也就是基于python或者ssh或者其他实现了ssh模块的这样一个功能。这件事情从非常古老的计算机时代就开始是如此，为什么ansible如此之流行，linux的推广以及总多模块的支持以及活跃的参与者和社区是其不断进步的重要原因，接下来我们会学习ansible常用的模块的使用方法。

## 3.Ansible执行命令常用Option

> 知识点：ansible命令执行常用Option 
>
> Ansible一般使用playbook来执行，ansible-playbook命令用于此种方式。如果不希望每次执行的时候都写一个playbook的yml文件，作为一个类似ssh延伸扩展功能的ansible还是能起到很多有用的作用的，本文将介绍一些平时用到较多的option。
>
> 

### option

| option | 说明 |
| ------ | ---- |
|-v      |详细信息输出 |
|-i		 |指定inventory的目录,缺省会使用/etc/ansible/hosts  |
|-f		 |fork的进程个数,默认是5                           |
|–private-key=xxx	|指定ssh连接用的文件                   |
|-m		 |指定module                                     |
|		 | –module-name 指定module名称                    |
|		 |–module-path 指定module的path 默认是/usr/share/ansible |
|-a		 |指定module的参数                                 |
|-k		 |提示输入password                                 |
|-K		 |提示输入sudo密码 与–sudo一起使用                   |
|-T		 |设定连接超时时长                                    |
|-B		 |设定后台运行并设定超时时长                        |
|-c		 |设定连接类型 有ssh或者local等。                    |
|-b		 |su的方式，可以指定用户                              |
|-C		 |only for check                |

### -i使用实例

```bash
Inventory内容设定servers为2台机器列表
[root@host31 ansible]# cat inventory
[servers]
host31
host32
# 不使用-i参数提示hosts list为空
[root@host31 ansible]# ansible servers -m ping
 [WARNING]: provided hosts list is empty, only localhost is available

[root@host31 ansible]#
# 指定-i之后能够正常动作
[root@host31 ansible]# ansible servers -i inventory -m ping
host31 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
host32 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
[root@host31 ansible]#
```
### -k使用实例

```bash
[root@host31 ~]# ansible host31 -k -m command -a "echo hello"
SSH password:
# 虽然设定了ssh通路，加上-k之后依然需要输入密码
host31 | SUCCESS | rc=0 >>
hello

[root@host31 ~]#
```

> 使用-k，实际是使用sshpass
```bash 
[root@host31 ~]# ansible host31 -k -m command -a "echo hello" -vvv
Using /etc/ansible/ansible.cfg as config file
SSH password:
<host31> ESTABLISH SSH CONNECTION FOR USER: None
<host31> SSH: EXEC sshpass -d12 ssh -C -q -o ControlMaster=auto -o ControlPersist=60s -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/ansible-ssh-%h-%p-%r host31 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo $HOME/.ansible/tmp/ansible-tmp-1469849015.27-12240784319451 `" && echo ansible-tmp-1469849015.27-12240784319451="` echo $HOME/.ansible/tmp/ansible-tmp-1469849015.27-12240784319451 `" ) && sleep 0'"'"''
<host31> PUT /tmp/tmp5kG8hJ TO /root/.ansible/tmp/ansible-tmp-1469849015.27-12240784319451/command
<host31> SSH: EXEC sshpass -d12 sftp -o BatchMode=no -b - -C -o ControlMaster=auto -o ControlPersist=60s -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/ansible-ssh-%h-%p-%r '[host31]'
<host31> ESTABLISH SSH CONNECTION FOR USER: None
<host31> SSH: EXEC sshpass -d12 ssh -C -q -o ControlMaster=auto -o ControlPersist=60s -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/ansible-ssh-%h-%p-%r -tt host31 '/bin/sh -c '"'"'LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 /usr/bin/python /root/.ansible/tmp/ansible-tmp-1469849015.27-12240784319451/command; rm -rf "/root/.ansible/tmp/ansible-tmp-1469849015.27-12240784319451/" > /dev/null 2>&1 && sleep 0'"'"''
host31 | SUCCESS | rc=0 >>
hello

[root@host31 ~]#
```
> 不使用-k则是直接使用ssh

```bash
[root@host31 ~]# ansible host31 -m command -a "echo hello" -vvv
Using /etc/ansible/ansible.cfg as config file
<host31> ESTABLISH SSH CONNECTION FOR USER: None
<host31> SSH: EXEC ssh -C -q -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/ansible-ssh-%h-%p-%r host31 '/bin/sh -c '"'"'( umask 77 && mkdir -p "` echo $HOME/.ansible/tmp/ansible-tmp-1469849066.0-90742279645616 `" && echo ansible-tmp-1469849066.0-90742279645616="` echo $HOME/.ansible/tmp/ansible-tmp-1469849066.0-90742279645616 `" ) && sleep 0'"'"''
<host31> PUT /tmp/tmpTvuyFh TO /root/.ansible/tmp/ansible-tmp-1469849066.0-90742279645616/command
<host31> SSH: EXEC sftp -b - -C -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/ansible-ssh-%h-%p-%r '[host31]'
<host31> ESTABLISH SSH CONNECTION FOR USER: None
<host31> SSH: EXEC ssh -C -q -o ControlMaster=auto -o ControlPersist=60s -o KbdInteractiveAuthentication=no -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey -o PasswordAuthentication=no -o ConnectTimeout=10 -o ControlPath=/root/.ansible/cp/ansible-ssh-%h-%p-%r -tt host31 '/bin/sh -c '"'"'LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 /usr/bin/python /root/.ansible/tmp/ansible-tmp-1469849066.0-90742279645616/command; rm -rf "/root/.ansible/tmp/ansible-tmp-1469849066.0-90742279645616/" > /dev/null 2>&1 && sleep 0'"'"''
host31 | SUCCESS | rc=0 >>
hello
[root@host31 ~]#
```

## 4.模块：command/shell/raw

> 知识点：使用module command或者shell或者raw都能调用对象机器上的某条指令或者某个可执行文件。

### 使用方法

```bash
[root@HF-SERVER17 ~]# ansible localhost -m shell -a "echo hello world"
localhost | SUCCESS | rc=0 >>
hello world

[root@HF-SERVER17 ~]# ansible localhost -m command -a "echo hello world"
localhost | SUCCESS | rc=0 >>
hello world

[root@HF-SERVER17 ~]# ansible localhost -m raw -a "echo hello world"
localhost | SUCCESS | rc=0 >>
hello world


[root@HF-SERVER17 ~]# 
```

### 是否支持管道

| module  | 是否支持管道 |
| ------- | ------------ |
| command | 不支持管道   |
| shell   | 支持管道     |
| raw     | 支持管道     |

测试结果：

```bash
[root@HF-SERVER17 ~]# ansible localhost -m raw -a "ps -ef| grep mysql"
localhost | SUCCESS | rc=0 >>
mysql     9437     1  0 Jun04 ?        02:31:40 /usr/sbin/mysqld
root     22670 18477 81 23:16 pts/0    00:00:01 /usr/bin/python2 /usr/bin/ansible localhost -m raw -a ps -ef| grep mysql
root     22678 22670  0 23:16 pts/0    00:00:00 /usr/bin/python2 /usr/bin/ansible localhost -m raw -a ps -ef| grep mysql
root     22680 22678  0 23:16 pts/0    00:00:00 /bin/sh -c ps -ef| grep mysql
root     22682 22680  0 23:16 pts/0    00:00:00 grep mysql


[root@HF-SERVER17 ~]# ansible localhost -m command -a "ps -ef| grep mysql"
localhost | FAILED | rc=1 >>
error: unsupported SysV option

Usage:
 ps [options]

 Try 'ps --help <simple|list|output|threads|misc|all>'
  or 'ps --help <s|l|o|t|m|a>'
 for additional help text.

For more details see ps(1).non-zero return code

[root@HF-SERVER17 ~]# ansible localhost -m shell -a "ps -ef| grep mysql"
localhost | SUCCESS | rc=0 >>
mysql     9437     1  0 Jun04 ?        02:31:40 /usr/sbin/mysqld
root     22720 18477 62 23:17 pts/0    00:00:01 /usr/bin/python2 /usr/bin/ansible localhost -m shell -a ps -ef| grep mysql
root     22731 22720 43 23:17 pts/0    00:00:00 /usr/bin/python2 /usr/bin/ansible localhost -m shell -a ps -ef| grep mysql
root     22747 22746  0 23:17 pts/0    00:00:00 /bin/sh -c ps -ef| grep mysql
root     22749 22747  0 23:17 pts/0    00:00:00 grep mysql

[root@HF-SERVER17 ~]# 
```

### 执行远程主机上文件

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a "/tmp/test.sh"
172.17.17.194 | FAILED | rc=8 >>
[Errno 8] Exec format error

[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "/tmp/test.sh"
172.17.17.194 | SUCCESS | rc=0 >>
hello world

[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m raw -a "/tmp/test.sh"
172.17.17.194 | SUCCESS | rc=0 >>
hello world
Shared connection to 172.17.17.194 closed.
[root@HF-SERVER17 ~]# 
```

> 都是支持的，但是需要注意/tmp/test.sh应该有执行权限

### ansible-doc -s取得更详细信息

> 希望知道更加详细的module的信息，最好的方法是使用ansible自带的ansible-doc的-s选项

```bash
[root@HF-SERVER17 ~]# ansible-doc -s raw
- name: Executes a low-down and dirty SSH command
  raw:
      executable:            # change the shell used to execute the command. Should be an absolute path to the executable. when using privilege escalation (`become'), a default shell will be assigned if one is
                               not provided as privilege escalation requires a shell.
      free_form:             # (required) the raw module takes a free form command to run. There is no parameter actually named 'free form'; see the examples!
[root@HF-SERVER17 ~]# ansible-doc -s command
- name: Executes a command on a remote node
  command:
      chdir:                 # Change into this directory before running the command.
      creates:               # A filename or (since 2.0) glob pattern, when it already exists, this step will *not* be run.
      free_form:             # (required) The command module takes a free form command to run.  There is no parameter actually named 'free form'. See the examples!
      removes:               # A filename or (since 2.0) glob pattern, when it does not exist, this step will *not* be run.
      stdin:                 # Set the stdin of the command directly to the specified value.
      warn:                  # If command_warnings are on in ansible.cfg, do not warn about this particular line if set to `no'.
[root@HF-SERVER17 ~]# 
```

## 5. 模块：copy

### option

| 参数   | 说明                                                         |
| ------ | ------------------------------------------------------------ |
| src    | 被复制到远程主机的本地对象文件或者文件夹，可以是绝对路径，也可以是相对路径。 |
| dest   | 被复制到远程主机的本地对象文件或者文件夹                     |
| mode   | 复制对象的设定权限                                           |
| backup | 在文件存在的时候可以选择覆盖之前，将源文件备份.设定值：yes/no 缺省为yes |
| force  | 是否强制覆盖.设定值：yes/no 缺省为no                         |
| …      | 其余请自行ansible-doc -s copy                                |

### 使用

> 使用ansible的copy的module将ttt.sh文件copy到远程的目标机上并命名为hello.sh

```bash
# 判断目标文件是否存在
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a /tmp/hello.sh
172.17.17.194 | FAILED | rc=2 >>
[Errno 2] No such file or directory

# 复制操作
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m copy -a "src=/tmp/test.sh dest=/tmp/hello.sh mode=750"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "checksum": "2c7123d6102ba1c47057f51fa46ebad71bbfb3a5", 
    "dest": "/tmp/hello.sh", 
    "gid": 0, 
    "group": "root", 
    "md5sum": "30fb1a7d0737a0ea240900274a1f6158", 
    "mode": "0750", 
    "owner": "root", 
    "secontext": "unconfined_u:object_r:admin_home_t:s0", 
    "size": 19, 
    "src": "/root/.ansible/tmp/ansible-tmp-1561011567.76-234066765270773/source", 
    "state": "file", 
    "uid": 0
}
# 执行结果
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a /tmp/hello.sh
172.17.17.194 | SUCCESS | rc=0 >>
hello world
```

### force使用实例
> default的情况下，force是yes的，所以什么都不写，文件存在的情况是会被覆盖的，如下所示。

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m copy -a "src=/tmp/test.sh dest=/tmp/hello.sh mode=750"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "checksum": "eaff3b7e3c54a6c71ce36418aa19565bfbeab7b6", 
    "dest": "/tmp/hello.sh", 
    "gid": 0, 
    "group": "root", 
    "md5sum": "ee1e94d8d76924858f314d43438704d7", 
    "mode": "0750", 
    "owner": "root", 
    "secontext": "unconfined_u:object_r:admin_home_t:s0", 
    "size": 62, 
    "src": "/root/.ansible/tmp/ansible-tmp-1561011996.52-77281185881857/source", 
    "state": "file", 
    "uid": 0
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m raw -a "ls -ltr /tmp"
172.17.17.194 | SUCCESS | rc=0 >>
total 12
-rw-r--r--. 1 root root 12 Jun 20 10:32 helloworld
-rwxr-xr-x. 1 root root 19 Jun 20 11:23 test.sh
-rwxr-x---. 1 root root 62 Jun 20 14:30 hello.sh
Shared connection to 172.17.17.194 closed.
```
> 明确写成force=no，此时将不会被覆盖。
```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "ls -l /tmp/hello.sh"
172.17.17.194 | SUCCESS | rc=0 >>
-rwxr-x---. 1 root root 0 Jul 30 05:40 /tmp/hello.sh
[root@HF-SERVER17 ~]]# ll /tmp/ttt.sh
-rwxr-x---. 1 root root 31 Jul 30 03:32 /tmp/ttt.sh
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m copy -a "src=/tmp/ttt.sh dest=/tmp/hello.sh force=no"
172.17.17.194 | SUCCESS => {
    "changed": false,
    "dest": "/tmp/hello.sh",
    "src": "/tmp/ttt.sh"
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "ls -l /tmp/hello.sh"
172.17.17.194 | SUCCESS | rc=0 >>
-rwxr-x---. 1 root root 0 Jul 30 05:40 /tmp/hello.sh

[root@HF-SERVER17 ~]
```

### backup使用实例
> 覆盖的动作作出之前，其会真正覆盖之前，会作出一个带时间戳的文件作为backup文件
```bash 
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m copy -a "src=/tmp/test.sh dest=/tmp/hello.sh backup=yes"
172.17.17.194 | SUCCESS => {
    "backup_file": "/tmp/hello.sh.9123.2019-06-20@14:39:33~", 
    "changed": true, 
    "checksum": "dbd33d9afb32668fd12dd50065b4b8c747638c79", 
    "dest": "/tmp/hello.sh", 
    "gid": 0, 
    "group": "root", 
    "md5sum": "e46f42b8c9fd00cfb36a4dbd593c873a", 
    "mode": "0750", 
    "owner": "root", 
    "secontext": "unconfined_u:object_r:admin_home_t:s0", 
    "size": 94, 
    "src": "/root/.ansible/tmp/ansible-tmp-1561012548.36-177726648425458/source", 
    "state": "file", 
    "uid": 0
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m raw -a "ls -ltr /tmp"
172.17.17.194 | SUCCESS | rc=0 >>
total 16
-rw-r--r--. 1 root root 12 Jun 20 10:32 helloworld
-rwxr-xr-x. 1 root root 19 Jun 20 11:23 test.sh
-rwxr-x---. 1 root root 62 Jun 20 14:30 hello.sh.9123.2019-06-20@14:39:33~
-rwxr-x---. 1 root root 94 Jun 20 14:39 hello.sh
Shared connection to 172.17.17.194 closed.
```

## 6. 模块：file

> 知识点：使用ansible可以用来设置文件属性。熟悉脚本的人可能直接会在command或者shell模块中设定可能会更加快捷。不过这样写，一定程度上读起来一致性更好一点。

### option

| Option | 说明                 |
| ------ | -------------------- |
| path   | 设定对象文件/目录    |
| owner  | 设定文件/目录的Owne  |
| group  | 设定文件/目录的Group |
| mode   | 设定文件/目录的权限  |
| …      | …                    |

### 使用实例

> 设定对象机器的某一文件的Owner/Group/mode

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m raw -a "ls -ltr /tmp/hello.sh"
172.17.17.194 | SUCCESS | rc=0 >>
-rwxr-x---. 1 root root 94 Jun 20 14:39 /tmp/hello.sh
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m file -a "path=/tmp/hello.sh owner=chensj group=chensj mode=0777"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "gid": 1000, 
    "group": "chensj", 
    "mode": "0777", 
    "owner": "chensj", 
    "path": "/tmp/hello.sh", 
    "secontext": "unconfined_u:object_r:admin_home_t:s0", 
    "size": 94, 
    "state": "file", 
    "uid": 1000
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m raw -a "ls -ltr /tmp/hello.sh"
172.17.17.194 | SUCCESS | rc=0 >>
-rwxrwxrwx. 1 chensj chensj 94 Jun 20 14:39 /tmp/hello.sh
```

## 7.模块：ping/setup

> 知识点：ping模块，用于确认和对象机器之间是否能够ping通，正常情况会返回pong 
> 知识点：setup模块，用于收集对象机器的基本设定信息。

### ping使用实例

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m ping
172.17.17.194 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

### setup使用实例

> 不用option的情况会输出所有相关的对象机器的facts

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m ping
172.17.17.194 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m setup
172.17.17.194 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.17.17.194"
        ], 
        "ansible_all_ipv6_addresses": [
            "fe80::80e1:43e0:475c:fa65"
        ], 
        "ansible_apparmor": {
            "status": "disabled"
        }, 
        "ansible_architecture": "x86_64", 
        "ansible_bios_date": "04/13/2018", 
        "ansible_bios_version": "6.00", 
        "ansible_cmdline": {
            "BOOT_IMAGE": "/vmlinuz-3.10.0-957.12.2.el7.x86_64", 
            "LANG": "en_US.UTF-8", 
            "crashkernel": "auto", 
            "quiet": true, 
            "rd.lvm.lv": "centos/swap", 
            "rhgb": true, 
            "ro": true, 
            "root": "/dev/mapper/centos-root"
        }, 
        "ansible_date_time": {
            "date": "2019-06-20", 
            "day": "20", 
            "epoch": "1561014160", 
            "hour": "15", 
            "iso8601": "2019-06-20T07:02:40Z", 
            "iso8601_basic": "20190620T150240667862", 
            "iso8601_basic_short": "20190620T150240", 
            "iso8601_micro": "2019-06-20T07:02:40.667941Z", 
            "minute": "02", 
            "month": "06", 
            "second": "40", 
            "time": "15:02:40", 
            "tz": "CST", 
            "tz_offset": "+0800", 
            "weekday": "Thursday", 
            "weekday_number": "4", 
            "weeknumber": "24", 
            "year": "2019"
        }, 
        "ansible_default_ipv4": {
            "address": "172.17.17.194", 
            "alias": "ens33", 
            "broadcast": "172.17.17.255", 
            "gateway": "172.17.17.254", 
            "interface": "ens33", 
            "macaddress": "00:0c:29:2b:a3:dd", 
            "mtu": 1500, 
            "netmask": "255.255.255.0", 
            "network": "172.17.17.0", 
            "type": "ether"
        }, 
        "ansible_default_ipv6": {
            "address": "fe80::80e1:43e0:475c:fa65", 
            "gateway": "fe80::6c0f:a705:f6d8:1255", 
            "interface": "ens33", 
            "macaddress": "00:0c:29:2b:a3:dd", 
            "mtu": 1500, 
            "prefix": "64", 
            "scope": "link", 
            "type": "ether"
        }, 
        "ansible_device_links": {
            "ids": {
                "dm-0": [
                    "dm-name-centos-root", 
                    "dm-uuid-LVM-YsyiGIApw8cLyS70vtesT0DZdONFIofifZYTsCSVau6xJgZPFIavaRm9U1vzOhsT"
                ], 
                "dm-1": [
                    "dm-name-centos-swap", 
                    "dm-uuid-LVM-YsyiGIApw8cLyS70vtesT0DZdONFIofiCEy3pAD7qp5tODAfcGUHZgvo9pO7WvDk"
                ], 
                "sda2": [
                    "lvm-pv-uuid-Rz9G3D-M4VX-FWaz-agu4-F1CE-XCDc-IlfyKn"
                ], 
                "sr0": [
                    "ata-VMware_Virtual_IDE_CDROM_Drive_10000000000000000001"
                ]
            }, 
            "labels": {}, 
            "masters": {
                "sda2": [
                    "dm-0", 
                    "dm-1"
                ]
            }, 
            "uuids": {
                "dm-0": [
                    "3bb980b0-4ad4-4c0b-a8f2-b14bd285d4ff"
                ], 
                "dm-1": [
                    "e69f4e73-08bd-4f89-aaa0-26ef720bf45c"
                ], 
                "sda1": [
                    "5045ffe2-df6a-4fbc-933b-f5dcaf3b172c"
                ]
            }
        }, 
        "ansible_devices": {
            "dm-0": {
                "holders": [], 
                "host": "", 
                "links": {
                    "ids": [
                        "dm-name-centos-root", 
                        "dm-uuid-LVM-YsyiGIApw8cLyS70vtesT0DZdONFIofifZYTsCSVau6xJgZPFIavaRm9U1vzOhsT"
                    ], 
                    "labels": [], 
                    "masters": [], 
                    "uuids": [
                        "3bb980b0-4ad4-4c0b-a8f2-b14bd285d4ff"
                    ]
                }, 
                "model": null, 
                "partitions": {}, 
                "removable": "0", 
                "rotational": "1", 
                "sas_address": null, 
                "sas_device_handle": null, 
                "scheduler_mode": "", 
                "sectors": "35643392", 
                "sectorsize": "512", 
                "size": "17.00 GB", 
                "support_discard": "0", 
                "vendor": null, 
                "virtual": 1
            }, 
            "dm-1": {
                "holders": [], 
                "host": "", 
                "links": {
                    "ids": [
                        "dm-name-centos-swap", 
                        "dm-uuid-LVM-YsyiGIApw8cLyS70vtesT0DZdONFIofiCEy3pAD7qp5tODAfcGUHZgvo9pO7WvDk"
                    ], 
                    "labels": [], 
                    "masters": [], 
                    "uuids": [
                        "e69f4e73-08bd-4f89-aaa0-26ef720bf45c"
                    ]
                }, 
                "model": null, 
                "partitions": {}, 
                "removable": "0", 
                "rotational": "1", 
                "sas_address": null, 
                "sas_device_handle": null, 
                "scheduler_mode": "", 
                "sectors": "4194304", 
                "sectorsize": "512", 
                "size": "2.00 GB", 
                "support_discard": "0", 
                "vendor": null, 
                "virtual": 1
            }, 
            "sda": {
                "holders": [], 
                "host": "", 
                "links": {
                    "ids": [], 
                    "labels": [], 
                    "masters": [], 
                    "uuids": []
                }, 
                "model": "VMware Virtual S", 
                "partitions": {
                    "sda1": {
                        "holders": [], 
                        "links": {
                            "ids": [], 
                            "labels": [], 
                            "masters": [], 
                            "uuids": [
                                "5045ffe2-df6a-4fbc-933b-f5dcaf3b172c"
                            ]
                        }, 
                        "sectors": "2097152", 
                        "sectorsize": 512, 
                        "size": "1.00 GB", 
                        "start": "2048", 
                        "uuid": "5045ffe2-df6a-4fbc-933b-f5dcaf3b172c"
                    }, 
                    "sda2": {
                        "holders": [
                            "centos-root", 
                            "centos-swap"
                        ], 
                        "links": {
                            "ids": [
                                "lvm-pv-uuid-Rz9G3D-M4VX-FWaz-agu4-F1CE-XCDc-IlfyKn"
                            ], 
                            "labels": [], 
                            "masters": [
                                "dm-0", 
                                "dm-1"
                            ], 
                            "uuids": []
                        }, 
                        "sectors": "39843840", 
                        "sectorsize": 512, 
                        "size": "19.00 GB", 
                        "start": "2099200", 
                        "uuid": null
                    }
                }, 
                "removable": "0", 
                "rotational": "1", 
                "sas_address": null, 
                "sas_device_handle": null, 
                "scheduler_mode": "deadline", 
                "sectors": "41943040", 
                "sectorsize": "512", 
                "size": "20.00 GB", 
                "support_discard": "0", 
                "vendor": "VMware,", 
                "virtual": 1
            }, 
            "sr0": {
                "holders": [], 
                "host": "", 
                "links": {
                    "ids": [
                        "ata-VMware_Virtual_IDE_CDROM_Drive_10000000000000000001"
                    ], 
                    "labels": [], 
                    "masters": [], 
                    "uuids": []
                }, 
                "model": "VMware IDE CDR10", 
                "partitions": {}, 
                "removable": "1", 
                "rotational": "1", 
                "sas_address": null, 
                "sas_device_handle": null, 
                "scheduler_mode": "deadline", 
                "sectors": "2097151", 
                "sectorsize": "512", 
                "size": "1024.00 MB", 
                "support_discard": "0", 
                "vendor": "NECVMWar", 
                "virtual": 1
            }
        }, 
        "ansible_distribution": "CentOS", 
        "ansible_distribution_file_parsed": true, 
        "ansible_distribution_file_path": "/etc/redhat-release", 
        "ansible_distribution_file_variety": "RedHat", 
        "ansible_distribution_major_version": "7", 
        "ansible_distribution_release": "Core", 
        "ansible_distribution_version": "7.6.1810", 
        "ansible_dns": {
            "nameservers": [
                "58.242.2.2", 
                "114.114.114.114"
            ], 
            "search": [
                "node.db"
            ]
        }, 
        "ansible_domain": "node.db", 
        "ansible_effective_group_id": 0, 
        "ansible_effective_user_id": 0, 
        "ansible_ens33": {
            "active": true, 
            "device": "ens33", 
            "features": {
                "busy_poll": "off [fixed]", 
                "fcoe_mtu": "off [fixed]", 
                "generic_receive_offload": "on", 
                "generic_segmentation_offload": "on", 
                "highdma": "off [fixed]", 
                "hw_tc_offload": "off [fixed]", 
                "l2_fwd_offload": "off [fixed]", 
                "large_receive_offload": "off [fixed]", 
                "loopback": "off [fixed]", 
                "netns_local": "off [fixed]", 
                "ntuple_filters": "off [fixed]", 
                "receive_hashing": "off [fixed]", 
                "rx_all": "off", 
                "rx_checksumming": "off", 
                "rx_fcs": "off", 
                "rx_gro_hw": "off [fixed]", 
                "rx_udp_tunnel_port_offload": "off [fixed]", 
                "rx_vlan_filter": "on [fixed]", 
                "rx_vlan_offload": "on", 
                "rx_vlan_stag_filter": "off [fixed]", 
                "rx_vlan_stag_hw_parse": "off [fixed]", 
                "scatter_gather": "on", 
                "tcp_segmentation_offload": "on", 
                "tx_checksum_fcoe_crc": "off [fixed]", 
                "tx_checksum_ip_generic": "on", 
                "tx_checksum_ipv4": "off [fixed]", 
                "tx_checksum_ipv6": "off [fixed]", 
                "tx_checksum_sctp": "off [fixed]", 
                "tx_checksumming": "on", 
                "tx_fcoe_segmentation": "off [fixed]", 
                "tx_gre_csum_segmentation": "off [fixed]", 
                "tx_gre_segmentation": "off [fixed]", 
                "tx_gso_partial": "off [fixed]", 
                "tx_gso_robust": "off [fixed]", 
                "tx_ipip_segmentation": "off [fixed]", 
                "tx_lockless": "off [fixed]", 
                "tx_nocache_copy": "off", 
                "tx_scatter_gather": "on", 
                "tx_scatter_gather_fraglist": "off [fixed]", 
                "tx_sctp_segmentation": "off [fixed]", 
                "tx_sit_segmentation": "off [fixed]", 
                "tx_tcp6_segmentation": "off [fixed]", 
                "tx_tcp_ecn_segmentation": "off [fixed]", 
                "tx_tcp_mangleid_segmentation": "off", 
                "tx_tcp_segmentation": "on", 
                "tx_udp_tnl_csum_segmentation": "off [fixed]", 
                "tx_udp_tnl_segmentation": "off [fixed]", 
                "tx_vlan_offload": "on [fixed]", 
                "tx_vlan_stag_hw_insert": "off [fixed]", 
                "udp_fragmentation_offload": "off [fixed]", 
                "vlan_challenged": "off [fixed]"
            }, 
            "hw_timestamp_filters": [], 
            "ipv4": {
                "address": "172.17.17.194", 
                "broadcast": "172.17.17.255", 
                "netmask": "255.255.255.0", 
                "network": "172.17.17.0"
            }, 
            "ipv6": [
                {
                    "address": "fe80::80e1:43e0:475c:fa65", 
                    "prefix": "64", 
                    "scope": "link"
                }
            ], 
            "macaddress": "00:0c:29:2b:a3:dd", 
            "module": "e1000", 
            "mtu": 1500, 
            "pciid": "0000:02:01.0", 
            "promisc": false, 
            "speed": 1000, 
            "timestamping": [
                "tx_software", 
                "rx_software", 
                "software"
            ], 
            "type": "ether"
        }, 
        "ansible_env": {
            "HOME": "/root", 
            "LANG": "en_US.UTF-8", 
            "LESSOPEN": "||/usr/bin/lesspipe.sh %s", 
            "LOGNAME": "root", 
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:", 
            "MAIL": "/var/mail/root", 
            "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin", 
            "PWD": "/root", 
            "SELINUX_LEVEL_REQUESTED": "", 
            "SELINUX_ROLE_REQUESTED": "", 
            "SELINUX_USE_CURRENT_RANGE": "", 
            "SHELL": "/bin/bash", 
            "SHLVL": "2", 
            "SSH_CLIENT": "172.17.1.242 50124 22", 
            "SSH_CONNECTION": "172.17.1.242 50124 172.17.17.194 22", 
            "SSH_TTY": "/dev/pts/1", 
            "TERM": "xterm", 
            "USER": "root", 
            "XDG_RUNTIME_DIR": "/run/user/0", 
            "XDG_SESSION_ID": "30", 
            "_": "/usr/bin/python"
        }, 
        "ansible_fips": false, 
        "ansible_form_factor": "Other", 
        "ansible_fqdn": "centos7.node.db", 
        "ansible_hostname": "centos7", 
        "ansible_interfaces": [
            "lo", 
            "ens33"
        ], 
        "ansible_kernel": "3.10.0-957.12.2.el7.x86_64", 
        "ansible_lo": {
            "active": true, 
            "device": "lo", 
            "features": {
                "busy_poll": "off [fixed]", 
                "fcoe_mtu": "off [fixed]", 
                "generic_receive_offload": "on", 
                "generic_segmentation_offload": "on", 
                "highdma": "on [fixed]", 
                "hw_tc_offload": "off [fixed]", 
                "l2_fwd_offload": "off [fixed]", 
                "large_receive_offload": "off [fixed]", 
                "loopback": "on [fixed]", 
                "netns_local": "on [fixed]", 
                "ntuple_filters": "off [fixed]", 
                "receive_hashing": "off [fixed]", 
                "rx_all": "off [fixed]", 
                "rx_checksumming": "on [fixed]", 
                "rx_fcs": "off [fixed]", 
                "rx_gro_hw": "off [fixed]", 
                "rx_udp_tunnel_port_offload": "off [fixed]", 
                "rx_vlan_filter": "off [fixed]", 
                "rx_vlan_offload": "off [fixed]", 
                "rx_vlan_stag_filter": "off [fixed]", 
                "rx_vlan_stag_hw_parse": "off [fixed]", 
                "scatter_gather": "on", 
                "tcp_segmentation_offload": "on", 
                "tx_checksum_fcoe_crc": "off [fixed]", 
                "tx_checksum_ip_generic": "on [fixed]", 
                "tx_checksum_ipv4": "off [fixed]", 
                "tx_checksum_ipv6": "off [fixed]", 
                "tx_checksum_sctp": "on [fixed]", 
                "tx_checksumming": "on", 
                "tx_fcoe_segmentation": "off [fixed]", 
                "tx_gre_csum_segmentation": "off [fixed]", 
                "tx_gre_segmentation": "off [fixed]", 
                "tx_gso_partial": "off [fixed]", 
                "tx_gso_robust": "off [fixed]", 
                "tx_ipip_segmentation": "off [fixed]", 
                "tx_lockless": "on [fixed]", 
                "tx_nocache_copy": "off [fixed]", 
                "tx_scatter_gather": "on [fixed]", 
                "tx_scatter_gather_fraglist": "on [fixed]", 
                "tx_sctp_segmentation": "on", 
                "tx_sit_segmentation": "off [fixed]", 
                "tx_tcp6_segmentation": "on", 
                "tx_tcp_ecn_segmentation": "on", 
                "tx_tcp_mangleid_segmentation": "on", 
                "tx_tcp_segmentation": "on", 
                "tx_udp_tnl_csum_segmentation": "off [fixed]", 
                "tx_udp_tnl_segmentation": "off [fixed]", 
                "tx_vlan_offload": "off [fixed]", 
                "tx_vlan_stag_hw_insert": "off [fixed]", 
                "udp_fragmentation_offload": "on", 
                "vlan_challenged": "on [fixed]"
            }, 
            "hw_timestamp_filters": [], 
            "ipv4": {
                "address": "127.0.0.1", 
                "broadcast": "host", 
                "netmask": "255.0.0.0", 
                "network": "127.0.0.0"
            }, 
            "ipv6": [
                {
                    "address": "::1", 
                    "prefix": "128", 
                    "scope": "host"
                }
            ], 
            "mtu": 65536, 
            "promisc": false, 
            "timestamping": [
                "rx_software", 
                "software"
            ], 
            "type": "loopback"
        }, 
        "ansible_local": {}, 
        "ansible_lsb": {}, 
        "ansible_lvm": {
            "lvs": {
                "root": {
                    "size_g": "17.00", 
                    "vg": "centos"
                }, 
                "swap": {
                    "size_g": "2.00", 
                    "vg": "centos"
                }
            }, 
            "pvs": {
                "/dev/sda2": {
                    "free_g": "0", 
                    "size_g": "19.00", 
                    "vg": "centos"
                }
            }, 
            "vgs": {
                "centos": {
                    "free_g": "0", 
                    "num_lvs": "2", 
                    "num_pvs": "1", 
                    "size_g": "19.00"
                }
            }
        }, 
        "ansible_machine": "x86_64", 
        "ansible_machine_id": "05c6d5f2afaa44dab8d1452d865fce46", 
        "ansible_memfree_mb": 6, 
        "ansible_memory_mb": {
            "nocache": {
                "free": 44, 
                "used": 424
            }, 
            "real": {
                "free": 6, 
                "total": 468, 
                "used": 462
            }, 
            "swap": {
                "cached": 9, 
                "free": 1911, 
                "total": 2047, 
                "used": 136
            }
        }, 
        "ansible_memtotal_mb": 468, 
        "ansible_mounts": [
            {
                "block_available": 2972973, 
                "block_size": 4096, 
                "block_total": 4452864, 
                "block_used": 1479891, 
                "device": "/dev/mapper/centos-root", 
                "fstype": "xfs", 
                "inode_available": 8869274, 
                "inode_total": 8910848, 
                "inode_used": 41574, 
                "mount": "/", 
                "options": "rw,seclabel,relatime,attr2,inode64,noquota", 
                "size_available": 12177297408, 
                "size_total": 18238930944, 
                "uuid": "3bb980b0-4ad4-4c0b-a8f2-b14bd285d4ff"
            }, 
            {
                "block_available": 217977, 
                "block_size": 4096, 
                "block_total": 259584, 
                "block_used": 41607, 
                "device": "/dev/sda1", 
                "fstype": "xfs", 
                "inode_available": 523956, 
                "inode_total": 524288, 
                "inode_used": 332, 
                "mount": "/boot", 
                "options": "rw,seclabel,relatime,attr2,inode64,noquota", 
                "size_available": 892833792, 
                "size_total": 1063256064, 
                "uuid": "5045ffe2-df6a-4fbc-933b-f5dcaf3b172c"
            }
        ], 
        "ansible_nodename": "centos7.node.db", 
        "ansible_os_family": "RedHat", 
        "ansible_pkg_mgr": "yum", 
        "ansible_processor": [
            "0", 
            "GenuineIntel", 
            "Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz"
        ], 
        "ansible_processor_cores": 1, 
        "ansible_processor_count": 1, 
        "ansible_processor_threads_per_core": 1, 
        "ansible_processor_vcpus": 1, 
        "ansible_product_name": "VMware Virtual Platform", 
        "ansible_product_serial": "VMware-56 4d 86 99 df ec 39 a0-65 df 32 00 18 2b a3 dd", 
        "ansible_product_uuid": "99864D56-ECDF-A039-65DF-3200182BA3DD", 
        "ansible_product_version": "None", 
        "ansible_python": {
            "executable": "/usr/bin/python", 
            "has_sslcontext": true, 
            "type": "CPython", 
            "version": {
                "major": 2, 
                "micro": 5, 
                "minor": 7, 
                "releaselevel": "final", 
                "serial": 0
            }, 
            "version_info": [
                2, 
                7, 
                5, 
                "final", 
                0
            ]
        }, 
        "ansible_python_version": "2.7.5", 
        "ansible_real_group_id": 0, 
        "ansible_real_user_id": 0, 
        "ansible_selinux": {
            "config_mode": "enforcing", 
            "mode": "enforcing", 
            "policyvers": 31, 
            "status": "enabled", 
            "type": "targeted"
        }, 
        "ansible_selinux_python_present": true, 
        "ansible_service_mgr": "systemd", 
        "ansible_ssh_host_key_ecdsa_public": "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC7qyU9bGtK5E1OaeOg95KzjqHMNDT1SDaxJXc1tjV5wu9hGMr9ktik4vT3bj/vUClyOjqRR0G3Ed88BwgTD6CE=", 
        "ansible_ssh_host_key_ed25519_public": "AAAAC3NzaC1lZDI1NTE5AAAAILg0dNFh9mFVGl0PvDPq85oxJaRCSY5TlFE6mFulYvHp", 
        "ansible_ssh_host_key_rsa_public": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDhsmfonhXSTVG9vty/N6eASNZwgfknEHK5+53eUjKQRXWkBacLYKdpX4Q3IAylgn2ARu5hl61wsF8/TnodXWgBpKhwft1AlottoX0LYdify3NWmlIVNL8K2rT8lfR7VoX5WW+sRYaUbmYJRGhWUvhxVkO+SULzQ9Eg98UFSQQgAeAD19QG5ZO2BO2tDtF8tt+GD4e2+b49GEXwWH/VkJaj11ip4HwwlXDhjWSPs23kMBQRYG0AfCgWNk1jHCQbgB3a2ZLXL6zMqMyCM+jUjSiVXHhJ9aS1q+0g5DwYu7oWDabemmhxGM4OVMU+OU93y725OIkpbauAR+LRWrt+3PBd", 
        "ansible_swapfree_mb": 1911, 
        "ansible_swaptotal_mb": 2047, 
        "ansible_system": "Linux", 
        "ansible_system_capabilities": [
            "cap_chown", 
            "cap_dac_override", 
            "cap_dac_read_search", 
            "cap_fowner", 
            "cap_fsetid", 
            "cap_kill", 
            "cap_setgid", 
            "cap_setuid", 
            "cap_setpcap", 
            "cap_linux_immutable", 
            "cap_net_bind_service", 
            "cap_net_broadcast", 
            "cap_net_admin", 
            "cap_net_raw", 
            "cap_ipc_lock", 
            "cap_ipc_owner", 
            "cap_sys_module", 
            "cap_sys_rawio", 
            "cap_sys_chroot", 
            "cap_sys_ptrace", 
            "cap_sys_pacct", 
            "cap_sys_admin", 
            "cap_sys_boot", 
            "cap_sys_nice", 
            "cap_sys_resource", 
            "cap_sys_time", 
            "cap_sys_tty_config", 
            "cap_mknod", 
            "cap_lease", 
            "cap_audit_write", 
            "cap_audit_control", 
            "cap_setfcap", 
            "cap_mac_override", 
            "cap_mac_admin", 
            "cap_syslog", 
            "35", 
            "36+ep"
        ], 
        "ansible_system_capabilities_enforced": "True", 
        "ansible_system_vendor": "VMware, Inc.", 
        "ansible_uptime_seconds": 18532, 
        "ansible_user_dir": "/root", 
        "ansible_user_gecos": "root", 
        "ansible_user_gid": 0, 
        "ansible_user_id": "root", 
        "ansible_user_shell": "/bin/bash", 
        "ansible_user_uid": 0, 
        "ansible_userspace_architecture": "x86_64", 
        "ansible_userspace_bits": "64", 
        "ansible_virtualization_role": "guest", 
        "ansible_virtualization_type": "VMware", 
        "gather_subset": [
            "all"
        ], 
        "module_setup": true
    }, 
    "changed": false
}
```

### setup 过滤

> setup常用Option：filter 
> 比如收集对象机器的环境变量信息

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m setup -a "filter=ansible_env"
172.17.17.194 | SUCCESS => {
    "ansible_facts": {
        "ansible_env": {
            "HOME": "/root", 
            "LANG": "en_US.UTF-8", 
            "LESSOPEN": "||/usr/bin/lesspipe.sh %s", 
            "LOGNAME": "root", 
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:", 
            "MAIL": "/var/mail/root", 
            "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin", 
            "PWD": "/root", 
            "SELINUX_LEVEL_REQUESTED": "", 
            "SELINUX_ROLE_REQUESTED": "", 
            "SELINUX_USE_CURRENT_RANGE": "", 
            "SHELL": "/bin/bash", 
            "SHLVL": "2", 
            "SSH_CLIENT": "172.17.1.242 50152 22", 
            "SSH_CONNECTION": "172.17.1.242 50152 172.17.17.194 22", 
            "SSH_TTY": "/dev/pts/1", 
            "TERM": "xterm", 
            "USER": "root", 
            "XDG_RUNTIME_DIR": "/run/user/0", 
            "XDG_SESSION_ID": "31", 
            "_": "/usr/bin/python"
        }
    }, 
    "changed": false
}
```

## 8. 模块： user/group

> 知识点：user模块，用于管理用户。 
> 知识点：group模块，用于管理group。

### 使用user模块添加用户

```bash
# 判断用户是否存在
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a "id admin"
172.17.17.194 | FAILED | rc=1 >>
id: admin: no such usernon-zero return code
# 添加用户
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m user -a "user=admin group=root"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "comment": "", 
    "createhome": true, 
    "group": 0, 
    "home": "/home/admin", 
    "name": "admin", 
    "shell": "/bin/bash", 
    "state": "present", 
    "system": false, 
    "uid": 1001
}
# 查看用户
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a "id admin"
172.17.17.194 | SUCCESS | rc=0 >>
uid=1001(admin) gid=0(root) groups=0(root)
```

### 使用user模块删除用户

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m user -a "name=admin state=absent remove=yes"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "force": false, 
    "name": "admin", 
    "remove": true, 
    "state": "absent"
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m command -a "id admin"
172.17.17.194 | FAILED | rc=1 >>
id: admin: no such usernon-zero return code
```

### 使用group增加组

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "cat /etc/group|grep testgrp1"
172.17.17.194 | FAILED | rc=1 >>
non-zero return code
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m group -a "name=testgrp1"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "gid": 1001, 
    "name": "testgrp1", 
    "state": "present", 
    "system": false
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "cat /etc/group|grep testgrp1"
172.17.17.194 | SUCCESS | rc=0 >>
testgrp1:x:1001:
```

### 使用group删除组

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m group -a "name=testgrp1 state=absent"
172.17.17.194 | SUCCESS => {
    "changed": true, 
    "name": "testgrp1", 
    "state": "absent"
}
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "cat /etc/group|grep testgrp1"
172.17.17.194 | FAILED | rc=1 >>
non-zero return code
```

## 9.模块：yum/service

> 知识点：yum模块用于yum安装包安装和卸载等操作。 
> 知识点：service模块用于系统服务管理操作，比如启动停止等操作。

### 使用yum安装httpd

> 事前确认未曾安装

```bash
[root@HF-SERVER17 ~]# ansible 172.17.17.194 -m shell -a "rpm -qa|grep httpd"
 [WARNING]: Consider using yum, dnf or zypper module rather than running rpm

172.17.17.194 | FAILED | rc=1 >>
non-zero return code
```

> 安装

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m yum -a "name=httpd"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "msg": "http://mirrors.aliyun.com/centos/7.6.1810/os/x86_64/Packages/apr-util-1.5.2-6.el7.x86_64.rpm: [Errno -1] Package does not match intended download. Suggestion: run yum --enablerepo=base clean metadata\nTrying other mirror.\nhttp://mirrors.aliyun.com/centos/7.6.1810/os/x86_64/Packages/apr-1.4.8-3.el7_4.1.x86_64.rpm: [Errno -1] Package does not match intended download. Suggestion: run yum --enablerepo=base clean metadata\nTrying other mirror.\nhttp://mirrors.aliyun.com/centos/7.6.1810/os/x86_64/Packages/mailcap-2.1.41-2.el7.noarch.rpm: [Errno -1] Package does not match intended download. Suggestion: run yum --enablerepo=base clean metadata\nTrying other mirror.\nhttp://mirrors.aliyun.com/centos/7.6.1810/updates/x86_64/Packages/httpd-tools-2.4.6-89.el7.centos.x86_64.rpm: [Errno -1] Package does not match intended download. Suggestion: run yum --enablerepo=updates clean metadata\nTrying other mirror.\nhttp://mirrors.aliyun.com/centos/7.6.1810/updates/x86_64/Packages/httpd-2.4.6-89.el7.centos.x86_64.rpm: [Errno -1] Package does not match intended download. Suggestion: run yum --enablerepo=updates clean metadata\nTrying other mirror.\n", 
    "rc": 0, 
    "results": [
        "Loaded plugins: fastestmirror\nLoading mirror speeds from cached hostfile\n * base: centos.ustc.edu.cn\n * extras: centos.ustc.edu.cn\n * updates: mirrors.163.com\nResolving Dependencies\n--> Running transaction check\n---> Package httpd.x86_64 0:2.4.6-89.el7.centos will be installed\n--> Processing Dependency: httpd-tools = 2.4.6-89.el7.centos for package: httpd-2.4.6-89.el7.centos.x86_64\n--> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-89.el7.centos.x86_64\n--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-89.el7.centos.x86_64\n--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-89.el7.centos.x86_64\n--> Running transaction check\n---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed\n---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed\n---> Package httpd-tools.x86_64 0:2.4.6-89.el7.centos will be installed\n---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package           Arch         Version                     Repository     Size\n================================================================================\nInstalling:\n httpd             x86_64       2.4.6-89.el7.centos         updates       2.7 M\nInstalling for dependencies:\n apr               x86_64       1.4.8-3.el7_4.1             base          103 k\n apr-util          x86_64       1.5.2-6.el7                 base           92 k\n httpd-tools       x86_64       2.4.6-89.el7.centos         updates        90 k\n mailcap           noarch       2.1.41-2.el7                base           31 k\n\nTransaction Summary\n================================================================================\nInstall  1 Package (+4 Dependent packages)\n\nTotal download size: 3.0 M\nInstalled size: 10 M\nDownloading packages:\nDelta RPMs disabled because /usr/bin/applydeltarpm not installed.\n--------------------------------------------------------------------------------\nTotal                                               98 kB/s | 3.0 MB  00:31     \nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Installing : apr-1.4.8-3.el7_4.1.x86_64                                   1/5 \n  Installing : apr-util-1.5.2-6.el7.x86_64                                  2/5 \n  Installing : httpd-tools-2.4.6-89.el7.centos.x86_64                       3/5 \n  Installing : mailcap-2.1.41-2.el7.noarch                                  4/5 \n  Installing : httpd-2.4.6-89.el7.centos.x86_64                             5/5 \n  Verifying  : httpd-tools-2.4.6-89.el7.centos.x86_64                       1/5 \n  Verifying  : mailcap-2.1.41-2.el7.noarch                                  2/5 \n  Verifying  : httpd-2.4.6-89.el7.centos.x86_64                             3/5 \n  Verifying  : apr-1.4.8-3.el7_4.1.x86_64                                   4/5 \n  Verifying  : apr-util-1.5.2-6.el7.x86_64                                  5/5 \n\nInstalled:\n  httpd.x86_64 0:2.4.6-89.el7.centos                                            \n\nDependency Installed:\n  apr.x86_64 0:1.4.8-3.el7_4.1                 apr-util.x86_64 0:1.5.2-6.el7    \n  httpd-tools.x86_64 0:2.4.6-89.el7.centos     mailcap.noarch 0:2.1.41-2.el7    \n\nComplete!\n"
    ]
}
```

> 确认安装

```bash
# 安装查询
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "rpm -qa|grep httpd"
 [WARNING]: Consider using yum, dnf or zypper module rather than running rpm
192.168.78.130 | SUCCESS | rc=0 >>
httpd-2.4.6-89.el7.centos.x86_64
httpd-tools-2.4.6-89.el7.centos.x86_64
```

### 使用service启动httpd服务

> 事前未曾启动，检查httpd运行状态

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "systemctl status httpd"
192.168.78.130 | FAILED | rc=3 >>
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
     Docs: man:httpd(8)
           man:apachectl(8)non-zero return code
```

> 使用service模块启动httpd

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m service -a "name=httpd state=started"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "name": "httpd", 
    "state": "started", 
    "status": {
        "ActiveEnterTimestampMonotonic": "0", 
        "ActiveExitTimestampMonotonic": "0", 
        "ActiveState": "inactive", 
        "After": "systemd-journald.socket nss-lookup.target tmp.mount system.slice network.target -.mount basic.target remote-fs.target", 
        "AllowIsolate": "no", 
        "AmbientCapabilities": "0", 
        "AssertResult": "no", 
        "AssertTimestampMonotonic": "0", 
        "Before": "shutdown.target", 
        "BlockIOAccounting": "no", 
        "BlockIOWeight": "18446744073709551615", 
        "CPUAccounting": "no", 
        "CPUQuotaPerSecUSec": "infinity", 
        "CPUSchedulingPolicy": "0", 
        "CPUSchedulingPriority": "0", 
        "CPUSchedulingResetOnFork": "no", 
        "CPUShares": "18446744073709551615", 
        "CanIsolate": "no", 
        "CanReload": "yes", 
        "CanStart": "yes", 
        "CanStop": "yes", 
        "CapabilityBoundingSet": "18446744073709551615", 
        "ConditionResult": "no", 
        "ConditionTimestampMonotonic": "0", 
        "Conflicts": "shutdown.target", 
        "ControlPID": "0", 
        "DefaultDependencies": "yes", 
        "Delegate": "no", 
        "Description": "The Apache HTTP Server", 
        "DevicePolicy": "auto", 
        "Documentation": "man:httpd(8) man:apachectl(8)", 
        "EnvironmentFile": "/etc/sysconfig/httpd (ignore_errors=no)", 
        "ExecMainCode": "0", 
        "ExecMainExitTimestampMonotonic": "0", 
        "ExecMainPID": "0", 
        "ExecMainStartTimestampMonotonic": "0", 
        "ExecMainStatus": "0", 
        "ExecReload": "{ path=/usr/sbin/httpd ; argv[]=/usr/sbin/httpd $OPTIONS -k graceful ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "ExecStart": "{ path=/usr/sbin/httpd ; argv[]=/usr/sbin/httpd $OPTIONS -DFOREGROUND ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "ExecStop": "{ path=/bin/kill ; argv[]=/bin/kill -WINCH ${MAINPID} ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "FailureAction": "none", 
        "FileDescriptorStoreMax": "0", 
        "FragmentPath": "/usr/lib/systemd/system/httpd.service", 
        "GuessMainPID": "yes", 
        "IOScheduling": "0", 
        "Id": "httpd.service", 
        "IgnoreOnIsolate": "no", 
        "IgnoreOnSnapshot": "no", 
        "IgnoreSIGPIPE": "yes", 
        "InactiveEnterTimestampMonotonic": "0", 
        "InactiveExitTimestampMonotonic": "0", 
        "JobTimeoutAction": "none", 
        "JobTimeoutUSec": "0", 
        "KillMode": "control-group", 
        "KillSignal": "18", 
        "LimitAS": "18446744073709551615", 
        "LimitCORE": "18446744073709551615", 
        "LimitCPU": "18446744073709551615", 
        "LimitDATA": "18446744073709551615", 
        "LimitFSIZE": "18446744073709551615", 
        "LimitLOCKS": "18446744073709551615", 
        "LimitMEMLOCK": "65536", 
        "LimitMSGQUEUE": "819200", 
        "LimitNICE": "0", 
        "LimitNOFILE": "4096", 
        "LimitNPROC": "1780", 
        "LimitRSS": "18446744073709551615", 
        "LimitRTPRIO": "0", 
        "LimitRTTIME": "18446744073709551615", 
        "LimitSIGPENDING": "1780", 
        "LimitSTACK": "18446744073709551615", 
        "LoadState": "loaded", 
        "MainPID": "0", 
        "MemoryAccounting": "no", 
        "MemoryCurrent": "18446744073709551615", 
        "MemoryLimit": "18446744073709551615", 
        "MountFlags": "0", 
        "Names": "httpd.service", 
        "NeedDaemonReload": "no", 
        "Nice": "0", 
        "NoNewPrivileges": "no", 
        "NonBlocking": "no", 
        "NotifyAccess": "main", 
        "OOMScoreAdjust": "0", 
        "OnFailureJobMode": "replace", 
        "PermissionsStartOnly": "no", 
        "PrivateDevices": "no", 
        "PrivateNetwork": "no", 
        "PrivateTmp": "yes", 
        "ProtectHome": "no", 
        "ProtectSystem": "no", 
        "RefuseManualStart": "no", 
        "RefuseManualStop": "no", 
        "RemainAfterExit": "no", 
        "Requires": "basic.target -.mount", 
        "RequiresMountsFor": "/var/tmp", 
        "Restart": "no", 
        "RestartUSec": "100ms", 
        "Result": "success", 
        "RootDirectoryStartOnly": "no", 
        "RuntimeDirectoryMode": "0755", 
        "SameProcessGroup": "no", 
        "SecureBits": "0", 
        "SendSIGHUP": "no", 
        "SendSIGKILL": "yes", 
        "Slice": "system.slice", 
        "StandardError": "inherit", 
        "StandardInput": "null", 
        "StandardOutput": "journal", 
        "StartLimitAction": "none", 
        "StartLimitBurst": "5", 
        "StartLimitInterval": "10000000", 
        "StartupBlockIOWeight": "18446744073709551615", 
        "StartupCPUShares": "18446744073709551615", 
        "StatusErrno": "0", 
        "StopWhenUnneeded": "no", 
        "SubState": "dead", 
        "SyslogLevelPrefix": "yes", 
        "SyslogPriority": "30", 
        "SystemCallErrorNumber": "0", 
        "TTYReset": "no", 
        "TTYVHangup": "no", 
        "TTYVTDisallocate": "no", 
        "TasksAccounting": "no", 
        "TasksCurrent": "18446744073709551615", 
        "TasksMax": "18446744073709551615", 
        "TimeoutStartUSec": "1min 30s", 
        "TimeoutStopUSec": "1min 30s", 
        "TimerSlackNSec": "50000", 
        "Transient": "no", 
        "Type": "notify", 
        "UMask": "0022", 
        "UnitFilePreset": "disabled", 
        "UnitFileState": "disabled", 
        "Wants": "system.slice", 
        "WatchdogTimestampMonotonic": "0", 
        "WatchdogUSec": "0"
    }
}
```

> 确认启动

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "systemctl status httpd"
192.168.78.130 | SUCCESS | rc=0 >>
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-06-20 15:55:19 CST; 3min 31s ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 7677 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/httpd.service
           ├─7677 /usr/sbin/httpd -DFOREGROUND
           ├─7678 /usr/sbin/httpd -DFOREGROUND
           ├─7679 /usr/sbin/httpd -DFOREGROUND
           ├─7680 /usr/sbin/httpd -DFOREGROUND
           ├─7681 /usr/sbin/httpd -DFOREGROUND
           └─7682 /usr/sbin/httpd -DFOREGROUND

Jun 20 15:55:13 centos7.node.db systemd[1]: Starting The Apache HTTP Server...
Jun 20 15:55:19 centos7.node.db systemd[1]: Started The Apache HTTP Server.
```

> 确认启动httpd 
>
> 需要确认网络是否通，端口是否允许通过
>
> centos7 则需要修改：
>
> firewall-cmd --zone=public --add-port=80/tcp --permanent
>
> firewall-cmd --reload

![确认启动httpd ](https://img-blog.csdn.net/20160731053313520)

### 使用service 停止httpd

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m service -a "name=httpd state=stopped"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "name": "httpd", 
    "state": "stopped", 
    "status": {
        "ActiveEnterTimestamp": "Thu 2019-06-20 15:55:19 CST", 
        "ActiveEnterTimestampMonotonic": "759887997", 
        "ActiveExitTimestampMonotonic": "0", 
        "ActiveState": "active", 
        "After": "nss-lookup.target network.target tmp.mount -.mount systemd-journald.socket remote-fs.target basic.target system.slice", 
        "AllowIsolate": "no", 
        "AmbientCapabilities": "0", 
        "AssertResult": "yes", 
        "AssertTimestamp": "Thu 2019-06-20 15:55:13 CST", 
        "AssertTimestampMonotonic": "753490128", 
        "Before": "shutdown.target", 
        "BlockIOAccounting": "no", 
        "BlockIOWeight": "18446744073709551615", 
        "CPUAccounting": "no", 
        "CPUQuotaPerSecUSec": "infinity", 
        "CPUSchedulingPolicy": "0", 
        "CPUSchedulingPriority": "0", 
        "CPUSchedulingResetOnFork": "no", 
        "CPUShares": "18446744073709551615", 
        "CanIsolate": "no", 
        "CanReload": "yes", 
        "CanStart": "yes", 
        "CanStop": "yes", 
        "CapabilityBoundingSet": "18446744073709551615", 
        "ConditionResult": "yes", 
        "ConditionTimestamp": "Thu 2019-06-20 15:55:13 CST", 
        "ConditionTimestampMonotonic": "753490128", 
        "Conflicts": "shutdown.target", 
        "ControlGroup": "/system.slice/httpd.service", 
        "ControlPID": "0", 
        "DefaultDependencies": "yes", 
        "Delegate": "no", 
        "Description": "The Apache HTTP Server", 
        "DevicePolicy": "auto", 
        "Documentation": "man:httpd(8) man:apachectl(8)", 
        "EnvironmentFile": "/etc/sysconfig/httpd (ignore_errors=no)", 
        "ExecMainCode": "0", 
        "ExecMainExitTimestampMonotonic": "0", 
        "ExecMainPID": "7677", 
        "ExecMainStartTimestamp": "Thu 2019-06-20 15:55:13 CST", 
        "ExecMainStartTimestampMonotonic": "753492286", 
        "ExecMainStatus": "0", 
        "ExecReload": "{ path=/usr/sbin/httpd ; argv[]=/usr/sbin/httpd $OPTIONS -k graceful ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "ExecStart": "{ path=/usr/sbin/httpd ; argv[]=/usr/sbin/httpd $OPTIONS -DFOREGROUND ; ignore_errors=no ; start_time=[Thu 2019-06-20 15:55:13 CST] ; stop_time=[n/a] ; pid=7677 ; code=(null) ; status=0/0 }", 
        "ExecStop": "{ path=/bin/kill ; argv[]=/bin/kill -WINCH ${MAINPID} ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "FailureAction": "none", 
        "FileDescriptorStoreMax": "0", 
        "FragmentPath": "/usr/lib/systemd/system/httpd.service", 
        "GuessMainPID": "yes", 
        "IOScheduling": "0", 
        "Id": "httpd.service", 
        "IgnoreOnIsolate": "no", 
        "IgnoreOnSnapshot": "no", 
        "IgnoreSIGPIPE": "yes", 
        "InactiveEnterTimestampMonotonic": "0", 
        "InactiveExitTimestamp": "Thu 2019-06-20 15:55:13 CST", 
        "InactiveExitTimestampMonotonic": "753492325", 
        "JobTimeoutAction": "none", 
        "JobTimeoutUSec": "0", 
        "KillMode": "control-group", 
        "KillSignal": "18", 
        "LimitAS": "18446744073709551615", 
        "LimitCORE": "18446744073709551615", 
        "LimitCPU": "18446744073709551615", 
        "LimitDATA": "18446744073709551615", 
        "LimitFSIZE": "18446744073709551615", 
        "LimitLOCKS": "18446744073709551615", 
        "LimitMEMLOCK": "65536", 
        "LimitMSGQUEUE": "819200", 
        "LimitNICE": "0", 
        "LimitNOFILE": "4096", 
        "LimitNPROC": "1780", 
        "LimitRSS": "18446744073709551615", 
        "LimitRTPRIO": "0", 
        "LimitRTTIME": "18446744073709551615", 
        "LimitSIGPENDING": "1780", 
        "LimitSTACK": "18446744073709551615", 
        "LoadState": "loaded", 
        "MainPID": "7677", 
        "MemoryAccounting": "no", 
        "MemoryCurrent": "18446744073709551615", 
        "MemoryLimit": "18446744073709551615", 
        "MountFlags": "0", 
        "Names": "httpd.service", 
        "NeedDaemonReload": "no", 
        "Nice": "0", 
        "NoNewPrivileges": "no", 
        "NonBlocking": "no", 
        "NotifyAccess": "main", 
        "OOMScoreAdjust": "0", 
        "OnFailureJobMode": "replace", 
        "PermissionsStartOnly": "no", 
        "PrivateDevices": "no", 
        "PrivateNetwork": "no", 
        "PrivateTmp": "yes", 
        "ProtectHome": "no", 
        "ProtectSystem": "no", 
        "RefuseManualStart": "no", 
        "RefuseManualStop": "no", 
        "RemainAfterExit": "no", 
        "Requires": "basic.target -.mount", 
        "RequiresMountsFor": "/var/tmp", 
        "Restart": "no", 
        "RestartUSec": "100ms", 
        "Result": "success", 
        "RootDirectoryStartOnly": "no", 
        "RuntimeDirectoryMode": "0755", 
        "SameProcessGroup": "no", 
        "SecureBits": "0", 
        "SendSIGHUP": "no", 
        "SendSIGKILL": "yes", 
        "Slice": "system.slice", 
        "StandardError": "inherit", 
        "StandardInput": "null", 
        "StandardOutput": "journal", 
        "StartLimitAction": "none", 
        "StartLimitBurst": "5", 
        "StartLimitInterval": "10000000", 
        "StartupBlockIOWeight": "18446744073709551615", 
        "StartupCPUShares": "18446744073709551615", 
        "StatusErrno": "0", 
        "StatusText": "Total requests: 10; Current requests/sec: 0; Current traffic:   0 B/sec", 
        "StopWhenUnneeded": "no", 
        "SubState": "running", 
        "SyslogLevelPrefix": "yes", 
        "SyslogPriority": "30", 
        "SystemCallErrorNumber": "0", 
        "TTYReset": "no", 
        "TTYVHangup": "no", 
        "TTYVTDisallocate": "no", 
        "TasksAccounting": "no", 
        "TasksCurrent": "18446744073709551615", 
        "TasksMax": "18446744073709551615", 
        "TimeoutStartUSec": "1min 30s", 
        "TimeoutStopUSec": "1min 30s", 
        "TimerSlackNSec": "50000", 
        "Transient": "no", 
        "Type": "notify", 
        "UMask": "0022", 
        "UnitFilePreset": "disabled", 
        "UnitFileState": "disabled", 
        "Wants": "system.slice", 
        "WatchdogTimestamp": "Thu 2019-06-20 15:55:19 CST", 
        "WatchdogTimestampMonotonic": "759887941", 
        "WatchdogUSec": "0"
    }
}
```

### 使用service模块重启httpd并设定开机自启

> 设定httpd，使得其能开机自启

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m service -a "name=httpd state=restarted enabled=yes"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "enabled": true, 
    "name": "httpd", 
    "state": "started", 
    "status": {
        "ActiveEnterTimestampMonotonic": "0", 
        "ActiveExitTimestampMonotonic": "0", 
        "ActiveState": "inactive", 
        "After": "system.slice nss-lookup.target systemd-journald.socket network.target tmp.mount remote-fs.target -.mount basic.target", 
        "AllowIsolate": "no", 
        "AmbientCapabilities": "0", 
        "AssertResult": "no", 
        "AssertTimestampMonotonic": "0", 
        "Before": "shutdown.target", 
        "BlockIOAccounting": "no", 
        "BlockIOWeight": "18446744073709551615", 
        "CPUAccounting": "no", 
        "CPUQuotaPerSecUSec": "infinity", 
        "CPUSchedulingPolicy": "0", 
        "CPUSchedulingPriority": "0", 
        "CPUSchedulingResetOnFork": "no", 
        "CPUShares": "18446744073709551615", 
        "CanIsolate": "no", 
        "CanReload": "yes", 
        "CanStart": "yes", 
        "CanStop": "yes", 
        "CapabilityBoundingSet": "18446744073709551615", 
        "ConditionResult": "no", 
        "ConditionTimestampMonotonic": "0", 
        "Conflicts": "shutdown.target", 
        "ControlPID": "0", 
        "DefaultDependencies": "yes", 
        "Delegate": "no", 
        "Description": "The Apache HTTP Server", 
        "DevicePolicy": "auto", 
        "Documentation": "man:httpd(8) man:apachectl(8)", 
        "EnvironmentFile": "/etc/sysconfig/httpd (ignore_errors=no)", 
        "ExecMainCode": "0", 
        "ExecMainExitTimestampMonotonic": "0", 
        "ExecMainPID": "0", 
        "ExecMainStartTimestampMonotonic": "0", 
        "ExecMainStatus": "0", 
        "ExecReload": "{ path=/usr/sbin/httpd ; argv[]=/usr/sbin/httpd $OPTIONS -k graceful ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "ExecStart": "{ path=/usr/sbin/httpd ; argv[]=/usr/sbin/httpd $OPTIONS -DFOREGROUND ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "ExecStop": "{ path=/bin/kill ; argv[]=/bin/kill -WINCH ${MAINPID} ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }", 
        "FailureAction": "none", 
        "FileDescriptorStoreMax": "0", 
        "FragmentPath": "/usr/lib/systemd/system/httpd.service", 
        "GuessMainPID": "yes", 
        "IOScheduling": "0", 
        "Id": "httpd.service", 
        "IgnoreOnIsolate": "no", 
        "IgnoreOnSnapshot": "no", 
        "IgnoreSIGPIPE": "yes", 
        "InactiveEnterTimestampMonotonic": "0", 
        "InactiveExitTimestampMonotonic": "0", 
        "JobTimeoutAction": "none", 
        "JobTimeoutUSec": "0", 
        "KillMode": "control-group", 
        "KillSignal": "18", 
        "LimitAS": "18446744073709551615", 
        "LimitCORE": "18446744073709551615", 
        "LimitCPU": "18446744073709551615", 
        "LimitDATA": "18446744073709551615", 
        "LimitFSIZE": "18446744073709551615", 
        "LimitLOCKS": "18446744073709551615", 
        "LimitMEMLOCK": "65536", 
        "LimitMSGQUEUE": "819200", 
        "LimitNICE": "0", 
        "LimitNOFILE": "4096", 
        "LimitNPROC": "1780", 
        "LimitRSS": "18446744073709551615", 
        "LimitRTPRIO": "0", 
        "LimitRTTIME": "18446744073709551615", 
        "LimitSIGPENDING": "1780", 
        "LimitSTACK": "18446744073709551615", 
        "LoadState": "loaded", 
        "MainPID": "0", 
        "MemoryAccounting": "no", 
        "MemoryCurrent": "18446744073709551615", 
        "MemoryLimit": "18446744073709551615", 
        "MountFlags": "0", 
        "Names": "httpd.service", 
        "NeedDaemonReload": "no", 
        "Nice": "0", 
        "NoNewPrivileges": "no", 
        "NonBlocking": "no", 
        "NotifyAccess": "main", 
        "OOMScoreAdjust": "0", 
        "OnFailureJobMode": "replace", 
        "PermissionsStartOnly": "no", 
        "PrivateDevices": "no", 
        "PrivateNetwork": "no", 
        "PrivateTmp": "yes", 
        "ProtectHome": "no", 
        "ProtectSystem": "no", 
        "RefuseManualStart": "no", 
        "RefuseManualStop": "no", 
        "RemainAfterExit": "no", 
        "Requires": "basic.target -.mount", 
        "RequiresMountsFor": "/var/tmp", 
        "Restart": "no", 
        "RestartUSec": "100ms", 
        "Result": "success", 
        "RootDirectoryStartOnly": "no", 
        "RuntimeDirectoryMode": "0755", 
        "SameProcessGroup": "no", 
        "SecureBits": "0", 
        "SendSIGHUP": "no", 
        "SendSIGKILL": "yes", 
        "Slice": "system.slice", 
        "StandardError": "inherit", 
        "StandardInput": "null", 
        "StandardOutput": "journal", 
        "StartLimitAction": "none", 
        "StartLimitBurst": "5", 
        "StartLimitInterval": "10000000", 
        "StartupBlockIOWeight": "18446744073709551615", 
        "StartupCPUShares": "18446744073709551615", 
        "StatusErrno": "0", 
        "StopWhenUnneeded": "no", 
        "SubState": "dead", 
        "SyslogLevelPrefix": "yes", 
        "SyslogPriority": "30", 
        "SystemCallErrorNumber": "0", 
        "TTYReset": "no", 
        "TTYVHangup": "no", 
        "TTYVTDisallocate": "no", 
        "TasksAccounting": "no", 
        "TasksCurrent": "18446744073709551615", 
        "TasksMax": "18446744073709551615", 
        "TimeoutStartUSec": "1min 30s", 
        "TimeoutStopUSec": "1min 30s", 
        "TimerSlackNSec": "50000", 
        "Transient": "no", 
        "Type": "notify", 
        "UMask": "0022", 
        "UnitFilePreset": "disabled", 
        "UnitFileState": "disabled", 
        "Wants": "system.slice", 
        "WatchdogTimestampMonotonic": "0", 
        "WatchdogUSec": "0"
    }
}
```

### 使用yum模块删除httpd

> 可以看出其能正常remove httpd-2.4.6-40.el7.centos.4.x86_64

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "rpm -qa|grep httpd"
 [WARNING]: Consider using yum, dnf or zypper module rather than running rpm

192.168.78.130 | SUCCESS | rc=0 >>
httpd-2.4.6-89.el7.centos.x86_64
httpd-tools-2.4.6-89.el7.centos.x86_64
```

> 删除httpd

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m yum -a "name=httpd state=absent"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "msg": "", 
    "rc": 0, 
    "results": [
        "Loaded plugins: fastestmirror\nResolving Dependencies\n--> Running transaction check\n---> Package httpd.x86_64 0:2.4.6-89.el7.centos will be erased\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package      Arch          Version                       Repository       Size\n================================================================================\nRemoving:\n httpd        x86_64        2.4.6-89.el7.centos           @updates        9.4 M\n\nTransaction Summary\n================================================================================\nRemove  1 Package\n\nInstalled size: 9.4 M\nDownloading packages:\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Erasing    : httpd-2.4.6-89.el7.centos.x86_64                             1/1 \n  Verifying  : httpd-2.4.6-89.el7.centos.x86_64                             1/1 \n\nRemoved:\n  httpd.x86_64 0:2.4.6-89.el7.centos                                            \n\nComplete!\n"
    ]
}
```

## 10. 模块： script

> 知识点：使用script模块可以实现到对象节点上执行本机脚本。有点类似copy+shell+删除copy的脚本的这样一个综合的功能。

### 准备

> 为了更好地确认其功能，在ansible的控制节点和对象节点上的同样目录放置同样名称内容不同的文件，确认其
>
> * 能否正常动作
> * 动作后是否能保证对象节点不受影响

```bash
[root@centos7 ~]# ls -ltr /tmp
total 4
-rwxr-xr-x. 1 root root 71 Jun 21 08:59 hello.sh
[root@centos7 ~]# /tmp/hello.sh 
this is test, from ansible manager, 192.168.78.12
```

### 使用script模块到对象节点上执行本地脚本

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m script -a /tmp/hello.sh
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "rc": 0, 
    "stderr": "Shared connection to 192.168.78.130 closed.\r\n", 
    "stdout": "this is test, from ansible manager, 192.168.78.128\r\n", 
    "stdout_lines": [
        "this is test, from ansible manager, 192.168.78.128"
    ]
}
```

### 执行后确认

```bash
[root@centos7 ~]# /tmp/hello.sh 
this is test, from ansible manager, 192.168.78.128
[root@centos7 ~]# ssh 192.168.78.130 /tmp/hello.sh  -> 目标机上源文件未发生变化
hello world
test ansible copy force
test ansible copy backup
```

## 11.模块：get_url/cron/synchronize

> 知识点：cron模块用于管理对象节点cron任务 
> 知识点：get_url模块类似于wget和curl的功能，可以进行下载以及webapi交互等操作 
> 知识点：synchronize模块使用rsync用于控制节点和管理对象节点之间的内容同步操作。

### cron

> 事前对象节点cron信息确认

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "crontab -l"
192.168.78.130 | FAILED | rc=1 >>
no crontab for rootnon-zero return code
```

#### 添加任务

> 利用cron模块向对象节点添加一个叫做sayhellojob的一个无聊job，此job每2分钟说一次hello

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m cron -a 'name=hellojob minute=*/2 hour=* day=* month=* weekday=* job="echo hello `date` >> /tmp/crontab.log"'
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "envs": [], 
    "jobs": [
        "hellojob"
    ]
}
```

> 事后对象节点的crontab内容

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "crontab -l"
192.168.78.130 | SUCCESS | rc=0 >>
#Ansible: hellojob
*/2 * * * * echo hello `date` >> /tmp/crontab.log
```

> 事后输出log的确认

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "cat /tmp/crontab.log"
192.168.78.130 | SUCCESS | rc=0 >>
hello Fri Jun 21 09:18:01 CST 2019
hello Fri Jun 21 09:20:01 CST 2019
```

#### 删除任务

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m cron -a 'name=hellojob minute=*/2 hour=* day=* month=* weekday=* job="echo hello `date` >> /tmp/crontab.log" state=absent'
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "envs": [], 
    "jobs": []
}
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "crontab -l"
192.168.78.130 | SUCCESS | rc=0 >>
```

### get_url

> 使用get_url下载baidu的index

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m get_url -a "url='http://www.baidu.com' dest=/tmp"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "checksum_dest": null, 
    "checksum_src": "52977040463a10a42a20b930336d2e8fb5eabf81", 
    "dest": "/tmp/index.html", 
    "gid": 0, 
    "group": "root", 
    "md5sum": "4881e6e81dbed6b9f1b3224b4ecca0a7", 
    "mode": "0644", 
    "msg": "OK (unknown bytes)", 
    "owner": "root", 
    "secontext": "unconfined_u:object_r:user_tmp_t:s0", 
    "size": 153711, 
    "src": "/tmp/tmpJxzNth", 
    "state": "file", 
    "status_code": 200, 
    "uid": 0, 
    "url": "http://www.baidu.com"
}
```

> 内容确认

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "ls -ltr /tmp"
192.168.78.130 | SUCCESS | rc=0 >>
total 176
-rw-r--r--. 1 root   root       12 Jun 20 10:32 helloworld
-rwxr-xr-x. 1 root   root       19 Jun 20 11:23 test.sh
-rwxr-x---. 1 root   root       62 Jun 20 14:30 hello.sh.9123.2019-06-20@14:39:33~
-rwxrwxrwx. 1 chensj chensj     94 Jun 20 14:39 hello.sh
-rw-------. 1 root   root     1494 Jun 20 15:39 yum_save_tx.2019-06-20.15-39.bImwfH.yumtx
drwx------. 2 root   root       65 Jun 21 09:19 ansible_PyhaIi
-rw-r--r--. 1 root   root      105 Jun 21 09:22 crontab.log
-rw-r--r--. 1 root   root   153711 Jun 21 09:25 index.html
drwx------. 2 root   root       65 Jun 21 09:26 ansible_ocuuFq
```

### synchronize

> 同步内容准备和确认

#### 准备

```bash
[root@centos7 ~]# mkdir -p /tmp/tst-syn /tmp/tst-syn/src /tmp/tst-syn/target /tmp/tst-syn/target/bin
[root@centos7 ~]# echo "hello" > /tmp/tst-syn/target/bin/hello
[root@centos7 ~]# ssh 192.168.78.130 ls -l /opt
total 48
drwxr-xr-x. 2 root root    95 May 28 13:47 apollo
-rw-r--r--. 1 root root 21509 May 27 13:11 apolloconfigdb.sql
-rw-r--r--. 1 root root 17270 May 27 13:11 apolloportaldb.sql
drwxr-xr-x. 3 root root    34 May 27 13:09 git
drwxr-xr-x. 2 root root  4096 May 25 00:25 mysql
drwxr-xr-x. 3 root root    51 May 25 00:36 redis
drwxr-xr-x. 2 root root     6 May 27 15:00 zipkin
```

#### 操作

> 将此目录结构完整同步到对象机器的/opt下

```bash
[root@centos7 ~]# ansible 192.168.78.130 -m synchronize -a "src=/tmp/tst-syn dest=/opt/dst-syn"
192.168.78.130 | SUCCESS => {
    "changed": true, 
    "cmd": "/usr/bin/rsync --delay-updates -F --compress --archive --rsh=/usr/bin/ssh -S none -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null --out-format=<<CHANGED>>%i %n%L /tmp/tst-syn 192.168.78.130:/opt/dst-syn", 
    "msg": "cd+++++++++ tst-syn/\ncd+++++++++ tst-syn/src/\ncd+++++++++ tst-syn/target/\ncd+++++++++ tst-syn/target/bin/\n<f+++++++++ tst-syn/target/bin/hello\n", 
    "rc": 0, 
    "stdout_lines": [
        "cd+++++++++ tst-syn/", 
        "cd+++++++++ tst-syn/src/", 
        "cd+++++++++ tst-syn/target/", 
        "cd+++++++++ tst-syn/target/bin/", 
        "<f+++++++++ tst-syn/target/bin/hello"
    ]
}
[root@centos7 ~]# ansible 192.168.78.130 -m shell -a "ls -ltr /opt/dst-syn"
192.168.78.130 | SUCCESS | rc=0 >>
total 0
drwxr-xr-x. 4 root root 31 Jun 21 09:29 tst-syn
```

> 报错： 
>
> ansible 192.168.78.130 -m synchronize -a "src=/tmp/tst-syn dest=/opt/dst-syn"
> 192.168.78.130 | FAILED! => {
>     "changed": false, 
>     "msg": "Failed to find required executable rsync in paths: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/sbin"
> }
>
> 处理：
>
>  yum install -y rsync

## 12. 模块：Docker

> 知识点：ansible使用docker可以对其进行管理。基本接近docker-compose对docker的使用支持，非常接近。诸如从port的设定到volume_from都支持，但是需要docker-py0.3.0 以上的支持。

### 准备

> 需要使用docker的module的管理对象节点需要满足如下前提

| Package       | 所需版本    |
| ------------- | ----------- |
| python        | 2.6 以上    |
| docker-py     | 0.3.0 以上  |
| docker server | 0.10.0 以上 |

### 安装docker-py

> 一般python等基本上无需意识，一般安装了docker-py本模块就能支持。

```bash
[root@centos7 ~]# yum -y install epel-release
[root@centos7 ~]# yum install -y python-pip
[root@centos7 ~]# pip -V
	pip 8.1.2 from /usr/lib/python2.7/site-packages (python 2.7)

```

## 13. playbook

### 常规使用

#### 准备

```yaml
- hosts: 192.168.78.130
  tasks:
    - name:  say hello task
      shell: echo hello world `date` by `hostname` >/tmp/hello.log

```

#### 运行

```bash
[root@centos7 playbook]# ansible-playbook hello.playbook
```

### 指定目录

```bash
[root@centos7 playbook]# ansible-playbook /opt/playbook/hello.playbook
```

### 指定目录与主机

#### playbook

```yaml
- hosts: "{{host}}"
  tasks:
    - name:  say hello task
      shell: echo hello world `date` by `hostname` >/tmp/hello.log
```

#### 运行

```bash
[root@centos7 playbook]# ansible-playbook /opt/playbook/hello.playbook -e "host=192.168.78.130"
```

