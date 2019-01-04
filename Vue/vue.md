# vue

## vue 生命周期
+ created
  - 实例创建完成后调用，此阶段完成了数据的观测等，尚未挂载，$el还不能使用。需要初始化数据时会比较有用
+ mounted
  - el 挂载到实例后调用，一般我们的第一个业务逻辑会在这里开始
+ beforeDestroy
  - 实例销毁前调用。主要解绑一些使用addEventListener监听事件

## 插值与表达式

***vue***使用```{{}}```作为最基本的文办插值方法

```javascript
var app = new Vue({
        el: '#app',
        data: {
            name: '',
            date: new Date()
        },
        mounted: function () {
            var _this = this;
            this.timer = setInterval(function () {
                _this.date = new Date(); //修改数据data
            },1000)
        },
        beforeDestroy(){
            if(this.timer){
                clearInterval(this.timer);
            }
        }
    });
```

```javascript
 		{{ number /10 }}<br> <!--计算-->
        {{ isOk ? '确定' : '取消'}} <br> <!--三元运算-->
        {{ text.split(',').reverse().join(',') }} <!--表达式处理-->
```

### 过滤器

```html
 <h2>{{ date | formatDate }}</h2> 
 <!--在vue中使用|管道符对数据进行过滤，常用于格式化文本-->
```

```html
<h3>过滤器使用</h3>
<p v-pre><!--串联使用--></p>
<p v-pre>{{ message | filterA | filterB }}</p>
<p v-pre><!--接收参数--></p>
<p v-pre>{{ message | filterA('arg1','arg2') }}</p>
```

```js
## js 代码
	function padDate(value) {
        return value < 10 ? '0'+value : value;
    }
    var app = new Vue({
        el: '#app',
        data: {
            name: '',
            date: new Date(),
            link: '<a href="#">这是一个链接</a>',
            number: 200,
            isOk: false,
            text:'123,456'
        },
        filters:{
            formatDate:function (value) {
                var date = new Date(value);
                var year = date.getFullYear();
                var month = padDate(date.getMonth()+1);
                var day = padDate(date.getDate());
                var hours = padDate(date.getHours());
                var minutes = padDate(date.getMinutes());
                var seconds = padDate(date.getSeconds());
                return year + '-' + month + '-' + day + ' ' + hours+ ':' + minutes+ ':' +seconds;
            }
        },
        mounted: function () {
            var _this = this; //声明一个变量指向Vue实例this，保证作用域一致
            this.timer = setInterval(function () {
                _this.date = new Date(); //修改数据data
            },1000)
        },
        beforeDestroy(){
            if(this.timer){
                clearInterval(this.timer); //vue销毁前，清除定时器
            }
        }
    });
```

## 指令

***指令***主要职责就是在其表达式的值发生改变时，相应地将某些行为应用到DOM上。

+ v-if  

  ```js
  <p v-if="show"> 显示文本 </p>
  <!--当show为true则p元素会被插入，反之则被移除-->
  ```

+ v-pre 标签内{{}}不转换

+ v-bind 基本用途就是动态更新HTML元素上的属性，比如id、class

  ```js
  <a v-bind:href="url">链接</a>
  <img v-bind:src="imgUrl">
  ```

+ v-on 用来绑定事件监听器

  ```vue
  <button v-on:click="handleClick">
      点击处理
  </button>
  ```

### 语法糖

***在不影响功能的情况下，添加某种方法实现同样的效果，从而方便程序开发***

```js
v-bind:url --> :url
v-on:click --> @click
```



## 计算属性

计算属性主要用于解决模板内的表达式处理复杂的运算或者复杂逻辑运算。

```javascript
{{ text.split(',').reverse().join(',') }}
使用计算属性：
  <!--计算属性-->
  {{ reverseText }}
  computed:{ /*计算属性*/
      reverseText(){
          return this.text.split(',').reverse().join(',');
      }
  }
```

### 计算属性用法

