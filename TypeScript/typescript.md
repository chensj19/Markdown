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

      ```js
      cnpm i @types/node -D
      ```

   4. 编写`HelloWorld.ts`文件，然后进行保存，代码如下。

   ```livecodeserver
   var a:string = "HelloWorld"console.log(a)
   ```

   1. 在Vscode的任务菜单下，打开运行生成任务，然后选择tsc：构建-tsconfig.json，这时候就会生成一个`helloWorld.js`文件
   2. 在终端中输入`node helloWorld.js`就可以看到结果了。

   **总结：**这节课虽然简单，但是小伙伴们一定要动手操作，如果不操作，或者开发环境配置不好，下面的课程就不好学习了。

## 3. 变量类型


