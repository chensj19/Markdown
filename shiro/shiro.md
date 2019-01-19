# shiro 

Apache Shiro 是一个强大而灵活的开源安全框架，它干净利落地处理身份认证，授权，企业会话管理和加密。

* 1. shiro是一个基于java的安全管理框架，可以完成认证、授权、加密、缓存等
* 2. 在java中，安全管理框架有spring security和shiro，spring security要依存于spring，并且比较复杂，学习曲线比较高。shiro比较简单，而且shiro比较独立，既可以在J2SE中使用，也可以在J2EE中使用，还可以在分布式集群环境下可以使用。

## shiro结构体系

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

## shiro 架构

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