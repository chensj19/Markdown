# vscode开发环境搭建

## 1、gopath路径配置

因网络问题，golang的依赖不容易下载，因此我们需要针对gopath做一些配置

```bash
cd $GOPATH
mkdir src pkg bin
cd src
mkdir -p github.com/golang
mkdir -p golang.org/x
cd github.com/golang
git clone https://github.com/golang/tools.git tools
# 如果网速过慢，也可以从gitee.com上面clone
git clone https://gitee.com/golang_github_clone/tools.git tools
cp -r tools ../../golang.org/x
```

## 2、vscode插件安装

![image-20200917033417631](01-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA.assets/image-20200917033417631.png)

## 3、创建文件main.go

![image-20200917033518553](01-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA.assets/image-20200917033518553.png)

这个时候会在右下角提示安装插件选择"install all"

```bash
go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/golang/lint/golint
go get -u -v github.com/lukehoban/go-find-references
go get -u -v github.com/lukehoban/go-outline
go get -u -v sourcegraph.com/sqs/goreturns
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v github.com/tpng/gopkgs
go get -u -v github.com/newhook/go-symbols
```

## 4、配置vscode

### 4.1 settings.json

```json
"files.autoSave":"onFocusChange",
"go.autocompleteUnimportedPackages": true, 
"go.gocodePackageLookupMode": "go", 
"go.gotoSymbol.includeImports": true, 
"go.useCodeSnippetsOnFunctionSuggest": true, 
"go.inferGopath": true, 
"go.useCodeSnippetsOnFunctionSuggestWithoutType": true,
"go.gopath":"/Users/chenshijie/Tools/go/global"
```

### 4.2 执行项目级settings.json

Alt+shift+p 选择"打开工作区设置json"

![image-20200917040459008](01-vscode%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA.assets/image-20200917040459008.png)

配置如下内容

```json
{
    "gopath": "项目模块根路径"
}
```

