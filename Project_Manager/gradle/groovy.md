# Groovy 基础

## 前言

Android方向的第一期文章，会专注于Gradle系列，名字叫做『 Gradle从入门到实战』，计划有如下几个课程：

* Groovy基础

* 全面理解Gradle

* 如何创建Gradle插件

* 分析Android的build tools插件

* 实战，从0到1完成一款Gradle插件

本篇文章讲解Groovy基础。为什么是Groovy基础呢，因为玩转Gradle并不需要学习Groovy的全部细节。Groovy是一门jvm语言，功能比较强大，细节也很多，全部学习的话比较耗时，对我们来说收益较小。

### 为什么是Gradle？

Gradle是目前Android主流的构建工具，不管你是通过命令行还是通过AndroidStudio来build，最终都是通过Gradle来实现的。所以学习Gradle非常重要。

目前国内对Android领域的探索已经越来越深，不少技术领域如插件化、热修复、构建系统等都对Gradle有迫切的需求，不懂Gradle将无法完成上述事情。所以Gradle必须要学习。

### 如何学习Gradle？

大部分人对Gradle表示一脸懵逼，每当遇到一个问题的时候都需要从网上去查，这是一个误区。

Gradle不单单是一个配置脚本，它的背后是几门语言，如果硬让我说，我认为是三门语言。

* Groovy Language
* Gradle DSL
* Android DSL

DSL的全称是Domain Specific Language，即领域特定语言，或者直接翻译成“特定领域的语言”，算了，再直接点，其实就是这个语言不通用，只能用于特定的某个领域，俗称“小语言”。因此DSL也是语言。

在你不懂这三门语言的情况下，你很难达到精通Gradle的程度。这个时候从网上搜索，或者自己记忆的一些配置，其实对你来说是很大的负担。但是把它们当做语言来学习，则不需要记忆这些配置，因为语言都是有文档的，我们只需要学语法然后查文档即可，没错，这就是学习方法，这就是正道。

你需要做什么呢？跟着我学习就行啦！下面步入正题，让我们来开始学习Groovy的基本语法。

### Groovy和Java的关系

Groovy是一门jvm语言，它最终是要编译成class文件然后在jvm上执行，所以Java语言的特性Groovy都支持，我们完全可以混写Java和Groovy。

既然如此，那Groovy的优势是什么呢？简单来说，Groovy提供了更加灵活简单的语法，大量的语法糖以及闭包特性可以让你用更少的代码来实现和Java同样的功能。比如解析xml文件，Groovy就非常方便，只需要几行代码就能搞定，而如果用Java则需要几十行代码。

### Groovy的变量和方法声明

在Groovy中，通过 def 关键字来声明变量和方法，比如：

```groovy
def a = 1;
def b = "hello world";
def int c = 1;

def hello() {
   println ("hello world");
   return 1;
}
```




在Groovy中，很多东西都是可以省略的，比如

* 语句后面的分号是可以省略的
* 变量的类型和方法的返回值也是可以省略的
* 方法调用时，括号也是可以省略的
* 甚至语句中的return都是可以省略的

所以上面的代码也可以写成如下形式：

```groovy
def a = 1
def b = "hello world"
def int c = 1

def hello() {
   println "hello world" // 方法调用省略括号
   1;                    // 方法返回值省略return
}

def hello(String msg) {
   println (msg)
}

// 方法省略参数类型
int hello(msg) {
   println (msg)
   return 1
}

// 方法省略参数类型
int hello(msg) {
   println msg
   return 1 // 这个return不能省略
   println "done"
}
```
### 总结

* 在Groovy中，类型是弱化的，所有的类型都可以动态推断，但是Groovy仍然是强类型的语言，类型不匹配仍然会报错；

* 在Groovy中很多东西都可以省略，所以寻找一种自己喜欢的写法；

* Groovy中的注释和Java中相同。

## Groovy 学习

### Groovy 基础语法

#### Groovy变量

##### Groovy变量类型

