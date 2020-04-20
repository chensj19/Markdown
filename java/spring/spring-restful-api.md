# Spring Restfull API

## 一、使用Spring MVC开发RESTful API

### 1.1 什么是RESTful API VS API

 1. 用URL描述资源
 2. 使用HTTP方法描述行为。使用HTTP状态码来表示不同的结果


| 方法名称 | 方法URL                    | 方法类型 | RESTful方法URL | 方法类型 |
|-------|---------|-------------|----------------|--------------|
| 查询     | /user/query?name=tome      | GET      | /user?name=tom | GET      |
|详情| /user/getInfo?id=1         |GET|/user/1|GET|
|创建| /user/create?name=tome     |POST|/user|POST|
|修改| /user/update?id=1&name=tom |GET|/user/1|PUT|
|删除| /user/delete?id=1          |GET|/user/1|DELETE|

> 注意：使用HTTP方法描述行为，这个说明就是如下
>
> 使用 POST发送    增加用户请求
>
> 使用 PUT发送       修改用户请求
>
> 使用DELETE发送  删除用户请求
>
> 使用GET发送        查询用户请求

3. 数据交付使用json

4. RESTful是一种风格，并不是强制的标准

### 1.2 开发RESTful API

#### 1.2.1 常用注解

##### `@RestController`

表明此Controller提供RestAPI

##### `@RequestMapping`及其变体

映射http请求URL到java方法

##### `@RequestParam`

映射请求参数到Java方法的参数

属性说明：

* required:
       如果不是需要的，则可以设置required为false，默认为true
*  name/value:
       name与value的参数意义是一样的，用法一直
       传入参数，与书写参数名称不一致的时候使用
       当传入参数为nickname，而接口使用参数为username，那么就可以这样设置
       {@code @RequestParam(name="nickname")} 表示username获取的值是nickname提供的
* defaultValue：
        参数如果没有传入，用来指定默认值

##### `@PageableDefault`

指定分页参数默认值

属性有五个

* `value/size`   分页中每页的数量，默认值是10

* `page`  当前的页面，默认值是0

* `sort` String数组，表示当前按照哪些字段进行排序

* `direction`  排序，升序或者降序

##### `@PathVariable`

映射url片段到java方法的参数

```java
 @RequestMapping(value = "/user/{id}",method = RequestMethod.GET)
 public User info(@PathVariable Long id ){
     System.out.println(id);
     User user = new User();
     user.setId(id);
     return user;
 }
```

属性：

* `name`/`value` 用于指定参数名称，不指定则直接与方法参数名称
* `required` 是否必须 默认为true

##### `@JsonView`

控制JSON输出内容，比如用户密码的信息不展示

使用步骤：

1. 使用接口声明多个视图，每个视图对应展示的内容不一样

   ```
   /**
    * 信息展示简单视图
    */
   public interface UserSimpleView{};
   
   /**
    * 信息展示全量视图 继承于简单视图
    */
   public interface UserDetailView extends UserSimpleView{};
   ```

2. 在值对象的get方法上面指定视图

   ```java
   @JsonView(UserSimpleView.class)
   private Long id;
   @JsonView(UserSimpleView.class)
   private String name;
   @JsonView(UserDetailView.class)
   private String password;
   ```
   
