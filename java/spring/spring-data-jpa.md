# JPA

## JPA 注解

### @Entity

```sql
被Entity标注的实体类将会被JPA管理控制，在程序运行时，JPA会识别并映射到指定的数据库表
唯一参数name:指定实体类名称，默认为当前实体类的非限定名称。
若给了name属性值即@Entity(name="XXX")，则jpa在仓储层(数据层)进行自定义查询时，所查的表名应是XXX。
如：select s from XXX s
```

### @Table

```java
当你想生成的数据库表名与实体类名称不同时，使用 @Table(name="数据库表名"),与@Entity标注并列使用，置于实体
类声明语句之前
@Entity
@Table(name="t_student")
public class student{
  ...
}
```


@Table中的参数(不常用)

* catalog: 用于设置表所映射到的数据库的目录
* schema: 用于设置表所映射到的数据库的模式
* uniqueConstraints: 设置约束条件

### @Id

```java
@Id 用于实体类的一个属性或者属性对应的getter方法的标注，被标注的的属性将映射为数据库主键
```

### @GeneratedValue

```java
与@Id一同使用，用于标注主键的生成策略，通过 strategy 属性指定。默认是JPA自动选择合适的策略
在 javax.persistence.GenerationType 中定义了以下几种可供选择的策略：

- IDENTITY：采用数据库ID自增长的方式产生主键，Oracle 不支持这种方式。
- AUTO： JPA 自动选择合适的策略，是默认选项。
- SEQUENCE：通过序列产生主键，通过@SequenceGenerator标注指定序列名，MySQL 不支持这种方式。
- TABLE：通过表产生主键，框架借由表模拟序列产生主键，使用该策略更易于做数据库移植。
```

### @Basic

```
@Basic表示一个简单的属性到数据库表的字段的映射,对于没有任何标注的 getXxxx() 方法,默认即为@Basic(fetch=FetechType.EAGER)
@Basic参数：
  1. fetch 表示该属性的加载读取策略
    1.1 EAGER 主动抓取 （默认为EAGER）
    1.2 LAZY 延迟加载,只有用到该属性时才会去加载
  2. optional (默认为 true)
    表示该属性是否允许为null
```

### @Column

```
通常置于实体的属性声明之前，可与 @Id 标注一起使用
@Column参数：

  1. name: 指定映射到数据库中的字段名
  2. unique: 是否唯一，默认为false
  3. nullable: 是否允许为null，默认为true
  5. insertable: 是否允许插入，默认为true
  6. updatetable: 是否允许更新，默认为true
  7. columnDefinition: 指定该属性映射到数据库中的实际类型，通常是自动判断。
```
### @Transient

```
JPA会忽略该属性，不会映射到数据库中，即程序运行后数据库中将不会有该字段
```

### @Temporal

```
Java中没有定义 Date 类型的精度，而数据库中，表示时间类型的数据有 DATE,TIME,TIMESTAMP三种精度
  - @Temporal(TemporalType.DATE) 表示映射到数据库中的时间类型为 DATE，只有日期
  - @Temporal(TemporalType.TIME) 表示映射到数据库中的时间类型为 TIME，只有时间
  - @Temporal(TemporalType.TIMESTAMP) 表示映射到数据库中的时间类型为 TIMESTAMP,日期和时间都有
```

### @Embedded 和 @Embeddable