​	类型包含基本类型和对象类型，基本类型与Java中基本类型是一样的，注意一点，在Groovy中基本类型也是**对象类型**。

```groovy
// 在Groovy中 基本类型都是对象
int x = 10
double d = 3.14

println x.class
println d.class
// 结果
class java.lang.Integer
class java.lang.Double
```

##### Groovy变量定义

变量定义分为两种类型，强类型定义和弱类型定义

* 强类型定义

  ```groovy
  int x = 10
  ```

* 弱类型定义

使用def定义变量，编译器会根据后面的类型来指定类型

```groovy
def a = 1
def b = 3.14
def c = 'dddd'
println(a.class)
println(b.class)
println(c.class)
// 结果
class java.lang.Integer
class java.math.BigDecimal
class java.lang.String
```

强类型定义与弱类型定义使用的区别

* 不对外使用，只有自己使用的情况下，可以使用def来定义即可

* 提供给其他模块使用，需要保证参数正确性，使用强类型定义
* def定义存在一个问题，当对应值发生改变后，可以自动完成类型转换，如果用于传递参数，则无法确定指定类型，def在定义类型的时候指定的类型是Object类型

```groovy
def c = 'dddd'
println(c.class)
c = 1.2
println(c.class)
// 结果
class java.lang.String
class java.math.BigDecimal
```

#### Groovy字符串

在Groovy中定义了两种类型的字符串，一种是String，另一种是GString

##### String定义方式

```groovy
// 字符串
def name = 'This is String'
println(name.class)

def thupleName = '''This is a Tuple String'''
println(thupleName.class)

// 上述两种字符串定义方式的区别主要在于后一种可以定义格式

def all_name = '''
 David
 Tom
 Green
'''
println(all_name)

def double_name = "This common module"
println("double_name")
println(double_name.class)
```

单引号定义：不可变字符串

三引号定义：可以书写格式的不可变字符串

双引号定义：可扩展字符串，可以在内部使用变量

```groovy
println('GString')
def aname = 'demo'
def hello = "hello ${aname}"
println(hello)
println(hello.class)
// 结果
hello demo
class org.codehaus.groovy.runtime.GStringImp
// 在字符串中使用表达式
println('在字符串中使用表达式')
// 可扩展做任意的表达式
def sum = "The sum is of 2 add 3 equals ${ 2 + 3}"
println(sum)
```

注意如下代码

```groovy
println('String GString Convert')

String echo(String message){
    return message
}

def result = echo(sum)
println(result)
```

> 结果显示上述代码运行正常，也就是说，在实际代码中GString和String是可以互转的

##### String 方法

在Groovy中，String方法来源如下图：

* 方法来源
  * java.lang.String
  * DefaultGroovyMethod Groovy中默认方法实现
  * StringGroovyMethod String的默认方法实现，继承DefaultGroovyMethod 重写适用于String
    * 按照参数类型可以分为两类
    * 普通类型参数
    * 闭包类型参数

```groovy
/*========================= 字符串方法 ===============================================*/
// 字符串填充
// center 字符串填充，以当前字符串为中心，两边填充
// 第一个参数指定填充后字符串长度，第二个参数指定填充的内容，不填则为空格
def str = 'Groovy'
println str.center(8,'1')
// padLeft 字符串填充，从当前字符串左边填充 参数同center
println str.padLeft(8,'1')
// padLeft 字符串填充，从当前字符串右边填充
println str.padRight(8,'1')
// 字符串对比 可以使用方法compareTo，也可以使用操作符 > < =
def str2 = 'Hello'
// 比较的是两个字符串的Unicode编码
println(str > str2)

// 索引
// java 结果 G
println(str.getAt(0))
// groovy  结果 G
println(str[0])
// 传入范围 结果 Gr
println(str[0..1])

// 减法 结果 Groovy 因为没有包含指定的值
println(str.minus(str2))
println(str - str2)

str = "hello groovy"
str2 = "hello"
println("minus")
println("str:${str}")
println("str2:${str2}")
println("str - str2:${str - str2}")

// reverse 反转 倒序
println("String reverse:${str.reverse()}")

// 首字母大写 仅限于首字母
println("首字母大写:${str.capitalize()}")

// 判断是否是数字型字符串
println("String is Number String:${str.isNumber()}")
// 可以通过使用toInteger/toLong等转换为指定的数字类型
str = '12345'
println("String to Integet:${str.toInteger()}")
```

