# Spring源码

## Spring-beans

### 核心类

#### `DefaultListableBeanFactory`

![DefaultListableBeanFactory类图](https://images0.cnblogs.com/blog/486074/201412/130947213849518.jpg)

* 接口部分
  * `BeanFactory`是Spring的最根的接口，类的工厂接口。
  * `HierarchicalBeanFactory`接口是在继承`BeanFactory`的基础上，实现BeanFactory的父子关系。
  * `ListableBeanFactory`接口是在继承BeanFactory的基础上，实现Bean的list集合操作功能
  * `AutowireCapableBeanFactory`接口是在继承`BeanFactory`的基础上，实现Bean的自动装配功能
  * `SingletonBeanRegistry`是单例bean的注册接口
* `ConfigurableBeanFactory`接口是在继承`HierarchicalBeanFactory`的基础上，实现`BeanFactory`的全部配置管理功能， 
  * `ConfigurableListableBeanFactory`接口是继承`AutowireCapableBeanFactory`，`ListableBeanFactory`，`ConfigurableBeanFactory`三个接口的一个综合接口
  * `AliasRegistry`接口是别名注册接口
  * `BeanDefinitionRegistry`是bean定义的注册接口
* 类部分
  * `SimpleAliasRegistry`类是简单的实现别名注册接口的类。
  * `DefaultSingletonBeanRegistry`是默认的实现`SingletonBeanRegistry`接口的类，同时，继承类`SimpleAliasRegistry` 。
  * `FactoryBeanRegistrySupport`是实现`FactoryBean`注册的功能实现。继承类``DefaultSingletonBeanRegistry`。
  * `AbstractBeanFactory`是部分实现接口`ConfigurableBeanFactory`，并继承类`FactoryBeanRegistrySupport `。
  * `AbstractAutowireCapableBeanFactory`是实现接口`AutowireCapableBeanFactory`，并继承类 `AbstractBeanFactory `。
  * `DefaultListableBeanFactory`实现接口`ConfigurableListableBeanFactory`、`BeanDefinitionRegistry`（bean定义的注册接口）， 并继承`AbstractAutowireCapableBeanFactory`，实现全部类管理的功能。

 