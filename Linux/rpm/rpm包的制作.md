# [rpm包的制作](http://blog.chinaunix.net/uid-23069658-id-3944462.html)

​		常见的Linux发行版主要可以分为两类，类ReadHat系列和类Debian系列，这里我们是以其软件包的格式来划分的，这两类系统分别提供了自己的软件包管理系统和相应的工具。类RedHat系统中软件包的后缀是rpm；类Debian系统中软件包的后缀是deb。另一方面，类RedHat系统提供了同名的rpm命令来安装、卸载、升级rpm软件包；类Debian系统同样提供了dpkg命令来对后缀是deb的软件包进行安装、卸载和升级等操作。
  rpm的全称是Redhat Package Manager，常见的使用rpm软件包的系统主要有Fedora、CentOS、openSUSE、SUSE企业版、PCLinuxOS以及Mandriva Linux、Mageia等。使用deb软件包后缀的类Debian系统最常见的有Debian、Ubuntu、Finnix等。

  无论是rpm命令还是dpkg命令在安装软件包时都存在一个让人非常头疼的问题，那就是软件包的依赖关系。这一点很多人应该深有体会，这也使初学者在接触Linux系统时觉得很不方便的地方。庆幸的是，很多发行版都考虑到了这问题，于是Fedora和CentOS提供了yum来自动解决软件包的安装依赖，同样的openSUSE提供了zypper，类Debian系统提供了apt-*命令。也就是说这些工具本质上最终还是调用了rpm(或者dpkg)是不过安装前自动帮用户解决了软件包的安装依赖。如下表所示：

| 分类                  | 发行版        | 手动安装命令 | 自动安装命令 | 软件包后缀 |
| --------------------- | ------------- | ------------ | ------------ | ---------- |
| 类RedHat              | Fedora/CentOS | rpm          | yum          | *.rpm      |
| openSUSE/SUSE         | zypper        |              |              |            |
| Mandriva Linux/Mageia | urpmi         |              |              |            |
| 类Debian              | Debian/Ubuntu | dpkg         | apt-get      | *.deb      |

  简单点了说，如果你会在Fedora或者CentOS上用yum来自动安装软件包，那么在Debian或者Ubuntu上你就会用apt-get自动安装软件，同理，在openSUSE上你就会用zypper自动安装软件包。

  本文档主要描述如何通过软件包的源代码构建自己的rpm软件安装包。
  从软件运行的结构来说，一个软件主要可以分为三个部分：可执行程序、配置文件和动态库。当然还有可能会有相关文档、手册、供二次开发用的头文件以及一些示例程序等等。其他部分都是可选的，只有可执行文件是必须的。
  关于如何制作rpm软件包的方法，网上教程也一大堆，谈及最多的当属rpmbuild这个命令行工具。这也是本文要介绍的“配角”，而主角是它的输入对象，也就是所谓的SPEC文件的格式，写法和说明。

  rpm的打包流程相比deb的要稍微麻烦一些，因为它对打包目录有一些严格的层次上的要求。如果你的rpm的版本<=4.4.x，那么rpmbuid工具其默认的工作路径是/usr/src/redhat，这就使得普通用户不能制作rpm包，因为权限的问题，在制作rpm软件包时必须切换到root身份才可以。所以，rpm从4.5.x版本开始，将rpmbuid的默认工作路径移动到用户家目录下的rpmbuild目录里，即$HOME/rpmbuild，并且推荐用户在制作rpm软件包时尽量不要以root身份进行操作。

  关于rpmbuild默认工作路径的确定，通常由在/usr/lib/rpm/macros这个文件里的一个叫做**%_topdir**的宏变量来定义。如果用户想更改这个目录名，rpm官方并不推荐直接更改这个目录，而是在用户家目录下建立一个名为.rpmmacros的隐藏文件(注意前面的点不能少，这是Linux下隐藏文件的常识)，然后在里面重新定义%_topdir，指向一个新的目录名。这样就可以满足某些“高级”用户的差异化需求了。通常情况下.rpmmacros文件里一般只有一行内容，比如：

```bash
%_topdir   $HOME/myrpmbuildenv
```

  在%_topdir目录下一般需要建立6个目录： 

