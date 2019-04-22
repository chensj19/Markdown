## spring bean 手工注册

手动注册bean的两种方式：

- 实现ImportBeanDefinitionRegistrar
- 实现BeanDefinitionRegistryPostProcessor

## 1.ImportBeanDefinitionRegistrar

​	ImportBeanDefinitionRegistrar其本质也是通过BeanDefinitionRegistryPostProcessor来实现的。实现ImportBeanDefinitionRegistrar比较简单，也有多种方式，下面这个是最简单的手动注册bean的方式。

### 1.1 手动创建BeanDefinition



```java
// 待注册Bean
public class Foo {
    public void foo() {
        System.out.println("Foo.foo() invoked!");
    }
}
// 接口实现
public class FooImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {

    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        BeanDefinitionBuilder builder = BeanDefinitionBuilder.genericBeanDefinition(Foo.class);
        BeanDefinition beanDefinition = builder.getBeanDefinition();
        registry.registerBeanDefinition("foo",beanDefinition);
    }

}

// 启动类
@SpringBootApplication
@Import({FooImportBeanDefinitionRegistrar.class})
public class Demo implements CommandLineRunner {

    @Autowired
    private Foo foo;

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Demo.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        foo.foo();
    }
}
```

输出： 
Foo.foo() invoked!

### 1.2 ClassPathBeanDefinitionScanner

借助spring类ClassPathBeanDefinitionScanner来扫描Bean并注册
```java
public class Foo {

    public void foo() {
        System.out.println("Foo.foo() invoked!");
    }
}

public class FooImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {

    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        ClassPathBeanDefinitionScanner scanner = new ClassPathBeanDefinitionScanner(registry);
        // 使用过滤器，可以创建使用的过滤器等
        scanner.addIncludeFilter(new AssignableTypeFilter(Foo.class));
        scanner.scan("com.study.demo.domain");
        //这里也可以扫描自定义注解并生成BeanDefinition并注册到Spring上下文中
    }
}

@SpringBootApplication
@Import({FooImportBeanDefinitionRegistrar.class})
public class Demo implements CommandLineRunner {

    @Autowired
    private Foo foo;
    
    public static void main(String[] args) throws Exception {
        SpringApplication.run(Demo.class, args);
    }
    
    @Override
    public void run(String... args) throws Exception {
        foo.foo();
    }
}
```

输出： 
Foo.foo() invoked!

### 1.3 ImportBeanDefinitionRegistrar
​		在上一个例子中我们直接使用的是`ClassPathBeanDefinitionScanner`，我们也可以继承`ImportBeanDefinitionRegistrar`并重写相关方法(一般都是扫描自定义的注解，才会继承`ClassPathBeanDefinitionScanner`)。这里你可以扫描自定义的注解，生成BeanDefinition（或其代理）的定义，然后注册到spring容器中。

​		实现代码可以参考Mybatis的`org.mybatis.spring.annotation.MapperScannerRegistrar`类，Mybatis扫描Mapper注解，通过MapperFactoryBean来代理了Mapper，并将其注册到spring中

