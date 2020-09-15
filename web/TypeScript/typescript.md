# TypeScript

Node.js之父瑞安达尔（Ryan Dahl）发布新的开源项目 deno，从官方介绍来看，可以认为它是下一代 Node，使用 Go 语言代替 C++ 重新编写跨平台底层内核驱动，上层仍然使用 V8 引擎，最终提供一个安全的 TypeScript 运行时。

## 1. TypeScript 简介

###  1.1 TypeScript是什么？

TypeScript 是一种由微软开发的自由和开源的编程语言。它是 JavaScript 的一个超集，TypeScript 在 JavaScript 的基础上添加了可选的静态类型和基于类的面向对象编程。

其实TypeScript就是相当于JavaScript的增强版，但是最后运行时还要编译成JavaScript。TypeScript最大的目的是让程序员更具创造性，提高生产力，它将极大增强JavaScript编写应用的开发和调试环节，让JavaScript能够方便用于编写大型应用和进行多人协作。

### 1.2 TypeScript和JavaScript的对比

TypeScript 与JavaScript两者的特性对比，主要表现为以下几点：

- TypeScript是一个应用程序级的JavaScript开发语言。（这也表示TypeScript比较牛逼，可以开发大型应用，或者说更适合开发大型应用）
- TypeScript是JavaScript的超集，可以编译成纯JavaScript。这个和我们CSS离的Less或者Sass是很像的，我们用更好的代码编写方式来进行编写，最后还是有好生成原生的JavaScript语言。
- TypeScript跨浏览器、跨操作系统、跨主机、且开源。由于最后他编译成了JavaScript所以只要能运行JS的地方，都可以运行我们写的程序，设置在node.js里。
- TypeScript始于JavaScript，终于JavaScript。遵循JavaScript的语法和语义，所以对于我们前端从业者来说，学习前来得心应手，并没有太大的难度。
- TypeScript可以重用JavaScript代码，调用流行的JavaScript库。
- TypeScript提供了类、模块和接口，更易于构建组件和维护。

## 2. 开发环境安装

1. 安装node.js

2. 安装TypeScript包

   ```bash
   npm install typescript -g
   tsc --version
   ```

3. 编写HelloWorld程序

   1. 初始化项目：进入你的编程文件夹后，可以使用`npm init -y`来初始化项目，生成package.json文件。

   2. 创建`tsconfig.json`文件，在终端中输入`tsc --init`：它是一个`TypeScript`项目的配置文件，可以通过读取它来设置`TypeScript`编译器的编译参数。

   3. 安装@types/node,使用`npm install @types/node --dev-save`进行安装。这个主要是解决模块的声明文件问题。

      ```cmd
      cnpm i @types/node -D
      ```

   4. 编写`HelloWorld.ts`文件，然后进行保存，代码如下。

   ```typescript
   var a:string = "HelloWorld"
   console.log(a)
```
   
   1. 在Vscode的任务菜单下，打开运行生成任务，然后选择tsc：构建-tsconfig.json，这时候就会生成一个`helloWorld.js`文件
2. 在终端中输入`node helloWorld.js`就可以看到结果了。
   
   **总结：**这节课虽然简单，但是小伙伴们一定要动手操作，如果不操作，或者开发环境配置不好，下面的课程就不好学习了。

## 3. 变量类型

TypeScript中的数据类型有：

- Undefined :
- Number:数值类型;
- string : 字符串类型;
- Boolean: 布尔类型；
- enum：枚举类型；
- any : 任意类型，一个牛X的类型；
- void：空类型；
- Array : 数组类型;
- Tuple : 元祖类型；
- Null ：空类型。

### Undefined类型

在js中当你定义了一个变量，但没有给他赋予任何值的时候，他就是Undefined类型。这可能和你以前学的语言稍有不同，其他语言会有个类型的默认值。

我们现在来看一个例子，比如我们要声明一个年龄的变量`age`,我们要使用数值类型，也就是`Number`,但是我们不给他任何的值，我们只是在控制台给它输出，然后我们来看结果。

新建demo01.ts文件，下入下面代码：

```typescript
//声明数值类型的变量age，但不予赋值var age:numberconsole.log(age)
```

写完后保存代码，进行运行任务，然后生成demo01.js，在终端中使用`node demo01.js`来进行查看运行结果。控制台输出了`undefined`,跟我们预想的一模一样。

### Number类型

在TypeScript中，所有的数字都是Number类型，这不分是整数还是小数。比如下面我们声明一个年龄是18岁，身高是178.5厘米。

新建一个文件demo01_1.ts文件，写入下面代码：