####  逻辑控制

* 逻辑控制

  * 顺序逻辑

    * 单步往下执行

  * 条件逻辑

    * if/else

    * switch/case

      ```groovy
      // switch 支持任意类型的类型匹配
      def x = 1.23
      def result
      switch (x) {
          case 'foo':
              result = 'found foo'
              break
          case 'bar':
              result = 'found bar'
              break
          case [1,2,3, 'list']:  // 列表
              result = 'found list'
              break
          case 12..30: // 范围
              result = 'in range'
              break
          case Integer:
              result = 'Integer'
              break
          case BigDecimal:
              result = 'BigDecimal'
              break
          default:
              result = 'default'
              break
      }
      println(result)
      ```

  * 循环逻辑

    * while循环
    * for循环

    ```groovy
    // 对范围的for循环
    def sum = 0
    for ( i in 0..9) {
        sum +=i
    }
    println(sum)
    /*对list的循环*/
    sum = 0
    for(i in [1,2,3,4,5,6,7,8,9]){
        sum += i
    }
    println(sum)
    /*对map循环*/
    sum = 0
    for (item in ['d1':1,'d2':2,'d3':3,'d4':4,'d5':5]){
        sum += item.value
    }
    println(sum)
    ```

### Groovy 闭包

Groovy中有一种特殊的类型，叫做Closure，翻译过来就是闭包，这是一种类似于C语言中函数指针的东西。闭包用起来非常方便，在Groovy中，闭包作为一种特殊的数据类型而存在，闭包可以作为方法的参数和返回值，也可以作为一个变量而存在。

#### 闭包基础

主要内容如下

* 闭包基础

  * 闭包概念

    * 闭包定义

      ```groovy
      // 闭包定义
      def closu = { println('This is Closure')}
      ```

    * 闭包调用

      ```groovy
      // 闭包调用
      closu.call()
      closu()
      ```

  * 闭包参数

    * 普通参数

    ```groovy
    // 闭包参数 箭头前为参数，后面为闭包体
    def closure_param = { name -> println("Hello ${name}, welcome to groovy wrold!")}
    // 调用
    closure_param('aaaa')
    closure_param.call('bbbb')
    // 多参数
    closure_param = { name,age -> println("Hello ${name}, age is ${age} ,welcome to groovy wrold!")}
    // 调用
    closure_param('aa',20)
    ```

    * 隐式参数

    ```groovy
    // 隐式参数
    closure_param = { println("Hello , ${it}")}
    // 调用
    closure_param('ccc')
    // 隐式参数 默认情况下是null
    closure_param =  { println("Hello , ${it}")}
    // 调用
    closure_param();
    ```

  * 闭包返回值

    * 返回值获取

    ```groovy
    println('闭包的返回值')
    // 使用return获取返回值
    closure_param = {name -> return "Hello , ${name} !"}
    def result = closure_param('Groovy')
    println(result) // 返回 Hello , Groovy !
    // 不使用return
    closure_param = {name -> println( "Hello , ${name} !")}
    result = closure_param('Groovy')
    println(result) // 返回null
    ```

    > 闭包都是有返回值的

#### 闭包使用