```javascript
{{ prices }}

data: {
	package1:[
        {
            name:'phone1',
            price:7199,
            count:2
        },{
            name:'phone2',
            price:5299,
            count:1
        }
        ],
     package2:[
        {
            name:'apple',
            price:3,
            count:8
        },{
            name:'banana',
            price:9,
            count:4
        }
        ]
	}
属性计算：
  prices(){
                var prices = 0;
                for (var i = 0 ; i < this.package1.length; i++) {
                    prices += this.package1[i].price * this.package1[i].count;
                }
                for (var i = 0 ; i < this.package2.length; i++) {
                    prices += this.package2[i].price * this.package2[i].count;
                }
                return prices;
            }
```

计算属性都包含一个get和set方法，上面只是默认用法，只利用了getter来修改，在需要的时候可以增加一个setter函数，当手动修改计算属性的值，就像修改普通数据那样，触发setter函数

```javascript
 <!--计算属性 get set-->
 <p>姓名：{{fullName}}</p>
 fullName: {
         get: function () {
             return this.firstName + ' ' + this.lastName;
         },
         set: function (newValue) {
             var names = newValue.split(' ');
             this.firstName = names[0];
             this.lastName = names[names.length -1];
         }
 }
```

一是计算属性可以依赖其他计算属性： 

二是计算属性不仅可以依赖当前Vue 实例的数据，还可以依赖其他实例的数据



### 计算属性缓存

计算属性可以直接在methods中直接定义使用，同样可以实现，两者的主要区别是***计算属性是基于它的依赖缓存的*** ，但是methods不同，只要重新渲染，它就会被调用，因此函数也会被执行。

使用计算属性还是methods 取决于你是否需要缓存，当遍历大数组和做大量计算时，应当使用计算属性，除非你不希望得到缓存。



## v-bind、class与style绑定

v-bind 主要用来动态更新HTML元素上的属性

### 绑定class的几种方式

#### 对象语法

```javascript
# 单个属性
<div :class="{'active': isActive }"></div>
# 多个属性
<div :class="{'active': isActive ,'error': isError }"></div>
# 使用计算属性
<div :class="classes"></div>
computed:{
    classes : function(){
        active:this.isActive && this.isError,
        'text-fail':this.error && this.error.type === 'fail'
    }
}
```

#### 数组语法
```html
# 数组
<div :class="[activeCls,errorCls]"></div>
# 三元表达式
<div :class="{isActive ? activeCls : '' }"></div>
```

#### 绑定内联样式

```html
<div :style＝’color’:color,’fontSize’:fontSize＋’px’｝”>文本</div>
```

## 内置指令

### 基本指令

+ v-cloak 

  - v-cloak 不需要表达式，它会在Vue 实例结束编译时从绑定的HTML 元素上移除， 经常和css的display: none；配合使用，v-cloak 是一个解决初始化慢导致页面闪动的最佳实践
+ v-once 
  - v-once 也是一个不需要表达式的指令，作用是定义它的元素或组件只渲染一次，包括元素或组件的所有子节点。首次渲染后，不再随数据的变化重新渲染，将被视为静态内容

### 条件渲染指令

+ v-if

+ v-else-if

+ v-else

  ```html
  <p v-if="status === 1">当status为1时候显示</p>
  <p v-else-if="status === 2">当status为3时候显示</p>
  <p v-else>否则显示本行</p>
  ```

+ v-show 

  - v-show 的用法与v-if 基本一致，只不过v -show 是改变元素的css 属性di splay 。当v-show 表达式的值为false 时， 元素会隐藏，查看DOM 结构会看到元素上加载了内联样式display : none;

+ v-show与v-if 对比
  + v-if 和v-show 具有类似的功能，不过v-if 才是真正的条件渲染，它会根据表达式适当地销毁或重建元素及绑定的事件或子组件。若表达式初始值为false ，则一开始元素／组件并不会渲染，只有当条件第一次变为真时才开始编译。
    而v-show 只是简单的css 属性切换，无论条件真与否，都会被编译。相比之下， v-if 更适合条件不经常改变的场景，因为它切换开销相对较大，而v-s how 适用于频繁切换条件。

### 列表渲染 

+ v-for

  + 当需要将一个数组遍历或枚举一个对象循环显示时，就会用到列表渲染指令v-for

  + ```html
    <ul>
        <li v-for="book in books">{{ book.name }}</li>
    </ul>    
    ```

### 方法与事件

#### 基本用法

```html
<button @click='count++'> +1 </button>

<button @click='handleAdd(10)'> +1 </button>
```