3. 在Controller上面指定视图

   ```java
    @RequestMapping(value = "user",method = RequestMethod.GET)
    @JsonView(User.UserSimpleView.class)
        public List<User> user(QueryCondition condition, @PageableDefault() Pageable pageable){
        // 通过反射方法将对象打印出来
        logger.info("QueryCondition:{}", ReflectionToStringBuilder.toString(condition, ToStringStyle.MULTI_LINE_STYLE));
        logger.info("Pageable:{}", ReflectionToStringBuilder.toString(pageable, ToStringStyle.MULTI_LINE_STYLE));
        List<User> users = new ArrayList();
        users.add(new User(1L,"aa","123456"));
        users.add(new User(2L,"bb","123456"));
        users.add(new User(3L,"cc","123456"));
        return users;
    }
   
   /**
   *  :\\d+ 为正则表达式，限制当前的传入的ID只能是数字
   * @param id
   * @return
   */
   @RequestMapping(value = "/user/{id:\\d+}",method = RequestMethod.GET)
   @JsonView(User.UserDetailView.class)
   public User info(@PathVariable Long id ){
       System.out.println(id);
       User user = new User();
       user.setId(id);
       return user;
   }
   ```

   测试代码：

   ``` java
   /**
        * 测试使用@JsonView
        * 测试结果为不显示 password字段
        */
       @Test
       public void jsonViewForListTest() throws Exception {
           //
           String content = mockMvc.perform(
                   // 创建一个MockMVCRequest
                   // 发送get请求
                   get("/user/list")
                   // 指定访问的参数 用来测试@RequestParam中 required、name、defaultValue
                   .param("username", "demo")
                   .param("age", "20")
                   .param("ageTo", "40")
                   .param("xxx", "yyy")
                   // 分页参数
                   .param("size", "20")
                   .param("page", "0")
                   // 排序字段
                   .param("sort", "age,desc")
                   // contentType是 application/json;charset=utf-8
                   .contentType(MediaType.APPLICATION_JSON_UTF8))
                   // 判断返回的状态码是否符合要求
                   .andExpect(status().isOk())
                   // 返回的内容 是个list，长度是3
                   .andExpect(jsonPath("$.length()").value(3))
                   // 获取返回值
                   .andReturn()
                   // 获取Response
                   .getResponse()
                   // 将内容转换为string并获取
                   .getContentAsString();
           System.out.println(content);
       }
   
       /**
        * 测试@JsonView
        * 测试结果： password字段应该显示
        * @throws Exception
        */
       @Test
       public void jsonViewForUserTest() throws Exception {
           String content = mockMvc.perform(
                   get("/user/1")
                           .contentType(MediaType.APPLICATION_JSON_UTF8))
                   .andExpect(status().isOk())
                   .andExpect(jsonPath("$.id").value(1))
                   .andReturn()
                   .getResponse()
                   .getContentAsString();
           System.out.println(getClass().getName()+":"+content);
       }
   ```

   

##### `@RequestBody`

映射请求体到java方法的参数

这种传值就是处理contentType为application/json;charset=utf-8



##### `@Valid`

@Valid和BindingResult验证请求参数合法性并处理校验结果

使用方法如下：

1. 在实体类指定属性上面添加@NotXXX等注解
2. Controller上增加一个@Valid注解

```java
 @JsonView(UserDetailView.class)
 @NotBlank
 private String password;
 
 @PostMapping
 public User add(@Valid @RequestBody User user){
     System.out.println(ReflectionToStringBuilder.toString(user, ToStringStyle.MULTI_LINE_STYLE));
     user.setId(1L);
     return user;
 }
```

上面这种方法下，会在请求的时候直接校验参数并返回，并不会进入方法体，如果需要进行方法体，并定义一些返回信息的话，则需要使用BindResult这个类：

```java
// handler
 @PostMapping
    public User add(@Valid @RequestBody User user, BindingResult errors){

        if(errors.hasErrors()){
            // must not be blank
            errors.getAllErrors().stream().forEach(item -> System.out.println(item.getDefaultMessage()));
        }
        System.out.println(ReflectionToStringBuilder.toString(user, ToStringStyle.MULTI_LINE_STYLE));
        user.setId(1L);
        return user;
    }
//测试代码
/**
     * 数据校验
     * 使用hibernate validate和@Valid注解实现
     * 1、在不能为空的字段上面写上@NotBlank，然后在Controller上增加一个@Valid注解
     * 2、上面这种方法下，会在请求的时候直接校验参数并返回，并不会进入方法体，如果需要进入方法体，
     * 并定制一些返回信息的话，则需要使用BindResult这个类
     */
    @Test
    public void whenCreateUserForValidate() throws Exception {
        Date date = new Date();
        long currentTimestamp = date.getTime();
        // json 字符串 将password字段设置为空
        String content ="{\"name\":\"tom\",\"birthday\":\""+currentTimestamp+"\"}";
        mockMvc.perform(
                post("/user")
                        .contentType(MediaType.APPLICATION_JSON_UTF8)
                        .content(content)
        ).andExpect(status().isOk());
    }

```



### 1.3 常用处理

