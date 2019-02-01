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

