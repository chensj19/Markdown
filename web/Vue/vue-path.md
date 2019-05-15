# Vue

## vue 单文件方式

* 单文件就是以`*.vue`结尾的文件，最终通过webpack编译成`*.js`在浏览器中运行
* 内容包含：`<template></template>+<script></scirpt>+<style></style>`
  * 1：`template`中只能有一个根节点 2.x
  * 2：`script`中 按照`export default {配置} `来写
  * 3：`style`中 可以设置`scoped`属性，让其只在`template`中生效

## 以单文件的方式启动
* `webpack` 需要配置vue的role来解析单文件代码

  * vue-loader -> vue-template-compile -> vue 

    * vue-loader  依赖   vue-template-compile  代码中依赖 vue

* 安装依赖

  ```bash
  cnpm i vue -S | cnpm i vue-loader vue-template-compiler -D
  ```

* 配置webpack-dev-server

  ```json
   "dev": "webpack-dev-server --inline --progress --config webpack.config.js"
   "dev2": "webpack-dev-server --inline --hot --open --config webpack.config.js"
   "build": "webpack"
  ```

## Vue 简介

* 2014年诞生，react于2013年诞生，angular于2009年诞生
* 核心概念：
  * angular：模块化 双向数据绑定 （基于脏检测：一个数组（$watch））
  * vue：组件化     双向数据流（基于ES5的defineProperty来实现），IE9才支持
    * 开发一个登陆的模块，登陆需要一个显示头部、中部、底部
    * 组件：组合起来的一个部件（头部、中部、底部）
    * _细分代码_
      * 头部：页面、 样式、 动态效果
      * 代码: template  style   script  一一对应

* 框架对比，学完VUE后再看

## 双向数据流

* 1向：js内存属性发生改变，影响页面的变化

* 1向：页面的改变影响js内存属性的改变

## 常用指令

* v-text 是元素的innerText，只能在双标签中使用

* v-html 是元素的innerHtml，不能包含`{{}}`

* v-if 是元素是否移除或者插入

* v-show 是元素是否显示或者隐藏

* v-model 双向数据绑定，v-bind是单向数据绑定（内存js改变影响页面）`:value='model'`

## class 结合v-bind使用

* 需要根据可变表达式的结果来给class赋值，就需要使用v-bind



## Vue状态管理

### 简介

vuex是专为vue.js应用程序开发的状态管理模式。它采用集中存储管理应用的所有组件的状态，并以相应的规则保证状态以一种可预测的方式发生变化。vuex也集成刀vue的官方调试工具devtools extension，提供了诸如零配置的time-travel调试、状态快照导入导出等高级调试功能。

### Vuex的思想

当我们在页面上点击一个按钮，它会处发(dispatch)一个`action`, `action`随后会执行(`commit`)一个`mutation`, `mutation` 立即会改变`state`,` state` 改变以后,我们的页面会`state` 获取数据，页面发生了变化。 Store 对象，包含了我们谈到的所有内容，`action`, `state`, `mutation`，所以是核心了

### **状态管理核心**

**状态管理有5个核心，分别是state、getter、mutation、action以及module。**

#### 1、state

state为单一状态树，在state中需要定义我们所需要管理的数组、对象、字符串等等，只有在这里定义了，在vue.js的组件中才能获取你定义的这个对象的状态。

#### 2、getter

getter有点类似vue.js的计算属性，当我们需要从store的state中派生出一些状态，那么我们就需要使用getter，getter会接收state作为第一个参数，而且getter的返回值会根据它的依赖被缓存起来，只有getter中的依赖值（state中的某个需要派生状态的值）发生改变的时候才会被重新计算。

#### 3、mutation

更改store中state状态的唯一方法就是提交mutation，就很类似事件。每个mutation都有一个字符串类型的事件类型和一个回调函数，我们需要改变state的值就要在回调函数中改变。我们要执行这个回调函数，那么我们需要执行一个相应的调用方法：store.commit。

#### 4、action

action可以提交mutation，在action中可以执行store.commit，而且action中可以有任何的异步操作。在页面中如果我们要嗲用这个action，则需要执行store.dispatch5、module module其实只是解决了当state中很复杂臃肿的时候，module可以将store分割成模块，每个模块中拥有自己的state、mutation、action和getter。

简单的Store模式

```vue
var store = {
  debug: true,
  state: {
    message: 'Hello!'
  },
  setMessageAction (newValue) {
    if (this.debug) console.log('setMessageAction triggered with', newValue)
    this.state.message = newValue
  },
  clearMessageAction () {
    if (this.debug) console.log('clearMessageAction triggered')
    this.state.message = ''
  }
}
```

所有 store 中 state 的改变，都放置在 store 自身的 action 中去管理。这种集中式状态管理能够被更容易地理解哪种类型的 mutation 将会发生，以及它们是如何被触发。当错误出现时，我们现在也会有一个 log 记录 bug 之前发生了什么。

此外，每个实例/组件仍然可以拥有和管理自己的私有状态：

```vue
var vmA = new Vue({
  data: {
    privateState: {},
    sharedState: store.state
  }
})

var vmB = new Vue({
  data: {
    privateState: {},
    sharedState: store.state
  }
})
```

![](https://img-blog.csdn.net/20180926004258547?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4NjU4NTY3/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)