* 闭包使用

  * 与基本类型的集合使用

  ```groovy
  //- 与基本类型的集合使用
  int x = 10
  // upto 用来求num的阶乘
  static int fab(int num){
      int result = 1;
      1.upto(num,{n -> result *= n})
      return result;
  }
  def result = fab(x)
  println(result)
  // downto 用来求num的阶乘
  static int fab2(int num){
      int result = 1;
      num.downto(1){
          n ->  result *=n
      }
      return result
  }
  result = fab2(x)
  println(result)
  // times 方法，不能用来获取阶乘，源码中index从0开始
  static int count(num){
      int result = 0
      num.times {
          n -> result += n
      }
      return result
  }
  
  result = count(x)
  println(result)
  ```

  > 闭包中传入参数的数量需要通过源码来进行确定，比如upto方法
  >
  > ```groovy
  > public static void upto(Number self, Number to, @ClosureParams(FirstParam.class) Closure closure) {
  >         int self1 = self.intValue();
  >         int to1 = to.intValue();
  >         if (self1 <= to1) {
  >             for (int i = self1; i <= to1; i++) {
  >                // 闭包使用参数的数量与参数类型确定
  >                 closure.call(i);
  >             }
  >         } else
  >             throw new GroovyRuntimeException("The argument (" + to +
  >                     ") to upto() cannot be less than the value (" + self + ") it's called on.");
  >     }
  > ```
  >
  
* 与String结合使用
  * 与数据结构结合使用
  * 与文件等结合使用

#### 闭包进阶使用





### Groovy 数据结构

### Groovy 面向对象

## Groovy的数据类型

  在Groovy中，数据类型有：

* Java中的基本数据类型
* Java中的对象
* Closure（闭包）
* 加强的List、Map等集合类型
* 加强的File、Stream等IO类型
  类型可以显示声明，也可以用`def`来声明，用`def`声明的类型Groovy将会进行类型推断。

基本数据类型和对象这里不再多说，和Java中的一致，只不过在Gradle中，对象默认的修饰符为public。下面主要说下String、闭包、集合和IO等。

####  1.String

String的特色在于字符串的拼接，比如
```groovy
def a = 1
def b = "hello"
def c = "a=${a}, b=${b}"
println c

outputs:
a=1, b=hello
```

#### 2. 闭包

Groovy中有一种特殊的类型，叫做Closure，翻译过来就是闭包，这是一种类似于C语言中函数指针的东西。闭包用起来非常方便，在Groovy中，闭包作为一种特殊的数据类型而存在，闭包可以作为方法的参数和返回值，也可以作为一个变量而存在。

如何声明闭包？
```groovy
{ parameters ->
   code
}
```
闭包可以有返回值和参数，当然也可以没有。下面是几个具体的例子：
```groovy
def closure = { int a, String b ->
   println "a=${a}, b=${b}, I am a closure!"
}

// 这里省略了闭包的参数类型
def test = { a, b ->
   println "a=${a}, b=${b}, I am a closure!"
}

def ryg = { a, b ->
   a + b
}

closure(100, "renyugang")
test.call(100, 200)
def c = ryg(100,200)
println c
```
闭包可以当做函数一样使用，在上面的例子中，将会得到如下输出：
```groovy
a=100, b=renyugang, I am a closure!
a=100, b=200, I am a closure!
300
```
另外，如果闭包不指定参数，那么它会有一个隐含的参数 it

// 这里省略了闭包的参数类型
```groovy
def test = {
   println "find ${it}, I am a closure!"
}
test(100)

outputs:
find 100, I am a closure! 
```
闭包的一个难题是如何确定闭包的参数，尤其当我们调用Groovy的API时，这个时候没有其他办法，只有查询Groovy的文档：

http://www.groovy-lang.org/api.html

http://docs.groovy-lang.org/latest/html/groovy-jdk/index-all.html

下面会结合具体的例子来说明如何查文档。

#### 3. List和Map

Groovy加强了Java中的集合类，比如List、Map、Set等。

List的使用如下：
```groovy
def emptyList = []

def test = [100, "hello", true]
test[1] = "world"
println test[0]
println test[1]
test << 200
println test.size

outputs:
100
world
4
```
List还有一种看起来很奇怪的操作符`<<`，其实这并没有什么大不了，左移位表示向List中添加新元素的意思，这一点从文档当也能查到。

