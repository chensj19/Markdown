# java注解说明

## 1.1 Spring 注解

#### `@SpringBootTest`

​	@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)

​	为Web 测试环境的端口为随机端口的配置

#### `@ConfigurationProperties`

​	设置属性的信息 如`prefix`就是前缀

#### `@Configuration`

用于定义配置类，可替换xml配置文件，被注解的类内部包含有一个或多个被@Bean注解的方法

@Configuration注解的配置类有如下要求：

1. @Configuration不可以是final类型；
2. @Configuration不可以是匿名类；
3. 嵌套的configuration必须是静态类。

#### `@AutoConfigureAfter`和`@AutoConfigureBefore`

```
* @AutoConfigureBefore : 自动注入在什么类加载前
* @AutoConfigureAfter: 自动注入在什么类加载后
```

#### `@PathVariable`

​	可以获取`RESTful`风格的`Uri`路径上的参数。

#### `@EnableEurekaServer`

​	开启Eureka Server

#### `@EnableEurekaClient`

开启Eureka Client

#### `@EnableDiscoveryClient`

开启客户端注册

> spring cloud中discovery service有许多种实现（eureka、consul、zookeeper等等），
> `@EnableDiscoveryClient`基于`spring-cloud-commons`, 
> `@EnableEurekaClient`基于`spring-cloud-netflix`。
> 其实用更简单的话来说，就是如果选用的注册中心是`eureka`，那么就推荐`@EnableEurekaClient`，
> 如果是其他的注册中心，那么推荐使用`@EnableDiscoveryClient`。

#### `@Import`

​	`@Import(EurekaServerInitializerConfiguration.class)`

- 将标记的class注入到spring IOC容器中

- 只能注解在类上，以及唯一的参数value上可以配置3种类型的值Configuration，ImportSelector，ImportBeanDefinitionRegistrar

  - **基于Configuration也就是直接填对应的class数组**

    ```java 
    @Import({Square.class,Circular.class})
    ```

  - **基于自定义ImportSelector的使用**

    ```java
    /**
     * 定义一个我自己的ImportSelector
     *
     * @author zhangqh
     * @date 2018年5月1日
     */
    public class MyImportSelector implements  ImportSelector{
        public String[] selectImports(AnnotationMetadata importingClassMetadata) {
            return new String[]{"com.zhang.bean.Triangle"};
        }
    }
    
    // 使用@Import
    @Import({Square.class,Circular.class,MyImportSelector.class})
    ```

  - **基于ImportBeanDefinitionRegistrar的使用**

    ```java
    /**
     * 定义一个自定的ImportBeanDefinitionRegistrar
     *
     * @author zhangqh
     * @date 2018年5月1日
     */
    public class MyImportBeanDefinitionRegistrar  implements ImportBeanDefinitionRegistrar{
        public void registerBeanDefinitions(
                AnnotationMetadata importingClassMetadata,
                BeanDefinitionRegistry registry) {
            // new一个RootBeanDefinition
            RootBeanDefinition rootBeanDefinition = new RootBeanDefinition(Rectangle.class);
            // 注册一个名字叫rectangle的bean
            registry.registerBeanDefinition("rectangle", rootBeanDefinition);
        }
    }
    
    // 使用@Import
    @Import({Square.class,Circular.class,MyImportSelector.class,MyImportBeanDefinitionRegistrar.class})
    ```

#### `@Conditional`

`@Conditional`是Spring4新提供的注解，它的作用是按照一定的条件进行判断，满足条件给容器注册bean。

```java
//此注解可以标注在类和方法上
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME) 
@Documented
public @interface Conditional {
    Class<? extends Condition>[] value();
}
```

从代码中可以看到，需要传入一个Class数组，并且需要继承Condition接口：

```java
public interface Condition {
    boolean matches(ConditionContext var1, AnnotatedTypeMetadata var2);
}
```

Condition是个接口，需要实现matches方法，返回true则注入bean，false则不注入。

#### `@ConditionalOnMissingBean`

（仅仅在当前上下文中不存在某个对象时，才会实例化一个Bean）

该注解表示，如果存在它修饰的类的bean，则不需要再创建这个bean

