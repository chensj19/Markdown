# Spring 常见知识学习

## 1、Spring 容器与Spring MVC容器

### 1.1 spring容器和springmvc容器，以及web容器的关系

　说到spring和springmvc，其实有很多工作好多年的人也分不清他们有什么区别，如果你问他项目里用的什么MVC技术，他会说我们用的spring和mybatis，或者spring和hibernate。

在潜意识里会认为springmvc就是spring，之前我也是这么认为的，哈哈。 

　　虽然springMVC和spring有必然的联系，但是他们的区别也是有的。下面我就简单描述下

　　首先 springmvc和spring它俩都是容器，容器就是管理对象的地方，例如Tomcat，就是管理servlet对象的，而springMVC容器和spring容器，就是管理bean对象的地方，再说的直白点，springmvc就是管理controller对象的容器，spring就是管理service和dao的容器，这下你明白了吧。*所以我们在springmvc的配置文件里配置的扫描路径就是controller的路径，而spring的配置文件里自然配的就是service和dao的路径*

**spring-mvc.xml**

```xml
<context:component-scan base-package="com.smart.controller" />
```

**applicationContext-service.xml**

```xml
<!-- 扫描包加载Service实现类 -->
<context:component-scan base-package="com.smart.service"></context:component-scan>
或者
<context:component-scan base-package="com.smart">    
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
</context:component-scan>
```

至于他是怎么管理起来的，又是怎么注入属性的，这就涉及到他们底层的实现技术了
　　其次， spring容器和springmvc容器的关系是父子容器的关系。spring容器是父容器，springmvc是子容器。在子容器里可以访问父容器里的对象，但是在父容器里不可以访问子容器的对象，*说的通俗点就是，在controller里可以访问service对象，但是在service里不可以访问controller对象*

　　*所以这么看的话，所有的bean，都是被spring或者springmvc容器管理的，他们可以直接注入。**然后springMVC的拦截器也是springmvc容器管理的**，所以在springmvc的拦截器里，可以直接注入bean对象。*

```xml
<mvc:interceptors>
        <mvc:interceptor>
            <mvc:mapping path="/employee/**" ></mvc:mapping>
            <bean class="com.smart.core.shiro.LoginInterceptor" ></bean>
        </mvc:interceptor>
</mvc:interceptors>
```

　　而web容器又是什么鬼，
　　web容器是管理servlet，以及监听器(Listener)和过滤器(Filter)的。**这些都是在web容器的掌控范围里。但他们不在spring和springmvc的掌控范围里**。因此，我们无法在这些类中直接使用Spring注解的方式来注入我们需要的对象，是无效的，
web容器是无法识别的。

　　但我们有时候又确实会有这样的需求，比如在容器启动的时候，做一些验证或者初始化操作，这时可能会在监听器里用到bean对象；又或者需要定义一个过滤器做一些拦截操作，也可能会用到bean对象。
那么在这些地方怎么获取spring的bean对象呢？下面我提供两个方法：

```java
public void contextInitialized(ServletContextEvent sce) {
　　ApplicationContext context = (ApplicationContext) sce.getServletContext().getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE); 
　　UserService userService = (UserService) context.getBean("userService");
}
```



```java
public void contextInitialized(ServletContextEvent sce) {
　　WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext()); 
　　UserService userService = (UserService) webApplicationContext.getBean("userService"); 
}
```

　　**注意**：以上代码有一个前提，**那就是servlet容器在实例化ConfigListener并调用其方法之前，要确保spring容器已经初始化完毕**！而spring容器的初始化也是由Listener（ContextLoaderListener）完成，因此只需在web.xml中先配置初始化spring容器的Listener，然后在配置自己的Listener。

### 1.2 Spring 与Spring MVC父子容器

#### 1.2.1 spring和springmvc父子容器概念介绍

在spring和springmvc进行整合的时候，一般情况下我们会使用不同的配置文件来配置spring和springmvc，因此我们的应用中会存在至少2个ApplicationContext实例，由于是在web应用中，因此最终实例化的是ApplicationContext的子接口WebApplicationContext。如下图所示：

