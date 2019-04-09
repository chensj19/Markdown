## 1、`content-type:application/json`参数接收

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