![](https://img-blog.csdn.net/20170726140909724)

其实Map也有左移操作，这如果不查文档，将会非常费解。

Map的使用如下：
```groovy
def emptyMap = [:]
def test = ["id":1, "name":"renyugang", "isMale":true]
test["id"] = 2
test.id = 900
println test.id
println test.isMale

outputs:
900
true
```
可以看到，通过Groovy来操作List和Map显然比Java简单的多。

这里借助Map再讲述下如何确定闭包的参数。比如我们想遍历一个Map，我们想采用Groovy的方式，通过查看文档，发现它有如下两个方法，看起来和遍历有关：

![](https://img-blog.csdn.net/20170726141108426)

可以发现，这两个each方法的参数都是一个闭包，那么我们如何知道闭包的参数呢？当然不能靠猜，还是要查文档。

![](https://img-blog.csdn.net/20170726141135044)

通过文档可以发现，这个闭包的参数还是不确定的，如果我们传递的闭包是一个参数，那么它就把entry作为参数；如果我们传递的闭包是2个参数，那么它就把key和value作为参数。

按照这种提示，我们来尝试遍历下：
```groovy
def emptyMap = [:]
def test = ["id":1, "name":"renyugang", "isMale":true]

test.each { key, value ->
   println "two parameters, find [${key} : ${value}]"
}

test.each {
   println "one parameters, find [${it.key} : ${it.value}]"
}

outputs:
two parameters, find [id : 1]
two parameters, find [name : renyugang]
two parameters, find [isMale : true]

one parameters, find [id : 1]
one parameters, find [name : renyugang]
one parameters, find [isMale : true]
```
另外一个eachWithIndex方法教给大家练习，自己查文档，然后尝试用这个方法去遍历。

试想一下，如果你不知道查文档，你又怎么知道each方法如何使用呢？光靠从网上搜，API文档中那么多接口，搜的过来吗？记得住吗？

#### 4. 加强的IO

在Groovy中，文件访问要比Java简单的多，不管是普通文件还是xml文件。怎么使用呢？还是来查文档。

![](https://img-blog.csdn.net/20170726141155161)

根据File的eachLine方法，我们可以写出如下遍历代码，可以看到，eachLine方法也是支持1个或2个参数的，这两个参数分别是什么意思，就需要我们学会读文档了，一味地从网上搜例子，多累啊，而且很难彻底掌握：
```groovy
def file = new File("a.txt")
println "read file using two parameters"
file.eachLine { line, lineNo ->
   println "${lineNo} ${line}"
}

println "read file using one parameters"
file.eachLine { line ->
   println "${line}"
}

outputs:
read file using two parameters
1 欢迎
2 关注
3 玉刚说

read file using one parameters
欢迎
关注
玉刚说
```
除了eachLine，File还提供了很多Java所没有的方法，大家需要浏览下大概有哪些方法，然后需要用的时候再去查就行了，这就是学习Groovy的正道。

下面我们再来看看访问xml文件，也是比Java中简单多了。
Groovy访问xml有两个类：XmlParser和XmlSlurper，二者几乎一样，在性能上有细微的差别，如果大家感兴趣可以从文档上去了解细节，不过这对于本文不重要。

在下面的链接中找到XmlParser的API文档，参照例子即可编程，

http://docs.groovy-lang.org/docs/latest/html/api/。

假设我们有一个xml，attrs.xml，如下所示：
```groovy
<resources>
    <declare-styleable name="CircleView">
       <attr name="circle_color" format="color">#98ff02</attr>
       <attr name="circle_size" format="integer">100</attr>
       <attr name="circle_title" format="string">renyugang</attr>
    </declare-styleable>
</resources>
```
那么如何遍历它呢？
```groovy
def xml = new XmlParser().parse(new File("attrs.xml"))
// 访问declare-styleable节点的name属性
println xml['declare-styleable'].@name[0]

// 访问declare-styleable的第三个子节点的内容
println xml['declare-styleable'].attr[2].text()


outputs：
CircleView
renyugang
```
更多的细节都可以从我发的那个链接中查到，大家有需要查文档即可。

## Groovy的其他特性

除了本文中已经分析的特性外，Groovy还有其他特性。

### Class是一等公民

在Groovy中，所有的Class类型，都可以省略.class，比如：

```groovy
func(File.class)
func(File)

def func(Class clazz) {
}
```
### Getter和Setter

在Groovy中，Getter/Setter和属性是默认关联的，比如：

```
class Book {
   private String name
   String getName() { return name }
   void setName(String name) { this.name = name }
}

class Book {
   String name
}
```
上述两个类完全一致，只有有属性就有Getter/Setter；同理，只要有Getter/Setter，那么它就有隐含属性。

### with操作符

在Groovy中，当对同一个对象进行操作时，可以使用with，比如：

```
Book bk = new Book()
bk.id = 1
bk.name = "android art"
bk.press = "china press"

可以简写为：
Book bk = new Book() 
bk.with {
   id = 1
   name = "android art"
   press = "china press"
}
```
### 判断是否为真

在Groovy中，判断是否为真可以更简洁：

```
if (name != null && name.length > 0) {}

可以替换为：
if (name) {}
```
### 简洁的三元表达式

在Groovy中，三元表达式可以更加简洁，比如：

```
def result = name != null ? name : "Unknown"

// 省略了name
def result = name ?: "Unknown"

```
### 简洁的非空判断

在Groovy中，非空判断可以用?表达式，比如：

```
if (order != null) {
   if (order.getCustomer() != null) {
       if (order.getCustomer().getAddress() != null) {
       System.out.println(order.getCustomer().getAddress());
       }
   }
}

可以简写为：
println order?.customer?.address
```
### 使用断言

在Groovy中，可以使用assert来设置断言，当断言的条件为false时，程序将会抛出异常：

```
def check(String name) {
   // name non-null and non-empty according to Gro    ovy Truth
   assert name
   // safe navigation + Groovy Truth to check
   assert name?.size() > 3
}

```
### switch方法

在Groovy中，switch方法变得更加灵活，可以同时支持更多的参数类型：

```
def x = 1.23
def result = ""
switch (x) {
   case "foo": result = "found foo"
   // lets fall through
   case "bar": result += "bar"
   case [4, 5, 6, 'inList']: result = "list"
   break
   case 12..30: result = "range"
   break
   case Integer: result = "integer"
   break
   case Number: result = "number"
   break
   case { it > 3 }: result = "number > 3"
   break
   default: result = "default"
}
assert result == "number"
```
### ==和equals

在Groovy中，==相当于Java的equals，，如果需要比较两个对象是否是同一个，需要使用.is()。

```
Object a = new Object()
Object b = a.clone()

assert a == b
assert !a.is(b)

```
本小节参考了如下文章，十分感谢原作者的付出：

1. http://www.jianshu.com/p/ba55dc163dfd

## 编译、运行Groovy
可以安装Groovy sdk来编译和运行。但是我并不想搞那么麻烦，毕竟我们的最终目的只是学习Gradle。

推荐大家通过这种方式来编译和运行Groovy。

在当面目录下创建build.gradle文件，在里面创建一个task，然后在task中编写Groovy代码即可，如下所示：
```groovy
task(yugangshuo).doLast {
   println "start execute yuangshuo"
   haveFun()
}

def haveFun() {
   println "have fun!"
   System.out.println("have fun!");
   1
   def file1 = new File("a.txt")
   def file2 = new File("a.txt")
   assert file1 == file2
   assert !file1.is(file2)
}

class Book {
   private String name
   String getName() { return name }
   void setName(String name) { this.name = name }
}
```
只需要在haveFun方法中编写Groovy代码即可，如下命令即可运行：

gradle yugangshuo

 