| 目录名    | 说明                                                  | macros中的宏名 |
| --------- | ----------------------------------------------------- | -------------- |
| BUILD     | 编译rpm包的临时目录                                   | %_builddir     |
| BUILDROOT | 编译后生成的软件临时安装目录                          | %_buildrootdir |
| RPMS      | 最终生成的可安装rpm包的所在目录                       | %_rpmdir       |
| SOURCES   | 所有源代码和补丁文件的存放目录                        | %_sourcedir    |
| SPECS     | 存放SPEC文件的目录(重要)                              | %_specdir      |
| SRPMS     | 软件最终的rpm源码格式存放路径(暂时忽略掉，别挂在心上) | %_srcrpmdir    |

  小技巧：执行**rpmdev-setuptree**会在当前用户家目录下的rpmbuild目录(如果该目录不存在也会被自动创建)里自动建立上述目录。
  当上述目录建立好之后，将所有用于生成rpm包的源代码、shell脚本、配置文件都拷贝到SOURCES目录里，注意**通常**情况下源码的压缩格式都为*.tar.gz格式(当然还可以为其他格式，但那就是另外一种方式，这里先不介绍)。然后，将最最最重要的SPEC文件，命名格式一般是“软件名-版本.spec”的形式，将其拷贝到SPECS目录下，切换到该目录下执行：

```bash
rpmbuild -bb 软件名-版本.spec
```

  最终我们想要的rpm软件包就安安稳稳地躺在RPMS目录下了。对，就这么简单。
  这里的关键就是上面的SPEC文件的写法，我们可以用rpmdev-newspec -o *Name-version*.spec命令来生成SPEC文件的模板，然后在上面修改就可。例如：

```bash
[root@localhost ~]# rpmdev-newspec -o myapp-0.1.0.spec
Skeleton specfile (minimal) has been created to "myapp-0.1.0.spec".
[root@localhost ~]# cat myapp-0.1.0.spec
Name: myapp-0.1.0
Version:
Release: 1%{?dist}
Summary:

Group:
License:
URL:
Source0:
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:
Requires:

%description

%prep
%setup -q

%build
%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc

%changelog
```

  其实SPEC文件的核心是它定义了一些“阶段”(%prep、%build、%install和%clean)，当rpmbuild执行时它首先会去解析SPEC文件，然后依次执行每个“阶段”里的指令。
  接下来，我们来简单了解一下SPEC文件的头部。假如，我们的源码包名字是myapp-0.1.0.tar.gz，那么myapp-0.1.0.spec的头部一般如下的样子：

```bash
Name:                  myapp <===软件包的名字(后面会用到)
Version:               0.1.0 <===软件包的版本(后面会用到)
Release:               1%{?dist} <===发布序号
Summary:               my first rpm <===软件包的摘要信息
Group:                 <===软件包的安装分类，参见/usr/share/doc/rpm-4.x.x/GROUPS这个文件
License:               GPL <===软件的授权方式
URL:                   <===这里本来写源码包的下载路径或者自己的博客地址或者公司网址之类
Source0:               %{name}-%{version}.tar.gz <===源代码包的名称(默认时rpmbuid回到SOURCES目录中去找)，这里的name和version就是前两行定义的值。如果有其他配置或脚本则依次用Source1、Source2等等往后增加即可。
BuildRoot:             %{_topdir}/BUILDROOT <=== 这是make install时使用的“虚拟”根目录，最终制作rpm安装包的文件就来自这里。
BuildRequires:         <=== 在本机编译rpm包时需要的辅助工具，以逗号分隔。假如，要求编译myapp时，gcc的版本至少为4.4.2，则可以写成gcc >=4.2.2。还有其他依赖的话则以逗号分别继续写道后面。
Requires:              <=== 编译好的rpm软件在其他机器上安装时，需要依赖的其他软件包，也以逗号分隔，有版本需求的可以
%description           <=== 软件包的详细说明信息，但最多只能有80个英文字符。
```


  下面我们来看一下制作rpm包的几个关键阶段，以及所发生的事情： 

