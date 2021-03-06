智能提示
* 安装命令
```bash
    npm install -g typings
```
* 查看版本
```bash
    typings --version
```
* 查询对应模块的typings对应
```bash
    typings search tape
```
* 根据名称查询
```bash
    typings search --name react
```

* 安装typings对应 本地安装
```bash
    typings install debug --save
```

* 开启提示
+ 第一种
 在需要进行只能提示的文件最上行增加提示信息文件所在目录
```js
    /// <reference path="./typings/index.d.ts" />
```
+  在项目所在目录增加一个名为`jsconfig.json`的空文件。

## 问题集
### exports、module.exports和export、export default 这几个的关系
```javascript
require: node 和 es6 都支持的引入
export / import : 只有es6 支持的导出引入
module.exports / exports: 只有 node 支持的导出
```
**什么意思？？？**
首先我们要明白一个前提，CommonJS模块规范和ES6模块规范完全是两种不同的概念。

## `CommonJS`模块规范
`Node`应用由模块组成，采用`CommonJS`模块规范。
根据这个规范，每个文件就是一个模块，有自己的作用域。在一个文件里面定义的变量、函数、类，都是私有的，对其他文件不可见。

+ `module.exports`/`require`
`CommonJS`规范规定，每个模块内部，`module`变量代表当前模块。
这个变量是一个对象，它的`exports`属性（即`module.exports`）是对外的接口。
加载某个模块，其实是加载该模块的`module.exports`属性。
```javascript
var x = 5;
var addX = function (value) {
  return value + x;
};
module.exports.x = x;
module.exports.addX = addX;
```
上面代码通过`module.exports`输出变量x和函数addX。

`require`方法用于加载模块。
```javascript
var example = require('./example.js');

console.log(example.x); // 5
console.log(example.addX(1)); // 6
```

+ `exports` 与 `module.exports`
为了方便，`Node`为每个模块提供一个`exports`变量，指向`module.exports`。这等同在每个模块头部，有一行这样的命令。
```javascript
var exports = module.exports;
```
于是我们可以直接在 `exports` 对象上添加方法，表示对外输出的接口，如同在`module.exports`上添加一样。
**注意，不能直接将exports变量指向一个值，因为这样等于切断了exports与module.exports的联系。**


## `ES6` 模块规范
不同于`CommonJS`，`ES6`使用 `export` 和 `import` 来导出、导入模块。
```javascript
// profile.js
var firstName = 'Michael';
var lastName = 'Jackson';
var year = 1958;

export {firstName, lastName, year};
```

需要特别注意的是，`export`命令规定的是对外的接口，必须与模块内部的变量建立一一对应关系。
```javascript
// 写法一
export var m = 1;

// 写法二
var m = 1;
export {m};

// 写法三
var n = 1;
export {n as m};
export default 命令
```

使用`export default`命令，为模块指定默认输出。
```javascript
// export-default.js
export default function () {
  console.log('foo');
}
```

综上所述： `require` 是在`ES6`和`node`都可以使用，
但是：`export`/`import`:是`ES6`提供的导出引入
     `module.exports` / `exports`: 只有 node 支持的导出
那么就可以导出这样的结论：
+ 按照规范分类
 - `module.exports`和`exports`是属于`CommonJS`模块规范！
 - `export`和`export default`是属于`ES6`语法
 - 同样`import`和`require`分别属于`ES6`和`CommonJS`！
+ 功能分类
 - `module.exports`和`exports`、`export`和`export default`都是导出模块；
 - `import`和`require`则是导入模块。

+ 组合使用
  - `module.exports`导出对应`require`导入
  - `export`导出对应`import`导入


### module.exports和exports的区别与联系
讲到这里就不得不稍微提一下模块化：
Node应用由模块组成，采用CommonJS模块规范。
根据这个规范，每个文件就是一个模块，有自己的作用域。在一个文件里面定义的变量、函数、类，都是私有的，对其他文件不可见。
CommonJS规范规定，每个模块内部，module变量代表当前模块。这个变量是一个对象，它的exports属性（即module.exports）是对外的接口。加载某个模块，其实是加载该模块的module.exports属性。
```javascript
var x = 5;
var addX = function (value) {
  return value + x;
};
module.exports.x = x;
module.exports.addX = addX;
```
上面代码通过module.exports输出变量x和函数addX。
require方法用于加载模块。
```javascript
var example = require('./example.js');

console.log(example.x); // 5
console.log(example.addX(1)); // 6
```
看了刚刚这段commonjs规范上面的介绍可以知道以下区别与联系：
其实exports变量是指向module.exports，
加载模块实际是加载该模块的module.exports。这等同在每个模块头部，有一行这样的命令。
```javascript
var exports = module.exports;
```

于是我们可以直接在 exports 对象上添加方法，表示对外输出的接口，如同在module.exports上添加一样。
**注意，不能直接将exports变量指向一个值，因为这样等于切断了exports与module.exports的联系。**

### export和export default的区别与联系

模块功能主要由：export和import构成。export导出模块的对外接口，import命令导入其他模块暴露的接口。
export其实和export default就是写法上面有点差别，一个是导出一个个单独接口，
一个是默认导出一个整体接口。使用import命令的时候，用户需要知道所要加载的变量名或函数名，
否则无法加载。这里就有一个简单写法不用去知道有哪些具体的暴露接口名，就用export default命令，为模块指定默认输出。
export可以这样写
```javascript
// testA.js
var f = 'Miel';
var name = 'Jack';
var data= 1988;

export {f, name, data};
```
使用export命令定义了模块的对外接口以后，其他 JS 文件就可以通过import命令加载这个模块。
```javascript
// main.js
import {f, name, data} from './testA';
```
export default可以这样写
```javascript
// export-default.js
export default function () {
  console.log('foo');
}
// 或者写成

function foo() {
  console.log('foo');
}
export default foo;
// import-default.js
import customName from './export-default';
customName(); // 'foo'
```


下面比较一下export default和export 输出。
```javascript
// 第一组
export default function car() { // 输出
  // ...
}

import car from 'car'; // 输入

// 第二组
export function car2() { // 输出
  // ...
};

import {car2} from 'car2'; // 输入
```


可以看到第一组是使用export default，import语句不需要使用大括号；
       第二组使用export，对应的import语句需要使用大括号，一个模块只能有一个默认输出，
       所以export default只能使用一次。
四、import和require的区别与联系

看了上面其实已经清楚了，import和require是分别属于ES6和CommonJS的两种导入模块的语法而已。
 
 
     

