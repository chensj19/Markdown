# webpack babel8 react antd 环境搭建

1. 初始化项目

   ```bash
   npm init -y
   ```

2. 安装webpack

   ```bash
   npm install webpack webpack-cli -D
   ```

3. 安装webpack插件

   * **webpack-merge** 因为分成3个配置文件所以需要进行合并，当然也可以不使用同一放到一个配置里。

     ```bash
      npm install webpack-merge -D
     ```

   * **HtmlWebpackPlugin** 用于自动产生html文件。
     ```bash
     npm install html-webpack-plugin  -D
     ```
   * **clean-webpack-plugin** 用于在build过程中，清理dist文件夹
     ```bash
     npm install clean-webpack-plugin  -D
     ```
   * **webpack-dev-server** 热加载模块
     ```bash
     npm install webpack-dev-server  -D
     ```
   
4. 配置

   1. 配置webpack.config

      1. 添加文件

         在根目录下建立`build`文件夹，分别新建三个名为的`webpack.base.conf.js`、`webpack.dev.conf.js`、`webpack.prod.conf.js`的配置文件。分别是公共配置，开发配置，生产配置。

         ```bash
         mkdir build
         touch build/webpack.base.conf.js
         touch build/webpack.dev.conf.js
         touch build/webpack.prod.conf.js
         ```

      2. webpack.base.conf.js

         ```js
         const path = require("path"); //node.js自带的路径参数
         const APP_PATH = path.resolve(__dirname, "../src"); //源文件目录
         const DIST_PATH = path.resolve(__dirname, "../dist"); //生产目录
         
         module.exports = {
           entry: {
             app: "./src/index.js",
           },
           output: {
             filename: "js/[name].[hash].js", //使用hash进行标记
             path: DIST_PATH,
           },
         };
         ```

      3. webpack.dev.conf.js

         ```js
         const path = require('path');
         const merge = require('webpack-merge');
         const baseWebpackConfig = require('./webpack.base.conf.js');
         const HtmlWebpackPlugin = require('html-webpack-plugin');
         const webpack = require('webpack');
         
         module.exports = merge(baseWebpackConfig,{
             mode: 'development',
           output: {
             filename: "js/[name].[hash:16].js",
           },
           devtool: 'inline-source-map', // 源错误检查
           plugins: [
             new HtmlWebpackPlugin({
               template: 'public/index.html',
               inject: 'body',
               minify: {
                 html5: true
               },
               hash: false
             }),
             new webpack.HotModuleReplacementPlugin(), // 热更新
           ],
           devServer: {  // 热更新服务配置
             port: '3000',
             contentBase: path.join(__dirname, '../public'),
             compress: true,
             historyApiFallback: true,
             hot: true,  //开启
             https: false,
             noInfo: true,
             open: true,
             proxy: {}
           }
         });
         ```

      4. webpack.pro.conf.js

         ```js
         const merge = require("webpack-merge"); //合并配置
         const baseWebpackConfig = require("./webpack.base.conf");
         const HtmlWebpackPlugin = require("html-webpack-plugin");
         const { CleanWebpackPlugin } = require("clean-webpack-plugin");
         
         module.exports = merge(baseWebpackConfig, {
           mode: "production", //mode是webpack4新增的模式
           plugins: [
             new CleanWebpackPlugin(),
             new HtmlWebpackPlugin({
               template: "public/index.html",
               title: "PresByter", //更改HTML的title的内容
               minify: {
                 removeComments: true,
                 collapseWhitespace: true,
                 removeAttributeQuotes: true,
               },
             }),
           ],
         });
         ```

   2. 添加文件

      1. `Index.js`

         ```cmd
         mkdir src
         touch src/index.js
         ```
   ```
      
   ​```js
         import React from 'react'
         import ReactDOM from 'react-dom'
         
         
   ReactDOM.render(
             <div>
                 123
             </div>,
             document.getElementById('app')
         )
   ```

      2. `index.html`
      
         ```bash
         mkdir -p public
         touch public/index.html
         ```

         ```html
         <!DOCTYPE html>
         <html lang="en">
           <head>
             <meta charset="UTF-8">
             <meta name="viewport" content="width=device-width, initial-scale=1.0">
             <title>Document</title>
           </head>
           <body>
             <div id="app"></div>
           </body>
         </html>
         ```


   3. 添加命令

      在`package.json`文件`scripts`属性添加`build`命令和`dev`命令：

      ```json
      {
          ......
          "scripts": {
              "build": "webpack --config build/webpack.prod.conf.js",
              "dev": "webpack-dev-server --inline --progress --config build/webpack.dev.conf.js",
              "test": "echo \"Error: no test specified\" && exit 1"
          },
          ......
      }
      ```

      

6. React 安装

   * [React官网](http://react.html.cn/)
   * [将 React 添加到网站](http://react.html.cn/docs/add-react-to-a-website.html)

   ```bash
   npm install react react-dom -S
   ```

6. Babel 8 安装和配置

   1. 参考文档
      * [Babel官方文档](https://babel.docschina.org/)
      * [配置Babel](https://babel.docschina.org/setup#installation)
      * [babel preset react](https://babel.docschina.org/docs/en/babel-preset-react)

   2. 安装babel

   ```bash
   # babel核心、加载器、import插件
   npm install @babel/core babel-loader babel-plugin-import -D
   # babel语法
   npm install @babel/preset-env @babel/preset-react -D
   # 插件
   npm install @babel/plugin-transform-runtime @babel/plugin-proposal-class-properties -D 
   # 运行时
   npm install  @babel/runtime -S
   ```
   3. 配置Babel

   ```bash
   touch .babelrc
   ```

   `.babelrc`

   ```json
   {
     "presets": ["@babel/preset-env", "@babel/preset-react"],
     "plugins": ["@babel/plugin-transform-runtime","@babel/plugin-proposal-class-properties"]
   }
   // presets 语法支持
   // plugins 插件支持
   ```

   `webpack.base.conf.js`添加规则

   ```js
    module:{
         rules: [
             {
                 test: /\.js?$/,
                 use: 'babel-loader',
                 exclude: /node_modules/,
                 include: APP_PATH
             }
         ]
     },
   ```

7. antd安装

   * 安装样式表插件

     ```bash
     npm install  file-loader url-loader  -D
     npm install  style-loader css-loader postcss-loader autoprefixer -D
     npm install  less sass less-loader node-sass -D
     ```

   * 在`webpack.base.conf.js`添加配置

     ```js
     module: {
         rules: [
           {
             test: /\.js?$/,
             use: "babel-loader",
             exclude: /node_modules/,
             include: APP_PATH,
           },
           {
             test: /\.css$/,
             use: ["style-loader", "css-loader"],
           },
           {
             test: /\.less$/,
             use: [
               { loader: "style-loader" },
               { loader: "css-loader" },
               {
                 loader: "postcss-loader", //自动加前缀
                 options: {
                   plugins: [
                     require("autoprefixer")({ browsers: ["last 5 version"] }),
                   ],
                 },
               },
               { loader: "less-loader" },
             ],
           },
           {
             test: /\.scss$/,
             use: [
               { loader: "style-loader" },
               { loader: "css-loader" },
               { loader: "sass-loader" },
               {
                 loader: "postcss-loader",
                 options: {
                   plugins: [
                     require("autoprefixer")({ browsers: ["last 5 version"] }),
                   ],
                 },
               },
             ],
           },
           {
             test: /\.(png|jpg|gif)$/,
             use: [
               {
                 loader: "url-loader",
                 options: {
                   name: "images/[name].[ext]",
                   limit: 1000, //是把小于1000B的文件打成Base64的格式，写入JS
                 },
               },
             ],
           },
           {
             test: /\.(woff|svg|eot|woff2|tff)$/,
             use: "url-loader",
             exclude: /node_modules/, // exclude忽略/node_modules/的文件夹
           },
         ],
       },
     ```

   * 安装antd

     ```bash
     npm install antd -S
     ```

   * 修改`.babelrc`配置

     ```json
     {
       "presets": ["@babel/preset-env", "@babel/preset-react"],
       "plugins": [
         "@babel/plugin-transform-runtime",
         "@babel/plugin-proposal-class-properties",
         ["import", { "libraryName": "antd", "style": "css" }]
       ]
     }
     ```

   * 

   