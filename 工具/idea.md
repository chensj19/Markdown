# idea

## 1、Command line is too long. Shorten command line for

报错内容:

> Error running 'ServiceStarter': Command line is too long. Shorten command line for ServiceStarter or also for Application default configuration.

解法:

> 修改项目下 .idea\workspace.xml，找到标签 <component name="PropertiesComponent"> ， 在标签里加一行 <property name="dynamic.classpath" value="true" />

## 2、方法注释

注释模板：

```bash
**
 * $description$
  $params$
  * @since 1.0.0
  * @author chensj
  * @return $returns$
  * @create $date$ $time$
  */
```

params 替换内容

```groovy
groovyScript("def result=''; def params=\"${_1}\".replaceAll('[\\\\[|\\\\]|\\\\s]', '').split(',').toList(); for(i = 0; i < params.size(); i++) {result+=' * @param ' + params[i] + ((i < params.size() - 1) ? '\\n' : '')}; return result", methodParameters())
```

