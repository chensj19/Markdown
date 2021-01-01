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

