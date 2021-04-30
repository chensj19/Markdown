# Hibernate5源码浅析

## （一）SessionFactory的创建过程

**Hibernate5源码浅析（一）SessionFactory的\**创建过程\****

我们调用Hibernate的第一步就是创建SessionFactory，这一步一句代码可以写完，但是为了分析整个过程，我们分解为以下三句：

```java
Configuration cfg = new Configuration();//1初始化配置类
cfg.configure();//2加载配置文件
SessionFactory sf = cfg.buildSessionFactory();//3根据配置创建SessionFactory
```

**1、初始化配置类**

打开Configuration的源码我们可以看到这个构造函数内部一共调用了以下三个方法：

```java
    public Configuration() {
　　　　 //这里创建了一个BootstrapServiceRegistry实例传入下一个构造函数
        this( new BootstrapServiceRegistryBuilder().build() );
    }

    public Configuration(BootstrapServiceRegistry serviceRegistry) {
　　　　//根据传来的值，初始化bootstrapServiceRegistry字段
        this.bootstrapServiceRegistry = serviceRegistry;
　　　　//初始化了metadataSources字段
        this.metadataSources = new MetadataSources( serviceRegistry );
        reset();
    }

    protected void reset() {
        implicitNamingStrategy = ImplicitNamingStrategyJpaCompliantImpl.INSTANCE;
        physicalNamingStrategy = PhysicalNamingStrategyStandardImpl.INSTANCE;
        namedQueries = new HashMap<String,NamedQueryDefinition>();
        namedSqlQueries = new HashMap<String,NamedSQLQueryDefinition>();
        sqlResultSetMappings = new HashMap<String, ResultSetMappingDefinition>();
        namedEntityGraphMap = new HashMap<String, NamedEntityGraphDefinition>();
        namedProcedureCallMap = new HashMap<String, NamedProcedureCallDefinition>(  );
　　　　　
　　　　//初始化standServiceRegistryBuilder字段
        standardServiceRegistryBuilder = new StandardServiceRegistryBuilder( bootstrapServiceRegistry );
        entityTuplizerFactory = new EntityTuplizerFactory();
        interceptor = EmptyInterceptor.INSTANCE;
        properties = new Properties(  );
        properties.putAll( standardServiceRegistryBuilder.getSettings());
    }
```

可以看到第一步里面主要做了一些Configuration内部字段的初始化，其中我们主要关注这三个字段：bootstrapServiceRegistry、metadataSources、standardServiceRegistryBuilder。

- **bootstrapServiceRegistry** ServiceRegistry可以称之为“服务注册表”或“服务注册中心”，而bootstrapServiceRegistry是hibernate中底层基础服务注册中心
- **metadatSources** 元数据来源，可以在调用完Configuration的构造函数后通过条用Configuration的addFile、addURL、addInputStream等方法添加额外的mapping配置
- **standardServiceRegistryBuilder** 标准服务注册中心构造器，在下一步中将会用它来初始化standardServiceRegistry字段

个人理解ServiceRegistry类似Spring中的IOC容器，Hibernate将所有的底层的功能都封装为Service注册到ServiceRegistry中，需要的时候通过getService方法获取即可；就像Spring中将所有的功能封装为Bean注册到IOC容器中，需要的时候调用getBean方法获取。我们也可以封装自己的Service注册到ServiceRegistry中。关于ServiceRegistry后续再展开。

**2 加载配置文件**

再看第二步调用configure方法的内部执行过程

```java
    public Configuration configure() throws HibernateException {
　　　　 //1.StandardServiceRegistryBuilder.DEFAULT_CFG_RESOURCE_NAME的值是"hibernate.cfg.xml"
        return configure( StandardServiceRegistryBuilder.DEFAULT_CFG_RESOURCE_NAME );
    }

    public Configuration configure(String resource) throws HibernateException {
        //2.通过这个builder来加载配置文件
　　　　 standardServiceRegistryBuilder.configure( resource );
        //3.把配置文件中的设置项复制到properties字段中
        properties.putAll( standardServiceRegistryBuilder.getSettings() );
        return this;
    }
```

