# JVM虚拟机

## 1.内容

* 了解历史
* 内存结构
* 垃圾回收机制
* 性能监控工具
* 性能调优案例实战
* 认识类的文件结构
* 类加载机制
* 字节码执行引擎
* 虚拟机编译及运行时优化
* Java线程高级

### 1.1 jvm初体验：内存溢出场景模拟

**JvmMemoryTest**

```java
public class JvmMemoryTest {

    public static void main(String[] args) {
        // 集合对象
        List<Demo> aa = new ArrayList<>();
        // 无限添加
        while (true){
            aa.add(new Demo());
        }
    }
}
```

**运行参数**

```bash
# 内存溢出时候输出错误信息
-XX:+HeapDumpOnOutOfMemoryError 
# 指定jvm堆的初始大小
-Xms20m 
# 指定jvm堆的最大值
-Xmx20m
```

### JProfile

注册信息

```bash
# Name填写
脚本之家
#Company填写 
www.jb51.net
# 序列号
L-J11-Everyone#speedzodiac-327a9wrs5dxvz#463a59
A-J11-Everyone#admin-3v7hg353d6idd5#9b4
```

[下载地址](http://fenghuoyunji.jb51.net:81/201903/tools/jprofiler_macos_11_jb51.dmg)

## 2.虚拟机历史

### jdk/jre/jvm 三者关系 [参考](https://docs.oracle.com/javase/8/docs/)

![image-20200613174822245](jvm%E8%99%9A%E6%8B%9F%E6%9C%BA.assets/image-20200613174822245.png)



## 3.内存结构

## 4.垃圾回收机制

## 5.性能监控工具

## 6.性能调优案例实战

## 7.认识类的文件结构

## 8.类加载机制

## 9.字节码执行引擎

## 10.虚拟机编译及运行时优化

## 11.Java线程高级

