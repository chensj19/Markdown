#### 简易的命令行入门教程:

Git 全局设置:

```bash
git config --global user.name "chensj.dev"
git config --global user.email "chenshijie1988@yeah.net"
```

创建 git 仓库:

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

已有仓库?

```bash
cd existing_git_repo
git remote add origin https://gitee.com/chensj881008/Markdown.git
git push -u origin master
```