```java
public class MapperScannerRegistrar implements ImportBeanDefinitionRegistrar, ResourceLoaderAware {

  private ResourceLoader resourceLoader;

  /**
   * {@inheritDoc}
      */

    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
    
    AnnotationAttributes annoAttrs = AnnotationAttributes.fromMap(importingClassMetadata.getAnnotationAttributes(MapperScan.class.getName()));
    ClassPathMapperScanner scanner = new ClassPathMapperScanner(registry);
    
    // this check is needed in Spring 3.1
    if (resourceLoader != null) {
      scanner.setResourceLoader(resourceLoader);
    }
    
    Class<? extends Annotation> annotationClass = annoAttrs.getClass("annotationClass");
    if (!Annotation.class.equals(annotationClass)) {
      scanner.setAnnotationClass(annotationClass);
    }
    
    Class<?> markerInterface = annoAttrs.getClass("markerInterface");
    if (!Class.class.equals(markerInterface)) {
      scanner.setMarkerInterface(markerInterface);
    }
    
    Class<? extends BeanNameGenerator> generatorClass = annoAttrs.getClass("nameGenerator");
    if (!BeanNameGenerator.class.equals(generatorClass)) {
      scanner.setBeanNameGenerator(BeanUtils.instantiateClass(generatorClass));
    }
    
    Class<? extends MapperFactoryBean> mapperFactoryBeanClass = annoAttrs.getClass("factoryBean");
    if (!MapperFactoryBean.class.equals(mapperFactoryBeanClass)) {
      scanner.setMapperFactoryBean(BeanUtils.instantiateClass(mapperFactoryBeanClass));
    }
    
    scanner.setSqlSessionTemplateBeanName(annoAttrs.getString("sqlSessionTemplateRef"));
    scanner.setSqlSessionFactoryBeanName(annoAttrs.getString("sqlSessionFactoryRef"));
    
    List<String> basePackages = new ArrayList<String>();
    for (String pkg : annoAttrs.getStringArray("value")) {
      if (StringUtils.hasText(pkg)) {
        basePackages.add(pkg);
      }
    }
    for (String pkg : annoAttrs.getStringArray("basePackages")) {
      if (StringUtils.hasText(pkg)) {
        basePackages.add(pkg);
      }
    }
    for (Class<?> clazz : annoAttrs.getClassArray("basePackageClasses")) {
      basePackages.add(ClassUtils.getPackageName(clazz));
    }
    scanner.registerFilters();
    scanner.doScan(StringUtils.toStringArray(basePackages));
  }

  /**
   * {@inheritDoc}
      */
    @Override
    public void setResourceLoader(ResourceLoader resourceLoader) {
    
    this.resourceLoader = resourceLoader;
  }
}
```

一般继承ClassPathBeanDefinitionScanner需要实现这三个方法（并不绝对）

* registerFilters
* doScan
* isCandidateComponent

## 2. BeanDefinitionRegistryPostProcessor
​		实现`BeanDefinitionRegistryPostProcessor`的`postProcessBeanDefinitionRegistry`方法。在spring源码中`@Configuration`、`@Import`等配置类的注解就是通过这种方式实现的，具体实现方式可以参考spring源码

`org.springframework.context.annotation.ConfigurationClassPostProcessor`

```java
@Override
public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) {
    int registryId = System.identityHashCode(registry);
    if (this.registriesPostProcessed.contains(registryId)) {
        throw new IllegalStateException(
                "postProcessBeanDefinitionRegistry already called on this post-processor against " + registry);
    }
    if (this.factoriesPostProcessed.contains(registryId)) {
        throw new IllegalStateException(
                "postProcessBeanFactory already called on this post-processor against " + registry);
    }
    this.registriesPostProcessed.add(registryId);

    processConfigBeanDefinitions(registry);
}
```

​		另外一个可参考的样例是Mybatis，在Mybatis中`MapperScannerConfigurer`实现了`BeanDefinitionRegistryPostProcessor`的`postProcessBeanDefinitionRegistry`方法，在这个方法中注册bean的方式同1.3

`org.mybatis.spring.mapper.MapperScannerConfigurer`
```java
  @Override
  public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) {
    if (this.processPropertyPlaceHolders) {
      processPropertyPlaceHolders();
    }

    ClassPathMapperScanner scanner = new ClassPathMapperScanner(registry);
    scanner.setAddToConfig(this.addToConfig);
    scanner.setAnnotationClass(this.annotationClass);
    scanner.setMarkerInterface(this.markerInterface);
    scanner.setSqlSessionFactory(this.sqlSessionFactory);
    scanner.setSqlSessionTemplate(this.sqlSessionTemplate);
    scanner.setSqlSessionFactoryBeanName(this.sqlSessionFactoryBeanName);
    scanner.setSqlSessionTemplateBeanName(this.sqlSessionTemplateBeanName);
    scanner.setResourceLoader(this.applicationContext);
    scanner.setBeanNameGenerator(this.nameGenerator);
    scanner.registerFilters();
    scanner.scan(StringUtils.tokenizeToStringArray(this.basePackage, ConfigurableApplicationContext.CONFIG_LOCATION_DELIMITERS));
}
```