```typescript
var age:number = 18
var stature:number = 178.5
console.log(age)
console.log(stature)
```

然后执行转换，查看结果，我们可以在控制台看到结果已经顺利输出，没有任何意外。

**在TypeScrip中有几种特殊的Number类型** 我们需要额外注意一下：

- NaN：它是Not a Number 的简写，意思就是不是一个数值。如果一个计算结果或者函数的返回值本应该是数值，但是由于种种原因，他不是数字。出现这种状况不会报错，而是把它的结果看成了NaN。（这就好比我们去泰国外，找了一个大长腿、瓜子脸、水蛇腰的女神。房也开好了，澡也洗完了，发现跟我们的性别统一，我们只能吃个哑巴亏，你绝不会声张）
- Infinity :正无穷大。
- -Infinity：负无穷大。

### string类型

由单引号或者双引号括起来的一串字符就是字符串。比如：“技术胖”,'jspang.com'。看下面的代码：

demo01_2.ts

```typescript
var jspang:string = "技术胖 jspang.com"
console.log(jspang)
```

这时候控制图就会乖乖的输出`技术胖 jspang.com`.

### boolean布尔类型

作任何业务逻辑判断都要有布尔类型的参与，通过对与错的判断是最直观的逻辑处理。boolean类型只有两种值，true和false。

```groovy
var b:boolean = true
var c:boolean = false
```

### enum 类型

这个世界有很多值是多个并且是固定的，比如：

- 世界上人的类型：男人、女人、中性
- 一年的季节：春、夏、秋、冬 ，有四个结果。

这种变量的结果是固定的几个数据时，就是我们使用枚举类型的最好时机：

demo01_3.ts

```typescript
enum REN{ nan , nv ,yao}
console.log(REN.yao)  
//返回了2，这是索引index，跟数组很想。
```

如果我们想给这些枚举赋值，可以直接使用`=`,来进行赋值。

```typescript
enum REN{nan ='男',nv ='女',yao= '妖'}
console.log(REN.yao)  //返回了妖 这个字
```

### any类型

一个写惯了前端的人，有时候不自觉的就分不清类型了。这是个不好的习惯，也是前端的痛，就因为这个原因，JavaScript也多次被人诟病说大型项目不适合用JavaScript。但是习惯一旦养成，改是需要时间和磨练的。TypeScript友好的为我们提供了一种特殊的类型`any`，比如我们在程序中不断变化着类型，又不想让程序报错，这时候就可以使用any了。

```typescript
var t:any =10 
t = "jspang"
t = true
console.log(t)
```

Null类型：

与 Undefined 类似，都代表空。Null 代表是引用类型为空。意义不大，但是有用。后续学习中会使用到。

注意：剩余的数组、元组、void 会在后续的章节中讲解。

## 4.TypeScript的函数

比如现在我们有个找小姐姐的需求：

- 找18岁的小姐姐
- 找28岁的小姐姐
- 找38岁的小姐姐

这个时候你会怎么作？难道要把代码写3遍吗？也许新手会这样作的，但是作为一个有多年开车经验的老司机，技术胖肯定会建立一个找小姐姐的机器，这就是函数。

正经点说是：

我们可以把功能相近的需求封装成一个独立的代码块，每次传入不同的变量或参数，就可以实现不同的结果。

### 4.1 定义函数

函数就相当于一个工具，如果你想使用这个工具，就要先制作这个工具。这就是我们说的定义函数。在TypeScript里定义函数跟JavaScript稍微有些不同。我们来定义找小姐姐的函数吧。

```typescript
function searchXiaoJieJie(age:number):string{    return '找到了'+age+'岁的小姐姐' 
}
var age:number = 18
var result:string = searchXiaoJieJie(age)
console.log(result)
```

上面的程序，先用function关键字声明了一个`searchXiaoJieJie`的方法，然后我们使用了他，并返回了给我们结果。

需要注意的是：

1. 声明（定义）函数必须加 function 关键字；
2. 函数名与变量名一样，命名规则按照标识符规则；
3. 函数参数可有可无，多个参数之间用逗号隔开；
4. 每个参数参数由名字与类型组成，之间用分号隔开；
5. 函数的返回值可有可无，没有时，返回类型为 void；
6. 大括号中是函数体。

### 4.2 形参和实参

**形参的使用**

函数定义的时候写的参数是形参。从字面意义上我们可以看出，形参就是形式上的参数。我们定义了形参也就规定了此函数的参数个数和参数类型，规范了函数。

