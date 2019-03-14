# React 属性绑定

## 常规属性
```jsx
import React from "react";

class Item extends React.Component{

	constructor(props){
		/**props 用户父子组件之间通信 */
		super(props);
		this.state = {
			name: "Item",
			title: "这是一个Title"
		};
	}

	render(){
		return (
		    /*绑定属性*/
			<div title={this.state.title}>
				<p>{this.state.name}</p>
				<ol>
					<li>1</li>
					<li>2</li>
					<li>3</li>
					<li>4</li>
					<li>5</li>
				</ol>
			</div>
		);
	}
}
export default Item;
```

## class 绑定
```css
.red {
  color: red
}
```
```jsx
/**
 * 创建一个Home组件
 */
import React, {Component} from 'react';
import '../assets/css/index.css'

class Home extends Component {
    constructor(props){
        // 继承父级
        super(props)
        this.state = {
            name: "张三",
            age: 30,
            user: {
                username: 'aaaaa',
                password: '123456'
            }
        }
    }
    render() {
        return (
            <div className="red">
                <h2>react 组件里面的所有节点必须被根节点包含</h2>
                <p>这个一个p标签</p>
                <p>{this.state.name}-{this.state.age}</p>
                <p>{this.state.user.username}-{this.state.user.password}</p>
            </div>
            )
    }
}

export default Home
```

## for

```jsx
<div className="red">
                <h2>react 组件里面的所有节点必须被根节点包含</h2>
                <p>这个一个p标签</p>
                <p>{this.state.name}-{this.state.age}</p>
                <p>{this.state.user.username}-{this.state.user.password}</p>
				 {/* 使用htmlFor替换 */}
                <label htmlFor="name">这个一个<code>Label</code></label>
                <input name="username" id="name"></input> <br/>>
            </div>
```

##  style

需要绑定对象

```jsx
this.state = {
            name: "张三",
            age: 30,
            user: {
                username: 'aaaaa',
                password: '123456'
            },
            style:{
                margin: "10px",
                padding: "20px",
                height: "100px",
                lineHeight: "100px",
                textAlign: "center",
                border: "1px solid skyblue"
            }
        }
<div style={{"border":"1px solid red","height":"80px", "lineHeight":"80px","textAlign":"center"}}>style</div>
<div style={this.state.style}>style-state</div>
```

> for 在JSX中使用htmlFor
>
>style使用json对象模式指定

## 图片

react 中万事万物都是组件

### 组件引入

```jsx
import Boat from '../assets/images/boat.png'
<img  src={Boat} alt="boat"></img>
```

### ES5 语法引入

```jsx
 <img src={require('../assets/images/boat.png')}></img>
```

### 远程图片

```html
<img src="https://www.baidu.com/img/dong1_dd071b75788996a161c3964d450fcd8c.gif"></img>
```

## 循环

### 直接循环

```jsx
this.state = {
            items2:[<h2 key='1'>111111</h2>,
                    <h2 key='2'>111111</h2>,
                    <h2 key='3'>111111</h2>,
                    <h2 key='4'>111111</h2>]
        }

  {/* 数据循环 */}
  {this.state.items2}
```

### 转换后在循环

```jsx
this.state = {
              items:[1,2,3,4,5,6,7],
        }
 // 数组循环的时候必须指定key
let itemsResult = this.state.items.map((val,key) => {
    return <li key={key}>{val}</li>
})
 {/* 数据先处理，在循环 */}
<ul>
    {itemsResult}
</ul>
```

### 转换与循环同时进行

```jsx
this.state = {
            items3:[
                {title:'ttttt'},
                {title:'ttttt'},
                {title:'ttttt'},
                {title:'ttttt'},
                {title:'ttttt'}
            ]        
        }
  {/* 直接在循环中处理 */}
<ol>
    {
        this.state.items3.map( (val,key) => {
            return <li key={key}>{val.title}</li>
        })
    }
</ol>
```

> 注意在使用循环的时候必须指定key

## React 方法

```jsx
import React from "react";

class Mehtods extends React.Component {
	constructor(props){
		super(props);
		this.state = {
			msg: "这是一个msg"
		};
	}
	// 定义方法
	run () {
		// eslint-disable-next-line no-undef
		alert("这是一个run方法");
	}
    
	render() {
		return (
			<div>
				<h2>{this.state.msg}</h2>
				<button onClick={this.run}>调用方法</button>
			</div>
		);
	}
}

export default Mehtods;
```