从中可以看出：

1. hibernate默认加载就是名为hibernate.cfg.xml的配置文件，我们也可以直接调用第二个方法来指定其他配置文件；
2. hibernate的配置文件实际上是通过standardServiceRegistryBuilder类去加载的，进入这个类的源码可以看到所有的配置信息被加载到了一个类型LoadedConfig的字段中；
3. 最后将一些配置项复制给了properties字段。

那么问题来了：第2点中的LoadedConfig和第3点中properties有什么区别？其实LoadedConfig包含了hibernate.cfg.xml中的所有配置项，而properties仅是其中的针对SessionFactory的Property的配置

**3 创建SessionFactory**

下一步是调用buildSessionFactory方法来创建SessionFactory，

```java
public SessionFactory buildSessionFactory() throws HibernateException {
  log.debug( "Building session factory using internal StandardServiceRegistryBuilder" );
  //使用properties重置配置信息
  standardServiceRegistryBuilder.applySettings( properties );
  //构造一个standardServiceRegistry传入下一个方法
  return buildSessionFactory( standardServiceRegistryBuilder.build() );
}

public SessionFactory buildSessionFactory(ServiceRegistry serviceRegistry) throws HibernateException {
  log.debug( "Building session factory using provided StandardServiceRegistry" );
  //创建metadataBuilder，然后配置它
  final MetadataBuilder metadataBuilder = metadataSources.getMetadataBuilder( (StandardServiceRegistry) serviceRegistry );
  if ( implicitNamingStrategy != null ) {
    metadataBuilder.applyImplicitNamingStrategy( implicitNamingStrategy );
  }
  if ( physicalNamingStrategy != null ) {
    metadataBuilder.applyPhysicalNamingStrategy( physicalNamingStrategy );
  }
  if ( sharedCacheMode != null ) {
    metadataBuilder.applySharedCacheMode( sharedCacheMode );
  }
  if ( !typeContributorRegistrations.isEmpty() ) {
    for ( TypeContributor typeContributor : typeContributorRegistrations ) {
      metadataBuilder.applyTypes( typeContributor );
    }
  }
  if ( !basicTypes.isEmpty() ) {
    for ( BasicType basicType : basicTypes ) {
      metadataBuilder.applyBasicType( basicType );
    }
  }
  if ( sqlFunctions != null ) {
    for ( Map.Entry<String, SQLFunction> entry : sqlFunctions.entrySet() ) {
      metadataBuilder.applySqlFunction( entry.getKey(), entry.getValue() );
    }
  }
  if ( auxiliaryDatabaseObjectList != null ) {
    for ( AuxiliaryDatabaseObject auxiliaryDatabaseObject : auxiliaryDatabaseObjectList ) {
      metadataBuilder.applyAuxiliaryDatabaseObject( auxiliaryDatabaseObject );
    }
  }
  if ( attributeConverterDefinitionsByClass != null ) {
    for ( AttributeConverterDefinition attributeConverterDefinition : attributeConverterDefinitionsByClass.values() ) {
      metadataBuilder.applyAttributeConverter( attributeConverterDefinition );
    }
  }

  //根据metadataBuilder创建metadata
  final Metadata metadata = metadataBuilder.build();
  //创建SessionFactoryBuilder，然后配置它
  final SessionFactoryBuilder sessionFactoryBuilder = metadata.getSessionFactoryBuilder();
  if ( interceptor != null && interceptor != EmptyInterceptor.INSTANCE ) {
    sessionFactoryBuilder.applyInterceptor( interceptor );
  }
  if ( getSessionFactoryObserver() != null ) {
    sessionFactoryBuilder.addSessionFactoryObservers( getSessionFactoryObserver() );
  }
  if ( entityNotFoundDelegate != null ) {
    sessionFactoryBuilder.applyEntityNotFoundDelegate( entityNotFoundDelegate );
  }
  if ( entityTuplizerFactory != null ) {
    sessionFactoryBuilder.applyEntityTuplizerFactory( entityTuplizerFactory );
  }

  //根据SessionFactoryBuilder创建SessionFactory
  return sessionFactoryBuilder.build();
}
```