```typescript
function searchXiaoJieJie(age:number):string{    return '找到了'+age+'岁的小姐姐' 
}
```

比如这个函数，就定义了一个形参，它的类型是数值类型。

**实参的使用**

调用函数时传递的具体值就是实参。同样从字面理解，实参就是真实的参数，我们在使用的时候，具体真实传递过去的就是实参，比如18，20，22，这些具体的参数就是实参。

打个比方，我们去按摩，需要找技师，当我们还没有找的时候，这时候就是形参。当一个个技师站好了，让你选。你最终选择了一个，这就是实参。实参在真实使用时才传递。

```typescript
var result:string = searchXiaoJieJie(age)
```

**注意**

在函数调用的时候，我们需要按照形参的规则传递实参，有几个形参就要传递几个实参，并且每一个实参的类型要与对应的形参类型一致。

### 4.3 TypeScript语言中的函数参数

TypeScript的函数参数是比较灵活的，它不像那些早起出现的传统语言那么死板。在TypeScript语言中，函数的形参分为：可选形参、默认形参、剩余参数形参等。

**1.有可选参数的函数**

可选参数，就是我们定义形参的时候，可以定义一个可传可不传的参数。这种参数，在定义函数的时候通过`?`标注。

比如我们继续作找小姐姐的函数，这回不仅可以传递年龄，还可以选择性的传递身材。我们来看如何编写。

```typescript
function searchXiaoJieJie2(age:number,stature?:string):string{    
    let yy:string = ''    
    yy = '找到了'+age+'岁'    
    if(stature !=undefined){        
        yy = yy + stature    
    }    
    return yy+'的小姐姐'
}
var result:string  =  searchXiaoJieJie2(22,'大长腿')
console.log(result)
```

**2.有默认参数的函数**

**有默认参数**就更好理解了，就是我们不传递的时候，他会给我们一个默认值，而不是`undefined`了。我们改造上边的函数，也是两个参数，但是我们把年龄和身材都设置默认值，这就相当于熟客，我们直接来一句**照旧**是一样的。

```typescript
function searchXiaoJieJie2(age:number=18,stature:string='大胸'):string{    
    let yy:string = ''    
        yy = '找到了'+age+'岁'    
        if(stature !=undefined){        
            yy = yy + stature    
        }    
    return yy+'的小姐姐'
}
var result:string  =  searchXiaoJieJie2()
console.log(result)
```

**3.有剩余参数的函数**

有时候我们有这样的需求，我传递给函数的参数个数不确定。例如：我找小姐姐的时候有很多要求，个人眼光比较挑剔。这时候你不能限制我，我要随心所欲。

说的技术点，剩余参数就是形参是一个数组，传递几个实参过来都可以直接存在形参的数组中。

```typescript
function searchXiaoJieJie3(...xuqiu:string[]):string{    
    let  yy:string = '找到了'    
    for (let i =0;i<xuqiu.length;i++){        
        yy = yy + xuqiu[i]        
        if(i<xuqiu.length){            
            yy=yy+'、'        
        }    
    }    
    yy=yy+'的小姐姐'    
    return yy
}
var result:string  =  searchXiaoJieJie3('22岁','大长腿','瓜子脸','水蛇腰')
console.log(result)
```

有了这个参数形式，我们好像无所不能了，我爱编程，编程让我幸福。好吧，这节课我们就先到这里，下节课我们继续找小姐姐去。不是，不是，是继续学习。

## 5. 三种函数的定义方式

上节课用参数的形式来区分了TypeScript里函数的定义方法，但这并不能完全包含所有的定义方法，所以再以声明的形式，而不是参数来总结几个方法。

### 5.1 函数声明法

函数声明法创建函数是最常用的函数定义法。使用function关键字和函数名去定义一个函数。

```TypeScript
function add(n1:number,n2:number):number{    
	return n1+n2
}
```

### 5.2 函数表达式法

函数表达式法是将一个函数赋值给一个变量，这个变量名就是函数名。通过变量名就可以调用函数了。这种方式定义的函数，必须在定义之后，调用函数。下面例子中等号右边的函数没有函数名，称为匿名函数。

```typescript
var add = function(n1:number,n2:number):number{    
return n1+n2
}
console.log(add(1,4))
```

### 5.3 箭头函数

箭头函数是 ES6 中新增的函数定义的新方式，我们的 TypeScript 语言是完全支持 ES6 语法的。箭头函数定义的函数一般都用于回调函数中。

```typescript
var add = (n1:number,n2:number):number=>{    
    return n1+n2}console.log(add(1,4))
}
```

## 6.函数中变量的作用域

