# gradle

## 指定使用仓库

```gradle
	# init.gradle
	allprojects{
    repositories {
        def REPOSITORY_URL = 'http://maven.aliyun.com/nexus/content/groups/public/'
        all { ArtifactRepository repo ->
            if(repo instanceof MavenArtifactRepository){
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2') || url.startsWith('https://jcenter.bintray.com/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $REPOSITORY_URL."
                    remove repo
                }
            }
        }
        maven {
            url REPOSITORY_URL
        }
    }
}
```

## 教你配置全局国内仓库，解决新建项目卡顿，下载构建慢等问题

步骤一：进入GRADLE_USER_HOME
一般情况下是C:\Users\Administrator.gradle\这个目录，如果你还没有配置过，这个目录是不会变的，我们讲windows下，linux用户大同小异。
C:\Users\Administrator.gradle\

步骤二：新建一个init.gradle文件
该文件是每一个Gradle 项目执行之前的脚本文件

步骤三：文件中填入如下内容
```gradle
allprojects {
    repositories {
        mavenLocal()
		maven { name "Alibaba" ; url "https://maven.aliyun.com/repository/public" }
		maven { name "Bstek" ; url "http://nexus.bsdn.org/content/groups/public/" }
    }
}
```
另外一个连插件都帮你配置好了
```gradle
allprojects {
    repositories {
        mavenLocal()
		maven { name "Alibaba" ; url "https://maven.aliyun.com/repository/public" }
		maven { name "Bstek" ; url "http://nexus.bsdn.org/content/groups/public/" }
    }

	buildscript { 
		repositories { 
			maven { name "Alibaba" ; url 'https://maven.aliyun.com/repository/public' }
			maven { name "Bstek" ; url 'http://nexus.bsdn.org/content/groups/public/' }
			maven { name "M2" ; url 'https://plugins.gradle.org/m2/' }
		}
	}
}
```
其实这个文件可以放置在其他目录，详细的话可以
参考官网的解释

说明一下。采用这种方法进行配置是全局性的配置。并不会对你的项目造成其他不好的影响，只是相当给你的项目的gradle 脚本新增了一段设置仓库的代码而已。所以可以放心使用。

自定义Task
```gradle
task showRepos(group:'Help',
		description:'Show all of the repository that had been config'){
	repositories.each {
		println it.name
		println "\t"+it.url	
	}
}
```
group 中首字母大写，否则Eclipse无法识别

description 是描述 ，必须是英文的，不能是中文的

## gradle使用本地maven仓库

指定环境变量GRADLE_USER_HOME到本地下载的maven仓库地址

```
GRADLE_USER_HOME=D:\devTools\repo
```

修改build.gradle

```gradle
// 指定使用仓库
repositories {
    mavenLocal()
    maven { name "Alibaba" ; url "https://maven.aliyun.com/repository/public" }
    maven { name "gradle-plugin" ; url "https://maven.aliyun.com/repository/gradle-plugin" }
    mavenCentral() // 中央仓库
}
```

这样就会先从本地maven仓库中获取，没有才会下载

## build.gradle

```gradle
maven { url "https://maven.aliyun.com/repository/central"}
maven { url "https://maven.aliyun.com/repository/google"}
maven { url "https://maven.aliyun.com/repository/gradle-plugin"}
maven { url "https://maven.aliyun.com/repository/jcenter"}
maven { url "https://maven.aliyun.com/repository/spring"}
maven { url "https://maven.aliyun.com/repository/spring-plugin"}
maven { url "https://maven.aliyun.com/repository/public"}
```

## Gradle的缓存路径修改的四种方法

### 1 修改gradle.properties文件

增加一句话设置目录：`gradle.user.home=D\:\\Android\\.gradle`

![](https://img-blog.csdn.net/20180413185639170?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zODYxNjAzOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 2 在Android Studio/Idea中修改gradle用户目录，打开设置(快捷键Ctrl+alt+S)，定位到Gradle菜单,作如下设置

![](https://img-blog.csdn.net/20180413185936826?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zODYxNjAzOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



### 3 修改gradle启动脚本，进入gradle安装的bin目录，使用文本编辑器打开gradle.bat文件，在如图的位置添加以下语句

```bash 
set GRADLE_OPTS="-Dgradle.user.home=D:\Android\.gradle"
```

![](https://img-blog.csdn.net/20180413190305121?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zODYxNjAzOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### 4 下面推荐[Windows](https://www.baidu.com/s?wd=Windows&tn=24004469_oem_dg&rsv_dl=gh_pl_sl_csd)环境变量设置gradle用户目录，

通过环境变量的方式，gradle会读取环境变量，所有的项目都会自动修改过来，非常方便。打开环境变量设置方法如图(win10下用快捷键win+Q呼出小娜,其他版本可以进控制面板查找到系统->高级系统设置)

![img](https://img-blog.csdn.net/20180413190548127?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zODYxNjAzOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

![img](https://img-blog.csdn.net/20180413190618936?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zODYxNjAzOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

![img](https://img-blog.csdn.net/20180413190745785?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2dpdGh1Yl8zODYxNjAzOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)