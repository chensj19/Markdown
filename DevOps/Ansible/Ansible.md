

# Ansible

## 一、Ansible 的命名由来？

此名取自 Ansible 作者最喜爱的《[安德的游戏](https://zh.wikipedia.org/zh-tw/安德的游戏)》小说，而这部小说更被后人改编成电影 －《[战争游戏](https://www.w3cschool.cn/automate_with_ansible/automate_with_ansible-atvo27or.html#fn_2)》。

大家或许早在电影中就已看过[**安塞波 (Ansible)**](http://enderverse.wikia.com/wiki/Ansible)，它是虚构的超光速通讯装置。片中主角安德 (Ender) 和他的伙伴们透过 Ansible 跨越时空指挥无数的战舰，就好比我们操控海量的远端服务器一样。

Ansible 是一个模型驱动的配置管理器，支持多节点发布、远程任务执行。默认使用 SSH 进行远程连接。无需在被管理节点上安装附加软件，可使用各种编程语言进行扩展。

**Ansible** 简单的说是一个配置管理系统(configuration management system)。你只需要可以使用 ssh 访问你的服务器或设备就行。它也不同于其他工具，因为它使用推送的方式，而不是像 puppet 等 那样使用拉取安装agent的方式。你可以将代码部署到任意数量的服务器上!

### 1.1 Ansible能做什么

```
ansible可以帮助我们完成一些批量任务，或者完成一些需要经常重复的工作。
比如：同时在100台服务器上安装nginx服务，并在安装后启动它们。
比如：将某个文件一次性拷贝到100台服务器上。
比如：每当有新服务器加入工作环境时，你都要为新服务器部署某个服务，也就是说你需要经常重复的完成相同的工作。
这些场景中我们都可以使用到ansible。
```

### 1.2 Ansible特性

```
 模块化：调用特定的模块，完成特定任务
 有Paramiko，PyYAML，Jinja2（模板语言）三个关键模块
 支持自定义模块
 基于Python语言实现
 部署简单，基于python和SSH(默认已安装)，agentless
 安全，基于OpenSSH
 支持playbook编排任务
 幂等性：一个任务执行1遍和执行n遍效果一样，不因重复执行带来意外情况
 无需代理不依赖PKI（无需ssl）
 可使用任何编程语言写模块
 YAML格式，编排任务，支持丰富的数据结构
 较强大的多层解决方案
```

## 二、Ansible架构

![Ansible架构](https://s1.51cto.com/images/blog/201801/29/649aecb333d17a6fca2f1313dc101f12.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

上图为ansible的基本架构，从上图可以了解到其由以下部分组成：

- 核心：ansible
- 核心模块（Core Modules）：这些都是ansible自带的模块
- 扩展模块（Custom Modules）：如果核心模块不足以完成某种功能，可以添加扩展模块
- 插件（Plugins）：完成模块功能的补充
- 剧本（Playbooks）：ansible的任务配置文件，将多个任务定义在剧本中，由ansible自动执行
- 连接插件（Connectior Plugins）：ansible基于连接插件连接到各个主机上，虽然ansible是使用ssh连接到各个主机的，但是它还支持其他的连接方法，所以需要有连接插件
- 主机群（Host Inventory）：定义ansible管理的主机

## 三、Ansible工作原理

![](https://s1.51cto.com/images/blog/201801/29/4a8a67bdf9ff0c353b14d7e729902191.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

### 3.1 Ansible主要组成部分功能说明

```
 PLAYBOOKS： 任务剧本（任务集），编排定义Ansible任务集的配置文件，由Ansible顺序依次执行，通常是JSON格式的YML文件
 INVENTORY： Ansible管理主机的清单/etc/anaible/hosts
 MODULES：   Ansible执行命令的功能模块，多数为内置的核心模块，也可自定义,ansible-doc –l 可查看模块
 PLUGINS：   模块功能的补充，如连接类型插件、循环插件、变量插件、过滤插件等，该功能不常用
 API：       供第三方程序调用的应用程序编程接口
 ANSIBLE：   组合INVENTORY、 API、 MODULES、PLUGINS的绿框，可以理解为是ansible命令工具，其为核心执行工具
```

**注意事项**

```
 执行ansible的主机一般称为主控端，中控，master或堡垒机
 主控端Python版本需要2.6或以上
 被控端Python版本小于2.4需要安装python-simplejson
 被控端如开启SELinux需要安装libselinux-python
 windows不能做为主控端
```

## 四、Ansible安装

安装方法有很多，这里仅仅以Centos yum安装为例。

Ansible默认不在标准仓库中，需要用到EPEL源。

```
请自行参考
https://mirrors.aliyun.com/help/centos
#yum install ansible
```

![](https://s1.51cto.com/images/blog/201801/29/9fb261d9e1df0ffcec0f74a9315f9481.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_100,g_se,x_10,y_10,shadow_90,type_ZmFuZ3poZW5naGVpdGk=)

```bash
# ansible --version
ansible 2.4.2.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Oct 30 2018, 23:45:53) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]

```

##  五、Ansible 功能详解

### 5.1 配置文件

| 配置文件或指令            | 描述                                   |
| ------------------------- | -------------------------------------- |
| /etc/ansible/ansible.cfg  | 主配置文件，配置ansible工作特性        |
| /etc/ansible/hosts        | 主机清单                               |
| /etc/ansible/roles/       | 存放角色的目录                         |
| /usr/bin/ansible          | 主程序，临时命令执行工具               |
| /usr/bin/ansible-doc      | 查看配置文档，模块功能查看工具         |
| /usr/bin/ansible-galaxy   | 下载/上传优秀代码或Roles模块的官网平台 |
| /usr/bin/ansible-playbook | 定制自动化任务，编排剧本工具           |
| /usr/bin/ansible-pull     | 远程执行命令的工具                     |
| /usr/bin/ansible-vault    | 文件加密工具                           |
| /usr/bin/ansible-console  | 基于Console界面与用户交互的执行工具    |

### 5.2 Ansible 配置文件

```
Ansible 配置文件/etc/ansible/ansible.cfg （一般保持默认）
 [defaults]
 #inventory = /etc/ansible/hosts # 主机列表配置文件
 #library = /usr/share/my_modules/ # 库文件存放目录
 #remote_tmp = $HOME/.ansible/tmp #临时py命令文件存放在远程主机目录
 #local_tmp = $HOME/.ansible/tmp # 本机的临时命令执行目录
 #forks = 5 # 默认并发数
 #sudo_user = root # 默认sudo 用户
 #ask_sudo_pass = True #每次执行ansible命令是否询问ssh密码
 #ask_pass = True      #连接时提示输入ssh密码
 #remote_port = 22     #远程主机的默认端口，生产中这个端口应该会不同
 #log_path = /var/log/ansible.log #日志
 #host_key_checking = False # 检查对应服务器的host_key，建议取消注释。也就是不会弹出
                                Are you sure you want to continue connecting (yes/no)
```

## 六、学习Ansible

| 主机名                   | 系统版本        | IP地址         | 功能          |
| ------------------------ | --------------- | -------------- | ------------- |
| centos7.ansiable.manager | Centos 7.6.1810 | 192.168.31.186 | Ansible主控端 |
| centos7.web.master       | Centos 7.6.1810 | 192.168.31.187 | web.master    |
| centos7.web.node1        | Centos 7.6.1810 | 192.168.31.188 | web.node1     |
| centos7.web.node2        | Centos 7.6.1810 | 192.168.31.189 | web.node2     |
| centos7.db.node          | Centos 7.6.1810 | 192.168.31.190 | db.node       |

### 6.1生成ssh私钥生成并复制

```bash
# 生成秘钥
$ ssh-keygen -t rsa
# 同步到各个主机
$ ssh-copy-id -i ~/.ssh/id_rsa  192.168.31.187
$ ssh-copy-id -i ~/.ssh/id_rsa  192.168.31.188
$ ssh-copy-id -i ~/.ssh/id_rsa  192.168.31.189
$ ssh-copy-id -i ~/.ssh/id_rsa  192.168.31.190
```

注意同步过程需要输入yes和各自的root密码即可;此进可直接ssh root@192.168.31.187 就无密码登录上去啦!
配置ansible的主机清单,即把准备的主机信息添加到管理清单中

```bash
$ vim /etc/ansible/hosts
```

```
[webservers]
192.168.31.187
192.168.31.188
192.168.31.189
[dbservers]
192.168.31.190
```

到此处配置的环境完成!

## 七、Ansible常用模块

### **7.1、copy模块**

从本地copy文件分发到目录主机路径 
参数说明:
src= 源文件路径
dest= 目标路径 
注意src= 路径后面带/ 表示带里面的所有内容复制到目标目录下，不带/是目录递归复制过去
content= 自行填充的文件内容
owner 属主
group 属组
mode权限
示例:

```bash
ansible all  -m copy -a "src=/etc/fstab dest=/tmp/fstab.ansible mode=600"
ansible all -m copy -a "content='hi there\n' dest=/tmp/hi.txt"
到node1上查看
[root@node1 tmp]# ll
-rw------- 1 root root 465 2月   9 14:59 fstab.ansible
-rw-r--r-- 1 root root   9 2月   9 14:58 hi.txt
```

### **7.2、fetch模块**

从远程主机拉取文件到本地
示例

```
[root@ansible ~]# ansible all  -m fetch -a "src=/tmp/hi.txt dest=/tmp"
172.16.3.152 | SUCCESS => {
    "changed": true, 
    "checksum": "279d9035886d4c0427549863c4c2101e4a63e041", 
    "dest": "/tmp/172.16.3.152/tmp/hi.txt", 
    "md5sum": "12f6bb1941df66b8f138a446d4e8670c", 
    "remote_checksum": "279d9035886d4c0427549863c4c2101e4a63e041", 
    "remote_md5sum": null
}
.......省略
```

说明:fetch使用很简单,src和dest,dest只要指定一个接收目录,默认会在后面加上远程主机及src的路径

### **7.3、command模块**

在远程主机上执行命令,属于裸执行,非键值对显示;不进行shell解析;
示例1:

```
[root@ansible ~]# ansible all -m command -a "ifconfig"
172.16.3.152 | SUCCESS | rc=0 >>
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.16.3.152  netmask 255.255.255.0  broadcast 172.16.3.255
        .....省略.....
172.16.3.216 | SUCCESS | rc=0 >>
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.16.3.216  netmask 255.255.255.0  broadcast 172.16.3.255
        .....省略.....
```

示例2:

```
[root@ansible ~]# ansible all -m command -a "ifconfig|grep lo"
172.16.3.152 | FAILED | rc=2 >>
[Errno 2] 没有那个文件或目录

172.16.3.216 | FAILED | rc=2 >>
[Errno 2] 没有那个文件或目录
```

这就是因为command模块不是shell解析属于裸执行导致的
为了能达成以上类似shell中的解析,ansible有一个shell模块;

### **7.4、shell模块**

由于commnad只能执行裸命令(即系统环境中有支持的命令),至于管道之类的功能不支持,
shell模块可以做到
示例:

```
[root@ansible ~]# ansible all -m shell -a "ifconfig|grep lo"
172.16.3.152 | SUCCESS | rc=0 >>
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        loop  txqueuelen 0  (Local Loopback)

172.16.3.216 | SUCCESS | rc=0 >>
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        loop  txqueuelen 0  (Local Loopback)
```

### **7.5、file模块**

设置文件属性(创建文件)
常用参数:
path目标路径
state directory为目录,link为软件链接
group 目录属组
owner 属主
等,其他参数通过ansible-doc -s file 获取
示例1:创建目录

```
[root@ansible ~]# ansible all -m file -a "path=/var/tmp/hello.dir state=directory"
172.16.3.152 | SUCCESS => {
    "changed": true, 
    "gid": 0, 
    "group": "root", 
    "mode": "0755", 
    "owner": "root", 
    "path": "/var/tmp/hello.dir", 
    "size": 6, 
    "state": "directory", 
    "uid": 0
}
172.16.3.216 | SUCCESS => {
    "changed": true, 
     .....省略.....
```

示例2:创建软件链接

```
[root@ansible ~]# ansible all -m file -a "src=/tmp/hi.txt path=/var/tmp/hi.link state=link"
172.16.3.152 | SUCCESS => {
    "changed": true, 
    "dest": "/var/tmp/hi.link", 
    "gid": 0, 
    "group": "root", 
    "mode": "0777", 
    "owner": "root", 
    "size": 11, 
    "src": "/tmp/hi.txt", 
    "state": "link", 
    "uid": 0
}
172.16.3.216 | SUCCESS => {
    "changed": true, 
     .....省略.....
```

### **7.6、cron模块**

通过cron模块对目标主机生成计划任务
常用参数:
除了分(minute)时(hour)日(day)月(month)周(week)外
name: 本次计划任务的名称
state: present 生成(默认) |absent 删除 (基于name)

示例:对各主机添加每隔3分钟从time.windows.com同步时间

```
[root@ansible ~]# ansible all -m cron -a "minute=*/3 job='/usr/sbin/update time.windows.com &>/dev/null'  name=update_time"
172.16.3.152 | SUCCESS => {
    "changed": true, 
    "envs": [], 
    "jobs": [
        "update_time"
    ]
}
172.16.3.216 | SUCCESS => {
    "changed": true, 
    "envs": [], 
    "jobs": [
        "update_time"
    ]
}

#到node1上查看
[root@node1 tmp]# crontab -l
#Ansible: update_time
*/3 * * * * /usr/sbin/update time.windows.com &>/dev/null
```

示例2:删除计划任务

```
[root@ansible ~]# ansible all -m cron -a "name=update_time state=absent"
172.16.3.152 | SUCCESS => {
    "changed": true, 
    "envs": [], 
    "jobs": []
}
172.16.3.216 | SUCCESS => {
    "changed": true, 
    "envs": [], 
    "jobs": []
}
#node1上查看
[root@node1 tmp]# crontab -l
会发现已经被删除了
```

### **7.7、yum模块**

故名思义就是yum安装软件包的模块;
常用参数说明:
enablerepo,disablerepo表示启用与禁用某repo库
name 安装包名
state (`present' or`installed', `latest')表示安装, (`absent' or `removed') 表示删除
示例:通过安装epel扩展源并安装nginx

```
[root@ansible ~]# ansible all -m yum -a "name=epel-release state=installed"
[root@ansible ~]# ansible all -m yum -a "name=nginx state=installed"
```

### **7.8、service模块**

服务管理模块
常用参数:
name:服务名
state:服务状态
enabled: 是否开机启动 true|false
runlevel: 启动级别 (systemed方式忽略)

示例:

```
[root@ansible ~]# ansible all -m service -a "name=nginx state=started enabled=true"
到node1上查看
[root@node1 tmp]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since 五 2018-02-09 15:54:29 CST; 1min 49s ago
 Main PID: 10462 (nginx)
   CGroup: /system.slice/nginx.service
           ├─10462 nginx: master process /usr/sbin/nginx
           └─10463 nginx: worker process
......省略......
```

### **7.9、script模块**

把本地的脚本传到远端执行;前提是到远端可以执行,不要把Linux下的脚本同步到windows下执行;
直接上示例:
本地ansible上的脚本:

```
[root@ansible ~]# cat test.sh 
#!/bin/bash
echo "ansible script test!" > /tmp/ansible.txt
[root@ansible ~]# ansible all -m script -a "/root/test.sh"
172.16.3.152 | SUCCESS => {
    "changed": true, 
    "rc": 0, 
    "stderr": "Shared connection to 172.16.3.152 closed.\r\n", 
    "stdout": "", 
    "stdout_lines": []
}
172.16.3.216 | SUCCESS => {
    "changed": true, 
    "rc": 0, 
    "stderr": "Shared connection to 172.16.3.216 closed.\r\n", 
    "stdout": "", 
    "stdout_lines": []
}
到node1上查看
[root@node1 tmp]# ls
ansible.txt  fstab.ansible  hi.txt 
[root@node1 tmp]# cat ansible.txt
ansible script test!
```

script模块这个功能可以做很多事,就看你怎么用了~
以上是常用模块,至于其他模块的使用可通过[官方模块列表](http://docs.ansible.com/ansible/latest/list_of_all_modules.html)获得~

## 八、Playbook实战

playbook是Ansible的配置，部署和编排的语言。他们可以描述你所希望的远程系统强制执行的政策，或者在一般的IT流程的一组步骤;形象点的说就是:如果ansible的各模块(能实现各种功能)是车间里的各工具;playbook就是指导手册,目标远程主机就是库存和原料对象.
playbook是基于YAML语言格式配置,关于[YAML](https://zh.wikipedia.org/wiki/YAML)
更多playbook[官方说明参考](http://docs.ansible.com/ansible/latest/playbooks_intro.html)

**1、playbook的核心元素**
hosts : playbook配置文件作用的主机
tasks: 任务列表
variables: 变量 
templates:包含模板语法的文本文件
handlers :由特定条件触发的任务
roles :用于层次性、结构化地组织playbook。roles 能够根据层次型结构自动装载变量文件、tasks以及handlers等

**2、playbook运行方式**
ansible-playbook --check 只检测可能会发生的改变,但不真执行操作
ansible-playbook --list-hosts 列出运行任务的主机
ansible-playbook --syntax-check playbook.yaml 语法检测
ansible-playbook -t TAGS_NAME playbook.yaml 只执行TAGS_NAME任务
ansible-playbook playbook.yaml 运行

**3、通过playbook安装管理redis服务**

* 创建`yaml`文件

    ```bash
    #在家目录下创建playbooks
    [root@ansible ~]# mkidr playbooks
    [root@ansible ~]# cd playbooks
    [root@ansible playbooks]# cat redis_first.yaml
    - hosts: 192.168.31.188,192.168.31.187
      remote_user: root
      vars:
        redis_data_dir: /home/work/redis/data
        var_dir: /home/work/redis
        unarch: /home/work
        redis_dir: /home/work/redis-4.0.13
      tasks:
        - name: 创建redis数据目录
          file: path={{ redis_data_dir }} state=directory
    
        - name: 复制redis包到远程主机
          copy: src=./file/redis-4.0.13.tar.gz dest=/tmp
    
        - name: 解压包
          unarchive:
            src: /tmp/redis-4.0.13.tar.gz
            dest: "{{ unarch }}"
            copy: no
    
        - name: 安装
          shell: cd {{ unarch }}/redis-4.0.13 && make
    
        - name: 创建二进制目录配置文件目录
          shell: cd {{ var_dir }} && mkdir -pv bin conf
    
        - name: cp 编译完成的二进制文件到bin和conf下配置文件
          shell: cp {{ redis_dir }}/src/redis-* {{ var_dir }}/bin && rm -rf {{ var_dir }}/bin/*.c && rm -rf {{ var_dir }}/bin/*.o
    
        - name: 拷贝编译完成的redis.conf文件到conf下
          template: src=./file/redis.conf.j2 dest={{ var_dir }}/conf/redis.conf
    
        - name: 启动redis
          shell: "{{ var_dir }}/bin/redis-server {{ var_dir }}/conf/redis.conf"
    
        - name: 删除redis解压包
          file: path={{ redis_dir }} state=absent
    ```

* 语法检测:

    ```bash
    [root@centos7 playbooks]# ansible-playbook --syntax-check redis_first.yaml

    playbook: redis_first.yaml
    ```
    
    说明语法没有问题
    
* 执行

    ```bash
    [root@centos7 playbooks]# ansible-playbook redis_first.yaml
    
    PLAY [192.168.31.187,192.168.31.188] ***************************************************************
    
    TASK [Gathering Facts] *****************************************************************************
    ok: [192.168.31.188]
    ok: [192.168.31.187]
    
    TASK [install redis] *******************************************************************************
    fatal: [192.168.31.188]: FAILED! => {"changed": false, "msg": "No package matching 'redis' found available, installed or updated", "rc": 126, "results": ["No package matching 'redis' found available, installedor updated"]}
    fatal: [192.168.31.187]: FAILED! => {"changed": false, "msg": "No package matching 'redis' found available, installed or updated", "rc": 126, "results": ["No package matching 'redis' found available, installedor updated"]}
    	to retry, use: --limit @/root/playbooks/redis_first.retry
    
    PLAY RECAP *****************************************************************************************
    192.168.31.187             : ok=1    changed=0    unreachable=0    failed=1
    192.168.31.188             : ok=1    changed=0    unreachable=0    failed=1
    
    ```

    































## 七、Inventory 主机清单

Ansible必须通过Inventory 来管理主机。Ansible 可同时操作属于一个组的多台主机,组和主机之间的关系通过 inventory 文件配置。

**语法格式：**

```
单台主机
green.example.com    >   FQDN
192.168.100.10       >   IP地址
192.168.100.11:2222  >   非标准SSH端口

[webservers]         >   定义了一个组名     
alpha.example.org    >   组内的单台主机
192.168.100.10 

[dbservers]
192.168.100.10       >   一台主机可以是不同的组，这台主机同时属于[webservers] 

[group:children]     >  组嵌套组，group为自定义的组名，children是关键字，固定语法，必须填写。
dns                  >  group组内包含的其他组名
db                   >  group组内包含的其他组名

[webservers] 
www[001:006].hunk.tech > 有规律的名称列表，
这里表示相当于：
www001.hunk.tech
www002.hunk.tech
www003.hunk.tech
www004.hunk.tech
www005.hunk.tech
www006.hunk.tech

[databases]
db-[a:e].example.com   >   定义字母范围的简写模式,
这里表示相当于：
db-a.example.com
db-b.example.com
db-c.example.com
db-d.example.com
db-e.example.com

以下这2条定义了一台主机的连接方式，而不是读取默认的配置设定
localhost       ansible_connection=local
www.163.com     ansible_connection=ssh        ansible_ssh_user=hunk

最后还有一个隐藏的分组，那就是all，代表全部主机,这个是隐式的，不需要写出来的。
```

### 7.1 Inventory 参数说明

```
ansible_ssh_host
      将要连接的远程主机名.与你想要设定的主机的别名不同的话,可通过此变量设置.

ansible_ssh_port
      ssh端口号.如果不是默认的端口号,通过此变量设置.这种可以使用 ip:端口 192.168.1.100:2222

ansible_ssh_user
      默认的 ssh 用户名

ansible_ssh_pass
      ssh 密码(这种方式并不安全,我们强烈建议使用 --ask-pass 或 SSH 密钥)

ansible_sudo_pass
      sudo 密码(这种方式并不安全,我们强烈建议使用 --ask-sudo-pass)

ansible_sudo_exe (new in version 1.8)
      sudo 命令路径(适用于1.8及以上版本)

ansible_connection
      与主机的连接类型.比如:local, ssh 或者 paramiko. Ansible 1.2 以前默认使用 paramiko.1.2 以后默认使用 'smart','smart' 方式会根据是否支持 ControlPersist, 来判断'ssh' 方式是否可行.

ansible_ssh_private_key_file
      ssh 使用的私钥文件.适用于有多个密钥,而你不想使用 SSH 代理的情况.

ansible_shell_type
      目标系统的shell类型.默认情况下,命令的执行使用 'sh' 语法,可设置为 'csh' 或 'fish'.

ansible_python_interpreter
      目标主机的 python 路径.适用于的情况: 系统中有多个 Python, 或者命令路径不是"/usr/bin/python",比如  \*BSD, 或者 /usr/bin/python 不是 2.X 版本的 Python.
      我们不使用 "/usr/bin/env" 机制,因为这要求远程用户的路径设置正确,且要求 "python" 可执行程序名不可为 python以外的名字(实际有可能名为python26).

      与 ansible_python_interpreter 的工作方式相同,可设定如 ruby 或 perl 的路径....
```

上面的参数用这几个例子来展示可能会更加直观

```
some_host         ansible_ssh_port=2222     ansible_ssh_user=manager
aws_host          ansible_ssh_private_key_file=/home/example/.ssh/aws.pem
freebsd_host      ansible_python_interpreter=/usr/local/bin/python
ruby_module_host  ansible_ruby_interpreter=/usr/bin/ruby.1.9.3
```















## 五、Ansible的七个命令

安装完ansible后，发现ansible一共为我们提供了七个指令：ansible、ansible-doc、ansible-galaxy、ansible-lint、ansible-playbook、ansible-pull、ansible-vault 。这里我们只查看usage部分，详细部分可以通过 "指令 -h"  的方式获取。

### **1、ansible**

```
1.[root@localhost ~]# ansible -h
2.Usage: ansible  [options]
```

ansible是指令核心部分，其主要用于执行ad-hoc命令，即单条命令。默认后面需要跟主机和选项部分，默认不指定模块时，使用的是command模块。如：

```
1.[root@361way.com ~]# ansible 192.168.0.102 -a 'date'
2192.168.0.102 | success | rc=0 >>
3Tue May 12 22:57:24 CST 2015
```

不过默认使用的模块是可以在ansible.cfg 中进行修改的。ansible命令下的参数部分解释如下：

1. 参数：
2. -a 'Arguments', --args='Arguments' 命令行参数
3. -m NAME, --module-name=NAME 执行模块的名字，默认使用 command 模块，所以如果是只执行单一命令可以不用 -m参数
4. -i PATH, --inventory=PATH 指定库存主机文件的路径,默认为/etc/ansible/hosts.
5. -u Username， --user=Username 执行用户，使用这个远程用户名而不是当前用户
6. -U --sud-user=SUDO_User sudo到哪个用户，默认为 root
7. -k --ask-pass 登录密码，提示输入SSH密码而不是假设基于密钥的验证
8. -K --ask-sudo-pass 提示密码使用sudo
9. -s --sudo sudo运行
10. -S --su 用 su 命令
11. -l --list 显示所支持的所有模块
12. -s --snippet 指定模块显示剧本片段
13. -f --forks=NUM 并行任务数。NUM被指定为一个整数,默认是5。 #ansible testhosts -a "/sbin/reboot" -f 10 重启testhosts组的所有机器，每次重启10台
14. --private-key=PRIVATE_KEY_FILE 私钥路径，使用这个文件来验证连接
15. -v --verbose 详细信息
16. all 针对hosts 定义的所有主机执行
17. -M MODULE_PATH, --module-path=MODULE_PATH 要执行的模块的路径，默认为/usr/share/ansible/
18. --list-hosts 只打印有哪些主机会执行这个 playbook 文件，不是实际执行该 playbook 文件
19. -o --one-line 压缩输出，摘要输出.尝试一切都在一行上输出。
20. -t Directory, --tree=Directory 将内容保存在该输出目录,结果保存在一个文件中在每台主机上。
21. -B 后台运行超时时间
22. -P 调查后台程序时间
23. -T Seconds, --timeout=Seconds 时间，单位秒s
24. -P NUM, --poll=NUM 调查背景工作每隔数秒。需要- b
25. -c Connection, --connection=Connection 连接类型使用。可能的选项是paramiko(SSH),SSH和地方。当地主要是用于crontab或启动。
26. --tags=TAGS 只执行指定标签的任务 例子:ansible-playbook test.yml --tags=copy 只执行标签为copy的那个任务
27. --list-hosts 只打印有哪些主机会执行这个 playbook 文件，不是实际执行该 playbook 文件
28. --list-tasks 列出所有将被执行的任务
29. -C, --check 只是测试一下会改变什么内容，不会真正去执行;相反,试图预测一些可能发生的变化
30. --syntax-check 执行语法检查的剧本,但不执行它
31. -l SUBSET, --limit=SUBSET 进一步限制所选主机/组模式 --limit=192.168.0.15 只对这个ip执行
32. --skip-tags=SKIP_TAGS 只运行戏剧和任务不匹配这些值的标签 --skip-tags=copy_start
33. -e EXTRA_VARS, --extra-vars=EXTRA_VARS 额外的变量设置为键=值或YAML / JSON
34. \#cat update.yml
35. \---
36. \- hosts: {{ hosts }}
37. remote_user: {{ user }}
38. ..............
39. \#ansible-playbook update.yml --extra-vars "hosts=vipers user=admin" 传递{{hosts}}、{{user}}变量,hosts可以是 ip或组名
40. -l,--limit 对指定的 主机/组 执行任务 --limit=192.168.0.10，192.168.0.11 或 -l 192.168.0.10，192.168.0.11 只对这个2个ip执行任务

### **2、ansible-doc**

```
# ansible-doc -h
Usage: ansible-doc [options] [module...]
```

该指令用于查看模块信息，常用参数有两个-l 和 -s ，具体如下：

1. //列出所有已安装的模块
2. \# ansible-doc -l
3. //查看具体某模块的用法，这里如查看command模块
4. \# ansible-doc -s command

### **3、ansible-galaxy**

```
# ansible-galaxy -h
Usage: ansible-galaxy [init|info|install|list|remove] [--help] [options] ...
```

ansible-galaxy 指令用于方便的从<https://galaxy.ansible.com/> 站点下载第三方扩展模块，我们可以形象的理解其类似于[centos](https://www.linuxprobe.com/)下的yum、python下的pip或easy_install 。如下示例：

```
[root@localhost ~]# ansible-galaxy install aeriscloud.docker
- downloading role 'docker', owned by aeriscloud
- downloading role from https://github.com/AerisCloud/ansible-docker/archive/v1.0.0.tar.gz
- extracting aeriscloud.docker to /etc/ansible/roles/aeriscloud.docker
- aeriscloud.docker was installed successfully
```

这个安装了一个aeriscloud.docker组件，前面aeriscloud是galaxy上创建该模块的用户名，后面对应的是其模块。在实际应用中也可以指定txt或yml 文件进行多个组件的下载安装。这部分可以参看[官方文档](http://docs.ansible.com/galaxy.html)。

### **4、ansible-lint**

ansible-lint是对playbook的语法进行检查的一个工具。用法是ansible-lint playbook.yml 。

### **5、ansible-playbook**

该指令是使用最多的指令，其通过读取playbook 文件后，执行相应的动作，这个后面会做为一个重点来讲。

### **6、ansible-pull**

该指令使用需要谈到ansible的另一种模式－－－pull 模式，这和我们平常经常用的push模式刚好相反，其适用于以下场景：你有数量巨大的机器需要配置，即使使用非常高的线程还是要花费很多时间；你要在一个没有网络连接的机器上运行Anisble，比如在启动之后安装。这部分也会单独做一节来讲。

### **7、ansible-vault**

ansible-vault主要应用于配置文件中含有敏感信息，又不希望他能被人看到，vault可以帮你加密/解密这个配置文件，属高级用法。主要对于playbooks里比如涉及到配置密码或其他变量时，可以通过该指令加密，这样我们通过cat看到的会是一个密码串类的文件，编辑的时候需要输入事先设定的密码才能打开。这种playbook文件在执行时，需要加上 --ask-vault-pass参数，同样需要输入密码后才能正常执行。具体该部分可以参查[官方博客](http://www.ansible.com/blog/2014/02/19/ansible-vault)。

注：上面七个指令，用的最多的只有两个ansible 和ansible-playbook ，这两个一定要掌握，其他五个属于拓展或高级部分。