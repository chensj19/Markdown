# MySQL cmake编译参数详解

MySQL 5.5版本以后，使用CMake编译工具 命令调用语法 下表列出了常用编译工具的调用语法和等效的CMake命令。.表示你当前的工作目录路径，请根据你所在的目录，适当的替换掉路径.。

MySQL 5.5版本以后，使用CMake编译工具

## **命令调用语法**

下表列出了常用编译工具的调用语法和等效的CMake命令。“.”表示你当前的工作目录路径，请根据你所在的目录，适当的替换掉路径“.”。

| configure命令      | CMake命令               |
| ------------------ | ----------------------- |
| ./configure        | cmake .                 |
| ./configure --help | cmake . -LH or ccmake . |

在重新配置或重新构建之前，需要先清除旧的对象文件和缓存信息，方法如下：
Autotools：

```bash
make clean 
rm config.cache
```

CMake (Unix/[Linux](http://www.linuxeye.com/))：

```bash
make clean 
rm CMakeCache.txt
```

CMake (Windows)：

```bash
devenv MySQL.sln /clean 
del CMakeCache.txt
```

## **安装参数选项**

在下表中，“CMAKE_INSTALL_PREFIX”的值表示的是安装根目录，其他参数值的路径都是相对于根目录的，当然你也可以直接使用绝对路径，具体如下：

| 参数值说明           | 配置选项                                 | CMak选项                               |
| -------------------- | ---------------------------------------- | -------------------------------------- |
| 安装根目录           | --prefix=/usr                            | -DCMAKE_INSTALL_PREFIX=/usr            |
| mysqld目录           | --libexecdir=/usr/sbin                   | -DINSTALL_SBINDIR=sbin                 |
| 数据存储目录         | --localstatedir=/var/lib/mysql           | -DMYSQL_DATADIR=/var/lib/mysql         |
| 配置文件(my.cnf)目录 | --sysconfdir=/etc/mysql                  | -DSYSCONFDIR=/etc/mysql                |
| 插件目录             | --with-plugindir=/usr/lib64/mysql/plugin | -DINSTALL_PLUGINDIR=lib64/mysql/plugin |
| 手册文件目录         | --mandir=/usr/share/man                  | -DINSTALL_MANDIR=share/man             |
| 共享数据目录         | --sharedstatedir=/usr/share/mysql        | -DINSTALL_SHAREDIR=share               |
| Library库目录        | --libdir=/usr/lib64/mysql                | -DINSTALL_LIBDIR=lib64/mysql           |
| Header安装目录       | --includedir=/usr/include/mysql          | -DINSTALL_INCLUDEDIR=include/mysql     |
| 信息文档目录         | --infodir=/usr/share/info                | -DINSTALL_INFODIR=share/info           |

## **存储引擎选项**

存储引擎是以插件的形式存在的，所以，该选项可以控制插件的构建，比如指定使用某个特定的引擎。
--with-plugins配置选项接受两种形式的参数值，它没有对应的CMake配置参数：
① 以逗号(,)分隔的引擎名称列表；
② a "group name" value that is shorthand for a set of engines

在CMake中，引擎被作为单个的选项来进行控制。假设有以下配置选项：

```bash
--with-plugins=csv,myisam,myisammrg,heap,innobase,archive,blackhole
```

上面的参数指定MySQL[数据库](http://www.linuxeye.com/database/)可以支持哪些数据库引擎，将上述编译选项转换成CMake编译选项时，下面的几个引擎名字可以被省略，因为编译时，默认就支持：

```bash
csv myisam myisammrg heap
```

然后使用下面的编译参数，以启用InnoDB、ARCHIVE和BLACKHOLE引擎支持：

```bash
-DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1
```

当然也可以使用“ON”来替代数字1，它们是等效的。
如果你想除去对某种引擎的支持，则在CMake编译选项中使用-DWITHOUT_<ENGINE>_STORAGE_ENGINE，例如：

```bash
-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITHOUT_FEDERATED_STORAGE_ENGINE=1 -DWITHOUT_PARTITION_STORAGE_ENGINE=1
```

## **库文件加载选项**

该选项指明Mysql使用库的情况：

| 参数值说明 | 配置选项             | CMak选项           |
| ---------- | -------------------- | ------------------ |
| readline库 | --with-readline      | -DWITH_READLINE=1  |
| SSL库      | --with-ssl=/usr      | -DWITH_SSL=system  |
| zlib库     | --with-zlib-dir=/usr | -DWITH_ZLIB=system |
| libwrap库  | --without-libwrap    | -DWITH_LIBWRAP=0   |

## **其他选项**

CMake编译选项支持大部分之前版本的MySQL编译选项，新老编译选项的差别在于：之前的是小写，现在全部变成了大写，之前采用双横线，现在使用单横线，之前使用的破折号，现在取而代之的是使用下划线，例如：

```pretty
--with-debug => WITH_DEBUG=1 --with-embedded-server => WITH_EMBEDDED_SERVER
```



## **MySQL的新老参数对照表**

| 参数值说明             | 配置选项                                                     | CMak选项                            |
| ---------------------- | ------------------------------------------------------------ | ----------------------------------- |
| TCP/IP端口             | --with-tcp-port-=3306                                        | -DMYSQL_TCP_PORT=3306               |
| UNIX socket文件        | --with-unix-socket-path=/tmp/mysqld.sock                     | -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock  |
| 启用加载本地数据       | --enable-local-in[file](http://www.linuxeye.com/command/file.html) | -DENABLED_LOCAL_INFILE=1            |
| 扩展字符支持           | --with-extra-charsets=all（默认：all）                       | -DEXTRA_CHARSETS=all（默认：all）   |
| 默认字符集             | --with-charset=utf8                                          | -DDEFAULT_CHARSET=utf8              |
| 默认字符校对           | --with-collation=utf8_general_ci                             | -DDEFAULT_COLLATION=utf8_general_ci |
| Build the server       | --with-server                                                | 无                                  |
| 嵌入式服务器           | --with-embedded-server                                       | -DWITH_EMBEDDED_SERVER=1            |
| libmysqld权限控制      | --with-embedded-privilege-control                            | 无                                  |
| 安装文档               | --without-docs                                               | 无                                  |
| Big tables支持         | --with-big-tables, --without-big-tables                      | 无                                  |
| mysqld运行用户         | --with-mysqld-user=mysql                                     | -DMYSQL_USER=mysql                  |
| 调试模式               | --without-debug（默认禁用）                                  | -DWITH_DEBUG=0（默认禁用）          |
| GIS支持                | --with-geometry                                              | 无                                  |
| 社区功能               | --enable-community-features                                  | 无                                  |
| Profiling              | --disable-profiling（默认启用）                              | -DENABLE_PROFILING=0（默认启用）    |
| pstack                 | --without-pstack                                             | 无（新版移除该功能）                |
| 汇编字符串函数         | --enable-assembler                                           | 无                                  |
| 构建类型               | --build=x86_64-pc-linux-gnu                                  | 没有等效参数                        |
| 交叉编译主机           | --host=x86_64-pc-linux-gnu                                   | 没有等效参数                        |
| 客户端标志             | --with-client-ldflags=-lstdc++                               | 无                                  |
| 线程安全标志           | --enable-thread-safe-client                                  | 无                                  |
| 注释存储类型           | --with-comment='string'                                      | -DWITH_COMMENT='string'             |
| Shared/static binaries | --enable-shared --enable-static                              | 无                                  |
| 内存使用控制           | --with-low-memory                                            | 无                                  |