# flex-详细说明

## 一、flex弹性盒模型

对于某个元素只要声明了`display: flex;`，那么这个元素就成为了弹性容器，具有flex弹性布局的特性。

```html
<body>
    <div class="flex-container"></div>
</body>

<style>
    .flex-container {
        /* 声明这个容器是弹性容器 
        具有flex弹性布局的特性
        */
        display: flex;
    }
</style>
```

![](https://ask.qcloudimg.com/http-save/1006489/akzmho8t10.jpeg?imageView2/2/w/1620)

1. 每个弹性容器都有两根轴：**主轴和交叉轴**，两轴之间成90度关系。注意：**水平的不一定就是主轴。**
2. 每根轴都有**起点和终点**，这对于元素的对齐非常重要。
3. 弹性容器中的所有子元素称为**弹性元素**，**弹性元素永远沿主轴排列**。
4. 弹性元素也可以通过`display:flex`设置为另一个弹性容器，形成嵌套关系。因此**一个元素既可以是弹性容器也可以是弹性元素**。

弹性容器的两根轴非常重要，所有属性都是作用于轴的。下面从轴入手，将所有flex布局属性串起来理解。

## 二、主轴

flex布局是一种**一维布局**模型，一次只能处理一个维度（一行或者一列）上的元素布局，作为对比的是二维布局[CSS Grid Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)，可以同时处理行和列上的布局。

也就是说，**flex布局大部分的属性都是作用于主轴的，在交叉轴上很多时候只能被动地变化**。

### 1. 主轴的方向 flex-direction

我们可以在弹性容器上通过`flex-direction`修改主轴的方向。如果主轴方向修改了，那么：

1. 交叉轴就会相应地旋转90度。
2. 弹性元素的排列方式也会发生改变，因为**弹性元素永远沿主轴排列**。

**`flex-direction:row;`**

![](https://ask.qcloudimg.com/http-save/1006489/qyuv0bo3h1.gif)

**`flex-direction:column`**

![](https://ask.qcloudimg.com/http-save/1006489/4u12kljsxv.gif)

**`flex-direction:row-reverse;`**

![](https://ask.qcloudimg.com/http-save/1006489/4p83wn4fgq.gif)

**`flex-direction:column-reverse`**

![](https://ask.qcloudimg.com/http-save/1006489/5u3vo6jku5.gif)

### 2. 沿主轴的排列处理 flex-wrap

弹性元素永远沿主轴排列，那么如果主轴排不下，该如何处理？

![](https://ask.qcloudimg.com/http-save/1006489/bpx6ga3at7.jpeg?imageView2/2/w/1620)

通过设置`flex-wrap: nowrap | wrap | wrap-reverse`可使得主轴上的元素不折行、折行、反向折行。

* 默认是`nowrap`不折行，难道任由元素直接溢出容器吗？当然不会，那么这里就涉及到元素的弹性伸缩应对，下面会讲到。

* `wrap`折行，顾名思义就是另起一行，那么折行之后行与行之间的间距（对齐）怎样调整？这里又涉及到交叉轴上的多行对齐。

* `wrap-reverse`反向折行，是从容器底部开始的折行，但每行元素之间的排列仍保留正向。

![](https://ask.qcloudimg.com/http-save/1006489/udke8t9iqt.jpeg?imageView2/2/w/1620)

### 3. 一个复合属性

```css
flex-flow = flex-drection + flex-wrap
```

`flex-flow`相当于规定了flex布局的“工作流(flow)”

```css
flex-flow: row nowrap;
```

> 注意：如果使用flex容器套容器的方式构建页面，那么元素的排列就会存在一个隐形的要求
>
> **在主容器中使用flex-directory定义主轴的方向，那么在子容器中处于主容器交叉轴上元素会弹性收缩**
>
> 也就是说在主容器的交叉轴上面使用了flex-shrink:1

## 三、元素如何弹性伸缩应对

当`flex-wrap: nowrap;`不折行时，容器宽度有剩余/不够分，弹性元素们该怎么“弹性”地伸缩应对？

这里针对上面两种场景，引入两个属性(需应用在弹性元素上)

1. `flex-shrink`：缩小比例（容器宽度<元素总宽度时如何收缩）
2. `flex-grow`：放大比例（容器宽度>元素总宽度时如何伸展）

### 1. flex-shrink: 缩小比例

来看下以下场景，弹性容器`#container`宽度是200px，一共有三个弹性元素，宽度分别是50px、100px、120px。在不折行的情况下，此时容器宽度是明显不够分配的。

实际上，`flex-shrink`默认为1，也就是当不够分配时，元素都将等比例缩小，占满整个宽度，如下图。

![](https://ask.qcloudimg.com/http-save/1006489/2ilaemtmlh.jpeg?imageView2/2/w/1620)

```css
#container {
  display: flex;
  flex-wrap: nowrap;
}
```

真的是等比缩小(每个元素各减去70/3的宽度)吗？这里稍微深究一下它的收缩计算方法。

1. 弹性元素1：50px→37.03px
2. 弹性元素2：100px→74.08px
3. 弹性元素3：120px→88.89px

先抛结论：`flex-shrink: 1`并非严格等比缩小，***它还会考虑弹性元素本身的大小***。

- 容器剩余宽度：`-70px`
- 缩小因子的分母：`1*50 + 1*100 + 1*120 = 270` (1为各元素flex-shrink的值)
- 元素1的缩小因子：`1*50/270`
- 元素1的缩小宽度为缩小因子乘于容器剩余宽度：`1*50/270 * (-70)`
- 元素1最后则缩小为：`50px + (1*50/270 *(-70)) = 37.03px`

加入弹性元素本身大小作为计算方法的考虑因素，主要是为了避免将一些本身宽度较小的元素在收缩之后宽度变为0的情况出现。

### 2. flex-grow: 放大比例

同样，弹性容器`#container`宽度是200px，但此时只有两个弹性元素，宽度分别是50px、100px。此时容器宽度是有剩余的。

那么剩余的宽度该怎样分配？而`flex-grow`则决定了要不要分配以及各个分配多少。

（1）在flex布局中，容器剩余宽度默认是不进行分配的，也就是所有弹性元素的`flex-grow`都为0。

![](https://ask.qcloudimg.com/http-save/1006489/yidnipfoxs.jpeg?imageView2/2/w/1620)

（2）通过指定`flex-grow`为大于零的值，实现容器剩余宽度的分配比例设置。

![](https://ask.qcloudimg.com/http-save/1006489/jajgry3s6d.jpeg?imageView2/2/w/1620)

##### 元素放大的计算方法

***放大的计算方法并没有与缩小一样，将元素大小纳入考虑***。

***仅仅按`flex-grow`声明的份数算出每个需分配多少，叠加到原来的尺寸上***。

- 容器剩余宽度：`50px`
- 分成每份：`50px / (3+2) = 10px`
- 元素1放大为：`50px + 3 * 10 = 80px`

> 在使用flex-shrink: 缩小比例,会考虑到元素自身的大小，根据元素自身的大小来决定缩小后的尺寸
>
> 在使用flex-grow：放大比例，不会考虑到元素自身的大小，只会考虑元素自身分配的倍数，决定多余空间的分配

##### 无多余宽度时，flex-grow无效

下图中，弹性容器的宽度正好等于元素宽度总和，无多余宽度，此时无论`flex-grow`是什么值都不会生效。

![](https://ask.qcloudimg.com/http-save/1006489/ruf9nq5byd.jpeg?imageView2/2/w/1620)

同理，对于`flex-shrink`，在容器宽度有剩余时也是不会生效的。因此这两个属性是针对两种不同场景的互斥属性。

## 四、弹性处理与刚性尺寸

在进行弹性处理之余，其实有些场景我们更希望元素尺寸固定，不需要进行弹性调整。设置元素尺寸除了width和height以外，flex还提供了一个`flex-basis`属性。

`flex-basis`设置的是元素在主轴上的初始尺寸，所谓的初始尺寸就是元素在`flex-grow`和`flex-shrink`生效前的尺寸。

### 1. 与width/height的区别

首先以width为例进行比较。看下下面的例子。`#container {display:flex;}`。

```html
<div id="container">
  <div>11111</div>
  <div>22222</div>
</div>
```

#### (1) 两者都为0

![](https://ask.qcloudimg.com/http-save/1006489/192dt7dvz5.jpeg?imageView2/2/w/1620)

- width: 0 —— 完全没显示
- flex-basis: 0 —— 根据内容撑开宽度

#### (2) 两者非0

![](https://ask.qcloudimg.com/http-save/1006489/y3ohay4hdt.jpeg?imageView2/2/w/1620)

- width: 非0;
- flex-basis: 非0

  - 数值相同时两者等效

  * 同时设置，flex-basis优先级高

#### (3) flex-basis为auto

![](https://ask.qcloudimg.com/http-save/1006489/5lu2f76fcd.jpeg?imageView2/2/w/1620)

flex-basis为auto时，如设置了width则元素尺寸由width决定；没有设置则由内容决定

#### (4) flex-basis == 主轴上的尺寸 != width

![](https://ask.qcloudimg.com/http-save/1006489/nvbks7qqxn.jpeg?imageView2/2/w/1620)

- 将主轴方向改为：上→下
- 此时主轴上的尺寸是元素的height
- flex-basis == height

### 2. 常用的复合属性 flex

这个属性应该是最容易迷糊的一个，下面揭开它的真面目。

flex = flex-grow + flex-shrink + flex-basis

复合属性，前面说的三个属性的简写。

![](https://ask.qcloudimg.com/http-save/1006489/xhjsaxsrrp.jpeg?imageView2/2/w/1620)

#### (1) 一些简写

- `flex: 1` = `flex: 1 1 0%`
- `flex: 2` = `flex: 2 1 0%`
- `flex: auto` = `flex: 1 1 auto;`
- `flex: none` = `flex: 0 0 auto;` // 常用于固定尺寸 不伸缩

#### (2) flex:1 和 flex:auto 的区别

`flex` 的默认值是以上三个属性值的组合。假设以上三个属性同样取默认值，则 `flex` 的默认值是 0 1 auto。同理，如下是等同的：

```css
.item {flex: 2333 3222 234px;}
.item {
    flex-grow: 2333;
    flex-shrink: 3222;
    flex-basis: 234px;
}
```

当 `flex` 取值为 `none`，则计算值为 0 0 auto，如下是等同的：

```css
.item {flex: none;}
.item {
    flex-grow: 0;
    flex-shrink: 0;
    flex-basis: auto;
}
```

当 `flex` 取值为 `auto`，则计算值为 1 1 auto，如下是等同的：

```css
.item {flex: auto;}
.item {
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: auto;
}
```

当 `flex` 取值为一个非负数字，则该数字为 `flex-grow` 值，`flex-shrink` 取 1，`flex-basis` 取 0%，如下是等同的：

```css
.item {flex: 1;}
.item {
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: 0%;
}
```

当 `flex` 取值为一个长度或百分比，则视为 `flex-basis` 值，`flex-grow` 取 1，`flex-shrink` 取 1，有如下等同情况（注意 0% 是一个百分比而不是一个非负数字）：

```css
.item-1 {flex: 0%;}
.item-1 {
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: 0%;
}
.item-2 {flex: 24px;}
.item-1 {
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: 24px;
}
```

当 `flex` 取值为两个非负数字，则分别视为 `flex-grow` 和 `flex-shrink` 的值，`flex-basis` 取 0%，如下是等同的：

```css
.item {flex: 2 3;}
.item {
    flex-grow: 2;
    flex-shrink: 3;
    flex-basis: 0%;
}
```

当 `flex` 取值为一个非负数字和一个长度或百分比，则分别视为 `flex-grow` 和 `flex-basis` 的值，`flex-shrink` 取 1，如下是等同的：

```css
.item {flex: 2333 3222px;}
.item {
    flex-grow: 2333;
    flex-shrink: 1;
    flex-basis: 3222px;
}
```

其实可以归结于`flex-basis:0`和`flex-basis:auto`的区别。

`flex-basis`是指定初始尺寸，当设置为0时（绝对弹性元素），此时相当于告诉`flex-grow`和`flex-shrink`在伸缩的时候不需要考虑我的尺寸；相反当设置为`auto`时（相对弹性元素），此时则需要在伸缩时将元素尺寸纳入考虑。

也就是说：0就是在开始的时候就会分配全部的空间，而auto则是通过`flex-grow`和`flex-shrink`将元素尺寸大小纳入分配处理。

因此从下图（转自W3C）可以看到绝对弹性元素如果`flex-grow`值是一样的话，那么他们的尺寸一定是一样的。

![](https://www.w3.org/html/ig/zh/css-flex-1/rel-vs-abs-flex.svg)

一个显示「绝对」伸缩（以零为基准值开始）与「相对」伸缩（以项目的内容大小为基准值开始）差异的图解。这三个项目的伸缩比例分别是「`1`」、「`1`」、「`2`」。

## 五、容器内如何对齐

前面讲完了元素大小关系之后，下面是另外一个重要议题——**如何对齐**。可以发现上面的所有属性都是围绕主轴进行设置的，但在对齐方面则不得不加入作用于交叉轴上。需要注意的是这些对齐属性都是作用于容器上。

### 1. 主轴上的对齐方式

**justify-content**

![](https://ask.qcloudimg.com/http-save/1006489/l8h27unmce.jpeg?imageView2/2/w/1620)

### 2. 交叉轴上的对齐方式

主轴上比较好理解，重点是交叉轴上。因为交叉轴上存在单行和多行两种情况。

#### (1) 交叉轴上的单行对齐

**align-items**

默认值是`stretch`，当元素没有设置具体尺寸时会将容器在交叉轴方向撑满。

当`align-items`不为`stretch`时，此时除了对齐方式会改变之外，元素在交叉轴方向上的尺寸将由内容或自身尺寸（宽高）决定。

![](https://ask.qcloudimg.com/http-save/1006489/0diquwvhq9.jpeg?imageView2/2/w/1620)

![](https://ask.qcloudimg.com/http-save/1006489/5h94l123w2.jpeg?imageView2/2/w/1620)

![](https://ask.qcloudimg.com/http-save/1006489/eabco8i7sq.jpeg?imageView2/2/w/1620)

![](https://ask.qcloudimg.com/http-save/1006489/ng0hzakutn.jpeg?imageView2/2/w/1620)

![](https://ask.qcloudimg.com/http-save/1006489/kaym7l5qke.jpeg?imageView2/2/w/1620)

注意，交叉轴不一定是从上往下，这点再次强调也不为过。

![](https://ask.qcloudimg.com/http-save/1006489/t0vusvkbnt.jpeg?imageView2/2/w/1620)

#### (2) 交叉轴上的多行对齐

还记得可以通过`flex-wrap: wrap`使得元素在一行放不下时进行换行。在这种场景下就会在交叉轴上出现多行，多行情况下，flex布局提供了`align-content`属性设置对齐。

`align-content`与`align-items`比较类似，同时也比较容易迷糊。下面会将两者对比着来看它们的异同。

首先明确一点：`align-content`只对多行元素有效，**会以多行作为整体进行对齐**，容器必须开启换行。

```
align-content: stretch | flex-start | flex-end | center | space-between | space-around

align-items: stretch | flex-start | flex-end | center | baseline
```

在属性值上，`align-content`比`align-items`多了两个值：`space-between`和`space-around`。

#### (3) align-content与align-items异同对比

与`align-items`一样，`align-content:`默认值也是`stretch`。两者同时都为`stretch`时，毫无悬念所有元素都是撑满交叉轴。

```CSS
#container {
  align-items: stretch;
  align-content: stretch;
}
```

![](https://ask.qcloudimg.com/http-save/1006489/8ibbzz89o4.jpeg?imageView2/2/w/1620)

当我们将align-items改为`flex-start`或者给弹性元素设置一个具体高度，此时效果是行与行之间形成了间距。

```CSS
#container {
  align-items: flex-start;
  align-content: stretch;
}

/*或者*/
#container {
  align-content: stretch;
}
#container > div {
  height: 30px;
}
```

为什么？因为`align-content`会以整行为单位，此时会将整行进行拉伸占满交叉轴；而`align-items`设置了高度或者顶对齐，在不能用高度进行拉伸的情况下，选择了用间距。

![](https://ask.qcloudimg.com/http-save/1006489/xi51if85n6.jpeg?imageView2/2/w/1620)

尝试把`align-content`设置为顶对齐，此时以行为单位，整体高度通过内容撑开。

而`align-items`仅仅管一行，因此在只有第一个元素设置了高度的情况下，第一行的其他元素遵循`align-items: stretch`也被拉伸到了50px。而第二行则保持高度不变。

```css
#container {
  align-items: stretch;
  align-content: flex-start;
}
#container > div:first-child {
    height: 50px;
}
```

![](https://ask.qcloudimg.com/http-save/1006489/7atpu6ub8d.jpeg?imageView2/2/w/1620)

两者的区别还是不明显？来看下面这个例子。

这里仅对第二个元素的高度进行设置，其他元素高度则仍保持内容撑开。

![](https://ask.qcloudimg.com/http-save/1006489/70hqzdmhhg.jpeg?imageView2/2/w/1620)

以第一个图为例，会发现`align-content`会将所有行进行顶对齐，然后第一行由于第二个元素设置了较高的高度，因此体现出了底对齐。

两者差异总结：

- 两者“作用域”不同
- align-content管全局(所有行视为整体)
- align-items管单行

#### (4) 能否更灵活地设置交叉轴对齐

除了在容器上设置交叉轴对齐，还可以通过`align-self`单独对某个元素设置交叉轴对齐方式。

1. 值与`align-items`相同
2. 可覆盖容器的`align-items`属性
3. 默认值为`auto`，表示继承父元素的`align-items`属性

![](https://ask.qcloudimg.com/http-save/1006489/ee1hgp6dw4.jpeg?imageView2/2/w/1620)

## 六、其他

### order：更优雅地调整元素顺序

![](https://ask.qcloudimg.com/http-save/1006489/bakv2uigsh.jpeg?imageView2/2/w/1620)

```css
#container > div:first-child {
  order: 2;
}
#container > div:nth-child(2) {
  order: 4;
}
#container > div:nth-child(3) {
  order: 1;
}
#container > div:nth-child(4) {
  order: 3;
}
```

order：可设置元素之间的排列顺序

1. 数值越小，越靠前，默认为0
2. 值相同时，以dom中元素排列为准

## 七、总结

![](https://ask.qcloudimg.com/http-save/1006489/6b7dfw9wix.jpeg?imageView2/2/w/1620)

![](https://ask.qcloudimg.com/http-save/1006489/0vlatyihcm.jpeg?imageView2/2/w/1620)

![](https://ask.qcloudimg.com/http-save/1006489/1n0cjkcpps.jpeg?imageView2/2/w/1620)



## 附

参考阮老师博文中的骰子练习，我做了张图，大家不妨可以各自实现下，理解之后应该能够比较轻松地写出来。

![](https://ask.qcloudimg.com/http-save/1006489/sr1fz3pqke.jpeg?imageView2/2/w/1620)