#### 1.3.1 在URL中使用正则表达式

正则表达式使用：

在接收参数的位置使用正则表达式，代码如下：

```java
// Controller
// :\\d+ 就是限制参数只能是数字
@RequestMapping(value = "/user/{id:\\d+}",method = RequestMethod.GET)
public User info(@PathVariable Long id ){
    System.out.println(id);
    User user = new User();
    user.setId(id);
    return user;
}
// 
//test
 @Test
public void whenGetInfoFail() throws Exception {
    mockMvc.perform(
        get("/user/a")
        .contentType(MediaType.APPLICATION_JSON_UTF8))
        .andExpect(status().is4xxClientError());
}
```

#### 1.3.2 日期参数处理

直接使用时间戳，后台只负责存储数据，展示信息全部交给前台

```java
@Test
    public void whenCreateUserForDate() throws Exception {
        Date date = new Date();
        long currentTimestamp = date.getTime();
        // json 字符串
        String content ="{\"name\":\"tom\",\"password\":\"123456\",\"birthday\":\""+currentTimestamp+"\"}";
        String content1 = mockMvc.perform(
                post("/user")
                        .contentType(MediaType.APPLICATION_JSON_UTF8)
                        .content(content)
        ).andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("1"))
                .andReturn().getResponse().getContentAsString();
        System.out.println(content1);
    }
```

### 1.4 数据校验

数据校验将会使用Hibernate validate这个jar包，用于校验传入参数是否符合要求，通常会与BindingResult一起使用，来定制一些信息返回

#### 1.4.1常用验证注解

| 注解                                         | 说明                                                         |
| -------------------------------------------- | ------------------------------------------------------------ |
| @Valid                                       | 被注释的元素是一个对象，需要检查此对象的所有字段值           |
| @NotNull                                     | 值不能为空                                                   |
| @Null                                        | 值必须为空                                                   |
| @Pattern(regex=)                             | 字符串必须匹配正则表达式                                     |
| @Size(min=,max=)                             | 集合元素必须在min和max之间                                   |
| @CreditCardNumber(ignoreNonDigitCharacters=) | 字符串必须是信用卡卡号(按照美国标准校验)                     |
| @Email                                       | 字符串必须是Email地址                                        |
| @Length(min=,max=)                           | 检查字符串长度                                               |
| @NotBlank                                    | 字符串必须有字符                                             |
| @NotEmpty                                    | 字符串不为null，集合有元素                                   |
| @Range(min=,max=)                            | 数字必须在min与max之间                                       |
| @SafeHtml                                    | 字符串是安全的html                                           |
| @URL                                         | 字符串是安全的URL                                            |
| @AssertTrue                                  | 被注释的元素必须为 true                                      |
| @AssertFalse                                 | 被注释的元素必须为 false                                     |
| @Max(value)                                  | 被注释的元素必须是一个`数字`，其值必须小于等于指定的最大值   |
| @Min(value)                                  | 被注释的元素必须是一个`数字`，其值必须大于等于指定的最小值   |
| @DecimalMax(value=,inclusive=)               | 值必须`小于等于`(`inclusive=true`))/值必须`小于`(`inclusive=false`) value属性指定的值。可以注解在字符串类型的属性上 |
| @DecimalMin(value=,inclusive=)               | 值必须`大于等于`(`inclusive=true`))/值必须`大于`(`inclusive=false`)  value属性指定的值。可以注解在字符串类型的属性上 |
| @Digits (integer, fraction)                  | 数字格式检查，integer指定整数部分的最大长度，fraction指定小数部分的最大长度 |
| @Past                                        | 值必须是过去的日期                                           |
| @Future                                      | 值必须是未来的日期                                           |

#### 1.4.2 自定义消息

