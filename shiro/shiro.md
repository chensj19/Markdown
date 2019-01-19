# shiro 

Apache Shiro 是一个强大而灵活的开源安全框架，它干净利落地处理身份认证，授权，企业会话管理和加密。

* 1. shiro是一个基于java的安全管理框架，可以完成认证、授权、加密、缓存等
* 2. 在java中，安全管理框架有spring security和shiro，spring security要依存于spring，并且比较复杂，学习曲线比较高。shiro比较简单，而且shiro比较独立，既可以在J2SE中使用，也可以在J2EE中使用，还可以在分布式集群环境下可以使用。

## 1、shiro结构体系

![1547722754725](http://dl2.iteye.com/upload/attachment/0093/9788/d59f6d02-1f45-3285-8983-4ea5f18111d5.png)

Shiro 把Shiro 开发团队称为“应用程序的四大基石”——身份验证，授权，会话管理和加密作为其目标。
- Authentication：有时也简称为“登录”，这是一个证明用户是他们所说的他们是谁的行为。

  -  验证用户是否合法，也就是登陆

- Authorization：访问控制的过程，也就是绝对“谁”去访问“什么”。

  -  授予谁具有访问某些资源的权限

- Session Management：管理用户特定的会话，即使在非Web 或EJB 应用程序。

  -  用户登陆后用户信息通过sessionmanagement来进行管理，不管在什么应用中

- Cryptography：通过使用加密算法保持数据安全同时易于使用。

  * 加密，提供了常见的一些算法，使得在应用中可以很方便的实现数据安全，并且使用很便捷

  也提供了额外的功能来支持和加强在不同环境下所关注的方面，尤其是以下这些：

- Web Support：Shiro 的web 支持的API 能够轻松地帮助保护Web 应用程序。

  -  web应用程序支持，可以方便的集成到web应用程序中

- Caching：缓存是Apache Shiro 中的第一层公民，来确保安全操作快速而又高效。

  -  提供了缓存支持，支持多种缓存架构，如：Ehchcahe，Redis

- Concurrency：Apache Shiro 利用它的并发特性来支持多线程应用程序。

  - 并发支持，支持多线程

- Testing：测试支持的存在来帮助你编写单元测试和集成测试，并确保你的能够如预期的一样安全。

  - 测试支持

- "Run As"：一个允许用户假设为另一个用户身份（如果允许）的功能，有时候在管理脚本很有用。

  - 支持一个用户允许的前提下，使用另外一个身份登录

- "Remember Me"：在会话中记住用户的身份，所以他们只需要在强制时候登录。

  - 记住我

## 2、shiro 架构

![1547731401919](http://dl2.iteye.com/upload/attachment/0093/9792/9b959a65-799d-396e-b5f5-b4fcfe88f53c.png)

* Subject(org.apache.shiro.subject.Subject)
  当前与软件进行交互的实体（用户，第三方服务，cron job，等等）的安全特定“视图”
* SecurityManager(org.apache.shiro.mgt.SecurityManager)
  如上所述，SecurityManager 是Shiro 架构的心脏。它基本上是一个“保护伞”对象，协调其管理的组件以确保
  它们能够一起顺利的工作。它还管理每个应用程序用户的Shiro 的视图，因此它知道如何执行每个用户的安全
  操作。
* Authenticator(org.apache.shiro.authc.Authenticator)
  Authenticator 是一个对执行及对用户的身份验证（登录）尝试负责的组件。当一个用户尝试登录时，该逻辑
  被Authenticator 执行。Authenticator 知道如何与一个或多个Realm 协调来存储相关的用户/帐户信息。从这些Realm 中获得的数据被用来验证用户的身份来保证用户确实是他们所说的他们是谁。
  * Authentication Strategy(org.apache.shiro.authc.pam.AuthenticationStrategy)
    如果不止一个Realm 被配置，则AuthenticationStrategy 将会协调这些Realm 来决定身份认证尝试成功或失败下的条件（例如，如果一个Realm 成功，而其他的均失败，是否该尝试成功？ 是否所有的Realm必须成功？或只有第一个成功即可？）。
* Authorizer(org.apache.shiro.authz.Authorizer)
    Authorizer 是负责在应用程序中决定用户的访问控制的组件。它是一种最终判定用户是否被允许做某事的机制。与Authenticator 相似，Authorizer 也知道如何协调多个后台数据源来访问角色恶化权限信息。Authorizer 使用该信息来准确地决定用户是否被允许执行给定的动作。
* SessionManager(org.apache.shiro.session.SessionManager)
    SessionManager 知道如何去创建及管理用户Session 生命周期来为所有环境下的用户提供一个强健的Session体验。这在安全框架界是一个独有的特色——Shiro 拥有能够在任何环境下本地化管理用户Session 的能力，即使没有可用的Web/Servlet 或EJB 容器，它将会使用它内置的企业级会话管理来提供同样的编程体验。SessionDAO 的存在允许任何数据源能够在持久会话中使用。
    * SessionDAO(org.apache.shiro.session.mgt.eis.SessionDAO)
    SesssionDAO 代表SessionManager 执行Session 持久化（CRUD）操作。这允许任何数据存储被插入到会话管理的基础之中。
* CacheManager(org.apahce.shiro.cache.CacheManager)
    CacheManager 创建并管理其他Shiro 组件使用的Cache 实例生命周期。因为Shiro 能够访问许多后台数据源，由于身份验证，授权和会话管理，缓存在框架中一直是一流的架构功能，用来在同时使用这些数据源时提高性能。任何现代开源和/或企业的缓存产品能够被插入到Shiro 来提供一个快速及高效的用户体验。
* Cryptography(org.apache.shiro.crypto.*)
    Cryptography 是对企业安全框架的一个很自然的补充。Shiro 的crypto 包包含量易于使用和理解的cryptographic  Ciphers，Hasher（又名digests）以及不同的编码器实现的代表。所有在这个包中的类都被精心地设计以易于使用和易于理解。任何使用Java 的本地密码支持的人都知道它可以是一个难以驯服的具有挑战性的动物。Shiro的cryptoAPI 简化了复杂的Java 机制，并使加密对于普通人也易于使用。
* Realms(org.apache.shiro.realm.Realm)
    如上所述，Realms 在Shiro 和你的应用程序的安全数据之间担当“桥梁”或“连接器”。当它实际上与安全相关的数据如用来执行身份验证（登录）及授权（访问控制）的用户帐户交互时，Shiro 从一个或多个为应用程序配置的Realm 中寻找许多这样的东西。你可以按你的需要配置多个Realm（通常一个数据源一个Realm），且Shiro 将为身份验证和授权对它们进行必要的协调。

## 3、spring 集成 shiro

### 3.1 web.xml

```xml
 <filter>
        <filter-name>shiroFilter</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
        <init-param>
            <param-name>targetFilterLifecycle</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>shiroFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```

### 3.2 spring-shiro.xml

```xml
<!-- =========================================================
      2、配置SecurityManager
    =========================================================-->
    <bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
        <!-- shiro缓存管理器 -->
        <property name="cacheManager" ref="shiroEhcacheManager"/>
        <!-- 配置Realm -->
        <property name="realm" ref="jdbcRealm"/>
    </bean>
 <!-- =========================================================
        3、配置缓存
        3.1 需要加入ehcache的jar和配置文件       =========================================================-->
    <bean id="shiroEhcacheManager" class="org.apache.shiro.cache.ehcache.EhCacheManager">
        <property name="cacheManagerConfigFile" value="classpath:ehcache-shiro.xml" />
    </bean>
 <!-- =========================================================
        4、配置Realm
        4.1.直接配置 直接实现Realm接口创建Realm
        =========================================================-->
    <bean id="jdbcRealm" class="com.winning.shiro.realm.ShiroRealm"/>
  <!-- =========================================================
        5、配置生命周期管理器，可以在spring容器中直接管理shiro bean的生命周期方法
         可以自动的来调用配置在Spring IOC容器中shiro bean 的生命周期方法
         =========================================================-->
    <bean id="lifecycleBeanPostProcessor" class="org.apache.shiro.spring.LifecycleBeanPostProcessor"/>
 <!--=========================================================
        6、启用IOC容器中在shiro的注解，仅必须在配置lifecycleBeanProcessor之后才开始使用
        =========================================================-->
    <bean class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator"
          depends-on="lifecycleBeanPostProcessor"/>
    <bean class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor">
        <property name="securityManager" ref="securityManager"/>
    </bean>
 <!--=========================================================
        7、配置shiro Filter
        7.1、注意此处配置的id必须与web.xml中配置的filter-name名称一致
            若不一致，则会抛出：NoSuchBeanDefinitionException，因为shiro回来IOC容器中查找与`<filter-name>`名称一样的filter-bean
            也可以通过在web.xml中配置DelegatingFilterProxy中配置初始化参数targetBeanName来指定shiroFilter的名称
        =========================================================-->
    <bean id="shiroFilter" class="org.apache.shiro.spring.web.ShiroFilterFactoryBean">
        <property name="securityManager" ref="securityManager"/>
        <property name="loginUrl" value="/login.jsp"/>
        <property name="successUrl" value="/main.jsp"/>
        <property name="unauthorizedUrl" value="/unauthorized.jsp"/>
        <!--
            配置那些页面需要受保护
            以及访问那些页面需要保护权限
            anon  可以匿名访问
            authc  登录后才可以登录
        -->
        <property name="filterChainDefinitions">
            <value>
                / = anon
                /favicon.ico = anon
                /logo.png = anon
                /shiro.css = anon
                /login.jsp = anon
                /index.jsp = anon
                /*.jar = anon
                # everything else requires authentication:
                /** = authc
            </value>
        </property>
    </bean>
```

*注意* 

1、web.xml 中filter-name必须要与spring-shiro的名称一致

​	若不一致，则会抛出：NoSuchBeanDefinitionException，因为shiro回来IOC容器中查找与`<filter-name>`名称一样的filter-bean

​	其中的主要原因在DelegatingFilterProxy中，

> ```
> * Proxy for a standard Servlet Filter, delegating to a Spring-managed bean that
> * implements the Filter interface. Supports a "targetBeanName" filter init-param
> * in {@code web.xml}, specifying the name of the target bean in the Spring
> * application context.
> DelegatingFilterProxy是一个标准的Servlet的过滤器，定义由Spring进行管理的，并且实现了Filter接口，支持使用“targetBeanName”的初始化参数来进行定义，可以在spring容器中通过这个名称查找对应的bean,如果没有配置则默认找`filter-name`
> *
> * <p>{@code web.xml} will usually contain a {@code DelegatingFilterProxy} definition,
> * with the specified {@code filter-name} corresponding to a bean name in
> * Spring's root application context. All calls to the filter proxy will then
> * be delegated to that bean in the Spring context, which is required to implement
> * the standard Servlet Filter interface.	
> 在web.xml中通常会存在使用filter-name定义的DelegatingFilterProxy，可以在spring容器中查找到。然后所有对proxy filter的调用都将在Spring上下文中被委托给bean，这是实现标准servlet过滤器接口。
> ```

2、如果需要使用shiro的注解，则需要配置`LifecycleBeanPostProcessor`

### 3.3 filterChainDefinitions配置

​	配置方式为`url=[拦截器]`的模式来进行配置，常见的拦截器如下：

 * anon 匿名访问
 * authc 登录访问
 * logout 登出操作

### 3.4 URL匹配模式

shiro支持Ant风格的URL匹配模式

* ?:匹配一个字符 如/admin? 可以匹配/admin1,但是不能匹配/admin或者/admin/
* \*:匹配零或多个字符串，如/admin\*则可以匹配/admin,/admin123，不能匹配/admin/123
* \*\*:匹配路径中的零或多个路径，如/admin/\*\*,将匹配/admin/a或者/admin/a/b

URL匹配采取**第一次**匹配优先模式，即是从头开始按照第一个匹配的url模式进行拦截

如：
```ini
/** = authc
/login=anon
```
上面这种则所有的都无法访问，必须登录后才能访问

## 4.shiro工作流程

1、在`web.xml`中配置`shiroFilter`，相当于配置一个入口，会拦截所有的请求

2、`shiroFilter`会根据配置url来进行拦截判断，属于anon请求的则可以访问，属于authc的则需要判断是否登录，登录则允许，反之则不可以访问，跳转到loginUrl页面

### 4.1 shiro 拦截器

查看shiro中的拦截器在类`org.apache.shiro.web.filter.mgt.DefaultFilter`中

* 认证相关Filter
  * anon(AnonymousFilter.class)  
    * 匿名过滤器
  * authc(FormAuthenticationFilter.class)
    * 基于表单的拦截器
  * authcBasic(BasicHttpAuthenticationFilter.class)
    * Basic Http 身份验证拦截器
  * logout(LogoutFilter.class)
    * 退出拦截器
  * user(UserFilter.class)
    * 用户拦截器
* 授权相关的Filter
  * perms(PermissionsAuthorizationFilter.class)
    * 权限授权拦截器，验证用户是否具有权限
  * roles(RolesAuthorizationFilter.class)
    * 角色授权拦截器，验证用户是否具有角色
  * port(PortFilter.class)
    * 端口拦截器，可以通过的端口
  * rest(HttpMethodPermissionFilter.class)
    * rest风格拦截器，自动根据请求方法构建拦截字符串
  * ssl(SslFilter.class)
    * SSL拦截器，只有请求协议为https才能通过
* session相关的Filter
  * noSessionCreation(NoSessionCreationFilter.class)


## 5.认证

### 5.1 登录流程

1. 用户通过表单将用户名和密码提交到后台处理登录的Controller，获取用户名和密码
2. 获取当前的Subject，通过SecurityUtils.getSubject()方法
3. 测试当前用户是否已经被认证，即是否已经登录，调用Subject的isAuthenticated()
   1. 如没有登录，则吧用户名和密码封装为UsernamePasswordToken对象
4. 执行登录，调用Subject.login(AuthenticationToken)方法，来执行登录
5. 自定义Realm的方法，从数据库中获取对应的记录，返回给shiro
   1. 自定义Realm，通常是继承`AuthenticatingRealm`，实现`doGetAuthenticationInfo(AuthenticationToken)`方法
6. 有Shiro完成密码比对

### 5.2 流程实现

####	5.2.1 密码比对

 * 前台传入密码存放在token中，后台取出的密码则存放在SimpleAuthenticationInfo，即Realm认证的时候存入的

   ```
   SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(principal,credentials,realmName);
   ```

* 通过AuthenticatingRealm中credentialsMatcher属性实现密码比对

```java
  protected void assertCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) throws AuthenticationException {
        CredentialsMatcher cm = getCredentialsMatcher();
        if (cm != null) {
            if (!cm.doCredentialsMatch(token, info)) {
                //not successful - throw an exception to indicate this:
                String msg = "Submitted credentials for token [" + token + "] did not match the expected credentials.";
                throw new IncorrectCredentialsException(msg);
            }
        } else {
            throw new AuthenticationException("A CredentialsMatcher must be configured in order to verify " +
                    "credentials during authentication.  If you do not wish for credentials to be examined, you " +
                    "can configure an " + AllowAllCredentialsMatcher.class.getName() + " instance.");
        }
    }
```

#### 5.2.2 多Realm

* 1.配置多Realm

  ```xml
  <bean id="shiroRealm" class="com.winning.shiro.realm.ShiroRealm">
          <!-- 指定Realm使用的密码匹配器-->
          <property name="credentialsMatcher">
              <bean class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
                  <!--指定使用的加密算法-->
                  <property name="hashAlgorithmName" value="MD5"/>
                  <!--指定加密次数-->
                  <property name="hashIterations" value="1024"/>
              </bean>
          </property>
      </bean>
      <!--
          第二个Realm 采用SHA1算法加密
      -->
      <bean id="secondShiroRealm" class="com.winning.shiro.realm.SecondShiroRealm">
          <!-- 指定Realm使用的密码匹配器-->
          <property name="credentialsMatcher">
              <bean class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
                  <!--指定使用的加密算法-->
                  <property name="hashAlgorithmName" value="SHA1"/>
                  <!--指定加密次数-->
                  <property name="hashIterations" value="1024"/>
              </bean>
          </property>
      </bean>
  ```

* 2.配置认证器

  ```xml
  <!--配置认证器-->
      <bean id="modularRealmAuthenticator" class="org.apache.shiro.authc.pam.ModularRealmAuthenticator">
          <property name="realms">
              <list>
                  <ref bean="shiroRealm"/>
                  <ref bean="secondShiroRealm"/>
              </list>
          </property>
      </bean>
  ```

* 3.配置安全管理器 SecurityManager

```xml
 <bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
        <!-- shiro缓存管理器 -->
        <property name="cacheManager" ref="shiroEhcacheManager"/>
        <!-- 单Realm配置-->
        <!--<property name="realm" ref="shiroRealm"/>-->
        <!--多Realm配置-->
        <property name="authenticator" ref="modularRealmAuthenticator"/>
    </bean>
```

**注意：配置认证顺序安装配置顺序来实现**

#### 5.2.3 认证策略

* 在shiro中默认采用的认证策略为`AtLeastOneSuccessfulStrategy`，设置代码在`ModularRealmAuthenticator`的构造器中

* 认证策略修改

```xml
<bean id="modularRealmAuthenticator" class="org.apache.shiro.authc.pam.ModularRealmAuthenticator">
        <property name="realms">
            <list>
                <ref bean="shiroRealm"/>
                <ref bean="secondShiroRealm"/>
            </list>
        </property>
        <!-- 认证策略修改 -->
        <property name="authenticationStrategy">
            <bean class="org.apache.shiro.authc.pam.AllSuccessfulStrategy"/>
        </property>
    </bean>
```

* 查看当前的认证策略
  * 代码在`ModularRealmAuthenticator.doMultiRealmAuthentication()`第200行
* 查看认证结果
  * 代码在`ModularRealmAuthenticator.doMultiRealmAuthentication()`第235行
  * 通过修改Realm中的principal字段的值，可以获取多个身份认证的信息

#### 5.2.4  Realms 传递

​	在Shiro中Realms会进行传递，即在SecurityManager中配置的Realms会传递给Authenticator(认证器)和authorizator(授权器)，源码中说明为

```java
 /**
     * Internal collection of <code>Realm</code>s used for all authentication and authorization operations.
     */
    private Collection<Realm> realms;
```

则，在设置Realms的时候，最好的方式是将Realms设置给SecurityManager

因此上面的多Realm设置应该修改为如下配置：

```xml
 <bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
        <!-- shiro缓存管理器 -->
        <property name="cacheManager" ref="shiroEhcacheManager"/>
        <!-- 单Realm配置-->
        <!--<property name="realm" ref="shiroRealm"/>-->
        <!--多Realm配置 指定认证器-->
        <property name="authenticator" ref="modularRealmAuthenticator"/>
        <!--多Realm配置 配置多realm-->
        <property name="realms">
            <list>
                <ref bean="shiroRealm"/>
                <ref bean="secondShiroRealm"/>
            </list>
        </property>
    </bean>
 <!--配置认证器-->
    <bean id="modularRealmAuthenticator" class="org.apache.shiro.authc.pam.ModularRealmAuthenticator">
        <!-- 认证策略修改 -->
        <property name="authenticationStrategy">
            <bean class="org.apache.shiro.authc.pam.AllSuccessfulStrategy"/>
        </property>
    </bean>
```







## 6.密码加密

### 6.1 密码加密 

* 替换credentialsMatcher属性

  * 使用shiro提供的加密类`HashedCredentialsMatcher`指定加密算法来完成加密

  ```xml
   <bean id="jdbcRealm" class="com.winning.shiro.realm.ShiroRealm">
          <!-- 指定Realm使用的密码匹配器-->
          <property name="credentialsMatcher">
              <bean class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
                  <!--指定使用的加密算法-->
                  <property name="hashAlgorithmName" value="MD5"/>
              </bean>
          </property>
      </bean>
  ```

* `HashedCredentialsMatcher`中设置流程

  * ```java
    CredentialsMatcher.doCredentialsMatch() // 密码匹配
    -->HashedCredentialsMatcher.doCredentialsMatch() // 开始密码匹配，获取密码
    -->HashedCredentialsMatcher.hashProvidedCredentials() // 判断是否存在salt，还可以定义加密的次数
    -->HashedCredentialsMatcher.hashProvidedCredentials() // 判断是否存在指定加密算法,构造SimpleHash返回加密后的前台输入的密码，至此前台输入密码加密完成
    -->HashedCredentialsMatcher.doCredentialsMatch() // 获取后台密码
    -->HashedCredentialsMatcher.equals() // 密码比较
    ```

  * 加密次数设定

  ```xml
   <bean id="jdbcRealm" class="com.winning.shiro.realm.ShiroRealm">
          <!-- 指定Realm使用的密码匹配器-->
          <property name="credentialsMatcher">
              <bean class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
                  <!--指定使用的加密算法-->
                  <property name="hashAlgorithmName" value="MD5"/>
                  <!--指定加密次数-->
                  <property name="hashIterations" value="1024"/>
              </bean>
          </property>
      </bean>
  ```

### 6.2 安全升级 -- salt引入

对于后台取出的数据盐值设置在Realm中完成

* 使用盐值加密意义
  * 即使在两个人密码相同的情况下也能够保存存入数据库的密文不一致
* 实现方式
  * 在Realm中的doGetAuthenticationInfo方法中返回创建SimpleAuthenticationInfo对象的时候，需要使用new SimpleAuthenticationInfo(principal,credentials,credentialsSalt,realmName)构造器
  * 使用ByteSource.Util.bytes();来计算盐值
  * 盐值需要唯一：一般使用随机字符串或者user id
  * 将使用return new SimpleHash(hashAlgorithmName, credentials, salt, hashIterations);来实现盐值加密

 ## 7.授权

访问控制，就是在应用中能够访问那些URL资源，主要包含以下几个关键的对象：

### 7.1 关键对象

* subject ：主体，访问应用的用户
* Resources：资源，在应用中用户可以访问的URL，显示的菜单列表
* Permission：权限，应用中用户能不能访问某个资源，或者说用户是否具有操作某个资源的权利
* Role：角色，权限的集合

### 7.2 授权方式

* 编程式：通过if、else授权代码完成
* 注解式：通过在执行Java方法上面放置相应的注解来完成，没有权限就抛出异常
* JSP、GSP标签：在JSP/GSP页面通过相应的标签来完成


















## 20.问题集合

#### redirect 失败

**检查当前使用的注解是否为为@RestController，如果是则需要改为@Controller**

#### 中文乱码

在tomcat或者其他WebServer(Servlet容器)中JSP编码为乱码，则需要在jsp中增加meta标签

```html
<meta charset="UTF-8">
```

解决中文乱码问题

在部分版本的Servlet容器中对于<%@page %>无法识别，导致无法设置编码，则需要使用上面的方式解决乱码问题