| 阶段      | 动作                                                         |
| --------- | ------------------------------------------------------------ |
| %prep     | 将%_sourcedir目录下的源代码解压到%_builddir目录下。如果有补丁的需要在这个阶段进行打补丁的操作 |
| %build    | 在%_builddir目录下执行源码包的编译。一般是执行./configure和make指令 |
| %install  | 将需要打包到rpm软件包里的文件从%_builddir下拷贝%_buildrootdir目录下。当用户最终用rpm -ivh name-version.rpm安装软件包时，这些文件会安装到用户系统中相应的目录里 |
| 制作rpm包 | 这个阶段是自动完成的，所以在SPEC文件里面是看不到的，这个阶段会将%_buildroot目录的相关文件制作成rpm软件包最终放到%_rpmdir目录里 |
| %clean    | 编译后的清理工作，这里可以执行make clean以及清空%_buildroot目录等 |

  每个阶段的详细说明如下：

- **%prep****阶段**

  这个阶段里通常情况，主要完成对源代码包的解压和打补丁(如果有的话)，而解压时最常见到的就是一句指令：

```bash
%setup -q
```

  当然，这句指令可以成功执行的前提是你位于SOURCES目录下的源码包必须是name-version.tar.gz的格式才行，它还会完成后续阶段目录的切换和设置。如果在这个阶段你不用这条指令，那么后面每个阶段都要自己手动去改变相应的目录。解压完成之后如果有补丁文件，也在这里做。想了解的童鞋可以自己去查查如何实现，也不难，这里我就不展开了。

- **%build****阶段**

   这个阶段就是执行常见的configure和make操作，如果有些软件需要最先执行bootstrap之类的，可以放在configure之前来做。这个阶段我们最常见只有两条指令：

点击(此处)折叠或打开

```bash
%configure
make %{?_smp_mflags}
```

  它就自动将软件安装时的路径自动设置成如下约定：

1. **可执行程序****/usr/bin**

2. **依赖的动态库****/usr/lib****或者****/usr/lib64****视操作系统版本而定。**

3. **二次开发的头文件****/usr/include**

4. **文档及手册****/usr/share/man**
     注意，这里的%configure是个宏常量，会自动将prefix设置成/usr。另外，这个宏还可以接受额外的参数，如果某些软件有某些高级特性需要开启，可以通过给%configure宏传参数来开启。如果不用 %configure这个宏的话，就需要完全手动指定configure时的配置参数了。同样地，我们也可以给make传递额外的参数，例如：

   ```bash
   make %{?_smp_mflags} CFLAGS="" …
   ```

   

- **%install阶段**

  这个阶段就是执行make install操作。这个阶段会在%_buildrootdir目录里建好目录结构，然后将需要打包到rpm软件包里的文件从%_builddir里拷贝到%_buildrootdir里对应的目录里。这个阶段最常见的两条指令是：

```bash
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
```


  其中$RPM_BUILD_ROOT也可以换成我们前面定义的BuildRoot变量，不过要写成%{buildroot}才可以，必须全部用小写，不然要报错。
  如果软件有配置文件或者额外的启动脚本之类，就要手动用copy命令或者install命令你给将它也拷贝到%{buildroot}相应的目录里。用copy命令时如果目录不存在要手动建立，不然也会报错，所以推荐用install命令。 

- **%clean****阶段**

  编译完成后一些清理工作，主要包括对%{buildroot}目录的清空(当然这不是必须的)，通常执行诸如make clean之类的命令。 

- **制作****rpm****软件包的阶段**

  这个阶段必须引出下面一个叫做%files的阶段。它主要用来说明会将%{buildroot}目录下的哪些文件和目录最终打包到rpm包里。

```bash
%files
%defattr(-,root,root,-)
%doc
```

  在%files阶段的第一条命令的语法是：

```bash
%defattr(文件权限,用户名,组名,目录权限)
```

  如果不牵扯到文件、目录权限的改变则一般用%defattr(-,root,root,-)这条指令来为其设置缺省权限。所有需要打包到rpm包的文件和目录都在这个地方列出，例如：