1. 注解使用

   ```java
   //测试代码
   /**
        * 测试使用@Past和@NotBlank
        * 错误信息显示为：
        *  must not be blank   password 不能为null
        *  must be a past date birthday必须是一个过去的时间
        * @throws Exception
        */
   @Test
   public void whenUpdateUseHibernateValidateAnnotationForPast() throws Exception {
           // 将出生日期+1年
           Date date = new Date(LocalDateTime.now().plusYears(1L).atZone(ZoneId.systemDefault()).toInstant().toEpochMilli());
           long currentTimestamp = date.getTime();
           // json 字符串 将password字段设置为空
           String content ="{\"id\":1,\"name\":\"tom\",\"password\":null,\"birthday\":\""+currentTimestamp+"\"}";
           mockMvc.perform(
                   put("/user/1")
                           .contentType(MediaType.APPLICATION_JSON_UTF8)
                           .content(content)
           ).andExpect(status().isOk());
   }
   //handler
   @PutMapping("/{id}")
   public User update(@Valid @RequestBody User user, BindingResult errors){
       if(errors.hasErrors()){
           // must not be blank
           errors.getAllErrors().stream().forEach(error -> {
               FieldError fieldError = (FieldError) error;
               // 获取字段信息和错误信息
               // 目前显示的是@Past和@NotBlank的默认信息
               logger.info("Field:{},Error Message：{}",fieldError.getField(),fieldError.getDefaultMessage());
           });
       }
       System.out.println(ReflectionToStringBuilder.toString(user, ToStringStyle.MULTI_LINE_STYLE));
       return user;
   }
   
   // 结果
   2019-05-11 23:53:30.878  INFO 25100 --- [           main] c.w.d.demo.controller.UserController     : Field:password,Error Message：must not be blank
   2019-05-11 23:53:30.878  INFO 25100 --- [           main] c.w.d.demo.controller.UserController     : Field:birthday,Error Message：must be a past date
   ```

2. 自定义消息

   就是将上面显示的英文消息，设置为自定义的信息，在hibernate提供的annotation中，都有一个message的字段，这个字段就是用来指定自定义信息。

   ```java
   // entity
   public class User {
   
       @JsonView(UserSimpleView.class)
       private Long id;
       @JsonView(UserSimpleView.class)
       private String name;
       @JsonView(UserDetailView.class)
       @NotBlank(message = "密码不能为空")
       private String password;
       @JsonView(UserSimpleView.class)
       @Past(message = "出生日期必须是过去的日期")
       private Date birthday;
   
   }    
   
   // 结果
   2019-05-11 23:58:52.472  INFO 25771 --- [           main] c.w.d.demo.controller.UserController     : Field:password,Error Message：密码不能为空
   2019-05-11 23:58:52.472  INFO 25771 --- [           main] c.w.d.demo.controller.UserController     : Field:birthday,Error Message：出生日期必须是过去的日期
   ```

   上面这种数据校验只是针对于传入的参数进行校验，不满足在实际业务中使用。这个时候就需要使用自定义校验注解

#### 1.4.2 自定义校验注解

1. 创建注解

   ```java
   // @Target 指定该注解使用的地方
   @Target({ElementType.FIELD,ElementType.METHOD})
   // @Retention 指定注解使用的时候
   @Retention(RetentionPolicy.RUNTIME)
   // @Constraint 处理使用注解的逻辑类
   @Constraint(validatedBy = TestConstraintValidator.class)
   public @interface TestConstraint {
   //    下面这三个属性是必须使用的
       /**
        * 错误时候显示的信息
        * @return
        */
       String message() default "这是一个自定义校验注解";
   
       /**
        * hibernate 属性
        * @return
        */
       Class<?>[] groups() default { };
       /**
        * hibernate 属性
        * @return
        */
       Class<? extends Payload>[] payload() default { };
   
   }
   ```

2. 校验处理类

   ```java
   /**
    * @author chensj
    * @title 自定义校验逻辑所在的处理类
    * 1、在注解上面使用 @Constraint(validatedBy = TestConstraintValidator.class)指定的
    * 2、ConstraintValidator<A extends Annotation, T>
    *     第一个参数是指定使用的是那个注解
    *     第二个参数指定验证的数据类型，String、Long等,或者使用Object 通用
    *
    *     可以使用spring的注解注入参数,不用增加@Component等注解，spring自动将当前类注入
    * @project winning-spring-security
    * @package com.winning.devops.demo.annotation.vlidate
    * @date: 2019-05-12 上午12:06
    */
   public class TestConstraintValidator implements ConstraintValidator<TestConstraint,Object> {
       /**
        * 注入的bean
        */
       @Autowired
       private HelloService helloService;
       /**
        * 初始化
        * @param constraintAnnotation
        */
       @Override
       public void initialize(TestConstraint constraintAnnotation) {
           System.out.println(getClass()+"  init ");
       }
   
       /**
        * 书写校验逻辑
        * @param value 校验的值
        * @param context 上下文
        * @return true/false  true校验通过  false校验不通过
        */
       @Override
       public boolean isValid(Object value, ConstraintValidatorContext context) {
           System.out.println(value);
           helloService.hello(getClass().getName());
           return false;
       }
   }
   ```