这一段比较长，但是很多都是在配置Builder的参数，红色注释标记了我们要关注的关键点：

1. 使用properties配置信息，为什么上一步刚刚从standardServiceRegistryBuilder中把这些配置信息复制到了properties字段，这一步又把这些值重新应用回去？个人认为主要是为了让调用者可以在这两步中间改写properties的值或者添加一些额外的配置信息进去。
2. 根据metadataBuilder创建metadata，metadata中存储了所有的ORM映射信息，这些映射信息来源于hibernate.cfg.xml和前面提高的metadataSources
3. 根据SessionFactoryBuilder创建SessionFactory，SessionFactoryBuilder是由上一点的metadata创建。

到此，一个SessionFactory创建完毕。

## （二）Hibernate中的各种Builder

上一篇简单的介绍了hibernate5中一个SessionFactory的创建过程，这里我们把这个过程在深入下去。hibernate的启动过程实际上就是加载配置、解析配置并创建出与当前配置环境匹配对应的Java对象的过程，因此这个过程中肯定会用到大量的创建型设计模式，其中尤其是Builder模式使用最多。例如上一篇中提到的BootstrapServiceRegistryBuilder、MetadataBuilder、sessionFactoryBuilder等。

**1. Builder模式**

先回头温习一下Builder设计模式，就不容易被hibernate中层层调用的各种XxxBuilder绕晕了。经典Builder模式网上有大量的参考，然而Hibernate中的Builder类与经典模式有些不同(做了一些简化，更加具有实用性)，看下面这一段摘自Configuration类中的代码：

```java
    public SessionFactory buildSessionFactory(ServiceRegistry serviceRegistry) throws HibernateException {
        log.debug( "Building session factory using provided StandardServiceRegistry" );
        //1.创建MetadataBuilder
        final MetadataBuilder metadataBuilder = metadataSources.getMetadataBuilder( (StandardServiceRegistry) serviceRegistry );
//2.配置MetadataBuilder
        if ( implicitNamingStrategy != null ) {
            metadataBuilder.applyImplicitNamingStrategy( implicitNamingStrategy );
        }
        if ( physicalNamingStrategy != null ) {
            metadataBuilder.applyPhysicalNamingStrategy( physicalNamingStrategy );
        }
        if ( sharedCacheMode != null ) {
            metadataBuilder.applySharedCacheMode( sharedCacheMode );
        }
        if ( !typeContributorRegistrations.isEmpty() ) {
            for ( TypeContributor typeContributor : typeContributorRegistrations ) {
                metadataBuilder.applyTypes( typeContributor );
            }
        }
        if ( !basicTypes.isEmpty() ) {
            for ( BasicType basicType : basicTypes ) {
                metadataBuilder.applyBasicType( basicType );
            }
        }
        if ( sqlFunctions != null ) {
            for ( Map.Entry<String, SQLFunction> entry : sqlFunctions.entrySet() ) {
                metadataBuilder.applySqlFunction( entry.getKey(), entry.getValue() );
            }
        }
        if ( auxiliaryDatabaseObjectList != null ) {
            for ( AuxiliaryDatabaseObject auxiliaryDatabaseObject : auxiliaryDatabaseObjectList ) {
                metadataBuilder.applyAuxiliaryDatabaseObject( auxiliaryDatabaseObject );
            }
        }
        if ( attributeConverterDefinitionsByClass != null ) {
            for ( AttributeConverterDefinition attributeConverterDefinition : attributeConverterDefinitionsByClass.values() ) {
                metadataBuilder.applyAttributeConverter( attributeConverterDefinition );
            }
        }

        //3.使用MetadataBuilder创建Metadata
        final Metadata metadata = metadataBuilder.build();

//4.创建SessionFactoryBuilder
        final SessionFactoryBuilder sessionFactoryBuilder = metadata.getSessionFactoryBuilder();
//5.配置SessionFactoryBuilder
        if ( interceptor != null && interceptor != EmptyInterceptor.INSTANCE ) {
            sessionFactoryBuilder.applyInterceptor( interceptor );
        }
        if ( getSessionFactoryObserver() != null ) {
            sessionFactoryBuilder.addSessionFactoryObservers( getSessionFactoryObserver() );
        }
        if ( entityNotFoundDelegate != null ) {
            sessionFactoryBuilder.applyEntityNotFoundDelegate( entityNotFoundDelegate );
        }
        if ( entityTuplizerFactory != null ) {
            sessionFactoryBuilder.applyEntityTuplizerFactory( entityTuplizerFactory );
        }
        //6.使用SessionFactoryBuilder创建SessionFactory
        return sessionFactoryBuilder.build();
    }
```

