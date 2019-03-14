# Stylus

Stylus与Less、Sass一样，是一种CSS编程语言

Stylus出现比较晚，因此语法比较新

- **富于表现力、具有健壮性、功能丰富、动态编码**
- **不需要写CSS的冒号、分号、大括号**
- **和LESS、SASS功能类似，会这些的入手很快**

## 安装

- 1.安装node+npm环境

- 2.命令行全局安装stylus

  > cnpm i stylus@latest -g

- 3.可以在命令行输入 `stylus -h` 查看有哪些可以用的命令

## 使用
1. 想将assets/css目录下的所有.styl文件编译成css怎么办？ 

   ```stylus
    stylus -c assets/css/
   ```

2. 只想将assets/css/index.styl 编译成assets/css/index.css？ 

      ```stylus
stylus -c assets/css/index.styl assets/css/index.css
      ```

3. 想将assets/css/index.css 编译成assets/css/index.styl？

 ```stylus
stylus -C assets/css/index.css
 ```

4. 不想这么麻烦的用命令怎么办？使用webstorm设置如图可以自动将.styl文件转成.css文件 

![](https://img-blog.csdn.net/20180525212025227?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 ![](https://img-blog.csdn.net/2018052521220362?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

-  4-1.注意第二张图是默认配置，无需修改，直接确定。
-  4-2.如果配置都是空的，可以安装我的配置填写。
-  4-3.如果Program项出现红色报错！是因为node环境有问题或者没有全局安装stylus
-  4-4.接下来只需要编写.styl文件就会自动编译出.css文件。如图 

![](https://img-blog.csdn.net/20180525212734770?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

5. vue中使用stylus, 命令行中输入cnpm i stylus --save-dev
   5.1在 .vue文件中使用, 添加使用 scoped 属性表示样式只对当前组件有效

<style scoped lang="stylus">
  html,body
    margin 0
    padding 0
    div
       color #333
</style>
## stylus语法

### (一)选择器

- 1.冒号,分号,大括号可写可不写
- 2.后代关系用相同缩进表示
- 3.父子关系用 `>`表示
- 4.伪类元素用 `&` 表示其宿主元素
- 5.属性写在前, 嵌套子元素样式写在后
- 6.分组选择器用相同缩进即可, 如 `+a` `+span` `+span` 

![](https://img-blog.csdn.net/20180525223452579?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### (二)变量
1. 定义变量并赋值(建议用$作为变量前缀), 如$width=3px
2. 定义函数(arguments为内置所有参数, 也可自定义参数), border() $width dashed #foo
3. 函数参数可以写默认值,类似于es6的解构赋值, 如 padding(top=1px,right=2px)
4. 方法名加() 为调用函数,如 border()
5. 建议变量定义在最上面, 然后是函数, 然后才是代码. 最好的方式是变量和函数定义成单独的文件, 然后通过@import variable.styl 导入
6. 使用@height 会冒泡查找值, 如自身有此属性则获取该属性值; 否则层层向上查找该属性, 如果都没有则报错
7. 可以使用运算符进行计算
8. z-index 1 unless @z-index 表示默认 z-index=1 除非 @z-index 存在 

![](https://img-blog.csdn.net/20180526001301529?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### (三)插值

- 1.实现类似 `autoprefixer.css` 的效果给兼容属性加前缀
- 2.使用循环 `for in` 减少代码量
- 3.使用 `if-else` 判断逻辑 

![](https://img-blog.csdn.net/2018052600573986?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

### (四)运算符
```stylus
[]
! ~ + -
is defined
** * / %
+ -
  ... ..
  <= >= < >
  in
  == is != is not isnt
  is a
  && and || or
  ?:
  = := ?= += -= *= /= %=
  not
  if unless
```

### (五)内置函数
函数实例	值	说明
unit(14%,px)	14px	直接用第二个参数替换第一个参数的
abs(-5px)	5px	
ceil(2.3px)	3px	向上取整
floor(2.6px)	2px	向下取整
round(2.6px)	3px	四舍五入取整
min(1,2)	1	
max(1,2)	2	
even(3)	false	是否为偶数
odd(3)	true	是否为奇数
sum(1 2 3)	6	
avg(1 2 3)	2	
join(‘,’,1 2 3)	1 2 3	使用第一个参数为连接符将后面数组连接
length(1 2 3 4)	4	
image-size(‘aa.png’)	20px 30px	获取图片宽高

###  (六)尾参数

1. 可以使用 args... 或者 arr... 等接受所有参数; 前面也可以单个接受参数; 但是 尾参数写法只能作为最后一个参数
2. 也可以使用 args[0] 或者 arguments[0] 这种下标的方式访问
3. args... 会忽略 , ;如果希望不忽略请使用 arguments

![](https://img-blog.csdn.net/2018052601084449?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)



### (七)@extend继承

1. 使用 `@extend` 将公共样式抽取, 用子类继承; 在html中可以少写一个类名 ,如 `class="btn btn-primary"` 只需要写成 `class="btn-primary"` 

![](https://img-blog.csdn.net/20180526004238570?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2x5dF9hbmd1bGFyanM=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

