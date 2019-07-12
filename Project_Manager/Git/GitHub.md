# Git常用设置:

## Git 全局设置:

```bash
git config --global user.name "chensj.dev"
git config --global user.email "chenshijie1988@yeah.net"
```

## Git仓库关联

### 新的git 仓库:

```bash
mkdir Markdown
cd Markdown
git init
touch README.md
git add README.md
git commit -m "first commit"
git remote add origin https://gitee.com/chensj881008/Markdown.git
git push -u origin master
```

### 已有仓库?

```bash
cd existing_git_repo
git remote add origin https://gitee.com/chensj881008/Markdown.git
git push -u origin master
```

### 设置跟踪远程分支：

```bash
git pull origin master
git branch --set-upstream-to=origin/master master
```

### 修改远程仓库的关联

查看本地远程分支

```bash
git remote -v
```

删除本地与远程分支关联

```bash
git remote remove xxx	
```

修改关联的远程仓库的方法，主要有三种。

* 使用 git remote set-url 命令，更新远程仓库的 url

  ```bash
  git remote set-url origin <newurl>
  ```

* 先删除之前关联的远程仓库，再来添加新的远程仓库关联

  * 删除关联的远程仓库

    ```bash
    git remote remove <name>
    ```

  * 添加新的远程仓库关联

    ```bash
    git remote add <name> <url>
    ```

    远程仓库的名称推荐使用默认的名称 origin 。

* 直接修改项目目录下的 .git 目录中的 config 配置文件。

  1. 进入git_test/.git

  2. vim config 

     ```bash
     [core] 
     repositoryformatversion = 0 
     filemode = true 
     logallrefupdates = true 
     precomposeunicode = true 
     [remote "origin"] 
     url = http://192.168.100.235:9797/shimanqiang/assistant.git 
     fetch = +refs/heads/*:refs/remotes/origin/* 
     [branch "master"] 
     remote = origin 
     merge = refs/heads/master
     ```

     修改`[remote "origin"] `下面的url即可

## 删除远程文件

### 删除文件

* 对需要删除的文件、文件夹进行如下操作

  ```bash
  git rm test.txt (删除文件)
  git rm -r test (删除文件夹)
  ```

* 提交修改

  ```bash
  git commit -m "Delete some files."
  ```

* 将修改提交到远程仓库的xxx分支:

  ```bash
  git push origin xxx
  ```

### 删除远程仓库 但不删本地资源

```bash
git rm -r --cached xxx.iml　　//-r 是递归的意思   当最后面是文件夹的时候有用
git add xxx.iml    　        //若.gitignore文件中已经忽略了xxx.iml则可以不用执行此句
git commit -m "ignore xxx.xml"
git push
```

