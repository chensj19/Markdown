# spring boot jpa

## EntityManagerFactory 初始化

### 一、HibernateJpaConfiguration注入

> 在环境中存在DataSource的情况下，会触发HibernateJpaConfiguration的自动注入

#### 1.1 JpaVendorAdapter注入

   > 这个类的注入将会处理二个问题
   >      1.1 persistenceProvider 后续用来做EntityManagerFactory创建
   >      1.2 entityManagerFactoryInterface和entityManagerInterface，指定entityManager对应类和工厂类的接口

   ```java
   public HibernateJpaVendorAdapter() {
   		this.persistenceProvider = new SpringHibernateJpaPersistenceProvider();
   		this.entityManagerFactoryInterface = org.hibernate.jpa.HibernateEntityManagerFactory.class;
   		this.entityManagerInterface = org.hibernate.jpa.HibernateEntityManager.class;
   	}
   ```

#### 1.2 entityManagerFactoryBuilder注入

> 这个类在这个阶段只是做了一个初始化，并将设置的jpaProperties输入解析，并没有什么其他用处，
>
> 类中影响最大是persistenceUnitManager目前还是null

### 二、EntityManagerFactory创建

> 触发来源于PrimaryJpaAutoConfig的hisEntityManagerFactory

#### 2.1 EntityManagerFactoryBuilder#builder

> 完成LocalContainerEntityManagerFactoryBean的初始化和参数的配置
>
> 最重要的方法是在其初始化完成后注入bean后，会调用afterPropertiesSet方法

#### 2.2 LocalContainerEntityManagerFactoryBean#afterPropertiesSet

> 先判断来源于entityManagerFactoryBuilder的persistenceUnitManager是否为空
>
> 为空，则会使用其内部的this.internalPersistenceUnitManager.afterPropertiesSet()

```java
public void afterPropertiesSet() throws PersistenceException {
   // 获取内部PersistenceUnitManager，默认为null
		PersistenceUnitManager managerToUse = this.persistenceUnitManager;
		if (this.persistenceUnitManager == null) {
      // 调用内部方法预先初始化好的internalPersistenceUnitManager
      // DefaultPersistenceUnitManager.afterPropertiesSet()
      // 在这个方法中会做scanPackage，读取符合要求的Entity
			this.internalPersistenceUnitManager.afterPropertiesSet();
			managerToUse = this.internalPersistenceUnitManager;
		}
		// 确定当前LocalContainerEntityManagerFactoryBean适用的PersistenceUnitInfo
		this.persistenceUnitInfo = determinePersistenceUnitInfo(managerToUse);
    // 获取适配器，这里会提供EntityManager的提供者
		JpaVendorAdapter jpaVendorAdapter = getJpaVendorAdapter();
		if (jpaVendorAdapter != null && this.persistenceUnitInfo instanceof SmartPersistenceUnitInfo) {
			String rootPackage = jpaVendorAdapter.getPersistenceProviderRootPackage();
			if (rootPackage != null) {
				((SmartPersistenceUnitInfo) this.persistenceUnitInfo).setPersistenceProviderPackageName(rootPackage);
			}
		}
		// AbstractEntityManagerFactoryBean#afterPropertiesSet
		super.afterPropertiesSet();
	}
```

#### 2.3 AbstractEntityManagerFactoryBean#afterPropertiesSet

```java
public void afterPropertiesSet() throws PersistenceException {
    // 获取适配器 或者是桥梁 
		JpaVendorAdapter jpaVendorAdapter = getJpaVendorAdapter();
		if (jpaVendorAdapter != null) {
			 .....

		AsyncTaskExecutor bootstrapExecutor = getBootstrapExecutor();
		if (bootstrapExecutor != null) {
			this.nativeEntityManagerFactoryFuture = bootstrapExecutor.submit(this::buildNativeEntityManagerFactory);
		}
		else {
      // 调用抽象方法
			this.nativeEntityManagerFactory = buildNativeEntityManagerFactory();
		}

		// Wrap the EntityManagerFactory in a factory implementing all its interfaces.
		// This allows interception of createEntityManager methods to return an
		// application-managed EntityManager proxy that automatically joins
		// existing transactions.
		this.entityManagerFactory = createEntityManagerFactoryProxy(this.nativeEntityManagerFactory);
	}
```

buildNativeEntityManagerFactory

```java
private EntityManagerFactory buildNativeEntityManagerFactory() {
		EntityManagerFactory emf;
		try {
      // 调用子类实现
			emf = createNativeEntityManagerFactory();
		}
		catch (PersistenceException ex) {
			if (ex.getClass() == PersistenceException.class) {
				Throwable cause = ex.getCause();
				if (cause != null) {
					String message = ex.getMessage();
					String causeString = cause.toString();
					if (!message.endsWith(causeString)) {
						throw new PersistenceException(message + "; nested exception is " + causeString, cause);
					}
				}
			}
			throw ex;
		}
	}

```

#### 2.4 LocalContainerEntityManagerFactoryBean#afterPropertiesSet

```java
protected EntityManagerFactory createNativeEntityManagerFactory() throws PersistenceException {
		Assert.state(this.persistenceUnitInfo != null, "PersistenceUnitInfo not initialized");

		PersistenceProvider provider = getPersistenceProvider();
     ....
    // provider 创建   EntityManagerFactory
		EntityManagerFactory emf =
				provider.createContainerEntityManagerFactory(this.persistenceUnitInfo, getJpaPropertyMap());
		postProcessEntityManagerFactory(emf, this.persistenceUnitInfo);

		return emf;
	}
```

#### 2.5 SpringHibernateJpaPersistenceProvider

```java
public EntityManagerFactory createContainerEntityManagerFactory(PersistenceUnitInfo info, Map properties) {
		final List<String> mergedClassesAndPackages = new ArrayList<>(info.getManagedClassNames());
		if (info instanceof SmartPersistenceUnitInfo) {
			mergedClassesAndPackages.addAll(((SmartPersistenceUnitInfo) info).getManagedPackages());
		}
		return new EntityManagerFactoryBuilderImpl(
				new PersistenceUnitInfoDescriptor(info) {
					@Override
					public List<String> getManagedClassNames() {
						return mergedClassesAndPackages;
					}
				}, properties).build();
	}
```

2.6 