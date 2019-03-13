[TOC](webpack 学习笔记) 

# 概念

本质上，webpack 是一个现代 JavaScript 应用程序的静态模块打包器(module bundler)。当 webpack 处理应用程序时，它会递归地构建一个依赖关系图(dependency graph)，其中包含应用程序需要的每个模块，然后将所有这些模块打包成一个或多个 bundle。
>可以从[这里](https://www.webpackjs.com/concepts/modules)了解更多关于 JavaScript 模块和 webpack 模块的信息。

从 webpack v4.0.0 开始，可以不用引入一个配置文件。然而，webpack 仍然还是[高度可配置的](https://www.webpackjs.com/configuration)。在开始前你需要先理解四个**核心概念**：

- 入口(entry)
- 输出(output)
- loader
- 插件(plugins)

本文档旨在给出这些概念的**高度**概述，同时提供具体概念的详尽相关用例。
## 概念说明
### 入口(entry)

**入口起点(entry point)**指示 webpack 应该使用哪个模块，来作为构建其内部*依赖图*的开始。进入入口起点后，webpack 会找出有哪些模块和库是入口起点（直接和间接）依赖的。

每个依赖项随即被处理，最后输出到称之为 *bundles* 的文件中，我们将在下一章节详细讨论这个过程。

可以通过在 [webpack 配置](https://www.webpackjs.com/configuration)中配置 `entry` 属性，来指定一个入口起点（或多个入口起点）。默认值为 `./src`。

接下来我们看一个 `entry` 配置的最简单例子：

**webpack.config.js**

```js
module.exports = {
  entry: './path/to/my/entry/file.js'
};
```

> 根据应用程序的特定需求，可以以多种方式配置 `entry` 属性。从[入口起点](https://www.webpackjs.com/concepts/entry-points)章节可以了解更多信息。

### 出口(output)

**output** 属性告诉 webpack 在哪里输出它所创建的 *bundles*，以及如何命名这些文件，默认值为 `./dist`。基本上，整个应用程序结构，都会被编译到你指定的输出路径的文件夹中。你可以通过在配置中指定一个 `output` 字段，来配置这些处理过程：

**webpack.config.js**

```javascript
const path = require('path');

module.exports = {
  entry: './path/to/my/entry/file.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'my-first-webpack.bundle.js'
  }
};
```

在上面的示例中，我们通过 `output.filename` 和 `output.path` 属性，来告诉 webpack bundle 的名称，以及我们想要 bundle 生成(emit)到哪里。可能你想要了解在代码最上面导入的 path 模块是什么，它是一个 [Node.js 核心模块](https://nodejs.org/api/modules.html)，用于操作文件路径。

> 你可能会发现术语**生成(emitted 或 emit)**贯穿了我们整个文档和[插件 API](https://www.webpackjs.com/api/plugins)。它是“生产(produced)”或“释放(discharged)”的特殊术语。

> `output` 属性还有[更多可配置的特性](https://www.webpackjs.com/configuration/output)，如果你想要了解更多关于 `output` 属性的概念，你可以通过[阅读概念章节](https://www.webpackjs.com/concepts/output)来了解更多。

### loader

*loader* 让 webpack 能够去处理那些非 JavaScript 文件（webpack 自身只理解 JavaScript）。loader 可以将所有类型的文件转换为 webpack 能够处理的有效[模块](https://www.webpackjs.com/concepts/modules)，然后你就可以利用 webpack 的打包能力，对它们进行处理。

本质上，webpack loader 将所有类型的文件，转换为应用程序的依赖图（和最终的 bundle）可以直接引用的模块。

> 注意，loader 能够 `import` 导入任何类型的模块（例如 `.css` 文件），这是 webpack 特有的功能，其他打包程序或任务执行器的可能并不支持。我们认为这种语言扩展是有很必要的，因为这可以使开发人员创建出更准确的依赖关系图。

在更高层面，在 webpack 的配置中 **loader** 有两个目标：

1. `test` 属性，用于标识出应该被对应的 loader 进行转换的某个或某些文件。
2. `use` 属性，表示进行转换时，应该使用哪个 loader。

**webpack.config.js**

```javascript
const path = require('path');

const config = {
  output: {
    filename: 'my-first-webpack.bundle.js'
  },
  module: {
    rules: [
      { test: /\.txt$/, use: 'raw-loader' }
    ]
  }
};

module.exports = config;
```

以上配置中，对一个单独的 module 对象定义了 `rules` 属性，里面包含两个必须属性：`test` 和 `use`。这告诉 webpack 编译器(compiler) 如下信息：

> “嘿，webpack 编译器，当你碰到「在 `require()`/`import` 语句中被解析为 '.txt' 的路径」时，在你对它打包之前，先**使用** `raw-loader` 转换一下。”

> 重要的是要记得，**在 webpack 配置中定义 loader 时，要定义在 module.rules 中，而不是 rules**。然而，在定义错误时 webpack 会给出严重的警告。为了使你受益于此，如果没有按照正确方式去做，webpack 会“给出严重的警告”

loader 还有更多我们尚未提到的具体配置属性。

[了解更多！](https://www.webpackjs.com/concepts/loaders)

### 插件(plugins)

loader 被用于转换某些类型的模块，而插件则可以用于执行范围更广的任务。插件的范围包括，从打包优化和压缩，一直到重新定义环境中的变量。[插件接口](https://www.webpackjs.com/api/plugins)功能极其强大，可以用来处理各种各样的任务。

想要使用一个插件，你只需要 `require()` 它，然后把它添加到 `plugins` 数组中。多数插件可以通过选项(option)自定义。你也可以在一个配置文件中因为不同目的而多次使用同一个插件，这时需要通过使用 `new` 操作符来创建它的一个实例。

**webpack.config.js**

```javascript
const HtmlWebpackPlugin = require('html-webpack-plugin'); // 通过 npm 安装
const webpack = require('webpack'); // 用于访问内置插件

const config = {
  module: {
    rules: [
      { test: /\.txt$/, use: 'raw-loader' }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({template: './src/index.html'})
  ]
};

module.exports = config;
```

webpack 提供许多开箱可用的插件！查阅我们的[插件列表](https://www.webpackjs.com/plugins)获取更多信息。

在 webpack 配置中使用插件是简单直接的，然而也有很多值得我们进一步探讨的用例。

[了解更多！](https://www.webpackjs.com/concepts/plugins)

### 模式

通过选择 `development` 或 `production` 之中的一个，来设置 `mode` 参数，你可以启用相应模式下的 webpack 内置的优化

```javascript
module.exports = {
  mode: 'production'
};
```

## 入口起点(entry points)

### 单个入口（简写）语法

用法：`entry: string|Array<string>`

####  **webpack.config.js**

```javascript
const config = {
  entry: './path/to/my/entry/file.js'
};

module.exports = config;
```

`entry` 属性的单个入口语法，是下面的简写：

```javascript
const config = {
  entry: {
    main: './path/to/my/entry/file.js'
  }
};
```

> **当你向 entry 传入一个数组时会发生什么？**向 `entry` 属性传入「文件路径(file path)数组」将创建**“多个主入口(multi-main entry)”**。在你想要多个依赖文件一起注入，并且将它们的依赖导向(graph)到一个“chunk”时，传入数组的方式就很有用。

当你正在寻找为「只有一个入口起点的应用程序或工具（即 library）」快速设置 webpack 配置的时候，这会是个很不错的选择。然而，使用此语法在扩展配置时有失灵活性。

### 对象语法

用法：`entry: {[entryChunkName: string]: string|Array<string>}`

#### **webpack.config.js**

```javascript
const config = {
  entry: {
    app: './src/app.js',
    vendors: './src/vendors.js'
  }
};
```

对象语法会比较繁琐。然而，这是应用程序中定义入口的最可扩展的方式。

> **“可扩展的 webpack 配置”**是指，可重用并且可以与其他配置组合使用。这是一种流行的技术，用于将关注点(concern)从环境(environment)、构建目标(build target)、运行时(runtime)中分离。然后使用专门的工具（如 [webpack-merge](https://github.com/survivejs/webpack-merge)）将它们合并。

### 常见场景

以下列出一些入口配置和它们的实际用例：

#### 分离 应用程序(app) 和 第三方库(vendor) 入口

##### **webpack.config.js**

```javascript
const config = {
  entry: {
    app: './src/app.js',
    vendors: './src/vendors.js'
  }
};
```

**这是什么？**从表面上看，这告诉我们 webpack 从 `app.js` 和 `vendors.js` 开始创建依赖图(dependency graph)。这些依赖图是彼此完全分离、互相独立的（每个 bundle 中都有一个 webpack 引导(bootstrap)）。这种方式比较常见于，只有一个入口起点（不包括 vendor）的单页应用程序(single page application)中。

**为什么？**此设置允许你使用 `CommonsChunkPlugin` 从「应用程序 bundle」中提取 vendor 引用(vendor reference) 到 vendor bundle，并把引用 vendor 的部分替换为 `__webpack_require__()` 调用。如果应用程序 bundle 中没有 vendor 代码，那么你可以在 webpack 中实现被称为[长效缓存](https://www.webpackjs.com/guides/caching)的通用模式。

> 为了支持提供更佳 vendor 分离能力的 DllPlugin，考虑移除该场景。

#### 多页面应用程序

##### **webpack.config.js**

```javascript
const config = {
  entry: {
    pageOne: './src/pageOne/index.js',
    pageTwo: './src/pageTwo/index.js',
    pageThree: './src/pageThree/index.js'
  }
};
```

**这是什么？**我们告诉 webpack 需要 3 个独立分离的依赖图（如上面的示例）。

**为什么？**在多页应用中，（译注：每当页面跳转时）服务器将为你获取一个新的 HTML 文档。页面重新加载新文档，并且资源被重新下载。然而，这给了我们特殊的机会去做很多事：

- 使用 `CommonsChunkPlugin` 为每个页面间的应用程序共享代码创建 bundle。由于入口起点增多，多页应用能够复用入口起点之间的大量代码/模块，从而可以极大地从这些技术中受益。

> 根据经验：每个 HTML 文档只使用一个入口起点。

## 输出(output)

配置 `output` 选项可以控制 webpack 如何向硬盘写入编译文件。注意，即使可以存在多个`入口`起点，但只指定一个`输出`配置。

### 用法(Usage)

在 webpack 中配置 `output` 属性的最低要求是，将它的值设置为一个对象，包括以下两点：

- `filename` 用于输出文件的文件名。

- 目标输出目录 `path` 的绝对路径。

#### **webpack.config.js**

  ```javascript
  const config = {
    output: {
      filename: 'bundle.js',
      path: '/home/proj/public/assets'
    }
  };
  
  module.exports = config;
  ```

  此配置将一个单独的 `bundle.js` 文件输出到 `/home/proj/public/assets` 目录中。

### 多个入口起点

  如果配置创建了多个单独的 "chunk"（例如，使用多个入口起点或使用像 CommonsChunkPlugin 这样的插件），则应该使用[占位符(substitutions)](https://www.webpackjs.com/configuration/output#output-filename)来确保每个文件具有唯一的名称。

  ```javascript
  {
    entry: {
      app: './src/app.js',
      search: './src/search.js'
    },
    output: {
      filename: '[name].js',
      path: __dirname + '/dist'
    }
  }
  
  // 写入到硬盘：./dist/app.js, ./dist/search.js
  ```

### 高级进阶

  以下是使用 CDN 和资源 hash 的复杂示例：

  **config.js**

  ```javascript
  output: {
    path: "/home/proj/cdn/assets/[hash]",
    publicPath: "http://cdn.example.com/assets/[hash]/"
  }
  ```

  在编译时不知道最终输出文件的 `publicPath` 的情况下，`publicPath` 可以留空，并且在入口起点文件运行时动态设置。如果你在编译时不知道 `publicPath`，你可以先忽略它，并且在入口起点设置 `__webpack_public_path__`。

  ```javascript
  __webpack_public_path__ = myRuntimePublicPath
  
  // 剩余的应用程序入口
  ```

## 模式(mode)

提供 `mode` 配置选项，告知 webpack 使用相应模式的内置优化。

```
string
```

### 用法

只在配置中提供 `mode` 选项：

```javascript
module.exports = {
  mode: 'production'
};
```

或者从 [CLI](https://www.webpackjs.com/api/cli/) 参数中传递：

```bash
webpack --mode=production
```

支持以下字符串值：

| 选项          | 描述                                                         |
| ------------- | ------------------------------------------------------------ |
| `development` | 会将 `process.env.NODE_ENV` 的值设为 `development`。启用 `NamedChunksPlugin` 和 `NamedModulesPlugin`。 |
| `production`  | 会将 `process.env.NODE_ENV` 的值设为 `production`。启用 `FlagDependencyUsagePlugin`, `FlagIncludedChunksPlugin`, `ModuleConcatenationPlugin`, `NoEmitOnErrorsPlugin`, `OccurrenceOrderPlugin`, `SideEffectsFlagPlugin` 和 `UglifyJsPlugin`. |

> 记住，只设置 `NODE_ENV`，则不会自动设置 `mode`。

### mode: development

```diff
// webpack.development.config.js
module.exports = {
+ mode: 'development'
- plugins: [
-   new webpack.NamedModulesPlugin(),
-   new webpack.DefinePlugin({ "process.env.NODE_ENV": JSON.stringify("development") }),
- ]
}
```

### mode: production

```diff
// webpack.production.config.js
module.exports = {
+  mode: 'production',
-  plugins: [
-    new UglifyJsPlugin(/* ... */),
-    new webpack.DefinePlugin({ "process.env.NODE_ENV": JSON.stringify("production") }),
-    new webpack.optimize.ModuleConcatenationPlugin(),
-    new webpack.NoEmitOnErrorsPlugin()
-  ]
}
```

## loader

loader 用于对模块的源代码进行转换。loader 可以使你在 `import` 或"加载"模块时预处理文件。因此，loader 类似于其他构建工具中“任务(task)”，并提供了处理前端构建步骤的强大方法。loader 可以将文件从不同的语言（如 TypeScript）转换为 JavaScript，或将内联图像转换为 data URL。loader 甚至允许你直接在 JavaScript 模块中 `import` CSS文件！

### 示例

例如，你可以使用 loader 告诉 webpack 加载 CSS 文件，或者将 TypeScript 转为 JavaScript。为此，首先安装相对应的 loader：

```bash
npm install --save-dev css-loader
npm install --save-dev ts-loader
```

然后指示 webpack 对每个 `.css` 使用 [`css-loader`](https://www.webpackjs.com/loaders/css-loader)，以及对所有 `.ts` 文件使用 [`ts-loader`](https://github.com/TypeStrong/ts-loader)：

**webpack.config.js**

```js
module.exports = {
  module: {
    rules: [
      { test: /\.css$/, use: 'css-loader' },
      { test: /\.ts$/, use: 'ts-loader' }
    ]
  }
};
```

### 使用 loader

在你的应用程序中，有三种使用 loader 的方式：

- [配置](https://www.webpackjs.com/concepts/loaders/#configuration)（推荐）：在 **webpack.config.js** 文件中指定 loader。
- [内联](https://www.webpackjs.com/concepts/loaders/#inline)：在每个 `import` 语句中显式指定 loader。
- [CLI](https://www.webpackjs.com/concepts/loaders/#cli)：在 shell 命令中指定它们。

### 配置[Configuration]

[`module.rules`](https://www.webpackjs.com/configuration/module/#module-rules) 允许你在 webpack 配置中指定多个 loader。 这是展示 loader 的一种简明方式，并且有助于使代码变得简洁。同时让你对各个 loader 有个全局概览：

```js
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          { loader: 'style-loader' },
          {
            loader: 'css-loader',
            options: {
              modules: true
            }
          }
        ]
      }
    ]
  }
```

### 内联

可以在 `import` 语句或任何[等效于 "import" 的方式](https://www.webpackjs.com/api/module-methods)中指定 loader。使用 `!` 将资源中的 loader 分开。分开的每个部分都相对于当前目录解析。

```js
import Styles from 'style-loader!css-loader?modules!./styles.css';
```

通过前置所有规则及使用 `!`，可以对应覆盖到配置中的任意 loader。

选项可以传递查询参数，例如 `?key=value&foo=bar`，或者一个 JSON 对象，例如 `?{"key":"value","foo":"bar"}`。

> 尽可能使用 `module.rules`，因为这样可以减少源码中的代码量，并且可以在出错时，更快地调试和定位 loader 中的问题。

### CLI

你也可以通过 CLI 使用 loader：

```sh
webpack --module-bind jade-loader --module-bind 'css=style-loader!css-loader'
```

这会对 `.jade` 文件使用 `jade-loader`，对 `.css` 文件使用 [`style-loader`](https://www.webpackjs.com/loaders/style-loader) 和 [`css-loader`](https://www.webpackjs.com/loaders/css-loader)。

### loader 特性

- loader 支持链式传递。能够对资源使用流水线(pipeline)。一组链式的 loader 将按照相反的顺序执行。loader 链中的第一个 loader 返回值给下一个 loader。在最后一个 loader，返回 webpack 所预期的 JavaScript。
- loader 可以是同步的，也可以是异步的。
- loader 运行在 Node.js 中，并且能够执行任何可能的操作。
- loader 接收查询参数。用于对 loader 传递配置。
- loader 也能够使用 `options` 对象进行配置。
- 除了使用 `package.json` 常见的 `main` 属性，还可以将普通的 npm 模块导出为 loader，做法是在 `package.json` 里定义一个 `loader` 字段。
- 插件(plugin)可以为 loader 带来更多特性。
- loader 能够产生额外的任意文件。

loader 通过（loader）预处理函数，为 JavaScript 生态系统提供了更多能力。 用户现在可以更加灵活地引入细粒度逻辑，例如压缩、打包、语言翻译和[其他更多](https://www.webpackjs.com/loaders)。

### 解析 loader

loader 遵循标准的[模块解析](https://www.webpackjs.com/concepts/module-resolution/)。多数情况下，loader 将从[模块路径](https://www.webpackjs.com/concepts/module-resolution/#module-paths)（通常将模块路径认为是 `npm install`, `node_modules`）解析。

loader 模块需要导出为一个函数，并且使用 Node.js 兼容的 JavaScript 编写。通常使用 npm 进行管理，但是也可以将自定义 loader 作为应用程序中的文件。按照约定，loader 通常被命名为 `xxx-loader`（例如 `json-loader`）。有关详细信息，请查看 [如何编写 loader？](https://www.webpackjs.com/contribute/writing-a-loader)。

## 插件(plugins)

插件是 webpack 的[支柱](https://github.com/webpack/tapable)功能。webpack 自身也是构建于，你在 webpack 配置中用到的**相同的插件系统**之上！

插件目的在于解决 [loader](https://www.webpackjs.com/concepts/loaders) 无法实现的**其他事**。

### 剖析

webpack **插件**是一个具有 [`apply`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/apply) 属性的 JavaScript 对象。`apply` 属性会被 webpack compiler 调用，并且 compiler 对象可在**整个**编译生命周期访问。

**ConsoleLogOnBuildWebpackPlugin.js**

```javascript
const pluginName = 'ConsoleLogOnBuildWebpackPlugin';

class ConsoleLogOnBuildWebpackPlugin {
    apply(compiler) {
        compiler.hooks.run.tap(pluginName, compilation => {
            console.log("webpack 构建过程开始！");
        });
    }
}
```

compiler hook 的 tap 方法的第一个参数，应该是驼峰式命名的插件名称。建议为此使用一个常量，以便它可以在所有 hook 中复用。

### 用法

由于**插件**可以携带参数/选项，你必须在 webpack 配置中，向 `plugins` 属性传入 `new` 实例。

根据你的 webpack 用法，这里有多种方式使用插件。

### 配置

#### **webpack.config.js**

```javascript
const HtmlWebpackPlugin = require('html-webpack-plugin'); //通过 npm 安装
const webpack = require('webpack'); //访问内置的插件
const path = require('path');

const config = {
  entry: './path/to/my/entry/file.js',
  output: {
    filename: 'my-first-webpack.bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        use: 'babel-loader'
      }
    ]
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin(),
    new HtmlWebpackPlugin({template: './src/index.html'})
  ]
};

module.exports = config;
```

### Node API

> 即便使用 Node API，用户也应该在配置中传入 `plugins` 属性。`compiler.apply` 并不是推荐的使用方式。

**some-node-script.js**

```javascript
  const webpack = require('webpack'); //访问 webpack 运行时(runtime)
  const configuration = require('./webpack.config.js');

  let compiler = webpack(configuration);
  compiler.apply(new webpack.ProgressPlugin());

  compiler.run(function(err, stats) {
    // ...
  });
```

> 你知道吗：以上看到的示例和 [webpack 自身运行时(runtime)](https://github.com/webpack/webpack/blob/e7087ffeda7fa37dfe2ca70b5593c6e899629a2c/bin/webpack.js#L290-L292) 极其类似。[wepback 源码](https://github.com/webpack/webpack)中隐藏有大量使用示例，你可以用在自己的配置和脚本中。

## 配置(configuration)

你可能已经注意到，很少有 webpack 配置看起来很完全相同。这是因为 **webpack 的配置文件，是导出一个对象的 JavaScript 文件。**此对象，由 webpack 根据对象定义的属性进行解析。

因为 webpack 配置是标准的 Node.js CommonJS 模块，你**可以做到以下事情**：

- 通过 `require(...)` 导入其他文件
- 通过 `require(...)` 使用 npm 的工具函数
- 使用 JavaScript 控制流表达式，例如 `?:` 操作符
- 对常用值使用常量或变量
- 编写并执行函数来生成部分配置

请在合适的时机使用这些特性。

虽然技术上可行，**但应避免以下做法**：

- 在使用 webpack 命令行接口(CLI)（应该编写自己的命令行接口(CLI)，或[使用 `--env`](https://www.webpackjs.com/configuration/configuration-types/)）时，访问命令行接口(CLI)参数
- 导出不确定的值（调用 webpack 两次应该产生同样的输出文件）
- 编写很长的配置（应该将配置拆分为多个文件）

> 你需要从这份文档中收获最大的点，就是你的 webpack 配置，可以有很多种的格式和风格。但为了你和你的团队能够易于理解和维护，你们要始终采取同一种用法、格式和风格。

接下来的例子展示了 webpack 配置对象(webpack configuration object)如何即具有表现力，又具有可配置性，这是因为*配置对象即是代码*：

### 基本配置

#### **webpack.config.js**

```javascript
var path = require('path');

module.exports = {
  mode: 'development',
  entry: './foo.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'foo.bundle.js'
  }
};
```

### 多个 Target

查看：[导出多个配置](https://www.webpackjs.com/configuration/configuration-types/#exporting-multiple-configurations)

### 使用其他配置语言

webpack 接受以多种编程和数据语言编写的配置文件。

查看：[配置语言](https://www.webpackjs.com/configuration/configuration-languages/)

## 模块(modules)

在[模块化编程](https://en.wikipedia.org/wiki/Modular_programming)中，开发者将程序分解成离散功能块(discrete chunks of functionality)，并称之为*模块*。

每个模块具有比完整程序更小的接触面，使得校验、调试、测试轻而易举。 精心编写的*模块*提供了可靠的抽象和封装界限，使得应用程序中每个模块都具有条理清楚的设计和明确的目的。

Node.js 从最一开始就支持模块化编程。然而，在 web，*模块化*的支持正缓慢到来。在 web 存在多种支持 JavaScript 模块化的工具，这些工具各有优势和限制。webpack 基于从这些系统获得的经验教训，并将*模块*的概念应用于项目中的任何文件。

### 什么是 webpack 模块

对比 [Node.js 模块](https://nodejs.org/api/modules.html)，webpack *模块*能够以各种方式表达它们的依赖关系，几个例子如下：

- [ES2015 `import`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) 语句
- [CommonJS](http://www.commonjs.org/specs/modules/1.0/) `require()` 语句
- [AMD](https://github.com/amdjs/amdjs-api/blob/master/AMD.md) `define` 和 `require` 语句
- css/sass/less 文件中的 [`@import` 语句](https://developer.mozilla.org/en-US/docs/Web/CSS/@import)。
- 样式(`url(...)`)或 HTML 文件(`<img src=...>`)中的图片链接(image url)

> webpack 1 需要特定的 loader 来转换 ES 2015 `import`，然而通过 webpack 2 可以开箱即用。

### 支持的模块类型

webpack 通过 *loader* 可以支持各种语言和预处理器编写模块。*loader* 描述了 webpack **如何**处理 非 JavaScript(non-JavaScript) _模块_，并且在 *bundle* 中引入这些*依赖*。 webpack 社区已经为各种流行语言和语言处理器构建了 *loader*，包括：

- [CoffeeScript](http://coffeescript.org/)
- [TypeScript](https://www.typescriptlang.org/)
- [ESNext (Babel)](https://babeljs.io/)
- [Sass](http://sass-lang.com/)
- [Less](http://lesscss.org/)
- [Stylus](http://stylus-lang.com/)

总的来说，webpack 提供了可定制的、强大和丰富的 API，允许**任何技术栈**使用 webpack，保持了在你的开发、测试和生成流程中**无侵入性(non-opinionated)**。

## 模块解析(module resolution)

resolver 是一个库(library)，用于帮助找到模块的绝对路径。一个模块可以作为另一个模块的依赖模块，然后被后者引用，如下：

```js
import foo from 'path/to/module'
// 或者
require('path/to/module')
```

所依赖的模块可以是来自应用程序代码或第三方的库(library)。resolver 帮助 webpack 找到 bundle 中需要引入的模块代码，这些代码在包含在每个 `require`/`import` 语句中。 当打包模块时，`webpack` 使用 [enhanced-resolve](https://github.com/webpack/enhanced-resolve) 来解析文件路径

### webpack 中的解析规则

使用 `enhanced-resolve`，webpack 能够解析三种文件路径：

### 绝对路径

```js
import "/home/me/file";

import "C:\\Users\\me\\file";
```

由于我们已经取得文件的绝对路径，因此不需要进一步再做解析。

### 相对路径

```js
import "../src/file1";
import "./file2";
```

在这种情况下，使用 `import` 或 `require` 的资源文件(resource file)所在的目录被认为是上下文目录(context directory)。在 `import/require` 中给定的相对路径，会添加此上下文路径(context path)，以产生模块的绝对路径(absolute path)。

### 模块路径

```js
import "module";
import "module/lib/file";
```

模块将在 [`resolve.modules`](https://www.webpackjs.com/configuration/resolve/#resolve-modules) 中指定的所有目录内搜索。 你可以替换初始模块路径，此替换路径通过使用 [`resolve.alias`](https://www.webpackjs.com/configuration/resolve/#resolve-alias) 配置选项来创建一个别名。

一旦根据上述规则解析路径后，解析器(resolver)将检查路径是否指向文件或目录。如果路径指向一个文件：

- 如果路径具有文件扩展名，则被直接将文件打包。
- 否则，将使用 [`resolve.extensions`] 选项作为文件扩展名来解析，此选项告诉解析器在解析中能够接受哪些扩展名（例如 `.js`, `.jsx`）。

如果路径指向一个文件夹，则采取以下步骤找到具有正确扩展名的正确文件：

- 如果文件夹中包含 `package.json` 文件，则按照顺序查找 [`resolve.mainFields`](https://www.webpackjs.com/configuration/resolve/#resolve-mainfields) 配置选项中指定的字段。并且 `package.json` 中的第一个这样的字段确定文件路径。
- 如果 `package.json` 文件不存在或者 `package.json` 文件中的 main 字段没有返回一个有效路径，则按照顺序查找 [`resolve.mainFiles`](https://www.webpackjs.com/configuration/resolve/#resolve-mainfiles) 配置选项中指定的文件名，看是否能在 import/require 目录下匹配到一个存在的文件名。
- 文件扩展名通过 `resolve.extensions` 选项采用类似的方法进行解析。

webpack 根据构建目标(build target)为这些选项提供了合理的[默认](https://www.webpackjs.com/configuration/resolve)配置。

### 解析 Loader(Resolving Loaders)

Loader 解析遵循与文件解析器指定的规则相同的规则。但是 [`resolveLoader`](https://www.webpackjs.com/configuration/resolve/#resolveloader) 配置选项可以用来为 Loader 提供独立的解析规则。

### 缓存

每个文件系统访问都被缓存，以便更快触发对同一文件的多个并行或串行请求。在[观察模式](https://www.webpackjs.com/configuration/watch/#watch)下，只有修改过的文件会从缓存中摘出。如果关闭观察模式，在每次编译前清理缓存。

## 依赖图(dependency graph)

任何时候，一个文件依赖于另一个文件，webpack 就把此视为文件之间有 *依赖关系* 。这使得 webpack 可以接收非代码资源(non-code asset)（例如图像或 web 字体），并且可以把它们作为 _依赖_ 提供给你的应用程序。

webpack 从命令行或配置文件中定义的一个模块列表开始，处理你的应用程序。 从这些 *入口起点* 开始，webpack 递归地构建一个 *依赖图* ，这个依赖图包含着应用程序所需的每个模块，然后将所有这些模块打包为少量的 *bundle* - 通常只有一个 - 可由浏览器加载。

> 对于 *HTTP/1.1* 客户端，由 webpack 打包你的应用程序会尤其强大，因为在浏览器发起一个新请求时，它能够减少应用程序必须等待的时间。对于 *HTTP/2*，你还可以使用代码拆分(Code Splitting)以及通过 webpack 打包来实现[最佳优化](https://medium.com/webpack/webpack-http-2-7083ec3f3ce6#.7y5d3hz59)。

## manifest

在使用 webpack 构建的典型应用程序或站点中，有三种主要的代码类型：

1. 你或你的团队编写的源码。
2. 你的源码会依赖的任何第三方的 library 或 "vendor" 代码。
3. webpack 的 runtime 和 *manifest*，管理所有模块的交互。

本文将重点介绍这三个部分中的最后部分，runtime 和 manifest。

### Runtime

如上所述，我们这里只简略地介绍一下。runtime，以及伴随的 manifest 数据，主要是指：在浏览器运行时，webpack 用来连接模块化的应用程序的所有代码。runtime 包含：在模块交互时，连接模块所需的加载和解析逻辑。包括浏览器中的已加载模块的连接，以及懒加载模块的执行逻辑。

### Manifest

那么，一旦你的应用程序中，形如 `index.html` 文件、一些 bundle 和各种资源加载到浏览器中，会发生什么？你精心安排的 `/src` 目录的文件结构现在已经不存在，所以 webpack 如何管理所有模块之间的交互呢？这就是 manifest 数据用途的由来……

当编译器(compiler)开始执行、解析和映射应用程序时，它会保留所有模块的详细要点。这个数据集合称为 "Manifest"，当完成打包并发送到浏览器时，会在运行时通过 Manifest 来解析和加载模块。无论你选择哪种[模块语法](https://www.webpackjs.com/api/module-methods)，那些 `import` 或 `require` 语句现在都已经转换为 `__webpack_require__` 方法，此方法指向模块标识符(module identifier)。通过使用 manifest 中的数据，runtime 将能够查询模块标识符，检索出背后对应的模块。

### 问题

所以，现在你应该对 webpack 在幕后工作有一点了解。“但是，这对我有什么影响呢？”，你可能会问。答案是大多数情况下没有。runtime 做自己该做的，使用 manifest 来执行其操作，然后，一旦你的应用程序加载到浏览器中，所有内容将展现出魔幻般运行。然而，如果你决定通过使用浏览器缓存来改善项目的性能，理解这一过程将突然变得尤为重要。

通过使用 bundle 计算出内容散列(content hash)作为文件名称，这样在内容或文件修改时，浏览器中将通过新的内容散列指向新的文件，从而使缓存无效。一旦你开始这样做，你会立即注意到一些有趣的行为。即使表面上某些内容没有修改，计算出的哈希还是会改变。这是因为，runtime 和 manifest 的注入在每次构建都会发生变化。

查看*管理构建文件*指南的 [manifest 部分](https://www.webpackjs.com/guides/output-management#the-manifest)，了解如何提取 manifest，并阅读下面的指南，以了解更多长效缓存错综复杂之处。

## 构建目标(targets)

因为服务器和浏览器代码都可以用 JavaScript 编写，所以 webpack 提供了多种*构建目标(target)*，你可以在你的 webpack [配置](https://www.webpackjs.com/configuration)中设置。

> webpack 的 `target` 属性不要和 `output.libraryTarget` 属性混淆。有关 `output` 属性的更多信息，请查看[我们的指南](https://www.webpackjs.com/concepts/output)。

### 用法

要设置 `target` 属性，只需要在你的 webpack 配置中设置 target 的值。

#### **webpack.config.js**

```javascript
module.exports = {
  target: 'node'
};
```

在上面例子中，使用 `node` webpack 会编译为用于「类 Node.js」环境（使用 Node.js 的 `require` ，而不是使用任意内置模块（如 `fs` 或 `path`）来加载 chunk）。

每个*target*都有各种部署(deployment)/环境(environment)特定的附加项，以支持满足其需求。查看[target 的可用值](https://www.webpackjs.com/configuration/target)。

> Further expansion for other popular target values

### 多个 Target

尽管 webpack 不支持向 `target` 传入多个字符串，你可以通过打包两份分离的配置来创建同构的库：

#### **webpack.config.js**

```javascript
var path = require('path');
var serverConfig = {
  target: 'node',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.node.js'
  }
  //…
};

var clientConfig = {
  target: 'web', // <=== 默认是 'web'，可省略
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'lib.js'
  }
  //…
};

module.exports = [ serverConfig, clientConfig ];
```

上面的例子将在你的 `dist` 文件夹下创建 `lib.js` 和 `lib.node.js` 文件。

### 资源

从上面的选项可以看出有多个不同的部署_目标_可供选择。下面是一个示例列表，以及你可以参考的资源。

- **compare-webpack-target-bundles**：有关「测试和查看」不同的 webpack *target* 的大量资源。也有大量 bug 报告。
- **Boilerplate of Electron-React Application**：一个 electron 主进程和渲染进程构建过程的很好的例子。

> Need to find up to date examples of these webpack targets being used in live code or boilerplates.

## 模块热替换(hot module replacement)

模块热替换(HMR - Hot Module Replacement)功能会在应用程序运行过程中替换、添加或删除[模块](https://www.webpackjs.com/concepts/modules/)，而无需重新加载整个页面。主要是通过以下几种方式，来显著加快开发速度：

- 保留在完全重新加载页面时丢失的应用程序状态。
- 只更新变更内容，以节省宝贵的开发时间。
- 调整样式更加快速 - 几乎相当于在浏览器调试器中更改样式。

### 这一切是如何运行的？

让我们从一些不同的角度观察，以了解 HMR 的工作原理……

### 在应用程序中

通过以下步骤，可以做到在应用程序中置换(swap in and out)模块：

1. 应用程序代码要求 HMR runtime 检查更新。
2. HMR runtime（异步）下载更新，然后通知应用程序代码。
3. 应用程序代码要求 HMR runtime 应用更新。
4. HMR runtime（同步）应用更新。

你可以设置 HMR，以使此进程自动触发更新，或者你可以选择要求在用户交互时进行更新。

### 在编译器中

除了普通资源，编译器(compiler)需要发出 "update"，以允许更新之前的版本到新的版本。"update" 由两部分组成：

1. 更新后的 [manifest](https://www.webpackjs.com/concepts/manifest)(JSON)
2. 一个或多个更新后的 chunk (JavaScript)

manifest 包括新的编译 hash 和所有的待更新 chunk 目录。每个更新 chunk 都含有对应于此 chunk 的全部更新模块（或一个 flag 用于表明此模块要被移除）的代码。

编译器确保模块 ID 和 chunk ID 在这些构建之间保持一致。通常将这些 ID 存储在内存中（例如，使用 [webpack-dev-server](https://www.webpackjs.com/configuration/dev-server/) 时），但是也可能将它们存储在一个 JSON 文件中。

### 在模块中

HMR 是可选功能，只会影响包含 HMR 代码的模块。举个例子，通过 [`style-loader`](https://github.com/webpack-contrib/style-loader) 为 style 样式追加补丁。为了运行追加补丁，`style-loader` 实现了 HMR 接口；当它通过 HMR 接收到更新，它会使用新的样式替换旧的样式。

类似的，当在一个模块中实现了 HMR 接口，你可以描述出当模块被更新后发生了什么。然而在多数情况下，不需要强制在每个模块中写入 HMR 代码。如果一个模块没有 HMR 处理函数，更新就会冒泡(bubble up)。这意味着一个简单的处理函数能够对整个模块树(complete module tree)进行更新。如果在这个模块树中，一个单独的模块被更新，那么整组依赖模块都会被重新加载。

有关 `module.hot` 接口的详细信息，请查看 [HMR API 页面](https://www.webpackjs.com/api/hot-module-replacement)。

### 在 HMR Runtime 中

这些事情比较有技术性……如果你对其内部不感兴趣，可以随时跳到 [HMR API 页面](https://www.webpackjs.com/api/hot-module-replacement)或 [HMR 指南](https://www.webpackjs.com/guides/hot-module-replacement)。

对于模块系统的 runtime，附加的代码被发送到 `parents` 和 `children` 跟踪模块。在管理方面，runtime 支持两个方法 `check` 和 `apply`。

`check` 发送 HTTP 请求来更新 manifest。如果请求失败，说明没有可用更新。如果请求成功，待更新 chunk 会和当前加载过的 chunk 进行比较。对每个加载过的 chunk，会下载相对应的待更新 chunk。当所有待更新 chunk 完成下载，就会准备切换到 `ready` 状态。

`apply` 方法将所有被更新模块标记为无效。对于每个无效模块，都需要在模块中有一个更新处理函数(update handler)，或者在它的父级模块们中有更新处理函数。否则，无效标记冒泡，并也使父级无效。每个冒泡继续，直到到达应用程序入口起点，或者到达带有更新处理函数的模块（以最先到达为准，冒泡停止）。如果它从入口起点开始冒泡，则此过程失败。

之后，所有无效模块都被（通过 dispose 处理函数）处理和解除加载。然后更新当前 hash，并且调用所有 "accept" 处理函数。runtime 切换回`闲置`状态(idle state)，一切照常继续。

### 入门

在开发过程中，可以将 HMR 作为 LiveReload 的替代。[webpack-dev-server](https://www.webpackjs.com/configuration/dev-server/) 支持 `hot` 模式，在试图重新加载整个页面之前，热模式会尝试使用 HMR 来更新。更多细节请查看[模块热更新指南](https://www.webpackjs.com/guides/hot-module-replacement)。

与许多其他功能一样，webpack 的强大之处在于它的可定制化。取决于特定项目需求，会有*许多种*配置 HMR 的方式。然而，对于多数实现来说，`webpack-dev-server` 能够配合良好，可以让你快速入门 HMR。







# 配置

## 说明

webpack 是需要传入一个配置对象(configuration object)。取决于你如何使用 webpack，可以通过两种方式之一：终端或 Node.js。下面指定了所有可用的配置选项。

> 刚接触 webpack？请查看我们提供的指南，从 webpack 一些[核心概念](https://www.webpackjs.com/concepts)开始学习吧！

> 注意整个配置中我们使用 Node 内置的 [path 模块](https://nodejs.org/api/path.html)，并在它前面加上 [__dirname](https://nodejs.org/docs/latest/api/globals.html#globals_dirname)这个全局变量。可以防止不同操作系统之间的文件路径问题，并且可以使相对路径按照预期工作。更多「POSIX 和 Windows」的相关信息请查看[此章节](https://nodejs.org/api/path.html#path_windows_vs_posix)。

### 选项

点击下面配置代码中每个选项的名称，跳转到详细的文档。还要注意，带有箭头的项目可以展开，以显示更多示例，在某些情况下可以看到高级配置。

**webpack.config.js**

```js
const path = require('path');

module.exports = {
  mode: "production", // "production" | "development" | "none"  // Chosen mode tells webpack to use its built-in optimizations accordingly.

  entry: "./app/entry", // string | object | array  // 这里应用程序开始执行
  // webpack 开始打包

  output: {
    // webpack 如何输出结果的相关选项

    path: path.resolve(__dirname, "dist"), // string
    // 所有输出文件的目标路径
    // 必须是绝对路径（使用 Node.js 的 path 模块）

    filename: "bundle.js", // string    // 「入口分块(entry chunk)」的文件名模板（出口分块？）

    publicPath: "/assets/", // string    // 输出解析文件的目录，url 相对于 HTML 页面

    library: "MyLibrary", // string,
    // 导出库(exported library)的名称

    libraryTarget: "umd", // 通用模块定义    // 导出库(exported library)的类型

    /* 高级输出配置（点击显示） */  },

  module: {
    // 关于模块配置

    rules: [
      // 模块规则（配置 loader、解析器等选项）

      {
        test: /\.jsx?$/,
        include: [
          path.resolve(__dirname, "app")
        ],
        exclude: [
          path.resolve(__dirname, "app/demo-files")
        ],
        // 这里是匹配条件，每个选项都接收一个正则表达式或字符串
        // test 和 include 具有相同的作用，都是必须匹配选项
        // exclude 是必不匹配选项（优先于 test 和 include）
        // 最佳实践：
        // - 只在 test 和 文件名匹配 中使用正则表达式
        // - 在 include 和 exclude 中使用绝对路径数组
        // - 尽量避免 exclude，更倾向于使用 include

        issuer: { test, include, exclude },
        // issuer 条件（导入源）

        enforce: "pre",
        enforce: "post",
        // 标识应用这些规则，即使规则覆盖（高级选项）

        loader: "babel-loader",
        // 应该应用的 loader，它相对上下文解析
        // 为了更清晰，`-loader` 后缀在 webpack 2 中不再是可选的
        // 查看 webpack 1 升级指南。

        options: {
          presets: ["es2015"]
        },
        // loader 的可选项
      },

      {
        test: /\.html$/,
        test: "\.html$"

        use: [
          // 应用多个 loader 和选项
          "htmllint-loader",
          {
            loader: "html-loader",
            options: {
              /* ... */
            }
          }
        ]
      },

      { oneOf: [ /* rules */ ] },
      // 只使用这些嵌套规则之一

      { rules: [ /* rules */ ] },
      // 使用所有这些嵌套规则（合并可用条件）

      { resource: { and: [ /* 条件 */ ] } },
      // 仅当所有条件都匹配时才匹配

      { resource: { or: [ /* 条件 */ ] } },
      { resource: [ /* 条件 */ ] },
      // 任意条件匹配时匹配（默认为数组）

      { resource: { not: /* 条件 */ } }
      // 条件不匹配时匹配
    ],

    /* 高级模块配置（点击展示） */  },

  resolve: {
    // 解析模块请求的选项
    // （不适用于对 loader 解析）

    modules: [
      "node_modules",
      path.resolve(__dirname, "app")
    ],
    // 用于查找模块的目录

    extensions: [".js", ".json", ".jsx", ".css"],
    // 使用的扩展名

    alias: {
      // 模块别名列表

      "module": "new-module",
      // 起别名："module" -> "new-module" 和 "module/path/file" -> "new-module/path/file"

      "only-module$": "new-module",
      // 起别名 "only-module" -> "new-module"，但不匹配 "only-module/path/file" -> "new-module/path/file"

      "module": path.resolve(__dirname, "app/third/module.js"),
      // 起别名 "module" -> "./app/third/module.js" 和 "module/file" 会导致错误
      // 模块别名相对于当前上下文导入
    },
    /* 可供选择的别名语法（点击展示） */
    /* 高级解析选项（点击展示） */  },

  performance: {
    hints: "warning", // 枚举    maxAssetSize: 200000, // 整数类型（以字节为单位）
    maxEntrypointSize: 400000, // 整数类型（以字节为单位）
    assetFilter: function(assetFilename) {
      // 提供资源文件名的断言函数
      return assetFilename.endsWith('.css') || assetFilename.endsWith('.js');
    }
  },

  devtool: "source-map", // enum  // 通过在浏览器调试工具(browser devtools)中添加元信息(meta info)增强调试
  // 牺牲了构建速度的 `source-map' 是最详细的。

  context: __dirname, // string（绝对路径！）
  // webpack 的主目录
  // entry 和 module.rules.loader 选项
  // 相对于此目录解析

  target: "web", // 枚举  // 包(bundle)应该运行的环境
  // 更改 块加载行为(chunk loading behavior) 和 可用模块(available module)

  externals: ["react", /^@angular\//],  // 不要遵循/打包这些模块，而是在运行时从环境中请求他们

  stats: "errors-only",  // 精确控制要显示的 bundle 信息

  devServer: {
    proxy: { // proxy URLs to backend development server
      '/api': 'http://localhost:3000'
    },
    contentBase: path.join(__dirname, 'public'), // boolean | string | array, static file location
    compress: true, // enable gzip compression
    historyApiFallback: true, // true for index.html upon 404, object for multiple paths
    hot: true, // hot module replacement. Depends on HotModuleReplacementPlugin
    https: false, // true for self-signed, object for cert authority
    noInfo: true, // only errors & warns on hot reload
    // ...
  },

  plugins: [
    // ...
  ],
  // 附加插件列表


  /* 高级配置（点击展示） */}
```

## 使用不同语言进行配置(configuration languages)

### TypeScript

为了用 [TypeScript](http://www.typescriptlang.org/) 书写 webpack 的配置文件，必须先安装相关依赖：

```bash
npm install --save-dev typescript ts-node @types/node @types/webpack
```

之后就可以使用 TypeScript 书写 webpack 的配置文件了：

**webpack.config.ts**

```typescript
import path from 'path';
import webpack from 'webpack';

const config: webpack.Configuration = {
  mode: 'production',
  entry: './foo.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'foo.bundle.js'
  }
};

export default config;
```

以上示例假定 webpack 版本 >= 2.7，或者，在 `tsconfig.json` 文件中，具有 `esModuleInterop` 和 `allowSyntheticDefaultImports` 这两个新的编译器选项的较新版本 TypeScript。

注意，你还需要核对 `tsconfig.json` 文件。如果 `tsconfig.json` 中的 `compilerOptions` 中的 module 字段是 `commonjs` ，则配置是正确的，否则 webpack 将因为错误而构建失败。发生这种情况，是因为 `ts-node` 不支持 `commonjs` 以外的任何模块语法。

这个问题有两种解决方案：

- 修改 `tsconfig.json`。
- 安装 `tsconfig-paths`。

__第一个选项_是指，打开你的 `tsconfig.json` 文件并查找 `compilerOptions`。将 `target` 设置为 `"ES5"`，以及将 `module` 设置为 `"CommonJS"`（或者完全移除 `module` 选项）。

__第二个选项_是指，安装 `tsconfig-paths` 包：

```bash
npm install --save-dev tsconfig-paths
```

然后，为你的 webpack 配置，专门创建一个单独的 TypeScript 配置：

**tsconfig-for-webpack-config.json**

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es5"
  }
}
```

> `ts-node` 可以使用 `tsconfig-path` 提供的环境变量来解析 `tsconfig.json` 文件。

然后，设置 `tsconfig-path` 提供的环境变量 `process.env.TS_NODE_PROJECT`，如下所示：

**package.json**

```json
{
  "scripts": {
    "build": "TS_NODE_PROJECT=\"tsconfig-for-webpack-config.json\" webpack"
  }
}
```

### CoffeeScript

类似的，为了使用 [CoffeeScript](http://coffeescript.org/) 来书写配置文件, 同样需要安装相关的依赖：

```bash
npm install --save-dev coffee-script
```

之后就可以使用 Coffeecript 书写配置文件了：

**webpack.config.coffee**

```javascript
HtmlWebpackPlugin = require('html-webpack-plugin')
webpack = require('webpack')
path = require('path')

config =
  mode: 'production'
  entry: './path/to/my/entry/file.js'
  output:
    path: path.resolve(__dirname, 'dist')
    filename: 'my-first-webpack.bundle.js'
  module: rules: [ {
    test: /\.(js|jsx)$/
    use: 'babel-loader'
  } ]
  plugins: [
    new (webpack.optimize.UglifyJsPlugin)
    new HtmlWebpackPlugin(template: './src/index.html')
  ]

module.exports = config
```

### Babel and JSX

在以下的例子中，使用了 JSX（React 形式的 javascript）以及 Babel 来创建 JSON 形式的 webpack 配置文件：

> 感谢 [Jason Miller](https://twitter.com/_developit/status/769583291666169862)

首先安装依赖：

```js
npm install --save-dev babel-register jsxobj babel-preset-es2015
```

**.babelrc**

```json
{
  "presets": [ "es2015" ]
}
```

**webpack.config.babel.js**

```js
import jsxobj from 'jsxobj';

// example of an imported plugin
const CustomPlugin = config => ({
  ...config,
  name: 'custom-plugin'
});

export default (
  <webpack target="web" watch mode="production">
    <entry path="src/index.js" />
    <resolve>
      <alias {...{
        react: 'preact-compat',
        'react-dom': 'preact-compat'
      }} />
    </resolve>
    <plugins>
      <uglify-js opts={{
        compression: true,
        mangle: false
      }} />
      <CustomPlugin foo="bar" />
    </plugins>
  </webpack>
);
```

> 如果你在其他地方也使用了 Babel 并且把`模块(modules)`设置为了 `false`，那么你要么同时维护两份单独的 `.babelrc` 文件，要么使用 `conts jsxobj = requrie('jsxobj');` 并且使用 `moduel.exports` 而不是新版本的 `import` 和 `export` 语法。这是因为尽管 Node.js 已经支持了许多 ES6 的新特性，然而还无法支持 ES6 模块语法。

## 多种配置类型(configuration types)

### 导出为一个函数

最终，你会发现需要在[开发](https://www.webpackjs.com/guides/development)和[生产构建](https://www.webpackjs.com/guides/production)之间，消除 `webpack.config.js` 的差异。（至少）有两种选项：

作为导出一个配置对象的替代，还有一种可选的导出方式是，从 webpack 配置文件中导出一个函数。该函数在调用时，可传入两个参数：

- 环境对象(environment)作为第一个参数。有关语法示例，请查看[CLI 文档的环境选项](https://www.webpackjs.com/api/cli#environment-options)。 一个选项 map 对象（`argv`）作为第二个参数。这个对象描述了传递给 webpack 的选项，并且具有 [`output-filename`](https://www.webpackjs.com/api/cli/#output-options) 和 [`optimize-minimize`](https://www.webpackjs.com/api/cli/#optimize-options) 等 key。

```diff
-module.exports = {
+module.exports = function(env, argv) {
+  return {
+    mode: env.production ? 'production' : 'development',
+    devtool: env.production ? 'source-maps' : 'eval',
     plugins: [
       new webpack.optimize.UglifyJsPlugin({
+        compress: argv['optimize-minimize'] // 只有传入 -p 或 --optimize-minimize
       })
     ]
+  };
};
```

### 导出一个 Promise

webpack 将运行由配置文件导出的函数，并且等待 Promise 返回。便于需要异步地加载所需的配置变量。

```js
module.exports = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({
        entry: './app.js',
        /* ... */
      })
    }, 5000)
  })
}
```

### 导出多个配置对象

作为导出一个配置对象/配置函数的替代，你可能需要导出多个配置对象（从 webpack 3.1.0 开始支持导出多个函数）。当运行 webpack 时，所有的配置对象都会构建。例如，导出多个配置对象，对于针对多个[构建目标](https://www.webpackjs.com/configuration/output#output-librarytarget)（例如 AMD 和 CommonJS）[打包一个 library](https://www.webpackjs.com/guides/author-libraries) 非常有用。

```js
module.exports = [{
  output: {
    filename: './dist-amd.js',
    libraryTarget: 'amd'
  },
  entry: './app.js',
  mode: 'production',
}, {
  output: {
    filename: './dist-commonjs.js',
    libraryTarget: 'commonjs'
  },
  entry: './app.js',
  mode: 'production',
}]
```

## TODO











## 指南起步

详见 demo01
webpack 用于编译 JavaScript 模块。一旦完成安装，你就可以通过 webpack 的 CLI 或 API 与其配合交互。如果你还不熟悉 webpack，请阅读核心概念和打包器对比，了解为什么你要使用 webpack，而不是社区中的其他工具。

### 基本安装

首先我们创建一个目录，初始化 npm，然后 [在本地安装 webpack](https://www.webpackjs.com/guides/installation#local-installation)，接着安装 webpack-cli（此工具用于在命令行中运行 webpack）：

```bash
mkdir webpack-demo && cd webpack-demo
npm init -y
npm install webpack webpack-cli --save-dev
```

贯穿整个指南的是，我们将使用 `diff` 块，来显示我们对目录、文件和代码所做的更改。

现在我们将创建以下目录结构、文件和内容：

**project**

```diff
  webpack-demo
  |- package.json
+ |- index.html
+ |- /src
+   |- index.js
```

**src/index.js**

```javascript
function component() {
  var element = document.createElement('div');

  // Lodash（目前通过一个 script 脚本引入）对于执行这一行是必需的
  element.innerHTML = _.join(['Hello', 'webpack'], ' ');

  return element;
}

document.body.appendChild(component());
```

**index.html**

```html
<!doctype html>
<html>
  <head>
    <title>起步</title>
    <script src="https://unpkg.com/lodash@4.16.6"></script>
  </head>
  <body>
    <script src="./src/index.js"></script>
  </body>
</html>
```

我们还需要调整 `package.json` 文件，以便确保我们安装包是`私有的(private)`，并且移除 `main` 入口。这可以防止意外发布你的代码。

> 如果你想要了解 `package.json` 内在机制的更多信息，我们推荐阅读 [npm 文档](https://docs.npmjs.com/files/package.json)。

**package.json**

```json
  {
    "name": "webpack-demo",
    "version": "1.0.0",
    "description": "",
+   "private": true,
-   "main": "index.js",
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "devDependencies": {
      "webpack": "^4.0.1",
      "webpack-cli": "^2.0.9"
    },
    "dependencies": {}
  }
```

在此示例中，`<script>` 标签之间存在隐式依赖关系。`index.js` 文件执行之前，还依赖于页面中引入的 `lodash`。之所以说是隐式的是因为 `index.js` 并未显式声明需要引入 `lodash`，只是假定推测已经存在一个全局变量 `_`。

使用这种方式去管理 JavaScript 项目会有一些问题：

- 无法立即体现，脚本的执行依赖于外部扩展库(external library)。
- 如果依赖不存在，或者引入顺序错误，应用程序将无法正常运行。
- 如果依赖被引入但是并没有使用，浏览器将被迫下载无用代码。

让我们使用 webpack 来管理这些脚本。

### 创建一个 bundle 文件

首先，我们稍微调整下目录结构，将“源”代码(`/src`)从我们的“分发”代码(`/dist`)中分离出来。“源”代码是用于书写和编辑的代码。“分发”代码是构建过程产生的代码最小化和优化后的“输出”目录，最终将在浏览器中加载：

**project**

```diff
  webpack-demo
  |- package.json
+ |- /dist
+   |- index.html
- |- index.html
  |- /src
    |- index.js
```

要在 `index.js` 中打包 `lodash` 依赖，我们需要在本地安装 library：

```bash
npm install --save lodash
```

> 在安装一个要打包到生产环境的安装包时，你应该使用 `npm install --save`，如果你在安装一个用于开发环境的安装包（例如，linter, 测试库等），你应该使用 `npm install --save-dev`。请在 [npm 文档](https://docs.npmjs.com/cli/install) 中查找更多信息。

现在，在我们的脚本中 import `lodash`：

**src/index.js**

```diff
+ import _ from 'lodash';
+
  function component() {
    var element = document.createElement('div');

-   // Lodash, currently included via a script, is required for this line to work
+   // Lodash, now imported by this script
    element.innerHTML = _.join(['Hello', 'webpack'], ' ');

    return element;
  }

  document.body.appendChild(component());
```

现在，由于通过打包来合成脚本，我们必须更新 `index.html` 文件。因为现在是通过 `import` 引入 lodash，所以将 lodash `<script>` 删除，然后修改另一个 `<script>` 标签来加载 bundle，而不是原始的 `/src` 文件：

**dist/index.html**

```diff
  <!doctype html>
  <html>
   <head>
     <title>起步</title>
-    <script src="https://unpkg.com/lodash@4.16.6"></script>
   </head>
   <body>
-    <script src="./src/index.js"></script>
+    <script src="main.js"></script>
   </body>
  </html>
```

在这个设置中，`index.js` 显式要求引入的 `lodash` 必须存在，然后将它绑定为 `_`（没有全局作用域污染）。通过声明模块所需的依赖，webpack 能够利用这些信息去构建依赖图，然后使用图生成一个优化过的，会以正确顺序执行的 bundle。

可以这样说，执行 `npx webpack`，会将我们的脚本作为[入口起点](https://www.webpackjs.com/concepts/entry-points)，然后 [输出](https://www.webpackjs.com/concepts/output) 为 `main.js`。Node 8.2+ 版本提供的 `npx` 命令，可以运行在初始安装的 webpack 包(package)的 webpack 二进制文件（`./node_modules/.bin/webpack`）：

```bash
npx webpack

Hash: dabab1bac2b940c1462b
Version: webpack 4.0.1
Time: 3003ms
Built at: 2018-2-26 22:42:11
    Asset      Size  Chunks             Chunk Names
main.js  69.6 KiB       0  [emitted]  main
Entrypoint main = main.js
   [1] (webpack)/buildin/module.js 519 bytes {0} [built]
   [2] (webpack)/buildin/global.js 509 bytes {0} [built]
   [3] ./src/index.js 256 bytes {0} [built]
    + 1 hidden module

WARNING in configuration(配置警告)
The 'mode' option has not been set. Set 'mode' option to 'development' or 'production' to enable defaults for this environment.('mode' 选项还未设置。将 'mode' 选项设置为 'development' 或 'production'，来启用环境默认值。)
```

> 输出可能会稍有不同，但是只要构建成功，那么你就可以继续。并且不要担心，稍后我们就会解决。

在浏览器中打开 `index.html`，如果一切访问都正常，你应该能看到以下文本：'Hello webpack'。

### 模块

[ES2015](https://babeljs.io/learn-es2015/) 中的 [`import`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) 和 [`export`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export) 语句已经被标准化。虽然大多数浏览器还无法支持它们，但是 webpack 却能够提供开箱即用般的支持。

事实上，webpack 在幕后会将代码“转译”，以便旧版本浏览器可以执行。如果你检查 `dist/bundle.js`，你可以看到 webpack 具体如何实现，这是独创精巧的设计！除了 `import` 和 `export`，webpack 还能够很好地支持多种其他模块语法，更多信息请查看[模块 API](https://www.webpackjs.com/api/module-methods)。

注意，webpack 不会更改代码中除 `import` 和 `export` 语句以外的部分。如果你在使用其它 [ES2015 特性](http://es6-features.org/)，请确保你在 webpack 的 [loader 系统](https://www.webpackjs.com/concepts/loaders/)中使用了一个像是 [Babel](https://babeljs.io/) 或 [Bublé](https://buble.surge.sh/guide/) 的[转译器](https://www.webpackjs.com/loaders/#transpiling)。

### 使用一个配置文件

在 webpack 4 中，可以无须任何配置使用，然而大多数项目会需要很复杂的设置，这就是为什么 webpack 仍然要支持 [配置文件](https://www.webpackjs.com/concepts/configuration)。这比在终端(terminal)中手动输入大量命令要高效的多，所以让我们创建一个取代以上使用 CLI 选项方式的配置文件：

**project**

```diff
  webpack-demo
  |- package.json
+ |- webpack.config.js
  |- /dist
    |- index.html
  |- /src
    |- index.js
```

* webpack 配置文件 **webpack.config.js**
```javascript
// 引入 path 模块
const path = require('path')

// 配置 webpack
module.exports = {
    entry: './src/index.js', // 入口
    output: { //输出
        filename: 'bundle.js', // 打包后的文件
        path: path.resolve(__dirname,'dist') // 打包后文件存放的路径，最好是绝对路径
    }
}
```
* webpack 构建命令
```js
npx webpack --config webpack.config.js
// 如果 webpack.config.js 存在，则 webpack 命令将默认选择使用它。在这里使用--config 选项只是向你表明，可以传递任何名称的配置文件
```
###  NPM 脚本
```json
 "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1",
      "build": "webpack"
    }
```
*默认存在webpack.config.js文件*

可以使用 `npm run build` 命令，来替代我们之前使用的 `npx` 命令。注意，使用 npm 的 `scripts`，我们可以像使用 `npx` 那样通过模块名引用本地安装的 npm 包。这是大多数基于 npm 的项目遵循的标准，因为它允许所有贡献者使用同一组通用脚本（如果必要，每个 flag 都带有 `--config` 标志）。

现在使用npm脚本来构建项目

```bash
cnpm run build

> webpack-demo@1.0.0 build /home/chensj/web-code/webpack-demo/webpack-demo/demo01
> webpack

Hash: 136fd0d514524ec66e2b
Version: webpack 4.28.2
Time: 464ms
Built at: 2018-12-27 22:35:06
  Asset      Size  Chunks             Chunk Names
main.js  70.3 KiB       0  [emitted]  main
Entrypoint main = main.js
[1] ./src/index.js 263 bytes {0} [built]
[2] (webpack)/buildin/global.js 472 bytes {0} [built]
[3] (webpack)/buildin/module.js 497 bytes {0} [built]
    + 1 hidden module

WARNING in configuration
The 'mode' option has not been set, webpack will fallback to 'production' for this value. Set 'mode' option to 'development' or 'production' to enable defaults for each environment.
You can also set it to 'none' to disable any default behavior. Learn more: https://webpack.js.org/concepts/mode/
```

webpack的默认配置文件名称为`webpack.config.js`，不能写错，否则无法需要在npm脚本中指定

##  管理资源

如果你是从开始一直遵循着指南的示例，现在会有一个小项目，显示 "Hello webpack"。现在我们尝试整合一些其他资源，比如图像，看看 webpack 如何处理。

在 webpack 出现之前，前端开发人员会使用 grunt 和 gulp 等工具来处理资源，并将它们从 `/src` 文件夹移动到 `/dist` 或 `/build` 目录中。同样方式也被用于 JavaScript 模块，但是，像 webpack 这样的工具，将**动态打包(dynamically bundle)**所有依赖项（创建所谓的[依赖图(dependency graph)](https://www.webpackjs.com/concepts/dependency-graph)）。这是极好的创举，因为现在每个模块都可以*明确表述它自身的依赖*，我们将避免打包未使用的模块。

`webpack` 最出色的功能之一就是，除了 `JavaScript`，还可以通过` loader` *引入任何其他类型的文件*。也就是说，以上列出的那些 JavaScript 的优点（例如显式依赖），同样可以用来构建网站或 web 应用程序中的所有非 JavaScript 内容。让我们从 CSS 开始起步，或许你可能已经熟悉了这个设置过程。

*详见demo02*

###  css 资源 `demo02`

#### 导入loader/rules

为了从 JavaScript 模块中 `import` 一个 CSS 文件，你需要在 [`module` 配置中](https://www.webpackjs.com/configuration/module) 安装并添加 [style-loader](https://www.webpackjs.com/loaders/style-loader) 和 [css-loader](https://www.webpackjs.com/loaders/css-loader)：

```bash
npm install --save-dev style-loader css-loader
cnpm install --save-dev style-loader css-loader
```

#### 增加webpack配置

#####  **webpack.config.js**  增加处理css

```diff
 const path = require('path');

  module.exports = {
    entry: './src/index.js',
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, 'dist')
    },
+   module: {
+     rules: [ //在webpack2.x之后新加的 会存在问题
+       {
+         test: /\.css$/,
+         use: [
+           'style-loader',
+           'css-loader'
+         ]
+       }
+     ]
+   }
  };
```

webpack 根据正则表达式，来确定应该查找哪些文件，并将其提供给指定的 loader。在这种情况下，以 `.css` 结尾的全部文件，都将被提供给 `style-loader` 和 `css-loader`。

这使你可以在依赖于此样式的文件中 `import './style.css'`。现在，当该模块运行时，含有 CSS 字符串的 `<style>` 标签，将被插入到 html 文件的 `<head>` 中。

我们尝试一下，通过在项目中添加一个新的 `style.css` 文件，并将其导入到我们的 `index.js`中：

#####  **project**

```diff
  webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
    |- bundle.js
    |- index.html
  |- /src
+   |- style.css
    |- index.js
  |- /node_modules
```

#####  **src/style.css**

```css
.hello {
  color: red;
}
```

#####  **index.js**

```javascript
import _ from 'lodash'
import './style.css';
function component() {
    var element = document.createElement('div');

    // Lodash（目前通过一个 script 脚本引入）对于执行这一行是必需的
    element.innerHTML = _.join(['Hello', 'webpack'], ' ');
    //添加class样式
    element.classList.add('hello');

    return element;
}

document.body.appendChild(component());
```

#####  **build**

```bash
npm run build

> demo03@1.0.0 build /home/chensj/web-code/webpack-demo/webpack-demo/demo03
> webpack -p

Hash: a941b72957c382271e1f
Version: webpack 4.28.2
Time: 1446ms
Built at: 12/28/2018 12:19:02 AM
    Asset      Size  Chunks             Chunk Names
bundle.js  24.9 KiB       0  [emitted]  main
Entrypoint main = bundle.js
[17] ./src/index.js 262 bytes {0} [built]
[52] ./src/styles.css 1.13 KiB {0} [built]
[53] ./node_modules/_css-loader@2.1.0@css-loader/dist/cjs.js!./src/styles.css 183 bytes {0} [built]
    + 54 hidden modules
```

### 加载图片 `demo03`
#### 增加loaders/rules

```bash
npm install --save-dev file-loader
cnpm install --save-dev file-loader
```

#### 配置webpack

##### **webpack.config.js**

```js
const path = require('path')

module.exports = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test:/\.css$/,
                use:[ 'style-loader' , 'css-loader' ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: ['file-loader']
            }
        ]
    }
}
```

##### **project**

```diff
  webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
    |- bundle.js
    |- index.html
  |- /src
+   |- icon.png
    |- style.css
    |- index.js
  |- /node_modules
```

##### **src/index.js**

```javascript
const _ = require('loadsh')
// 引入css
require('./styles.css')
// 引入 图片
const Icon = require('./icon.png')
function addContent(){
    var ele = document.createElement('div')
    ele.innerHTML = _.join(['Hello','webpack'],' ');
    ele.classList.add('hello');
     // 将图像添加到我们现有的 div。
     var myIcon = new Image(); 
     myIcon.src = Icon; 
     ele.appendChild(myIcon);
    return ele;
}
document.body.appendChild(addContent());
```

##### **styles.css**

```css
.hello{
    color:red;
    background: url('./icon.png');
}
```

##### **build**

```bash
cnpm run build

> demo03@1.0.0 build /home/chensj/web-code/webpack-demo/webpack-demo/demo03
> webpack -p

Hash: 2d82b467882328216406
Version: webpack 4.28.2
Time: 1491ms
Built at: 12/28/2018 12:37:38 AM
                               Asset      Size  Chunks             Chunk Names
                           bundle.js  25.2 KiB       0  [emitted]  main
ef916021687c1ea97d96cb821522c8b2.png  1.92 KiB          [emitted]
Entrypoint main = bundle.js
[17] ./src/icon.png 82 bytes {0} [built]
[18] ./src/index.js 427 bytes {0} [built]
[53] ./src/styles.css 1.13 KiB {0} [built]
[54] ./node_modules/_css-loader@2.1.0@css-loader/dist/cjs.js!./src/styles.css 416 bytes{0} [built]
    + 55 hidden modules
```

### 加载字体 `demo04`

像字体这样的其他资源如何处理呢？file-loader 和 url-loader 可以接收并加载任何文件，然后将其输出到构建目录。这就是说，我们可以将它们用于任何类型的文件，包括字体。让我们更新 `webpack.config.js` 来处理字体文件：

####  **webpack.config.js**

```javascript
const path = require('path')

module.exports = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {  // css 处理
                test:/\.css$/,
                use:[ 'style-loader' , 'css-loader' ]
            },
            {  // 图片处理
                test: /\.(png|svg|jpg|gif)$/,
                use: ['file-loader']
            },
            { // 文字字体处理
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: ['file-loader']
            }

        ]
    }
}
```

#### **src/styles.css**

```css
@font-face {
    font-family: 'MyFont';
    src: url('./myFont.woff2') format('woff2'),
         url('./myFont.woff') format('woff');
    font-weight: 600;
    font-style: normal;
}
.hello{
    color:red;
    font-family: 'MyFont';
    background: url('./icon.png');
}
```

### 加载数据 `demo05`

可以加载的有用资源还有数据，如 JSON 文件，CSV、TSV 和 XML。类似于 NodeJS，JSON 支持实际上是内置的，也就是说 `import Data from './data.json'` 默认将正常运行。要导入 CSV、TSV 和 XML，你可以使用 [csv-loader](https://github.com/theplatapi/csv-loader) 和 [xml-loader](https://github.com/gisikw/xml-loader)。让我们处理这三类文件：

#### 增加loaders/rules

```bash
npm install --save-dev csv-loader xml-loader
cnpm install --save-dev csv-loader xml-loader
```

#### webpack配置

##### **webpack.config.js**

```javascript
const path = require('path')

module.exports = {
    entry: './src/index.js',
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {  // css 处理
                test:/\.css$/,
                use:[ 'style-loader' , 'css-loader' ]
            },
            {  // 图片处理
                test: /\.(png|svg|jpg|gif)$/,
                use: ['file-loader']
            },
            { // 文字字体处理
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: ['file-loader']
            },
            { // 处理csv
                test: /\.(csv|tsv)$/,
                use: ['csv-loader'] 
            },
            { // 处理xml
                test: /\.xml$/,
                use: ['xml-loader'] 
            }
        ]
    }
}
```

##### **project**

```diff
  webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
    |- bundle.js
    |- index.html
  |- /src
+   |- data.xml
    |- my-font.woff
    |- my-font.woff2
    |- icon.png
    |- style.css
    |- index.js
  |- /node_modules
```

##### **xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<note>
  <to>Mary</to>
  <from>John</from>
  <heading>Reminder</heading>
  <body>Call Cindy on Tuesday</body>
</note>
```

##### **index.js**

```javascript
const _ = require('loadsh')
// 引入css
require('./styles.css')
// 引入 图片
const Icon = require('./icon.png')
const data = require('./data.xml')
function addContent(){
    var ele = document.createElement('div')
    ele.innerHTML = _.join(['Hello','webpack'],' ');
    ele.classList.add('hello');
     // 将图像添加到我们现有的 div。
     var myIcon = new Image(); 
     myIcon.src = Icon; 
     ele.appendChild(myIcon);
     console.log(data);
     var e1 = document.createElement('div')
     e1.innerHTML = data;
     ele.appendChild(e1);
    return ele;
}
document.body.appendChild(addContent());
```

##### **build**

```bash
cnpm run build

> demo03@1.0.0 build /home/chensj/web-code/webpack-demo/webpack-demo/demo05
> webpack -p

Hash: 74454f625055435996e3
Version: webpack 4.28.2
Time: 1957ms
Built at: 12/28/2018 1:02:57 AM
                                Asset      Size  Chunks             Chunk Names
 674f50d287a8c48dc19ba404d20fe713.eot   162 KiB          [emitted]
                            bundle.js  25.8 KiB       0  [emitted]  main
 ef916021687c1ea97d96cb821522c8b2.png  1.92 KiB          [emitted]
fee66e712a8a08eef5805a46892932ad.woff  95.7 KiB          [emitted]
Entrypoint main = bundle.js
[17] ./src/icon.png 82 bytes {0} [built]
[18] ./src/index.js 582 bytes {0} [built]
[53] ./src/styles.css 1.13 KiB {0} [built]
[54] ./node_modules/_css-loader@2.1.0@css-loader/dist/cjs.js!./src/styles.css 799 bytes{0} [built]
[57] ./src/myFont.eot 82 bytes {0} [built]
[58] ./src/myFont.woff 83 bytes {0} [built]
[61] ./src/data.xml 113 bytes {0} [built]
    + 55 hidden modules
```

### 全局资源

上述所有内容中最出色之处是，以这种方式加载资源，你可以以更直观的方式将模块和资源组合在一起。无需依赖于含有全部资源的 `/assets` 目录，而是将资源与代码组合在一起。例如，类似这样的结构会非常有用：

```diff
- |- /assets
+ |– /components
+ |  |– /my-component
+ |  |  |– index.jsx
+ |  |  |– index.css
+ |  |  |– icon.svg
+ |  |  |– img.png
```

这种配置方式会使你的代码更具备可移植性，因为现有的统一放置的方式会造成所有资源紧密耦合在一起。假如你想在另一个项目中使用 `/my-component`，只需将其复制或移动到 `/components` 目录下。只要你已经安装了任何*扩展依赖(external dependencies)*，并且你*已经在配置中定义过相同的 loader*，那么项目应该能够良好运行。

但是，假如你无法使用新的开发方式，只能被固定于旧有开发方式，或者你有一些在多个组件（视图、模板、模块等）之间共享的资源。你仍然可以将这些资源存储在公共目录(base directory)中，甚至配合使用 [alias](https://www.webpackjs.com/configuration/resolve#resolve-alias) 来使它们更方便 `import 导入`。

### 回退处理

对于接下来的指南，我们无需使用本指南中所有用到的资源，因此我们会进行一些清理工作，以便为下一部分指南中的[管理输出章节](https://www.webpackjs.com/guides/output-management/)做好准备：

**project**

```diff
  webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
    |- bundle.js
    |- index.html
  |- /src
-   |- data.xml
-   |- my-font.woff
-   |- my-font.woff2
-   |- icon.png
-   |- style.css
    |- index.js
  |- /node_modules
```

**webpack.config.js**

```diff
  const path = require('path');

  module.exports = {
    entry: './src/index.js',
    output: {
      filename: 'bundle.js',
      path: path.resolve(__dirname, 'dist')
    },
-   module: {
-     rules: [
-       {
-         test: /\.css$/,
-         use: [
-           'style-loader',
-           'css-loader'
-         ]
-       },
-       {
-         test: /\.(png|svg|jpg|gif)$/,
-         use: [
-           'file-loader'
-         ]
-       },
-       {
-         test: /\.(woff|woff2|eot|ttf|otf)$/,
-         use: [
-           'file-loader'
-         ]
-       },
-       {
-         test: /\.(csv|tsv)$/,
-         use: [
-           'csv-loader'
-         ]
-       },
-       {
-         test: /\.xml$/,
-         use: [
-           'xml-loader'
-         ]
-       }
-     ]
-   }
  };
```

**src/index.js**

```diff
  import _ from 'lodash';
- import './style.css';
- import Icon from './icon.png';
- import Data from './data.xml';
-
  function component() {
    var element = document.createElement('div');
-
-   // Lodash，现在通过 script 标签导入
    element.innerHTML = _.join(['Hello', 'webpack'], ' ');
-   element.classList.add('hello');
-
-   // 将图像添加到我们已有的 div 中。
-   var myIcon = new Image();
-   myIcon.src = Icon;
-
-   element.appendChild(myIcon);
-
-   console.log(Data);

    return element;
  }

  document.body.appendChild(component());
```



## 管理输出

到目前为止，我们在 `index.html` 文件中手动引入所有资源，然而随着应用程序增长，并且一旦开始对[文件名使用哈希(hash)](https://www.webpackjs.com/guides/caching)]并输出[多个 bundle](https://www.webpackjs.com/guides/code-splitting)，手动地对 `index.html` 文件进行管理，一切就会变得困难起来。然而，可以通过一些插件，会使这个过程更容易操控。

### 预先准备 `demo06`

首先，让我们调整一下我们的项目：

#### **project**

```diff
webpack-demo
  |- package.json
  |- webpack.config.js
  |- /dist
  |- /src
    |- index.js
+   |- print.js
  |- /node_modules
```

我们在 `src/print.js` 文件中添加一些逻辑：

#### **src/print.js**

```js
export default function printMe() {
  console.log('I get called from print.js!');
}
```

并且在 `src/index.js` 文件中使用这个函数：

#### **src/index.js**

```diff
  import _ from 'lodash';
+ import printMe from './print.js';

  function component() {
    var element = document.createElement('div');
+   var btn = document.createElement('button');

    element.innerHTML = _.join(['Hello', 'webpack'], ' ');

+   btn.innerHTML = 'Click me and check the console!';
+   btn.onclick = printMe;
+
+   element.appendChild(btn);

    return element;
  }

  document.body.appendChild(component());
```

我们还要更新 `dist/index.html` 文件，来为 webpack 分离入口做好准备：

#### **dist/index.html**

```diff
  <!doctype html>
  <html>
    <head>
-     <title>Asset Management</title>
+     <title>Output Management</title>
+     <script src="./print.bundle.js"></script>
    </head>
    <body>
-     <script src="./bundle.js"></script>
+     <script src="./app.bundle.js"></script>
    </body>
  </html>
```

现在调整配置。我们将在 entry 添加 `src/print.js` 作为新的入口起点（`print`），然后修改 output，以便根据入口起点名称动态生成 bundle 名称：

#### **webpack.config.js**

```diff
  const path = require('path');

  module.exports = {
-   entry: './src/index.js',
+   entry: { // 入口文件修改为两个
+     app: './src/index.js',
+     print: './src/print.js'
+   },
    output: {
-     filename: 'bundle.js',
+     filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

执行 `npm run build`，然后看到生成如下：

```bash
Hash: aa305b0f3373c63c9051
Version: webpack 3.0.0
Time: 536ms
          Asset     Size  Chunks                    Chunk Names
  app.bundle.js   545 kB    0, 1  [emitted]  [big]  app
print.bundle.js  2.74 kB       1  [emitted]         print
   [0] ./src/print.js 84 bytes {0} {1} [built]
   [1] ./src/index.js 403 bytes {0} [built]
   [3] (webpack)/buildin/global.js 509 bytes {0} [built]
   [4] (webpack)/buildin/module.js 517 bytes {0} [built]
    + 1 hidden module
```

我们可以看到，webpack 生成 `print.bundle.js` 和 `app.bundle.js` 文件，这也和我们在 `index.html` 文件中指定的文件名称相对应。如果你在浏览器中打开 `index.html`，就可以看到在点击按钮时会发生什么。

但是，如果我们更改了我们的一个入口起点的名称，甚至添加了一个新的名称，会发生什么？生成的包将被重命名在一个构建中，但是我们的`index.html`文件仍然会引用旧的名字。我们用 [`HtmlWebpackPlugin`](https://www.webpackjs.com/plugins/html-webpack-plugin) 来解决这个问题。

### 多入口处理

#### 设定 HtmlWebpackPlugin

首先安装插件，并且调整 `webpack.config.js` 文件：

```bash
npm install --save-dev html-webpack-plugin
cnpm install --save-dev html-webpack-plugin
```

####  **webpack.config.js** 引入plugin

```javascript
const path = require('path')
const htmlWepackPlugin = require('html-webpack-plugin')
module.exports = {
    entry: { //多入口
        app: './src/index.js',
        print: './src/print.js'
    },
    plugins: [
        new htmlWebpackPlugin({
            title: '输出管理'
        })
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js' //输出根据entry定义的名称来输出
    }
}
```

在我们构建之前，你应该了解，虽然在 `dist/` 文件夹我们已经有 `index.html` 这个文件，然而 `HtmlWebpackPlugin` 还是会默认生成 `index.html` 文件。这就是说，它会用新生成的 `index.html` 文件，把我们的原来的替换。让我们看下在执行 `npm run build` 后会发生什么：

```bash
npm run build

> demo06@1.0.0 build E:\03_代码\self\web\webpack-demo\demo06
> webpack -p

Hash: cd32b5ea3f9def263c10
Version: webpack 4.28.3
Time: 3004ms
Built at: 2018-12-30 23:00:53
          Asset       Size  Chunks             Chunk Names
  app.bundle.js   70.6 KiB    0, 1  [emitted]  app
     index.html  241 bytes          [emitted]
print.bundle.js   1.02 KiB       1  [emitted]  print
Entrypoint app = app.bundle.js
Entrypoint print = print.bundle.js
[0] ./src/print.js 85 bytes {0} {1} [built]
[2] ./src/index.js 412 bytes {0} [built]
[3] (webpack)/buildin/global.js 472 bytes {0} [built]
[4] (webpack)/buildin/module.js 497 bytes {0} [built]
    + 1 hidden module
Child html-webpack-plugin for "index.html":
     1 asset
    Entrypoint undefined = index.html
    [2] (webpack)/buildin/global.js 472 bytes {0} [built]
    [3] (webpack)/buildin/module.js 497 bytes {0} [built]
        + 2 hidden modules
```

如果你在代码编辑器中将 `index.html` 打开，你就会看到 `HtmlWebpackPlugin` 创建了一个全新的文件，所有的 bundle 会自动添加到 html 中。

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>输出管理</title>
  </head>
  <body>
  <script type="text/javascript" src="app.bundle.js"></script>
  <script type="text/javascript" src="print.bundle.js"></script>
   </body>
</html>
```



如果你想要了解更多 `HtmlWebpackPlugin` 插件提供的全部功能和选项，那么你就应该多多熟悉 [`HtmlWebpackPlugin`](https://github.com/jantimon/html-webpack-plugin) 仓库。

你还可以看一下 [`html-webpack-template`](https://github.com/jaketrent/html-webpack-template)，除了默认模板之外，还提供了一些额外的功能。

###  清理 `/dist` 文件夹

你可能已经注意到，由于过去的指南和代码示例遗留下来，导致我们的 `/dist` 文件夹相当杂乱。webpack 会生成文件，然后将这些文件放置在 `/dist` 文件夹中，但是 webpack 无法追踪到哪些文件是实际在项目中用到的。

通常，在每次构建前清理 `/dist` 文件夹，是比较推荐的做法，因此只会生成用到的文件。让我们完成这个需求。

[`clean-webpack-plugin`](https://www.npmjs.com/package/clean-webpack-plugin) 是一个比较普及的管理插件，让我们安装和配置下。

```bash
npm install clean-webpack-plugin --save-dev
cnpm install clean-webpack-plugin --save-dev
```

####  **webpack.config.js**

```javascript
const path = require('path')
// html 文件重新生成
const htmlWepackPlugin = require('html-webpack-plugin')
// 文件清理
const cleanWebpackPlugin = require('clean-webpack-plugin')
module.exports = {
    entry: { //多入口
        app: './src/index.js',
        print: './src/print.js'
    },
    plugins: [
        new cleanWebpackPlugin(['dist']), // 参数为需要清理的文件夹
        new htmlWepackPlugin({
            title: '输出管理'
        })
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js' //输出根据entry定义的名称来输出
    }
}
```

#### build

```bash
npm run build

> demo06@1.0.0 build E:\03_代码\self\web\webpack-demo\demo06
> webpack -p

clean-webpack-plugin: E:\03_代码\self\web\webpack-demo\demo06\dist has been removed.
Hash: cd32b5ea3f9def263c10
Version: webpack 4.28.3
Time: 557ms
Built at: 2018-12-30 23:07:25
          Asset       Size  Chunks             Chunk Names
  app.bundle.js   70.6 KiB    0, 1  [emitted]  app
     index.html  241 bytes          [emitted]
print.bundle.js   1.02 KiB       1  [emitted]  print
Entrypoint app = app.bundle.js
Entrypoint print = print.bundle.js
[0] ./src/print.js 85 bytes {0} {1} [built]
[2] ./src/index.js 412 bytes {0} [built]
[3] (webpack)/buildin/global.js 472 bytes {0} [built]
[4] (webpack)/buildin/module.js 497 bytes {0} [built]
    + 1 hidden module
Child html-webpack-plugin for "index.html":
     1 asset
    Entrypoint undefined = index.html
    [2] (webpack)/buildin/global.js 472 bytes {0} [built]
    [3] (webpack)/buildin/module.js 497 bytes {0} [built]
        + 2 hidden modules
```

### Manifest

你可能会感兴趣，webpack及其插件似乎“知道”应该哪些文件生成。答案是，通过 manifest，webpack 能够对「你的模块映射到输出 bundle 的过程」保持追踪。如果你对通过其他方式来管理 webpack 的[输出](https://www.webpackjs.com/configuration/output)更感兴趣，那么首先了解 manifest 是个好的开始。

通过使用 [`WebpackManifestPlugin`](https://github.com/danethurber/webpack-manifest-plugin)，可以直接将数据提取到一个 json 文件，以供使用。

我们不会在此展示一个关于如何在你的项目中使用此插件的完整示例，但是你可以仔细深入阅读 [manifest 的概念页面](https://www.webpackjs.com/concepts/manifest)，以及通过[缓存指南](https://www.webpackjs.com/guides/caching)来弄清如何与长期缓存相关联。

## 开发

如果你一直跟随之前的指南，应该对一些 webpack 基础知识有着很扎实的理解。在我们继续之前，先来看看如何建立一个开发环境，使我们的开发变得更容易一些。

###  使用 source map

当 webpack 打包源代码时，可能会很难追踪到错误和警告在源代码中的原始位置。例如，如果将三个源文件（`a.js`, `b.js` 和 `c.js`）打包到一个 bundle（`bundle.js`）中，而其中一个源文件包含一个错误，那么堆栈跟踪就会简单地指向到 `bundle.js`。这并通常没有太多帮助，因为你可能需要准确地知道错误来自于哪个源文件。

为了更容易地追踪错误和警告，JavaScript 提供了 [source map](http://blog.teamtreehouse.com/introduction-source-maps) 功能，将编译后的代码映射回原始源代码。如果一个错误来自于 `b.js`，source map 就会明确的告诉你。

source map 有很多[不同的选项](https://www.webpackjs.com/configuration/devtool)可用，请务必仔细阅读它们，以便可以根据需要进行配置。

对于本指南，我们使用 `inline-source-map` 选项，这有助于解释说明我们的目的（仅解释说明，不要用于生产环境）：

#### **webpack.config.js**

```javascript
const path = require('path')
// html 文件重新生成
const htmlWepackPlugin = require('html-webpack-plugin')
// 文件清理
const cleanWebpackPlugin = require('clean-webpack-plugin')
module.exports = {
    entry: { //多入口
        app: './src/index.js',
        print: './src/print.js'
    },
    devtool: 'inline-source-map', // 仅适用于开发阶段用于跟踪错误
    plugins: [
        new cleanWebpackPlugin(['dist']), // 参数为需要清理的文件夹
        new htmlWepackPlugin({
            title: '输出管理'
        })
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js' //输出根据entry定义的名称来输出
    }
}
```

现在，让我们来做一些调试，在 `print.js` 文件中生成一个错误：

#### **src/print.js** 

增加错误输出代码connole.error()

```javascript
export default function pringme() {
    // console.log("I am called from print.js");
    connole.error('I am called from print.js');
}
```

运行 `npm run build`，就会编译为如下：

```bash
npm run build

> demo06@1.0.0 build E:\03_代码\self\web\webpack-demo\demo07
> webpack -p

clean-webpack-plugin: E:\03_代码\self\web\webpack-demo\demo07\dist has been removed.
Hash: a7f74a966bbddba6fabc
Version: webpack 4.28.3
Time: 3045ms
Built at: 2018-12-30 23:19:02
          Asset       Size  Chunks             Chunk Names
  app.bundle.js   70.6 KiB    0, 1  [emitted]  app
     index.html  241 bytes          [emitted]
print.bundle.js   1.02 KiB       1  [emitted]  print
Entrypoint app = app.bundle.js
Entrypoint print = print.bundle.js
[0] ./src/print.js 137 bytes {0} {1} [built]
[2] ./src/index.js 412 bytes {0} [built]
[3] (webpack)/buildin/global.js 472 bytes {0} [built]
[4] (webpack)/buildin/module.js 497 bytes {0} [built]
    + 1 hidden module
Child html-webpack-plugin for "index.html":
     1 asset
    Entrypoint undefined = index.html
    [2] (webpack)/buildin/global.js 472 bytes {0} [built]
    [3] (webpack)/buildin/module.js 497 bytes {0} [built]
        + 2 hidden modules
```

打开页面后，点击后显示错误：

```html
Uncaught ReferenceError: connole is not defined
    at HTMLUnknownElement.e (print.js:3)
```

根据上述错误可以很好地定位到错误的位置。

### 选择一个开发工具

每次要编译代码时，手动运行 `npm run build` 就会变得很麻烦。

webpack 中有几个不同的选项，可以帮助你在代码发生变化后自动编译代码：

1. webpack's Watch Mode
2. webpack-dev-server
3. webpack-dev-middleware

多数场景中，你可能需要使用 `webpack-dev-server`，但是不妨探讨一下以上的所有选项。

#### 使用观察模式

你可以指示 webpack "watch" 依赖图中的所有文件以进行更改。如果其中一个文件被更新，代码将被重新编译，所以你不必手动运行整个构建。

我们添加一个用于启动 webpack 的观察模式的 npm script 脚本：

##### **package.json**

```json
{
  "name": "demo07",
  "version": "1.0.0",
  "description": "",
  "main": "./src/index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "watch": "webpack --watch",
    "build": "webpack -p"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "css-loader": "^2.1.0",
    "lodash": "^4.17.11",
    "style-loader": "^0.23.1",
    "typings": "^2.1.1"
  },
  "devDependencies": {
    "clean-webpack-plugin": "^1.0.0",
    "csv-loader": "^3.0.2",
    "file-loader": "^3.0.1",
    "html-webpack-plugin": "^3.2.0",
    "typings": "^2.1.1",
    "webpack": "^4.28.3",
    "webpack-cli": "^3.1.2",
    "xml-loader": "^1.2.1"
  }
}
```

在`scripts`中增加一个watch，那么就可以执行`npm run watch`,就可以使用`webpack`编译代码，却不会退出命令行，这是因为`script`脚本还在继续观察文件

现在,保存文件并检查终端窗口。应该可以看到 webpack 自动重新编译修改后的模块！

唯一的缺点是，为了看到修改后的实际效果，你需要刷新浏览器。如果能够自动刷新浏览器就更好了，可以尝试使用 `webpack-dev-server`，恰好可以实现我们想要的功能。

####  使用 webpack-dev-server

`webpack-dev-server` 为你提供了一个简单的 web 服务器，并且能够实时重新加载(live reloading)。让我们设置以下：

```bash
npm install --save-dev webpack-dev-server
cnpm install --save-dev webpack-dev-server
```

#####  **webpack.config.js**

修改配置文件，告诉开发服务器(dev server)，在哪里查找文件：

```javascript
const path = require('path')
// html 文件重新生成
const htmlWepackPlugin = require('html-webpack-plugin')
// 文件清理
const cleanWebpackPlugin = require('clean-webpack-plugin')
module.exports = {
    entry: { //多入口
        app: './src/index.js',
        print: './src/print.js'
    },
    devtool: 'inline-source-map', // 代码调试使用，仅限于开发阶段
    devServer: {
        contentBase: './dist' // 指定文件变化的路径
    },
    plugins: [
        new cleanWebpackPlugin(['dist']), // 参数为需要清理的文件夹
        new htmlWepackPlugin({
            title: '输出管理'
        })
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js' //输出根据entry定义的名称来输出
    }
}
```

以上配置告知 `webpack-dev-server`，在 `localhost:8080` 下建立服务，将 `dist` 目录下的文件，作为可访问文件。

让我们在`package.json`添加一个` script` 脚本，可以直接运行开发服务器(dev server)：

```json
{
  "name": "demo07",
  "version": "1.0.0",
  "description": "",
  "main": "./src/index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "watch": "webpack --watch",
    "start": "webpack-dev-server --open", //dev
    "build": "webpack -p"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "css-loader": "^2.1.0",
    "lodash": "^4.17.11",
    "style-loader": "^0.23.1",
    "typings": "^2.1.1"
  },
  "devDependencies": {
    "clean-webpack-plugin": "^1.0.0",
    "csv-loader": "^3.0.2",
    "file-loader": "^3.0.1",
    "html-webpack-plugin": "^3.2.0",
    "typings": "^2.1.1",
    "webpack": "^4.28.3",
    "webpack-cli": "^3.1.2",
    "webpack-dev-server": "^3.1.14",
    "xml-loader": "^1.2.1"
  }
}
```

现在，我们可以在命令行中运行 `npm start`，就会看到浏览器自动加载页面。如果现在修改和保存任意源文件，web 服务器就会自动重新加载编译后的代码。试一下！

`webpack-dev-server` 带有许多可配置的选项。转到[相关文档](https://www.webpackjs.com/configuration/dev-server)以了解更多。

现在，服务器正在运行，你可能需要尝试[模块热替换(Hot Module Replacement)](https://www.webpackjs.com/guides/hot-module-replacement)！

#### 使用 webpack-dev-middleware

`webpack-dev-middleware` 是一个容器(wrapper)，它可以把 webpack 处理后的文件传递给一个服务器(server)。 `webpack-dev-server` 在内部使用了它，同时，它也可以作为一个单独的包来使用，以便进行更多自定义设置来实现更多的需求。接下来是一个 webpack-dev-middleware 配合 express server 的示例。

首先，安装 `express` 和 `webpack-dev-middleware`：

```bash
npm install --save-dev express webpack-dev-middleware
cnpm install --save-dev express webpack-dev-middleware
```

接下来我们需要对 webpack 的配置文件做一些调整，以确保中间件(middleware)功能能够正确启用：

##### **webpack.config.js**

```javascript
const path = require('path')
// html 文件重新生成
const htmlWepackPlugin = require('html-webpack-plugin')
// 文件清理
const cleanWebpackPlugin = require('clean-webpack-plugin')
module.exports = {
    entry: { //多入口
        app: './src/index.js',
        print: './src/print.js'
    },
    devtool: 'inline-source-map', // 代码调试使用，仅限于开发阶段
    devServer: {
        contentBase: './dist' // 指定文件变化的路径
    },
    plugins: [
        new cleanWebpackPlugin(['dist']), // 参数为需要清理的文件夹
        new htmlWepackPlugin({
            title: '输出管理'
        })
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js', //输出根据entry定义的名称来输出
        publicPath: '/' 
    }
}
```

`publicPath` 也会在服务器脚本用到，以确保文件资源能够在 `http://localhost:3000` 下正确访问，我们稍后再设置端口号。下一步就是设置我们自定义的 `express` 服务：

##### **project**

```diff
webpack-demo
  |- package.json
  |- webpack.config.js
+ |- server.js
  |- /dist
  |- /src
    |- index.js
    |- print.js
  |- /node_modules
```

##### **server.js**

```js
const express = require('express');
const webpack = require('webpack');
const webpackDevMiddleware = require('webpack-dev-middleware');

const app = express();
const config = require('./webpack.config.js');
const compiler = webpack(config);

// Tell express to use the webpack-dev-middleware and use the webpack.config.js
// configuration file as a base.
app.use(webpackDevMiddleware(compiler, {
  publicPath: config.output.publicPath
}));

// Serve the files on port 3000.
app.listen(3000, function () {
  console.log('Example app listening on port 3000!\n');
});
```

现在，添加一个 npm script，以使我们更方便地运行服务：

##### **package.json**

```json
{
  "name": "demo07",
  "version": "1.0.0",
  "description": "",
  "main": "./src/index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "watch": "webpack --watch",
    "start": "webpack-dev-server --open",
    "server": "node server.js",
    "build": "webpack -p"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "css-loader": "^2.1.0",
    "lodash": "^4.17.11",
    "style-loader": "^0.23.1",
    "typings": "^2.1.1"
  },
  "devDependencies": {
    "clean-webpack-plugin": "^1.0.0",
    "csv-loader": "^3.0.2",
    "express": "^4.16.4",
    "file-loader": "^3.0.1",
    "html-webpack-plugin": "^3.2.0",
    "typings": "^2.1.1",
    "webpack": "^4.28.3",
    "webpack-cli": "^3.1.2",
    "webpack-dev-middleware": "^3.4.0",
    "webpack-dev-server": "^3.1.14",
    "xml-loader": "^1.2.1"
  }
}
```

现在，在你的终端执行 `npm run server`，将会有类似如下信息输出：

```bash
npm run server

> demo07@1.0.0 server E:\03_代码\self\web\webpack-demo\demo07
> node server.js

clean-webpack-plugin: E:\03_代码\self\web\webpack-demo\demo07\dist has been removed.
Example app listening on port 3000!

‼ ｢wdm｣: Hash: 2c99064aa340dee037a8
Version: webpack 4.28.3
Time: 3429ms
Built at: 2018-12-30 23:46:12
          Asset       Size  Chunks                    Chunk Names
  app.bundle.js    968 KiB    0, 1  [emitted]  [big]  app
     index.html  243 bytes          [emitted]
print.bundle.js   7.73 KiB       1  [emitted]         print
Entrypoint app [big] = app.bundle.js
Entrypoint print = print.bundle.js
[0] ./src/print.js 256 bytes {0} {1} [built]
[1] ./node_modules/_lodash@4.17.11@lodash/lodash.js 527 KiB {0} [built]
[2] ./src/index.js 412 bytes {0} [built]
[3] (webpack)/buildin/global.js 472 bytes {0} [built]
[4] (webpack)/buildin/module.js 497 bytes {0} [built]

WARNING in configuration
The 'mode' option has not been set, webpack will fallback to 'production' for this value. Set 'mode' option to 'development' or 'production' to enable defaults for each environment.
You can also set it to 'none' to disable any default behavior. Learn more: https://webpack.js.org/concepts/mode/

WARNING in asset size limit: The following asset(s) exceed the recommended size limit (244 KiB).
This can impact web performance.
Assets:
  app.bundle.js (968 KiB)

WARNING in entrypoint size limit: The following entrypoint(s) combined asset size exceeds the recommended limit (244 KiB). This can impact web performance.
Entrypoints:
  app (968 KiB)
      app.bundle.js


WARNING in webpack performance recommendations:
You can limit the size of your bundles by using import() or require.ensure to lazy load some parts of your
application.
For more info visit https://webpack.js.org/guides/code-splitting/
Child html-webpack-plugin for "index.html":
         Asset     Size  Chunks  Chunk Names
    index.html  532 KiB       0
    Entrypoint undefined = index.html
    [0] ./node_modules/_html-webpack-plugin@3.2.0@html-webpack-plugin/lib/loader.js!./node_modules/_html-webpack-plugin@3.2.0@html-webpack-plugin/default_index.ejs 392 bytes {0} [built]
    [1] ./node_modules/_lodash@4.17.11@lodash/lodash.js 527 KiB {0} [built]
    [2] (webpack)/buildin/global.js 472 bytes {0} [built]
    [3] (webpack)/buildin/module.js 497 bytes {0} [built]
i ｢wdm｣: Compiled with warnings.
```

#### 调整文本编辑器

使用自动编译代码时，可能会在保存文件时遇到一些问题。某些编辑器具有“安全写入”功能，可能会影响重新编译。

要在一些常见的编辑器中禁用此功能，请查看以下列表：

- **Sublime Text 3** - 在用户首选项(user preferences)中添加 `atomic_save: "false"`。
- **IntelliJ** - 在首选项(preferences)中使用搜索，查找到 "safe write" 并且禁用它。
- **Vim** - 在设置(settings)中增加 `:set backupcopy=yes`。
- **WebStorm** - 在 `Preferences > Appearance & Behavior > System Settings` 中取消选中 Use `"safe write"`。

## 模块热替换

模块热替换(Hot Module Replacement 或 HMR)是 webpack 提供的最有用的功能之一。它允许在运行时更新各种模块，而无需进行完全刷新。本页面重点介绍**实现**，而[概念页面](https://www.webpackjs.com/concepts/hot-module-replacement)提供了更多关于它的工作原理以及为什么它有用的细节。

**HMR** 不适用于生产环境，这意味着它应当只在开发环境使用。更多详细信息，请查看[生产环境构建指南](https://www.webpackjs.com/guides/production)。

### 启用 HMR

启用此功能实际上相当简单。而我们要做的，就是更新 [webpack-dev-server](https://github.com/webpack/webpack-dev-server) 的配置，和使用 webpack 内置的 HMR 插件。我们还要删除掉 `print.js` 的入口起点，因为它现在正被 `index.js` 模块使用。

> 如果你使用了 `webpack-dev-middleware` 而没有使用 `webpack-dev-server`，请使用 [`webpack-hot-middleware`](https://github.com/webpack-contrib/webpack-hot-middleware) package 包，以在你的自定义服务或应用程序上启用 HMR。

#### **webpack.config.js**

```javascript
const path = require('path')
// html 文件重新生成
const htmlWepackPlugin = require('html-webpack-plugin')
// 文件清理
const cleanWebpackPlugin = require('clean-webpack-plugin')
// 引入 webpack
const webpack = require('webpack')

module.exports = {
    entry: { //多入口
        app: './src/index.js',
        print: './src/print.js'
    },
    devtool: 'inline-source-map', // 代码调试使用，仅限于开发阶段
    devServer: {
        contentBase: './dist' // 指定文件变化的路径
    },
    plugins: [
        new cleanWebpackPlugin(['dist']), // 参数为需要清理的文件夹
        new htmlWepackPlugin({
            title: '输出管理'
        }),
        new webpack.NamedModulesPlugin(),
        new webpack.HotModuleReplacementPlugin()
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: '[name].bundle.js', //输出根据entry定义的名称来输出
        publicPath: '/' //
    }
}
```

你可以通过命令来修改 [webpack-dev-server](https://github.com/webpack/webpack-dev-server) 的配置：`webpack-dev-server --hotOnly`。

#### **package.json**

```json
{
  "name": "demo08",
  "version": "1.0.0",
  "description": "模块热替换",
  "main": "./src/index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "watch": "webpack --watch",
    "start": "webpack-dev-server --hotOnly",
    "server": "node server.js",
    "build": "webpack -p"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "css-loader": "^2.1.0",
    "lodash": "^4.17.11",
    "style-loader": "^0.23.1",
    "typings": "^2.1.1"
  },
  "devDependencies": {
    "clean-webpack-plugin": "^1.0.0",
    "csv-loader": "^3.0.2",
    "express": "^4.16.4",
    "file-loader": "^3.0.1",
    "html-webpack-plugin": "^3.2.0",
    "typings": "^2.1.1",
    "webpack": "^4.28.3",
    "webpack-cli": "^3.1.2",
    "webpack-dev-middleware": "^3.4.0",
    "webpack-dev-server": "^3.1.14",
    "xml-loader": "^1.2.1"
  }
}
```

我们还添加了 `NamedModulesPlugin`，以便更容易查看要修补(patch)的依赖。在起步阶段，我们将通过在命令行中运行 `npm start` 来启动并运行 dev server。

现在，我们来修改 `index.js` 文件，以便当 `print.js` 内部发生变更时可以告诉 webpack 接受更新的模块。

#### **src/index.js**

```javascript
import _ from 'lodash';
import printMe from './print.js';

function addContent() {
    var ele = document.createElement('div')
    var btn = document.createElement('btn');

    ele.innerHTML = _.join(['Hello', 'webpack'], ' ');
    btn.innerHTML = 'Click me and check the console';

    btn.onclick = printMe;

    ele.appendChild(btn);

    return ele;
}
document.body.appendChild(addContent());

if (module.hot) {
    module.hot.accept('./print.js', function () {
        onsole.log('Accepting the updated printMe module!');
        printMe();
    })
}
```

**console**

```diff
[HMR] Waiting for update signal from WDS...
main.js:4395 [WDS] Hot Module Replacement enabled.
+ 2main.js:4395 [WDS] App updated. Recompiling...
+ main.js:4395 [WDS] App hot update...
+ main.js:4330 [HMR] Checking for updates on the server...
+ main.js:10024 Accepting the updated printMe module!
+ 0.4b8ee77….hot-update.js:10 Updating print.js...
+ main.js:4330 [HMR] Updated modules:
+ main.js:4330 [HMR]  - 20
+ main.js:4330 [HMR] Consider using the NamedModulesPlugin for module names.
```

###  通过 Node.js API

当使用 webpack dev server 和 Node.js API 时，不要将 dev server 选项放在 webpack 配置对象(webpack config object)中。而是，在创建选项时，将其作为第二个参数传递。例如：

```
new WebpackDevServer(compiler, options)
```

想要启用 HMR，还需要修改 webpack 配置对象，使其包含 HMR 入口起点。`webpack-dev-server` package 中具有一个叫做 `addDevServerEntrypoints` 的方法，你可以通过使用这个方法来实现。这是关于如何使用的一个小例子：

####  **dev-server.js**

```js
const webpackDevServer = require('webpack-dev-server');
const webpack = require('webpack');

const config = require('./webpack.config.js');
const options = {
    contentBase: './dist',
    hot: true,
    host: 'localhost'
};

webpackDevServer.addDevServerEntrypoints(config, options);
const compiler = webpack(config);
const server = new webpackDevServer(compiler, options);

server.listen(5000, 'localhost', () => {
    console.log('dev server listening on port 5000');
});
```

###  问题

模块热替换可能比较难掌握。为了说明这一点，我们回到刚才的示例中。如果你继续点击示例页面上的按钮，你会发现控制台仍在打印这旧的 `printMe` 功能。

这是因为按钮的 `onclick` 事件仍然绑定在旧的 `printMe` 函数上。

为了让它与 HMR 正常工作，我们需要使用 `module.hot.accept` 更新绑定到新的 `printMe` 函数上：

#### **index.js**

```diff
  import _ from 'lodash';
  import printMe from './print.js';

  function component() {
    var element = document.createElement('div');
    var btn = document.createElement('button');

    element.innerHTML = _.join(['Hello', 'webpack'], ' ');

    btn.innerHTML = 'Click me and check the console!';
    btn.onclick = printMe;  // onclick 事件绑定原始的 printMe 函数上

    element.appendChild(btn);

    return element;
  }

- document.body.appendChild(component());
+ let element = component(); // 当 print.js 改变导致页面重新渲染时，重新获取渲染的元素
+ document.body.appendChild(element);

  if (module.hot) {
    module.hot.accept('./print.js', function() {
      console.log('Accepting the updated printMe module!');
-     printMe();
+     document.body.removeChild(element);
+     element = component(); // 重新渲染页面后，component 更新 click 事件处理
+     document.body.appendChild(element);
    })
  }
```

这只是一个例子，但还有很多其他地方可以轻松地让人犯错。幸运的是，存在很多 loader（其中一些在下面提到），使得模块热替换的过程变得更容易。

###  HMR 修改样式表

借助于 `style-loader` 的帮助，CSS 的模块热替换实际上是相当简单的。当更新 CSS 依赖模块时，此 loader 在后台使用 `module.hot.accept` 来修补(patch) `<style>` 标签。

所以，可以使用以下命令安装两个 loader ：

```bash
npm install --save-dev style-loader css-loader
cnpm install --save-dev style-loader css-loader
```

接下来我们来更新 webpack 的配置，让这两个 loader 生效。

#### **webpack.config.js**

```diff
  const path = require('path');
  const HtmlWebpackPlugin = require('html-webpack-plugin');
  const webpack = require('webpack');

  module.exports = {
    entry: {
      app: './src/index.js'
    },
    devtool: 'inline-source-map',
    devServer: {
      contentBase: './dist',
      hot: true
    },
+   module: {
+     rules: [
+       {
+         test: /\.css$/,
+         use: ['style-loader', 'css-loader']
+       }
+     ]
+   },
    plugins: [
      new CleanWebpackPlugin(['dist'])
      new HtmlWebpackPlugin({
        title: 'Hot Module Replacement'
      }),
      new webpack.HotModuleReplacementPlugin()
    ],
    output: {
      filename: '[name].bundle.js',
      path: path.resolve(__dirname, 'dist')
    }
  };
```

热加载样式表，与将其导入模块一样简单：

####  **project**

```diff
  webpack-demo
  | - package.json
  | - webpack.config.js
  | - /dist
    | - bundle.js
  | - /src
    | - index.js
    | - print.js
+   | - styles.css
```

**styles.css**

```css
body {
  background: blue;
}
```

####  **index.js**

```diff
  import _ from 'lodash';
  import printMe from './print.js';
+ import './styles.css';

  function component() {
    var element = document.createElement('div');
    var btn = document.createElement('button');

    element.innerHTML = _.join(['Hello', 'webpack'], ' ');

    btn.innerHTML = 'Click me and check the console!';
    btn.onclick = printMe;  // onclick event is bind to the original printMe function

    element.appendChild(btn);

    return element;
  }

  let element = component();
  document.body.appendChild(element);

  if (module.hot) {
    module.hot.accept('./print.js', function() {
      console.log('Accepting the updated printMe module!');
      document.body.removeChild(element);
      element = component(); // Re-render the "component" to update the click handler
      document.body.appendChild(element);
    })
  }
```

将 `body` 上的样式修改为 `background: red;`，你应该可以立即看到页面的背景颜色随之更改，而无需完全刷新。

####  **styles.css**

```diff
  body {
-   background: blue;
+   background: red;
  }
```

### 其他代码和框架

社区还有许多其他 loader 和示例，可以使 HMR 与各种框架和库(library)平滑地进行交互……

- [React Hot Loader](https://github.com/gaearon/react-hot-loader)：实时调整 react 组件。
- [Vue Loader](https://github.com/vuejs/vue-loader)：此 loader 支持用于 vue 组件的 HMR，提供开箱即用体验。
- [Elm Hot Loader](https://github.com/fluxxu/elm-hot-loader)：支持用于 Elm 程序语言的 HMR。
- [Redux HMR](https://survivejs.com/webpack/appendices/hmr-with-react/#configuring-hmr-with-redux)：无需 loader 或插件！只需对 main store 文件进行简单的修改。
- [Angular HMR](https://github.com/gdi2290/angular-hmr)：No loader necessary! A simple change to your main NgModule file is all that's required to have full control over the HMR APIs.没有必要使用 loader！只需对主要的 NgModule 文件进行简单的修改，由 HMR API 完全控制。

> 如果你知道任何其他 loader 或插件，能够有助于或增