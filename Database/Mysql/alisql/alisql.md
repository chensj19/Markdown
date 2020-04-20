# AliSQL 源码编译

[HOME](http://blog.fungo.me/)[ABOUT](http://blog.fungo.me/about/)[CATEGORIES](http://blog.fungo.me/categories/)[TAGS](http://blog.fungo.me/tags/)[LINKS](http://blog.fungo.me/links/)[SUBSCRIBE](http://blog.fungo.me/feed/)

## 前言

AliSQL 在 2016 云栖大会宣布开放源代码之后，迅速就获得了广泛的关注，目前(2016-10-23) star 数目已达 1187，欢迎访问 [AliSQL GitHub](https://github.com/alibaba/AliSQL) 项目关注。社区反应也非常活跃，在 [Issue](https://github.com/alibaba/AliSQL/issues) 中提了不少反馈建议，其中有一部分是和编译安装相关的，因为官方目前并没有提供 binary，有同学可能没有 GNU/Linux 环境下编译代码的经验，导致不能直接使用。针对这个问题，本文提供一个非官方 (unofficial) 的编译指导，希望对大家有所帮助。

目前只提供使用最普遍的 GNU/Linux 发行版 Ubuntu 和 CentOS 的编译指导。

## Ubuntu 16.04

1. 编译环境准备

   编译需要 `gcc >= 4.7, cmake >= 2.8`，16.04 apt 源里的版本 (gcc = 5.4, cmake = 3.5) 已经够用了，直接安装使用。

   ```
    apt-get update -y
    apt-get install git gcc g++ cmake -y
    apt-get install bison libncurses5-dev zlib1g-dev libssl-dev -y
   ```

2. 从 GitHub clone 代码

   ```
    git clone https://github.com/alibaba/AliSQL.git
   ```

3. cmake 配置

   MySQL 有非常多的 cmake 参数，大家可以参考[官方这个页面](https://dev.mysql.com/doc/mysql-sourcebuild-excerpt/5.6/en/source-configuration-options.html)，这里的配置只是个参考，大家根据需要修改：

   ```
    cmake .                              \
    -DCMAKE_BUILD_TYPE="Release"         \
    -DCMAKE_INSTALL_PREFIX="/opt/alisql" \
    -DWITH_EMBEDDED_SERVER=0             \
    -DWITH_EXTRA_CHARSETS=all            \
    -DWITH_MYISAM_STORAGE_ENGINE=1       \
    -DWITH_INNOBASE_STORAGE_ENGINE=1     \
    -DWITH_PARTITION_STORAGE_ENGINE=1    \
    -DWITH_CSV_STORAGE_ENGINE=1          \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1      \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1    \
    -DWITH_FEDERATED_STORAGE_ENGINE=1    \
    -DWITH_PERFSCHEMA_STORAGE_ENGINE=1   \
    -DWITH_TOKUDB_STORAGE_ENGINE=1
   ```

4. 编译安装

   ```
    make -j4 && make install
   ```

   `-j4` 表示开 4 个并发编译进程，加速编译，根据机器 CPU 核数调整，一般是 CPU 核数 + 1，最终二进制安装在 `/opt/alisql` 目录下。

## CentOS 6.8

1. 编译环境准备

   CentOS 和 Ubuntu 环境的区别就在这一步，CentOS yum 源里的 gcc 版本是 4.4 的，不满足需求，可以通过[我之前介绍过](http://blog.fungo.me/2016/03/centos-development-env/)的 devtoolset 来安装高版本 gcc，devtoolset 目前最新套装是 [devtoolset-4](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-4/)，包含 gcc 5.2。

   ```
    yum install centos-release-scl -y
    yum install devtoolset-4-gcc-c++ devtoolset-4-gcc -y
    yum install cmake git -y
    yum install ncurses-devel openssl-devel bison -y
   ```

2. 从 GitHub clone 代码

   ```
    git clone https://github.com/alibaba/AliSQL.git
   ```

3. cmake 配置

   在配置前，要先设置下环境变量，这样才能用到 devtoolset-4 套装里的gcc。

   ```
    scl enable devtoolset-4 bash
    cmake .                              \
    -DCMAKE_BUILD_TYPE="Release"         \
    -DCMAKE_INSTALL_PREFIX="/opt/alisql" \
    -DWITH_EMBEDDED_SERVER=0             \
    -DWITH_EXTRA_CHARSETS=all            \
    -DWITH_MYISAM_STORAGE_ENGINE=1       \
    -DWITH_INNOBASE_STORAGE_ENGINE=1     \
    -DWITH_PARTITION_STORAGE_ENGINE=1    \
    -DWITH_CSV_STORAGE_ENGINE=1          \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1      \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1    \
    -DWITH_FEDERATED_STORAGE_ENGINE=1    \
    -DWITH_PERFSCHEMA_STORAGE_ENGINE=1   \
    -DWITH_TOKUDB_STORAGE_ENGINE=1
   ```

4. 编译安装

   ```
    make -j4 && make install
   ```

玩的开心 ^_^ ！