如果当前容器中已经有bean了，就不注入备用bean，如果没有，则注入备用bean

#### `@ConditionalOnClass`

（某个class位于类路径上，才会实例化一个Bean）

​	该注解的参数对应的类必须存在，否则不解析该注解修饰的配置类

注解@ConditionalOnClass和@Bean,可以仅当某些类存在于 classpath 上时候才创建某个Bean

常规使用代码如下：

```java
 // 仅当类 java.util.HashMap 存在于 classpath 上时才创建一个bean : beanA
 // 注意这里使用了 @ConditionalOnClass 的属性value，
 @Bean
 @ConditionalOnClass(value={java.util.HashMap.class})
 public A beanA(){}
 // 仅当类 com.sample.Dummy 存在于 classpath 上时才创建一个bean : beanB
 // 注意这里使用了 @ConditionalOnClass 的属性 name，
 @Bean
 @ConditionalOnClass(name="com.sample.Dummy")
 public B beanB(){}
```

`name`or `value`

- `name` : 不确定指定类在`classpath` 上
- `value` : 确定指定类在 `classpath` 上

#### @ConditionalOnBean

​	仅仅在当前上下文中存在某个对象时，才会实例化一个Bean

#### @ConditionalOnExpression

​	当表达式为true的时候，才会实例化一个Bean

#### @ConditionalOnMissingClass

​	某个class类路径上不存在的时候，才会实例化一个Bean）

#### @ConditionalOnNotWebApplication

（不是web应用）

#### `@Autowired` 

用来注入已有的bean,required`默认为true，当为false的时候，表示忽略当前要注入的bean，如果有直接注入，没有跳过，不会报错

### 1.2 java元注解

java中元注解有四个： @Retention @Target @Document @Inherited；

```java
 @Retention：注解的保留位置　　　　　　　　　
       @Retention(RetentionPolicy.SOURCE)   //注解仅存在于源码中，在class字节码文件中不包含
　　    @Retention(RetentionPolicy.CLASS)     // 默认的保留策略，注解会在class字节码文件中存在，但运行时无法获得，
　　　	 @Retention(RetentionPolicy.RUNTIME)  // 注解会在class字节码文件中存在，在运行时可以通过反射获取到
@Target:注解的作用目标　
        @Target(ElementType.TYPE)   //接口、类、枚举、注解
        @Target(ElementType.FIELD) //字段、枚举的常量
        @Target(ElementType.METHOD) //方法
        @Target(ElementType.PARAMETER) //方法参数
        @Target(ElementType.CONSTRUCTOR)  //构造函数
        @Target(ElementType.LOCAL_VARIABLE)//局部变量
        @Target(ElementType.ANNOTATION_TYPE)//注解
        @Target(ElementType.PACKAGE) ///包   
@Document：说明该注解将被包含在javadoc中
@Inherited：说明子类可以继承父类中的该注解
```

##### `@Target`:注解的作用目标

**@Target(ElementType.TYPE)——接口、类、枚举、注解 **

**@Target(ElementType.FIELD)——字段、枚举的常量 **

**@Target(ElementType.METHOD)——方法 **

**@Target(ElementType.PARAMETER)——方法参数 **

**@Target(ElementType.CONSTRUCTOR) ——构造函数 **

**@Target(ElementType.LOCAL_VARIABLE)——局部变量 **

**@Target(ElementType.ANNOTATION_TYPE)——注解 **

**@Target(ElementType.PACKAGE)——包**

#####  `@Retention`：注解的保留位置

**RetentionPolicy.SOURCE:这种类型的Annotations只在源代码级别保留,编译时就会被忽略,在class字节码文件中不包含。 **

**RetentionPolicy.CLASS:这种类型的Annotations编译时被保留,默认的保留策略,在class文件中存在,但JVM将会忽略,运行时无法获得。 **

**RetentionPolicy.RUNTIME:这种类型的Annotations将被JVM保留,所以他们能在运行时被JVM或其他使用反射机制的代码所读取和使用。**

 **@Document：说明该注解将被包含在javadoc中 @Inherited：说明子类可以继承父类中的该注解**

