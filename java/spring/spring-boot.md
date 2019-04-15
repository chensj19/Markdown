# spring-boot 配置特殊处理记录

## 1、**spring-boot-configuration-processor的作用**

spring默认使用yml中的配置，但有时候要用传统的xml或properties配置，就需要使用spring-boot-configuration-processor了

```xml
<dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-configuration-processor</artifactId>
     <optional>true</optional>
</dependency>
```

再在你的配置类开头加上@PropertySource("classpath:your.properties")，其余用法与加载yml的配置一样

## 2、**Swagger与Spring boot集成**

导入jar包
```xml
<!--添加Swagger2依赖-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
```

配置
```java
@Configuration
@EnableSwagger2
public class Swagger2 {

    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.winning.mbk"))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("模板知识库 RESTful APIs")
                .description("模板知识库后台api接口文档")
                .version("1.0")
                .build();
    }
}
```
拦截器
```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    /**
     * 配置静态资源资源映射
     *
     * @param registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
       //CSS JS 等静态资源
       registry.addResourceHandler("/**").addResourceLocations("classpath:/static/");
        registry.addResourceHandler("/assets/**").addResourceLocations("classpath:/static/assets/");
        registry.addResourceHandler("/resources/**").addResourceLocations("classpath:/static/resources/");
        registry.addResourceHandler(fileUploadProperteis.getStaticAccessPath()).addResourceLocations("file:" + fileUploadProperteis.getUploadFolder() + "/");
        //swagger 资源
        registry.addResourceHandler("swagger-ui.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }

    /**
     * 增加字符串到java.util.Date数据转换
     */
    @PostConstruct
    public void initEditableValidation(){
        ConfigurableWebBindingInitializer initializer = (ConfigurableWebBindingInitializer) handlerAdapter.getWebBindingInitializer();
        if (initializer.getConversionService() != null){
            GenericConversionService genericConversionService = (GenericConversionService) initializer.getConversionService();
            genericConversionService.addConverter(new StringToDateConverter());
        }
    }

```

## 3、时间问题

前台传参数到后台存在一个时间问题，前台为字符串，而后台为Date或者其他类型，因此需要做一个转换，将字符串转换为Date

```java
package com.winning.mbk.base.convert;

import com.winning.mbk.base.utils.StringUtil;
import org.springframework.core.convert.converter.Converter;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author chensj
 * @title 前台String转java.util.Date
 * @email chensj@winning.com.cn
 * @package com.winning.mbk.base.convert
 * @date: 2018-11-12 13:16
 */
public class StringToDateConverter implements Converter<String, Date> {
    private static final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
    private static final String SHORT_DATE_FORMAT = "yyyy-MM-dd";
    private static final String DATE_FORMAT_2 = "yyyy/MM/dd HH:mm:ss";
    private static final String SHORT_DATE_FORMAT_2 = "yyyy/MM/dd";

    private static final String SPLIT_FLAG_1 = "-";
    private static final String SPLIT_FLAG_2 = ":";
    private static final String SPLIT_FLAG_3 = "/";
    private static final String SPLIT_FLAG_4 = ":";
    @Override
    public Date convert(String source) {
        if(StringUtil.isEmptyOrNull(source)){
            return  null;
        }
        source = source.trim();
        try {
            SimpleDateFormat formatter;
            if (source.contains(SPLIT_FLAG_1)) {
                if (source.contains(SPLIT_FLAG_2)) {
                    formatter = new SimpleDateFormat(DATE_FORMAT);
                } else {
                    formatter = new SimpleDateFormat(SHORT_DATE_FORMAT);
                }
                Date dtDate = formatter.parse(source);
                return dtDate;
            } else if (source.contains(SPLIT_FLAG_3)) {
                if (source.contains(SPLIT_FLAG_4)) {
                    formatter = new SimpleDateFormat(DATE_FORMAT_2);
                } else {
                    formatter = new SimpleDateFormat(SHORT_DATE_FORMAT_2);
                }
                Date dtDate = formatter.parse(source);
                return dtDate;
            }
        } catch (Exception e) {
            throw new RuntimeException(String.format("parser %s to Date fail", source));
        }

        throw new RuntimeException(String.format("parser %s to Date fail", source));

    }
}

```

注册拦截器

```java
 	/**
     * 增加字符串到java.util.Date数据转换
     */
    @PostConstruct
    public void initEditableValidation(){
        ConfigurableWebBindingInitializer initializer = (ConfigurableWebBindingInitializer) handlerAdapter.getWebBindingInitializer();
        if (initializer.getConversionService() != null){
            GenericConversionService genericConversionService = (GenericConversionService) initializer.getConversionService();
            genericConversionService.addConverter(new StringToDateConverter());
        }
    }
```

![spring boot 启动流程图](<http://upload-images.jianshu.io/upload_images/6912735-51aa162747fcdc3d.png?imageMogr2/auto-orient/strip>)