```
用于一个实体类要在多个不同的实体类中进行使用，而本身又不需要独立生成一个数据库表
```
网上有一份比较详细说明，可参考[链接](http://blog.csdn.net/lmy86263/article/details/52108130)

### @JoinColumn

```
定义表关联的外键字段名
常用参数有：
  1. name: 指定映射到数据库中的外键的字段名
  2. unique: 是否唯一，默认为false
  3. nullable: 是否允许为null，默认为true
  4. insertable: 是否允许插入，默认为true
  5. updatetable: 是否允许更新，默认为true
  6. columnDefinition: 指定该属性映射到数据库中的实际类型，通常是自动判断。
```

### @OneToOne

```java
参数：

targetEntity： 指定关联实体类型，默认为被注解的属性或方法所属的类
cascade： 级联操作策略
CascadeType.ALL 级联所有操作
CascadeType.PERSIST 级联新增
CascadeType.MERGE 级联归并更新
CascadeType.REMOVE 级联删除
CascadeType.REFRESH 级联刷新
CascadeType.DETACH 级联分离
fetch： fetch 表示该属性的加载读取策略 (默认值为 EAGER)
EAGER 主动抓取
LAZY 延迟加载,只有用到该属性时才会去加载
optional： 默认为true，关联字段是否为空
如果为false，则常与@JoinColumn一起使用
mappedBy： 指定关联关系，该参数只用于关联关系被拥有方
只用于双向关联@OneToOne,@OneToMany,@ManyToMany。而@ManyToOne中没有
@OneToOne(mappedBy = “xxx”)
表示xxx所对应的类为关系被拥有方，而关联的另一方为关系拥有方
关系拥有方：对应拥有外键的数据库表
关系被拥有方：对应主键被子表引用为外键的数据库表
orphanRemoval:默认值为false
判断是否自动删除与关系拥有方不存在联系的关系被拥有方(关系被拥有方的一个主键在关系拥有方中未被引用，
当jpa执行更新操作时，是否删除数据库中此主键所对应的一条记录，若为true则删除)
//单向 一对一
@Entity  
public class Emp{//员工
  @Id
  @GeneratedValue
  privte Integer eId;

  @Column(length = 40)
  private String empName;

  @OneToOne(cascade = CascadeType.ALL)
  private Identity identity;
  //get,set方法省略
}

@Entity
public class Identity{//身份证
  //...
}

//双向 一对一
@Entity  
public class Emp{
  @Id
  @GeneratedValue
  privte Integer eId;

  @Column(length = 40)
  private String empName;

  @OneToOne(cascade = CascadeType.ALL)
  private Identity identity;
  //get,set方法省略
}

@Entity
public class Identity{
  @Id
  @GeneratedValue
  privte Integer iId;

  @OneToOne(cascade = CascadeType.ALL, mappedBy = "identity")
  private Emp emp;
  //...
}
```
以上例子，双向一对一，Emp 为关系拥有方，Identity 为关系被拥有方。
执行spring-data-jpa新增操作时，如果通过Identity的数据访问层进行新增操作(IdentityRepository.save())
，Emp表和Identity表都有数据，但是不会设置这两条数据的关系，Emp表中的外键为null。
反之，以关系拥有方Emp的数据访问层进行新增操作(EmpRepository.save()),Emp表和Identity表都有数据，并且
设置了两条数据的关系，即Emp表中的外键也得到正确新增

### @ManyToOne、@OneToMany

多对一(也可叫一对多，只是前后表颠倒一下而已)，只有双向多对一时才用得到`@OneToMany`。多对一中多的一方必定是对应数据库中拥有外键的表，即是关系拥有方，`@ManyToOne`只用在多对一中代表多的一类中，因为`mappedBy`只用于关系被拥有方，所以`@ManyToOne`参数中不包含`mappedBy`。

`@ManyToOne`参数:

* targetEntity： 指定关联实体类型，默认为被注解的属性或方法所属的类

* cascade： 级联操作策略

  * CascadeType.ALL 级联所有操作

  * CascadeType.PERSIST 级联新增

  * CascadeType.MERGE 级联归并更新

  * CascadeType.REMOVE 级联删除

  * CascadeType.REFRESH 级联刷新

  * CascadeType.DETACH 级联分离
  
* fetch： fetch 表示该属性的加载读取策略(@ManyToOne 的默认值是 EAGER，@OneToMany 的默认值是 LAZY)
    * EAGER 主动抓取
    * LAZY 延迟加载,只有用到该属性时才会去加载
    
* optional： 默认为true，关联字段是否为空
         如果为false，则常与@JoinColumn一起使用

`@OneToMany`参数除上述以外还有：

* `mappedBy`: 指定关联关系，该参数只用于关联关系被拥有方
  只用于双向关联`@OneToOne`,`@OneToMany`,`@ManyToMany`。而`@ManyToOne`中没有
  `@OneToMany(mappedBy = “xxx”)`
  表示xxx所对应的类为关系被拥有方，而关联的另一方为关系拥有方
  * 关系拥有方：对应拥有外键的数据库表
  * 关系被拥有方：对应主键被子表引用为外键的数据库表
* `orphanRemoval`:默认值为false
  判断是否自动删除与关系拥有方不存在联系的关系被拥有方(关系被拥有方的一个主键在关系拥有方中未被引用，
  当jpa执行更新操作时，是否删除数据库中此主键所对应的一条记录，若为true则删除)
```java
//单向 多对一
@Entity
public class Emp{
  @Id
  @GeneratedValue
  privte Integer eId;

  @Column(length = 40)
  private String empName;

  @ManyToOne(cascade = CascadeType.ALL)
  private Dept dept;
  //...
}

@Entity
public class Dept{
  @Id
  @GeneratedValue
  privte Integer dId;

  @Column(length = 40)
  private String deptName;
  //...
}
```

```java
//双向 多对一
@Entity
public class Emp{
  @Id
  @GeneratedValue
  privte Integer eId;

  @Column(length = 40)
  private String empName;

  @ManyToOne(cascade = CascadeType.ALL)
  private Emp emp;
  //...
}

@Entity
public class Dept{
  @Id
  @GeneratedValue
  privte Integer dId;

  @Column(length = 40)
  private String deptName;

  @OneToMany(cascade = CascadeType.ALL, mappedBy = "emp")
  private List<Emp> emps;
  //...
}
```
> 无论双向关联还是单向关联，数据库中均会在Emp表中自动生成一个外键（dept_d_id）

### @ManyToMany

* targetEntity： 指定关联实体类型，默认为被注解的属性或方法所属的类
* cascade： 级联操作策略
  * CascadeType.ALL 级联所有操作
  * CascadeType.PERSIST 级联新增
  * CascadeType.MERGE 级联归并更新
  * CascadeType.REMOVE 级联删除
  * CascadeType.REFRESH 级联刷新
  * CascadeType.DETACH 级联分离
* fetch： fetch 表示该属性的加载读取策略 (默认值为 LAZY)
    * EAGER 主动抓取
    * LAZY 延迟加载,只有用到该属性时才会去加载
* mappedBy: 指定关联关系，该参数只用于关联关系被拥有方
        只用于双向关联`@OneToOne`,`@OneToMany`,`@ManyToMany`。而`@ManyToOne`中没有。
        @ManyToMany(mappedBy = “xxx”)
        表示xxx所对应的类为关系被拥有方，而关联的另一方为关系拥有方：
    * 关系拥有方：对应拥有外键的数据库表
    * 关系被拥有方：对应主键被子表引用为外键的数据库表

```java
//单向 多对多
@Entity
public class Student{
    @ManyToMany(cascade = CascadeType.ALL)
    private List<Course> courses;
    //...
}

@Entity
public class Course{
  //...
}
//双向 多对多
@Entity
public class Student{
  @ManyToMany(cascade = CascadeType.ALL)
  private List<Course> courses;
  //...
}

@Entity
public class Course{
  @ManyToMany(cascade = CascadeType.ALL, mappedBy = "courses")
  private List<Student> students;
  //...
}
```

> 所有双向关联使用时需谨慎，查询时容易引起栈内存溢出，尽量使用单向关联

### @Enumerated

当实体类中有枚举类型的属性时，默认情况下自动生成的数据库表中对应的字段类型是枚举的索引值，是数字类型的，若希望数据库中存储的是枚举对应的String类型，在属性上加入`@Enumerated(EnumType.STRING)`注解即可。

```java
@Enumerated(EnumType.STRING)
@Column(nullable = true)

private RoleEnum role;
```


## Spring Data Jpa 

​	Spring Data是一个用于简化数据库访问，并支持云服务的开源框架，其主要目标是使得对数据的访问变得方便快捷。Spring Data包含多个子项目，spring-data-jpa就是其子项目之一。

 	 JPA（Java Persistence API）是一种Java持久化解决方案，负责把数据保存到数据库，实际上它就是一种标准、规范，而不是具体的实现。JPA属于重量级的，因为它需要运行在JAVA EE容器中，而Spring Data JPA提供了轻量级的实现，在任何servlet容器中都可以运行。

​      Spring Data JPA相对于JAVA EE中的JPA，配置更简单，以轻量级的方式实现了部分在 EJB 容器环境下才具有的功能，将 EntityManager 的创建与销毁、事务管理等代码抽取出来，并由其统一管理，并且极大的简化了数据库访问层的代码。

### 重要的类或接口

#### `Repository`

```java
public interface Repository<T, ID> {
}
```

`Repository`是一个空接口，或者说一个**标记接口**(没有包含方法声明的接口)

如果接口继承这个接口的话，这个接口就会被Spring IOC 容器管理

或者可以使用`@RepositoryDefinition()` 指定`domainClass`与`idClass`也可以实现

```java
@RepositoryDefinition(domainClass=User.class,idClass=Integer.class)
```

#### `CrudRepository`

```java
public interface CrudRepository<T, ID> extends Repository<T, ID> {
    // 保存
    <S extends T> S save(S var1);
	// 批量保存
    <S extends T> Iterable<S> saveAll(Iterable<S> var1);
	// 根据ID找到一个对象
    Optional<T> findById(ID var1);
    // 根据ID判断兑现是否存在
    boolean existsById(ID var1);
	// 找到全部
    Iterable<T> findAll();
	// 根据ID的集合找到全部
    Iterable<T> findAllById(Iterable<ID> var1);
	// 统计全部
    long count();
    // 根据ID删除
    void deleteById(ID var1);
    // 根据对象删除
    void delete(T var1);
    // 根据对象List删除
    void deleteAll(Iterable<? extends T> var1);
	// 全部删除
    void deleteAll();
}
```

完成CRUD功能

#### `PagingAndSortingRepository`

```java
public interface PagingAndSortingRepository<T, ID> extends CrudRepository<T, ID> {
    // 排序
    Iterable<T> findAll(Sort var1);
    // 分页
    Page<T> findAll(Pageable var1);
}
```

继承与`CrudRepository`，实现分页与排序操作

#### `JpaRepository`

```java
public interface JpaRepository<T, ID> extends PagingAndSortingRepository<T, ID>, QueryByExampleExecutor<T> {
    // 全部
    List<T> findAll();
    // 排序后全部
    List<T> findAll(Sort var1);
    // 使用ID List 获取符合要求的全部
    List<T> findAllById(Iterable<ID> var1);
	// 批量保存
    <S extends T> List<S> saveAll(Iterable<S> var1);
    // flush到数据库
    void flush();
	// 保存并刷新
    <S extends T> S saveAndFlush(S var1);
	// 按照对象List批量删除
    void deleteInBatch(Iterable<T> var1);
	// 全部删除
    void deleteAllInBatch();
	// 获取一个
    T getOne(ID var1);

    <S extends T> List<S> findAll(Example<S> var1);

    <S extends T> List<S> findAll(Example<S> var1, Sort var2);
}
```

继承`PagingAndSortingRepository`，实现分页与排序操作

### 查询方法名称定义规则与复杂查询命名

所有支持的关键词：

![](https://img-blog.csdn.net/20180309101755260?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcXFfMzI5NTMwNzk=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

![](https://img-blog.csdn.net/20180309101805277?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvcXFfMzI5NTMwNzk=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

```java
public interface EmployeeRepository extends JpaRepository<Employee,Integer> {
    /**
     * 查询名称开始为{@code name}，并且年龄小于{@code age}
     * @param name
     * @param age
     * @return
     * select   from Employee where name like 'name%' and age < age
     */
    List<Employee> findAllByNameStartingWithAndAgeLessThanOrderByAgeDesc(String name,int age);

    /**
     * {@code names} 名称在这个里面 或者age在一个{@code age1}与{@code age2}范围里面
     * @param names
     * @param age1
     * @param age2
     * @return
     * select   from Employee where name in (names) or age between age1 and age2
     */
    List<Employee> findAllByNameInOrAgeBetweenOrderByAgeDesc(List<String> names,int age1,int age2);
}
```



这种方法存在如下问题

* 方法名称比较长
* 复杂查询无法实现

使用`@Query`来定义SQL解决

### `@Query`使用

* 在Repository中方法上面使用，不需要遵循查询方法命名规则
* 只需要将`@Query`定义在Repository中即可
* 命名参数和索引参数均可以使用
* 支持本地查询

```java
 /**
     * 占位符使用
     * @param name
     * @param age
     * @return
     */
    @Query("select t2 from Employee t2 where t2.name = ?1 and t2.age = ?2")
    public Employee queryByParams1(String name,int age);
    /**
     * 占位符使用
     * @param name 参数中包含%, 开始就在后面加，结尾就在前面加，全局匹配就是两边都加
     * @param age
     * @return
     */
    @Query("select t2 from Employee t2 where t2.name like ?1 and t2.age > ?2")
    public List<Employee> queryByParams2(String name,int age);

    /**
     * 命名参数使用 必须使用@Param()指定参数
     * @param name 参数中包含%, 开始就在后面加，结尾就在前面加，全局匹配就是两边都加
     * @param age
     * @return
     */
    @Query("select t2 from Employee t2 where t2.name like :name and t2.age > :age")
    public List<Employee> queryByParams3(@Param("name") String name, @Param("age") int age);
```



### 更新与删除

* `@Modifying`注解使用
* `@Modifying`与`@Query`结合使用完成更新操作
* `@Transactional`使用

```java
 /**
     * 更新操作
     * @param id
     * @param age
     */
    @Modifying
    @Query("update Employee o set o.age = :age where o.id = :id")
    public void update(@Param("id") Integer id,@Param("age") Integer age);
```

`service` 事务放在此处

```java
 @Transactional
 @Override
 public void update(Integer id, Integer age) {
 employeeRepository.update(id,age);
 }
```



事务在Spring Data Jpa 中使用：

* 事务一般定义在`service`层
* `@Modifying`,`@Query`,` @Transactional`三个注解的结合使用

### `JpaSpecificationExecutor`接口使用

* 该接口封装了`JPA Criteria`查询条件

#### `JPA Criteria`

​		Criteria 查询是以元模型的概念为基础的，元模型是为具体持久化单元的受管实体定义的，这些实体可以是实体类，嵌入类或者映射的父类。

​		CriteriaQuery接口：代表一个specific的顶层查询对象，它包含着查询的各个部分，比如：select 、from、where、group by、order by等注意：CriteriaQuery对象只对实体类型或嵌入式类型的Criteria查询起作用

​		Root接口：代表Criteria查询的根对象，Criteria查询的查询根定义了实体类型，能为将来导航获得想要的结果，它与SQL查询中的FROM子句类似

​    1：Root实例是类型化的，且定义了查询的FROM子句中能够出现的类型。

​    2：查询根实例能通过传入一个实体类型给 AbstractQuery.from方法获得。

​    3：Criteria查询，可以有多个查询根。

​    4：AbstractQuery是CriteriaQuery 接口的父类，它提供得到查询根的方法。CriteriaBuilder接口：用来构建CritiaQuery的构建器对象Predicate：一个简单或复杂的谓词类型，其实就相当于条件或者是条件组合

##### **JPA元模型**

> 在JPA中,标准查询是以元模型的概念为基础的.元模型是为具体持久化单元的受管实体定义的.这些实体可以是实体类,嵌入类或者映射的父类.提供受管实体元信息的类就是元模型类.
>
> 使用元模型类最大的优势是凭借其实例化可以在编译时访问实体的持久属性.该特性使得criteria 查询更加类型安全.

```java
  public void testPageBySpecification() {
        Sort sort = new Sort(
                Sort.Direction.DESC, "id"
        );
        Pageable pageable = PageRequest.of(0, 10, sort);

        /*
         * root 就是我们要查询的类型(Employee)
         * query 添加查询条件
         * CriteriaBuilder 构建Predicate
         */
        Specification<Employee> specification = new Specification<Employee>() {

            @Override
            public Predicate toPredicate(Root<Employee> root,
                                         CriteriaQuery<?> query,
                                         CriteriaBuilder cb) {
                // root -> Employee -> age
                Path<Integer> path = root.get("age");
                // age > 50
                return cb.gt(path,50);
            }
        };
        Page<Employee> employees = employeeRepository.findAll(specification,pageable);
        System.out.println("查询的总页数：" + employees.getTotalPages());
        System.out.println("查询的总记录数：" + employees.getTotalElements());
        System.out.println("查询的当前页：" + (employees.getNumber() + 1));
        System.out.println("查询的当前页元素：" + employees.getContent());
        System.out.println("查询的当前页元素总数：" + employees.getNumberOfElements());
    }
```