3. 测试

   ```java
   //entity
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   public class User {
   
       @JsonView(UserSimpleView.class)
       private Long id;
       @JsonView(UserSimpleView.class)
       @TestConstraint
       private String name;
       @JsonView(UserDetailView.class)
       @NotBlank(message = "密码不能为空")
       private String password;
       @JsonView(UserSimpleView.class)
       @Past(message = "出生日期必须是过去的日期")
       private Date birthday;
   
       /**
        * 信息展示简单视图
        */
       public interface UserSimpleView{};
   
       /**
        * 信息展示全量视图 继承于简单视图
        */
       public interface UserDetailView extends UserSimpleView{};
   }
   
   //test
   @Test
   public void whenUpdateUseHibernateValidateAnnotationForPast() throws Exception {
       // 将出生日期+1年
       Date date = new Date(LocalDateTime.now().plusYears(1L).atZone(ZoneId.systemDefault()).toInstant().toEpochMilli());
       long currentTimestamp = date.getTime();
       // json 字符串 将password字段设置为空
       String content ="{\"id\":1,\"name\":\"tom\",\"password\":null,\"birthday\":\""+currentTimestamp+"\"}";
       mockMvc.perform(
           put("/user/1")
           .contentType(MediaType.APPLICATION_JSON_UTF8)
           .content(content)
       ).andExpect(status().isOk());
   }
   //result
   // 校验器初始化
   class com.winning.devops.demo.annotation.vlidate.TestConstraintValidator  init 
   // 校验器输出值
   tom
   // 校验器调用HelloService
   class com.winning.devops.demo.service.impl.HelloServiceImpl:hello,com.winning.devops.demo.annotation.vlidate.TestConstraintValidator
   2019-05-12 00:23:46.017  INFO 27832 --- [           main] c.w.d.demo.controller.UserController     : Field:birthday,Error Message：出生日期必须是过去的日期
   // 校验结果
   2019-05-12 00:23:46.019  INFO 27832 --- [           main] c.w.d.demo.controller.UserController     : Field:name,Error Message：这是一个自定义校验注解
   2019-05-12 00:23:46.019  INFO 27832 --- [           main] c.w.d.demo.controller.UserController     : Field:password,Error Message：密码不能为空
   ```

   这种方式可以减少在Controller中的代码，并且将同样的校验逻辑转移到同一块

   

### 1.5 RESTful API的总结

1. 使用不同的方法类型来区分不同的处理逻辑

   1. `get`方法处理 获取列表、获取当个实体
   2. `post`方法处理 新增请求
   3. `put`方法处理 修改请求
   4. `delete`方法处理 删除请求

   这种方式区分，可以方便针对于不同的请求方法来处理不同逻辑，方便方法的管理

2. 使用`@JsonView`管理查询的结果

   1. 定义显示使用的视图，控制各个字段的显示规则
   2. 在不同的方法(`Controller`)中使用不同的视图
   3. 可以避免敏感数据的泄露

3. 测试代码优先于业务代码

   1. 在书写` RESTful API`的时候，需要将测试优先于业务代码，优先测试，方便自己了解自己需要什么规则

4. 数据校验

   1. 使用Hibernate Validator来对传入数据进行验证，使用BindResult获取验证结果，方便调用接口方尽快知道为什么出问题
   2. 通过使用自定义的校验器，可以将公共的校验逻辑统一，减少重复代码出现

### 1.6 Restful API异常处理

#### 1.6.1 Spring Boot 异常处理

在Spring Boot中error处理的基础类是`BasicErrorController`，在这个类中包含有以下两个方法，分别对应处理app请求和浏览器请求

