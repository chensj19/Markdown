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
  
* 

