# Node编译常见问题

## 一、node-gyp问题

### 1、下载头文件问题

```bash
gyp verb command install [ '14.15.3' ]
gyp verb install input version string "14.15.3"
gyp verb install installing version: 14.15.3
gyp verb install --ensure was passed, so won't reinstall if already installed
gyp verb install version not already installed, continuing with install 14.15.3
gyp verb ensuring nodedir is created /root/.node-gyp/14.15.3
gyp verb created nodedir /root/.node-gyp
gyp http GET https://nodejs.org/download/release/v14.15.3/node-v14.15.3-headers.tar.gz
```

> 在不无法连接外网情况或限制外网的情况下，上述问题无法通过，导致构建失败
>
> 解决方法：
>
> 1、下载头文件信息
>
> 2、解压到指定目录
>
> 3、重命名

```bash
# 下载头文件
curl -o https://npm.taobao.org/mirrors/node/v14.15.3/node-v14.15.3-headers.tar.gz
# 创建目录
mkdir ~/.cache/node-gyp
# 解压文件到指定目录
tar -xzf node-v14.15.3-headers.tar.gz ~/.cache/node-gyp
cd ~/.cache/node-gyp
# 重命名
mv node-v14.15.3 14.15.3
```

## 2、复制node_modules后由于node-sass版本导致无法编译

```
npm rubuid node-sass 失败
```

处理方案

```bash
 rm -rf node_modules/node-gyp
 npm install node-sass  --registry https://registry.npm.taobao.org --unsafe-perm=true --allow-root
```

## 3、包缺失

### 3.1 自己推送

从https://registry.npm.taobao.org/body-parser下载包到本地，然后解压，推送上私服

```bash
tar zxvf xxx.tgz
# package 就是需要推送的内容
npm publish package --registry  http://nexus.winning.com.cn:8081/repository/npm/
```

### 3.2 使用淘宝源安装

```bash
npm i safer-buffer --registry https://registry.npm.taobao.org
```