通过两节对TypeScript的学习，再加上如果你以前JavaScript的知识很扎实，你一定知道函数类似于一个封闭的盒子。盒子里面的世界和外面的世界是不一样的。有点像人的外在表现和内在性格，虽然相辅相成，相生相克，但是完全不一样。定义在函数内部的变量与定义在函数外部的变量也是不一样的，他们起作用的范围也不一样。

> 每个变量都有一个起作用的范围，这个范围就是变量的作用域。在TypeScript语言中变量作用域划分是以函数为标准的。

### 6.1 函数作用域演示

我们来举个例子，现在要制作一个整形的方法，然后在函数里用`var`定义一个`yangzi`的变量,我们再函数的外部读取这个变量，你会发现是读取不到的。

```javascript
function zhengXing():void{    var yangzi = '刘德华'    console.log(yangzi)}zhengXing()console.log(yangzi)
```

### 6.2 认识全局变量和局部变量

现在我们对函数的作用域有了一点了解，那么到底什么是全局变量，什么又是局部变量那？这个问题很多面试中都会提问，所以跟你的前途息息相关。

- **局部变量**：函数体内定义的变量就是局部变量。
- **全局变量**: 函数体外 定义的变量就是全局变量。

我们改造上边的程序，把`yangzi`办理移动到全局，然后再进行输出。

```javascript
var yangzi = '刘德华'function zhengXing():void{    console.log('技术胖整形成了'+yangzi+'的样子')}zhengXing()console.log(yangzi)
```

这时候`yangzi`变量是全局的，所以在函数内也可以调用，在函数外也可以调用。

### 6.3 局部变量和全局变量重名

当局部变量与全局变量重名的时候，在函数体内是局部变量起作用；如果重名，就有变量提升，这是一个坑，小伙伴们必须要注意

还是上边整形的例子，技术胖是想整形成刘德华，但是函数体内部声明了一个马德华。虽然一字之差，但是样子可是完全不同的。我们来看代码如何实现：

```typescript
var yangzi:string = '刘德华'
function zhengXing():void{    
    var yangzi:string = '马德华'    
    console.log('技术胖整形成了'+yangzi+'的样子')
}
zhengXing()
console.log(yangzi)
```

这回你会发现，技术胖并没有变成刘德华而是变成了马德华。那你说我我想变成刘德华，我在函数没声明新变量前打印到控制台行不行？

```typescript
var yangzi:string = '刘德华'
function zhengXing():void{    
    console.log('技术胖整形成了'+yangzi+'的样子')    
    var yangzi:string = '马德华'    
    console.log('技术胖整形成了'+yangzi+'的样子')
}
zhengXing()
console.log(yangzi)
```

代码改造成了这样，但是你会发现，我们输出的结果如下：

```actionscript
技术胖整形成了undefined的样子
```

产生这个结果的原因就是变量提升，他的真实代码是这样的。

```typescript
var yangzi:string = '刘德华'
function zhengXing():void{   
    var  yangzi:string     
    console.log('技术胖整形成了'+yangzi+'的样子')    
    yangzi = '马德华'    
    console.log('技术胖整形成了'+yangzi+'的样子')
}
zhengXing()
console.log(yangzi)
```

也就是当内部声明了和全局的变量同名时，就会出现变量提升的效果，声明语句会提升到函数的第一句。这就是著名的变量提升效果。

### 6.4 let关键字变量的作用域

在早期javascript的变量作用域只有全局和局部，并且是以函数划分的，但在其他语言中，作用域的划分是以一对大括号作为界限的。

所以，JavaScript就遭到了无数开发者的吐槽，甚至说javascript不适合开发大型语言，容易内存溢出。JavaScript团队意识到了这一点，在ES6中推出了let关键字。

使用let关键字的变量就是一个块级作用域变量。希望大家在实际工作中多使用let来声明你的变量，让你的程序更有条例。 来看一端程序：

```typescript
function zhengXing():void{   
    var yangzia:string = '刘德华' {           
    	let yangzib:string = '小沈阳'        
    	console.log('技术胖整形成了'+yangzib+'的样子')   
    }    
console.log('技术胖整形成了'+yangzia+'的样子')    
console.log('技术胖整形成了'+yangzib+'的样子')
}
zhengXing()
```

这时候编译后，我们运行，你会发现是可以执行的，并且打印到了控制台正确的结果。 这是因为ts编译成js，他自动给我们加了ES5的处理，ES5里是没有let关键字的，现在我们再改一下编译好的程序，你会发现`yangzib`这个关键字就找不到了（详情看视频吧）。