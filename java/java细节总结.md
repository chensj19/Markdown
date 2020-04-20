## 1、`application/json`参数接收

`content-type:application/json`参数接收

使用`ajax`请求的时候，设置如下的情况时：

```js
$.ajax({
            url: Common.getRootPath() + '/admin/rolemodule/add',
            dataType: 'json',
            contentType :'application/json',
            data:  JSON.stringify(roleModule),
            type: "post",
            async: false,
            cache: false,
            success: function (result) {
                var _result = result;
                if (_result.status == Common.SUCCESS) {
                    $('#treeModal').modal('hide');
                }
            },
            error :function (msg) {
                alert(msg.statusText);
                console.log(msg);
            }
        });
```

后台接收的时候处理如下：

```java
public Map<String, Object> addModPopedomMapping(@RequestBody List<SysModPopedom> modPopedomList) {
       super.getFacade().getSysModPopedomService().createSysModPopedomByList(modPopedomList);
       Map<String, Object> result = new HashMap<String, Object>(6);;
       result.put("status", Constants.SUCCESS);
       return result;
   }
```

使用`@RequestBody`进行参数的接收

> **@RequestBody**该注解常用来处理Content-Type: 不是application/x-www-form-urlencoded编码的内容，例如application/json, application/xml等；
>
> **@RequestParam**用来处理ContentType: 为 application/x-www-form-urlencoded编码的内容

# 2、getResource

比较`Class.getResource`与`ClassLoader.getResource`

## 2.1 `Class.getResource`

该方法接收一个表示文件路径的数，返回一个URL对象，该URL对象表示的name指向的那个资源（文件）。这个方法是在类中根据name获取资源。其中，name可以是文件的***相对路径（相对于该class类来说）***，也可以是***绝对路径（绝对路径的话，根目录符号/是代表项目路径而不是磁盘的根目录）***。



## 2.2 `ClassLoader.getResource`

该方法的作用与**`class.getResource(name)`**的作用一样，接收一个表示路径的参数，返回一个URL对象，该URL对象表示name对应的资源（文件）。但是，与**`class.getResource(name)`**不同的是，该方法**只能接收一个相对路径**，***不能接收绝对路径***如/xxx/xxx。并且，***接收的相对路径是相对于项目的包的根目录来说的***。



## 2.3 对比

1. 假定在根目录下面有一个application.yml文件，下面就是通过上述两种方式获取同一个文件的区别：

   ```java
   this.getClass().getResource("/application.yml").getPath()
   this.getClass().getClassLoader().getResource("application.yml").getPath()
   
   MainTest.class.getResource("/application.yml").getPath();
   MainTest.class.getClassLoader().getResource("application.yml").getPath()
   ```
2. 加载初始路径也是不同的

   `Class.getResource`默认是类所在的路径
   
   `ClassLoader.getResource`默认是项目根路径

   ```java
   this.getClass().getResource("").getPath()
   // /E:/11_VSTS_GIT/winning-devops/winning-devops/winning-devops-common/target/classes/com/winning/devops/util/
   this.getClass().getClassLoader().getResource("").getPath()
   ///E:/11_VSTS_GIT/winning-devops/winning-devops/winning-devops-common/target/classes/
   
   MainTest.class.getResource("").getPath();
   // /E:/11_VSTS_GIT/winning-devops/winning-devops/winning-devops-common/target/classes/com/winning/devops/util/
   MainTest.class.getClassLoader().getResource("").getPath()
   // /E:/11_VSTS_GIT/winning-devops/winning-devops/winning-devops-common/target/classes/
   ```
   
   