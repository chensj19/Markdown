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