从第一步到第三步，Hibernate的最终目的是要创建一个Metadata对象，然而要创建一个Metadata对象并不是直接New一个那么简单，因此Hibernate提供了一个MetadataBuilder类来专门负责创建Metadata，从第二步中可以看出MetadataBuilder做了大量的判断和处理后才能走到第三步调用build方法创建Metadata对象。后面第四步到第六步创建SessionFactory对象也是同样的道理。因此阅读源码的时候可以先抓住主要过程，中间大量参数准备的内容可以暂时略过。比如上面这段代码中实际上就是做了两件事创建Metadata和创建SessionFactory。

当我们创建一个对象需要判断大量条件和参数时，与其提供带有大量参数的、各种不同重载方式的构造函数（其中可能有部分必传参数部分可选参数），倒不如为它专门提供一个Builder类来负责处理这些创建逻辑，Hibernate中大量的Builder类大多都是这样产生的。

 **2.Hibernate中的Builder**

**2.1 BootstrapServiceRegistryBuilder**

我们在Hibernate中遇到的第一个Builder应该就是BootstrapServiceRegistryBuilder，它负责创建BootstrapServiceRegistry（基础服务注册中心）：

```java
    public Configuration() {
        this( new BootstrapServiceRegistryBuilder().build() );
    }
```

BootstrapServiceRegistry中注册的了固定的三个基础服务ClassLoaderService（类加载器服务）、StrategySelector（决策选择器）、IntegratorService（集成服务），其中StrategySelector又是由对应的StrategySelectorBuilder来创建。

```java
        return new BootstrapServiceRegistryImpl(
                autoCloseRegistry,
                classLoaderService,
                strategySelectorBuilder.buildSelector( classLoaderService ),
                integratorService
        );
```

 **2.2 StandardServiceRegistryBuilder**

StandardServiceRegistryBuilder用于创建StandardServiceRegistry（标准服务注册中心），这里将注册Hibernate中需要用到的大量服务，上一篇中我们了解到Configuration类中的configure方法实际上是调用了StandardServiceRegistryBuilder的configure方法：

```java
public Configuration configure(String resource) throws HibernateException {
  standardServiceRegistryBuilder.configure( resource );
  properties.putAll( standardServiceRegistryBuilder.getSettings() );
  return this;
}
```

为什么配置文件是由这个StandardServiceRegistryBuilder来装载呢，实际上这正是Hibernate里面Builder模式的主要作用，Builder在创建对象之前需要先获取对象创建参数，然后执行参数判断逻辑，最终创建出目标对象，而此处StandardServiceRegistryBuilder的参数来源就是hibernate配置文件，因此用它来装载配置文件解析其中的参数然后才能创建目标对象。

 

有了对Hibernate中Builder模式的基本理解，再去阅读原码，就更容易抓住逻辑主线了，而不会被大量的参数准备逻辑带晕了。