```bash
%files
%{_bindir}/*
%{_libdir}/*
%config(noreplace) %{_sysconfdir}/*.conf
```

  在安装rpm时，会将可执行的二进制文件放在/usr/bin目录下，动态库放在/usr/lib或者/usr/lib64目录下，配置文件放在/etc目录下，并且多次安装时新的配置文件不会覆盖以前已经存在的同名配置文件。
  这里在写要打包的文件列表时，**既可以以宏常量开头，也可以为“/”开头，没任何本质的****区别**，都表示从%{buildroot}中拷贝文件到最终的rpm包里；如果是相对路径，则表示要拷贝的文件位于%{_builddir}目录，这主要适用于那些在%install阶段没有被拷贝到%{buildroot}目录里的文件，最常见的就是诸如README、LICENSE之类的文件。如果不想将%{buildroot}里的某些文件或目录打包到rpm里，则用：

```bash
%exclude dic_name或者file_name
```

  但是关于%files阶段有两个特性要牢记：

1. %{buildroot}里的所有文件都要明确被指定是否要被打包到rpm里。什么意思呢？假如，%{buildroot}目录下有4个目录a、b、c和d，在%files里仅指定a和b要打包到rpm里，如果不把c和d用exclude声明是要报错的；
2. 如果声明了%{buildroot}里不存在的文件或者目录也会报错。

  关于%doc宏，所有跟在这个宏后面的文件都来自%{_builddir}目录，当用户安装rpm时，由这个宏所指定的文件都会安装到/usr/share/doc/*name*-*version*/目录里。

- **%changelog阶段**

  这是最后一个阶段，主要记录的每次打包时的修改变更日志。标准格式是：

```bash
* date +"%a %b %d %Y" 修改人 邮箱 本次版本x.y.z-p
- 本次变更修改了那些内容
```


  说了这么多，我们实战一下。网上很多教程都是拿Tomcat或者Nigix开头，这里我就先从简单的mp3解码库libmad入手，将它打成一个rpm包，具体步骤如下：

  (如果自己系统上没有rpmbuild命令就安装之：yum install rpm* rpm-build rpmdev*)

  1、构建rpm的编译目录结构：
![img](http://blog.chinaunix.net/attachment/201310/13/23069658_13816681089H8H.jpg)
  2、下载libmad源码到rpmbuild/SOURCES目录下，可以从 http://downloads.sourceforge.net/mad/libmad-0.15.1b.tar.gz这里下载。

  3、在rpmbuild/SPECS目录下执行rpmdev-newspec -o libmad-0.15.1b.spec，会在当前目录下生成名为libmad-0.15.1b.spec的模板文件。

  4、将libmad-0.15.1b.spec修改成如下的样子：

![img](http://blog.chinaunix.net/attachment/201310/13/23069658_1381668368pnEs.jpg)

  5、在rpmbuild/SPECS目录下执行打包编译：

```bash
rpmbuild -bb libmad-0.15.1b.spec
```

  最终生成的rpm包如下：

![img](http://blog.chinaunix.net/attachment/201310/13/23069658_13816684860iwt.jpg)

  因为我是64位系统，所以编译出的libmad适用于CentOS6.0-64。

  如果我们将libmad的源码和spec文件拷贝32位系统上，再执行rpm打包，看看结果：

![img](http://blog.chinaunix.net/attachment/201310/13/23069658_1381668551QLfn.jpg)

  结果如下：

![img](http://blog.chinaunix.net/attachment/201310/13/23069658_13816685927iii.jpg)


后记：
  关于SPEC文件，还有一些其他特性，诸如安装软件包之前、之后要做的事情，以及卸载软件包之前之后要做的事情，包括给源码打补丁，关于这些特性感兴趣的童鞋自己去摸索吧。最后给出一个完整的，包含了打补丁、安装、卸载特性的SPEC文件模板：

```bash
Name: test
Version:
Requires:
%description
…
#==================================SPEC头部====================================
%prep
%setup -q
%patch <==== 在这里打包
%build
%configure
make %{?_smp_mflags}
%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
%clean
rm -rf $RPM_BUILD_ROOT
%files
%defattr(-,root,root,-)
要打包到rpm包里的文件清单
%doc
%changelog
#==================================SPEC主体====================================
%pre
安装或者升级软件前要做的事情，比如停止服务、备份相关文件等都在这里做。
%post
安装或者升级完成后要做的事情，比如执行ldconfig重构动态库缓存、启动服务等。
%preun
卸载软件前要做的事情，比如停止相关服务、关闭进程等。
%postun
卸载软件之后要做的事情，比如删除备份、配置文件等。
```

