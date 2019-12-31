# Spec文件参数详解

## 1.1 起手势 安装rpm-build

```
yum -y install rpm-build
```


新建一个新用户并切换到用户上（避免权限的问题）、建立工作车间目录（官网的说法。。。），并写进环境变量里。

```
[root]# useradd devops    #新建用户
[root]# su - devops       #切换用户
[devops]$ echo "%_topdir %(echo $HOME)/rpmbuild" >>  ~/.rpmmacros
[devops]$ mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
```


注意: 这几个新建的文件夹必须要求全部大写！全部大写！全部大写！

以下为目录所对应存放文件的解释：

> - BUILD：源码解压以后放的目录
> - RPMS：制作完成后的rpm包存放目录
> - SOURCES：存放源文件，配置文件，补丁文件等放置的目录【常用】
> - SPECS：存放spec文件，作为制作rpm包的文件，即：nginx.spec……【常用】
> - SRPMS：src格式的rpm包目录
> - BuiltRoot：虚拟安装目录，即在整个install的过程中临时安装到这个目录，把这个目录当作根来用的，所以在这个目录下的文件，才是真正的目录文件。最终，Spec文件中最后有清理阶段，这个目录中的内容将被删除


Spec文件的宏定义：

> rpmbuild --showrc | grep topdir #工作车间目录：_topdir /root/rpmbuild
> -14: _builddir %{_topdir}/BUILD
> -14: _buildrootdir %{_topdir}/BUILDROOT
> -14: _rpmdir %{_topdir}/RPMS
> -14: _sourcedir %{_topdir}/SOURCES
> -14: _specdir %{_topdir}/SPECS
> -14: _srcrpmdir %{_topdir}/SRPMS
> -14: _topdir /root/rpmbuild


rpmbuild --showrc显示所有的宏，以下划线开头：


- 一个下划线：定义环境的使用情况，

- 二个下划线：通常定义的是命令，
  为什么要定义宏，因为不同的系统，命令的存放位置可能不同，所以通过宏的定义找到命令的真正存放位置

  

## 1.2 理解Spec脚本中各个变量

  rpm的配置文档还算是比较有调理性的，按照标准的格式整理一些信息，包括：软件基础信息，以及安装、卸载前后执行的脚本，对源码包解压、打补丁、编译，安装路径和文件引用等,其中需要注意的地方为：虚拟路径的位置，以及宏的定义。

  spec脚本包括很多关键字，主要有：

* Name: 软件包的名称，在后面的变量中即可使用%{name}的方式引用

* Summary: 软件包的内容

* Version: 软件的实际版本号，例如：1.12.1等，后面可使用%{version}引用

* Release: 发布序列号，例如：1%{?dist}，标明第几次打包，后面可使用%{release}引用

* Group: 软件分组，建议使用：Applications/System

  > Amusements/Games （娱乐/游戏）Amusements/Graphics（娱乐/图形）
  >
  > Applications/Archiving （应用/文档）Applications/Communications（应用/通讯
  >
  > Applications/Databases （应用/数据库）Applications/Editors （应用/编辑器）
  >
  > Applications/Emulators （应用/仿真器）Applications/Engineering （应用/工程）
  >
  > Applications/File （应用/文件）Applications/Internet （应用/因特网）
  >
  > Applications/Multimedia（应用/多媒体）Applications/Productivity （应用/产品）
  >
  > Applications/Publishing（应用/印刷）Applications/System（应用/系统）
  >
  > Applications/Text （应用/文本）Development/Debuggers （开发/调试器）
  >
  > Development/Languages （开发/语言）Development/Libraries （开发/函数库）
  >
  > Development/System （开发/系统）Development/Tools （开发/工具）
  >
  > Documentation （文档）System Environment/Base（系统环境/基础）
  >
  > System Environment/Daemons （系统环境/守护）System Environment/Kernel （系统环境/内核）
  >
  > System Environment/Libraries （系统环境/函数库）System Environment/Shells （系统环境/接口）
  >
  > User Interface/Desktops（用户界面/桌面）User Interface/X （用户界面/X窗口）
  >
  > User Interface/X Hardware Support （用户界面/X硬件支持）

* License: 软件授权方式GPLv2

* Source: 源码包，可以带多个用Source1、Source2等源，后面也可以用%{source1}、%{source2}引用

* BuildRoot: 这个是安装或编译时使用的临时目录，即模拟安装完以后生成的文件目录：%_topdir/BUILDROOT 后面可使用$RPM_BUILD_ROOT 方式引用。_

* URL: 软件的URI

* Vendor: 打包组织或者人员

* Patch: 补丁源码，可使用Patch1、Patch2等标识多个补丁，使用%patch0或%{patch0}引用

* Prefix: %{_prefix} 这个主要是为了解决今后安装rpm包时，并不一定把软件安装到rpm中打包的目录的情况。这样，必须在这里定义该标识，并在编写%install脚本的时候引用，才能实现rpm安装时重新指定位置的功能
  Prefix: %{_sysconfdir} 这个原因和上面的一样，但由于%{_prefix}指/usr，而对于其他的文件，例如/etc下的配置文件，则需要用%{_sysconfdir}标识
  
* Requires: 该rpm包所依赖的软件包名称，可以用>=或<=表示大于或小于某一特定版本，例如：
  libxxx-devel >= 1.1.1 openssl-devel 。 注意：“>=”号两边需用空格隔开，而不同软件名称也用空格分开
  
* %description: 软件的详细说明

* %define: 预定义的变量，例如定义日志路径: _logpath /var/log/weblog

* %prep: 预备参数，通常为 %setup -q

* %build: 编译参数 ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx/……

* %install: 安装步骤,此时需要指定安装路径，创建编译时自动生成目录，复制配置文件至所对应的目录中（这一步比较重要！）

* %pre: 安装前需要做的任务，如：创建用户

* %post: 安装后需要做的任务 如：自动启动的任务

* %preun: 卸载前需要做的任务 如：停止任务

* %postun: 卸载后需要做的任务 如：删除用户，删除/备份业务数据

* %clean: 清除上次编译生成的临时文件，就是上文提到的虚拟目录

* %files: 设置文件属性，包含编译文件需要生成的目录、文件以及分配所对应的权限

* %changelog: 修改历史