```java
// 返回HTML
@RequestMapping(produces = MediaType.TEXT_HTML_VALUE)
public ModelAndView errorHtml(HttpServletRequest request,
HttpServletResponse response) {
    HttpStatus status = getStatus(request);
    Map<String, Object> model = Collections.unmodifiableMap(getErrorAttributes(
    request, isIncludeStackTrace(request, MediaType.TEXT_HTML)));
    response.setStatus(status.value());
    ModelAndView modelAndView = resolveErrorView(request, response, status, model);
    return (modelAndView != null) ? modelAndView : new ModelAndView("error", model);
}

@RequestMapping
public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
    Map<String, Object> body = getErrorAttributes(request,
    isIncludeStackTrace(request, MediaType.ALL));
    HttpStatus status = getStatus(request);
    return new ResponseEntity<>(body, status);
}
```

上面这两个方法都是处理`/error`这个url对应的参数，唯一的区别就是请求头中是否包含`text/html`内容。

##### 1.6.1.2 Spring Boot XXX 状态码处理

###### 1.6.1.2.1  浏览器访问

例如：404

在`src/main/resources`下面建立文件夹`resources/error`，创建一个404的html页面，这个时候从浏览器访问，那么页面就会直接跳转到这个页面上：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404</title>
</head>
<body>
    您访问的页面不存在
</body>
</html>
```

#### 1.6.2 自定义处理

使用`@ControllerAdvice`定义一个handler 用于处理异常

```java
@ControllerAdvice
public class ControllerExceptionHandler {
/**
* 处理指定异常
* 返回500 状态码
* @return
*/
@ExceptionHandler(UserNotExistsException.class)
@ResponseBody
@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
public Map<String,Object> handlerUserNotException(UserNotExistsException ex){
    Map<String,Object> errorMap = new HashMap<>();
    errorMap.put("message",ex.getMessage());
    errorMap.put("id",ex.getId());
    errorMap.put("timestamp",new Date());
    return errorMap;
    }
}
```





























































## 三、问题集

### 3.1 与Spring Session、Redis集成的问题

```bash
The bean 'propertySourcesPlaceholderConfigurer', defined in class path resource [org/springframework/boot/autoconfigure/session/RedisSessionConfiguration$SpringBootRedisHttpSessionConfiguration.class], could not be registered. A bean with that name has already been defined in class path resource [org/springframework/boot/autoconfigure/context/PropertyPlaceholderAutoConfiguration.class] and overriding is disabled.

Action:

Consider renaming one of the beans or enabling overriding by setting spring.main.allow-bean-definition-overriding=true
```

配置后，仍然报错
```bash
***************************
APPLICATION FAILED TO START
***************************

Description:

An attempt was made to call a method that does not exist. The attempt was made from the following location:

    org.springframework.boot.autoconfigure.session.RedisSessionConfiguration$SpringBootRedisHttpSessionConfiguration.customize(RedisSessionConfiguration.java:64)

The following method did not exist:

    org.springframework.boot.autoconfigure.session.RedisSessionConfiguration$SpringBootRedisHttpSessionConfiguration.setCleanupCron(Ljava/lang/String;)V

The method's class, org.springframework.boot.autoconfigure.session.RedisSessionConfiguration$SpringBootRedisHttpSessionConfiguration, is available from the following locations:

    jar:file:/D:/DevTools/Repository/org/springframework/boot/spring-boot-autoconfigure/2.1.4.RELEASE/spring-boot-autoconfigure-2.1.4.RELEASE.jar!/org/springframework/boot/autoconfigure/session/RedisSessionConfiguration$SpringBootRedisHttpSessionConfiguration.class

It was loaded from the following location:

    file:/D:/DevTools/Repository/org/springframework/boot/spring-boot-autoconfigure/2.1.4.RELEASE/spring-boot-autoconfigure-2.1.4.RELEASE.jar


Action:

Correct the classpath of your application so that it contains a single, compatible version of org.springframework.boot.autoconfigure.session.RedisSessionConfiguration$SpringBootRedisHttpSessionConfiguration
```

通过查询发现是因为Redis与spring-session集成导致的，在application.yml中增加如下配置：
```yml
spring:
    session:
        store-type: none
```
即可解决上面的问题