![img](https://img2018.cnblogs.com/blog/738818/201906/738818-20190617214214614-761905677.png)

上图中显示了2个WebApplicationContext实例，为了进行区分，分别称之为：Servlet WebApplicationContext、Root WebApplicationContext。 其中：

- Servlet WebApplicationContext：这是对J2EE三层架构中的web层进行配置，如控制器(controller)、视图解析器(view resolvers)等相关的bean。通过spring mvc中提供的DispatchServlet来加载配置，通常情况下，配置文件的名称为spring-servlet.xml。
- Root WebApplicationContext：这是对J2EE三层架构中的service层、dao层进行配置，如业务bean，数据源(DataSource)等。通常情况下，配置文件的名称为applicationContext.xml。在web应用中，其一般通过ContextLoaderListener来加载。

 以下是一个web.xml配置案例：

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<web-app version="3.0" xmlns="http://java.sun.com/xml/ns/javaee"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
xsi:schemaLocation="http://java.sun.com/xml/ns/javaeehttp://java.sun.com/xml/ns/javaee/web-app_3_0.xsd">  
    
    <!--创建Root WebApplicationContext-->
    <context-param>  
        <param-name>contextConfigLocation</param-name>  
        <param-value>/WEB-INF/spring/applicationContext.xml</param-value>  
    </context-param>  
    <listener>  
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
    </listener>  
    
    <!--创建Servlet WebApplicationContext-->
    <servlet>  
        <servlet-name>dispatcher</servlet-name>  
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class> 
        <init-param>  
            <param-name>contextConfigLocation</param-name>  
            <param-value>/WEB-INF/spring/spring-servlet.xml</param-value>  
        </init-param>  
        <load-on-startup>1</load-on-startup>  
    </servlet>  
    <servlet-mapping>  
        <servlet-name>dispatcher</servlet-name>  
        <url-pattern>/*</url-pattern>  
    </servlet-mapping>  
</web-app>
```

在上面的配置中：

- `ContextLoaderListener`会被优先初始化时，其会根据`<context-param>`元素中`contextConfigLocation`参数指定的配置文件路径，在这里就是`/WEB-INF/spring/applicationContext.xml`，来创建`WebApplicationContex`t实例。 并调用`ServletContext`的`setAttribute`方法，将其设置到`ServletContext`中，属性的key为`org.springframework.web.context.WebApplicationContext.ROOT`，最后的`ROOT`字样表明这是一个 `Root WebApplicationContext`。
- `DispatcherServlet`在初始化时，会根据`<init-param>`元素中`contextConfigLocation`参数指定的配置文件路径，即`/WEB-INF/spring/spring-servlet.xml`，来创建`Servlet WebApplicationContext`。同时，其会调用`ServletContext`的`getAttribute`方法来判断是否存在`Root WebApplicationContext`。如果存在，则将其设置为自己的`parent`。这就是父子上下文(父子容器)的概念。

​        父子容器的作用在于，当我们尝试从child context(即：Servlet WebApplicationContext)中获取一个bean时，如果找不到，则会委派给parent context (即Root WebApplicationContext)来查找。
如果我们没有通过ContextLoaderListener来创建Root WebApplicationContext，那么Servlet WebApplicationContext的parent就是null，也就是没有parent context。

#### 1.2.2 为什么要有父子容器

笔者理解，父子容器的作用主要是划分框架边界。
        在J2EE三层架构中，在service层我们一般使用spring框架， 而在web层则有多种选择，如spring mvc、struts等。因此，通常对于web层我们会使用单独的配置文件。例如在上面的案例中，一开始我们使用spring-servlet.xml来配置web层，使用applicationContext.xml来配置service、dao层。如果现在我们想把web层从spring mvc替换成struts，那么只需要将spring-servlet.xml替换成Struts的配置文件struts.xml即可，而applicationContext.xml不需要改变。
        事实上，如果你的项目确定了只使用spring和spring mvc的话，你甚至可以将service 、dao、web层的bean都放到spring-servlet.xml中进行配置，并不是一定要将service、dao层的配置单独放到applicationContext.xml中，然后使用ContextLoaderListener来加载。在这种情况下，就没有了Root WebApplicationContext，只有Servlet WebApplicationContext。

#### 1.2.3 相关问题

##### 1.2.3.1 为什么不能在Spring的applicationContext.xml中配置全局扫描

如果都在spring容器中，这时的SpringMVC容器中没有对象，所以加载处理器，适配器的时候就会找不到映射对象，映射关系，因此在页面上就会出现404的错误。
因为在解析@ReqestMapping解析过程中，initHandlerMethods()函数只是对Spring MVC 容器中的bean进行处理的，并没有去查找父容器的bean。因此不会对父容器中含有@RequestMapping注解的函数进行处理，更不会生成相应的handler。所以当请求过来时找不到处理的handler，导致404。

##### 1.2.3.2 如果不用Spring容器，直接把所有层放入SpringMVC容器的配置spring-servlet.xml中可不可以

如果把所有层放入SpringMVC的。但是事务和AOP的相关功能不能使用。

##### 1.2.3.3 同时扫描

会在两个父子IOC容器中生成大量的相同bean，这就会造成内存资源的浪费。

#### 1.2.4 一般正常的操作

因为@RequestMapping一般会和@Controller搭配使。为了防止重复注册bean，建议在spring-servlet.xml配置文件中只扫描含有Controller bean的包，其它的共用bean的注册定义到applicationContext.xml文件中。

applicationContext.xml

```xml
<context:component-scan base-package="org.xuan.springmvc">
    <context:exclude-filter type="annotation"
                            expression="org.springframework.stereotype.Controller"/>
</context:component-scan>
```

spring-servlet.xml

```xml
<context:component-scan base-package="org.xuan.springmvc.controller" use-default-filters="false">
    <context:include-filter type="annotation"
                            expression="org.springframework.stereotype.Controller"/>
</context:component-scan>
```

注意

> Spring容器导入的properties配置文件，只能在Spring容器中用而在SpringMVC容器中不能读取到。 需要在SpringMVC 的配置文件中重新进行导入properties文件，并且同样在父容器Spring中不能被使用，导入后使用@Value("${key}")在java类中进行读取。