```javascript
data:{
 count:0
},
methods:{
	handleAdd:function(val){
        /*if(val){
			this.count+=val;
        }else{
            this.count+=1;
        }*/
        val = val || 1 ;
        this.count += val;
	}
}
```

Vue 提供了一个特殊变量$event ，用于访问原生DOM 事件

```html
<a href="http://www.baidu.com" @click="handleClick('禁止打开',$event)">打开链接</a>
<script>
	
    methods:{
        handleClick: function(msg,event){
            event.preventDefault();
            window.alert(msg);
        }
    }
</script>
```

#### 修饰符

vue支持以下的修饰符

+ .stop
+ .prevent
+ .capture
+ .self
+ .once
```html 
＜！一阻止单击事件冒泡一〉
<a @click.stop="handle"></a>
〈！一提交事件不再重载页面一〉
<form @submit.prevent="handle"></ form>
〈！一修饰符可以串联一〉
<a @click.stop.prevent=” handle ” ></a>
〈！一只有修饰符一〉
<form @submit.prevent></form>
〈！一添加事件侦听器时使用事件捕获模式一〉
<div @click . capture=”handle ”> ... </div>
〈！一只当事件在该元素本身（而不是子元素） 触发时触发回调一〉
<div @click.self=” handle ”> ... </div>
＜ ！一只触发一次，组件同样适用一〉
<div @click.once=” handle ”> ... </div>
在表单元素上监昕键盘事件时，还可以使用按键修饰符，比如按下具体某个键时才调用方法：
＜!--有在keyCode 是13 时调用vm.submit()-->
<input @keyup.13 ＝“submit”〉
Vue.config.keyCodes.fl = 112;
／／全局定义后，就可以使用自keyup.fl
除了具体的某个keyCode 外， Vue 还提供了一些快捷名称，以下是全部的别名：
• .enter
• .tab
• .delete （捕获“删除”和“退格”键）
• .esc
• .space
• .up
• .down
• .left
• .right
这些按键修饰符也可以组合使用，或和鼠标一起配合使用：
• .ctrl
• .alt
• .shift
• .meta (Mac 下是Command 键， Windows 下是窗口键）
```



## 表单与v-model

###  基本用法

```html
<input type='text' v-model='msg'>
<p>
    输入的内容是：{{ msg }}
</p>
上述方案对于textarea同样适用
```

***注意*** 使用v-model后，表单控件显示的值只依赖所绑定的数据，不在关心初始化的value属性，如textarea之间的值不会生效。同样在使用中文输入法的时候，在未选定词组之前，vue不会更新数据，只有敲下汉字后才会触发更新，如果希望实时更新则需要使用@input替换v-model

```html
<input type='text' @input='handleMessage'>
<p>
    输入的内容是：{{ msg }}
</p>
```

```javascript
handleMessage:function(e){
    this.msg = e.target.value;
}
```

### 单选按钮

单选按钮在单独使用时，不需要v-model ，直接使用v-bind 绑定一个布尔类型的值， 为真时选中， 为否时不选

如果是组合使用来实现互斥选择的效果，就需要v-model 配合value 来使用

### 复选框

复选框也分单独使用和组合使用，不过用法稍与单选不同。复选框单独使用时，也是用v-model来绑定一个布尔值

组合使用时，也是v-model 与value 一起，多个勾选框都绑定到同一个数组类型的数据，value的值在数组当中，就会选中这一项。这一过程也是双向的，在勾选时， value 的值也会自动push 到这个数组中



### 修饰符

+ .lazy:
  在输入框中， v-model 默认是在input 事件中同步输入框的数据（除了中文输入法情况外），使用修饰符.lazy 会转变为在change 事件中同步，即在失焦或按回车时才更新。
+ .number:
  使用修饰符.number 可以将输入转换为Number 类型，否则虽然你输入的是数字，但它的类型其实是String ，比如在数字输入框时会比较有用

+ .trim:
  修饰符.trim 可以自动过滤输入的首尾空格

## 组件详解

### 组件注册

#### 全局注册

```js
 /*全局注册组件*/
    Vue.component('my-component',{
        template:'<div>这是一个自定义组件</div>' /*这里必须要写成html的样式，否则无法加载*/
    })
```

`上述方式注册必须在vue实例创建之前`

#### 局部注册组件