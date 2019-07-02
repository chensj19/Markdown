# Nacos 集成

## Nacos Spring 快速开始

本文主要面向 Spring 的使用者，通过两个示例来介绍如何使用 Nacos 来实现分布式环境下的配置管理和服务发现。

- 通过 Nacos server 和 Nacos Spring 配置管理模块，实现配置的动态变更；
- 通过 Nacos server 和 Nacos Spring 服务发现模块，实现服务的注册与发现。

### 前提条件

您需要先下载 Nacos 并启动 Nacos server。操作步骤参见 [Nacos 快速入门](https://nacos.io/zh-cn/docs/quick-start.html)。

### 启动配置管理

启动了 Nacos server 后，您就可以参考以下示例代码，为您的 Spring 应用启动 Nacos 配置管理服务了。完整示例代码请参考：[nacos-spring-config-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-example/nacos-spring-config-example)

1. 添加依赖。

```xml
<dependency>
    <groupId>com.alibaba.nacos</groupId>
    <artifactId>nacos-spring-context</artifactId>
    <version>${latest.version}</version>
</dependency>
```

最新版本可以在 maven 仓库，如 "[mvnrepository.com](https://mvnrepository.com/artifact/com.alibaba.nacos/nacos-spring-context)" 中获取。

1. 添加 `@EnableNacosConfig` 注解启用 Nacos Spring 的配置管理服务。以下示例中，我们使用 `@NacosPropertySource` 加载了 `dataId` 为 `example` 的配置源，并开启自动更新：

```java
@Configuration
@EnableNacosConfig(globalProperties = @NacosProperties(serverAddr = "127.0.0.1:8848"))
@NacosPropertySource(dataId = "example", autoRefreshed = true)
public class NacosConfiguration {

}
```

1. 通过 Nacos 的 `@NacosValue` 注解设置属性值。

```java
@Controller
@RequestMapping("config")
public class ConfigController {

    @NacosValue(value = "${useLocalCache:false}", autoRefreshed = true)
    private boolean useLocalCache;

    @RequestMapping(value = "/get", method = GET)
    @ResponseBody
    public boolean get() {
        return useLocalCache;
    }
}
```

1. 启动 Tomcat，调用 `curl http://localhost:8080/config/get`尝试获取配置信息。由于此时还未发布过配置，所以返回内容是 `false`。
2. 通过调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-API.html) 向 Nacos Server 发布配置：dataId 为`example`，内容为`useLocalCache=true`

```bash
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=example&group=DEFAULT_GROUP&content=useLocalCache=true"
```

1. 再次访问 `http://localhost:8080/config/get`，此时返回内容为`true`，说明程序中的`useLocalCache`值已经被动态更新了。

### 启动服务发现

本节演示如何在您的 Spring 项目中启动 Nacos 的服务发现功能。完整示例代码请参考：[nacos-spring-discovery-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-example/nacos-spring-discovery-example)

1. 添加依赖。

```xml
<dependency>
    <groupId>com.alibaba.nacos</groupId>
    <artifactId>nacos-spring-context</artifactId>
    <version>${latest.version}</version>
</dependency>
```

最新版本可以在 maven 仓库，如 "[mvnrepository.com](https://mvnrepository.com/artifact/com.alibaba.nacos/nacos-spring-context)" 中获取。

1. 通过添加 `@EnableNacosDiscovery` 注解开启 Nacos Spring 的服务发现功能：

```java
@Configuration
@EnableNacosDiscovery(globalProperties = @NacosProperties(serverAddr = "127.0.0.1:8848"))
public class NacosConfiguration {

}
```

1. 使用 `@NacosInjected` 注入 Nacos 的 `NamingService` 实例：

```java
@Controller
@RequestMapping("discovery")
public class DiscoveryController {

    @NacosInjected
    private NamingService namingService;

    @RequestMapping(value = "/get", method = GET)
    @ResponseBody
    public List<Instance> get(@RequestParam String serviceName) throws NacosException {
        return namingService.getAllInstances(serviceName);
    }
}
```

1. 启动 Tomcat，调用 `curl http://localhost:8080/discovery/get?serviceName=example`，此时返回为空 JSON 数组`[]`。
2. 通过调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-API.html) 向 Nacos server 注册一个名称为 `example` 服务。

```bash
curl -X PUT 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=example&ip=127.0.0.1&port=8080'
```

1. 再次访问 `curl http://localhost:8080/discovery/get?serviceName=example`，此时返回内容为：

```json
[
  {
    "instanceId": "127.0.0.1#8080#DEFAULT#example",
    "ip": "127.0.0.1",
    "port": 8080,
    "weight": 1.0,
    "healthy": true,
    "cluster": {
      "serviceName": null,
      "name": "",
      "healthChecker": {
        "type": "TCP"
      },
      "defaultPort": 80,
      "defaultCheckPort": 80,
      "useIPPort4Check": true,
      "metadata": {}
    },
    "service": null,
    "metadata": {}
  }
]
```



## Nacos Spring Boot 快速开始

本文主要面向 Spring Boot 的使用者，通过两个示例来介绍如何使用 Nacos 来实现分布式环境下的配置管理和服务发现。

关于 Nacos Spring Boot 的详细文档请参看：[nacos-spring-boot-project](https://github.com/nacos-group/nacos-spring-boot-project)。

- 通过 Nacos Server 和 nacos-config-spring-boot-starter 实现配置的动态变更；
- 通过 Nacos Server 和 nacos-discovery-spring-boot-starter 实现服务的注册与发现。

### 前提条件

您需要先下载 Nacos 并启动 Nacos server。操作步骤参见 [Nacos 快速入门](https://nacos.io/zh-cn/docs/quick-start.html)。

### 启动配置管理

启动了 Nacos server 后，您就可以参考以下示例代码，为您的 Spring Boot 应用启动 Nacos 配置管理服务了。完整示例代码请参考：[nacos-spring-boot-config-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-boot-example/nacos-spring-boot-config-example)

1. 添加依赖。

```xml
<dependency>
    <groupId>com.alibaba.boot</groupId>
    <artifactId>nacos-config-spring-boot-starter</artifactId>
    <version>${latest.version}</version>
</dependency>
```

**注意**：版本 [0.2.x.RELEASE](https://mvnrepository.com/artifact/com.alibaba.boot/nacos-config-spring-boot-starter) 对应的是 Spring Boot 2.x 版本，版本 [0.1.x.RELEASE](https://mvnrepository.com/artifact/com.alibaba.boot/nacos-config-spring-boot-starter) 对应的是 Spring Boot 1.x 版本。

1. 在 `application.properties` 中配置 Nacos server 的地址：

```
nacos.config.server-addr=127.0.0.1:8848
```

1. 使用 `@NacosPropertySource` 加载 `dataId` 为 `example` 的配置源，并开启自动更新：

```java
@SpringBootApplication
@NacosPropertySource(dataId = "example", autoRefreshed = true)
public class NacosConfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(NacosConfigApplication.class, args);
    }
}
```

1. 通过 Nacos 的 `@NacosValue` 注解设置属性值。

```java
@Controller
@RequestMapping("config")
public class ConfigController {

    @NacosValue(value = "${useLocalCache:false}", autoRefreshed = true)
    private boolean useLocalCache;

    @RequestMapping(value = "/get", method = GET)
    @ResponseBody
    public boolean get() {
        return useLocalCache;
    }
}
```

1. 启动 `NacosConfigApplication`，调用 `curl http://localhost:8080/config/get`，返回内容是 `false`。
2. 通过调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-API.html) 向 Nacos server 发布配置：dataId 为`example`，内容为`useLocalCache=true`

```bash
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=example&group=DEFAULT_GROUP&content=useLocalCache=true"
```

1. 再次访问 `http://localhost:8080/config/get`，此时返回内容为`true`，说明程序中的`useLocalCache`值已经被动态更新了。

### 启动服务发现

本节演示如何在您的 Spring Boot 项目中启动 Nacos 的服务发现功能。完整示例代码请参考：[nacos-spring-boot-discovery-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-boot-example/nacos-spring-boot-discovery-example)

1. 添加依赖。

```xml
<dependency>
    <groupId>com.alibaba.boot</groupId>
    <artifactId>nacos-discovery-spring-boot-starter</artifactId>
    <version>${latest.version}</version>
</dependency>
```

**注意**：版本 [0.2.x.RELEASE](https://mvnrepository.com/artifact/com.alibaba.boot/nacos-discovery-spring-boot-starter) 对应的是 Spring Boot 2.x 版本，版本 [0.1.x.RELEASE](https://mvnrepository.com/artifact/com.alibaba.boot/nacos-discovery-spring-boot-starter) 对应的是 Spring Boot 1.x 版本。

1. 在 `application.properties` 中配置 Nacos server 的地址：

```yaml
nacos.discovery.server-addr=127.0.0.1:8848
```

1. 使用 `@NacosInjected` 注入 Nacos 的 `NamingService` 实例：

```java
@Controller
@RequestMapping("discovery")
public class DiscoveryController {

    @NacosInjected
    private NamingService namingService;

    @RequestMapping(value = "/get", method = GET)
    @ResponseBody
    public List<Instance> get(@RequestParam String serviceName) throws NacosException {
        return namingService.getAllInstances(serviceName);
    }
}

@SpringBootApplication
public class NacosDiscoveryApplication {

    public static void main(String[] args) {
        SpringApplication.run(NacosDiscoveryApplication.class, args);
    }
}
```

1. 启动 `NacosDiscoveryApplication`，调用 `curl http://localhost:8080/discovery/get?serviceName=example`，此时返回为空 JSON 数组`[]`。
2. 通过调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-API.html) 向 Nacos server 注册一个名称为 `example` 服务

```bash
curl -X PUT 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=example&ip=127.0.0.1&port=8080'
```

1. 再次访问 `curl http://localhost:8080/discovery/get?serviceName=example`，此时返回内容为：

```json
[
  {
    "instanceId": "127.0.0.1-8080-DEFAULT-example",
    "ip": "127.0.0.1",
    "port": 8080,
    "weight": 1.0,
    "healthy": true,
    "cluster": {
      "serviceName": null,
      "name": "",
      "healthChecker": {
        "type": "TCP"
      },
      "defaultPort": 80,
      "defaultCheckPort": 80,
      "useIPPort4Check": true,
      "metadata": {}
    },
    "service": null,
    "metadata": {}
  }
]
```



## Nacos Spring Cloud 快速开始

本文主要面向 [Spring Cloud](https://spring.io/projects/spring-cloud) 的使用者，通过两个示例来介绍如何使用 Nacos 来实现分布式环境下的配置管理和服务注册发现。

关于 Nacos Spring Cloud 的详细文档请参看：[Nacos Config](https://github.com/spring-cloud-incubator/spring-cloud-alibaba/wiki/Nacos-config) 和 [Nacos Discovery](https://github.com/spring-cloud-incubator/spring-cloud-alibaba/wiki/Nacos-discovery)。

- 通过 Nacos Server 和 spring-cloud-starter-alibaba-nacos-config 实现配置的动态变更。
- 通过 Nacos Server 和 spring-cloud-starter-alibaba-nacos-discovery 实现服务的注册与发现。

### 前提条件

您需要先下载 Nacos 并启动 Nacos server。操作步骤参见 [Nacos 快速入门](https://nacos.io/zh-cn/docs/quick-start.html)

### 启动配置管理

启动了 Nacos server 后，您就可以参考以下示例代码，为您的 Spring Cloud 应用启动 Nacos 配置管理服务了。完整示例代码请参考：[nacos-spring-cloud-config-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-cloud-example/nacos-spring-cloud-config-example)

1. 添加依赖：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
    <version>${latest.version}</version>
</dependency>
```

**注意**：版本 [0.2.x.RELEASE](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-alibaba-nacos-config) 对应的是 Spring Boot 2.x 版本，版本 [0.1.x.RELEASE](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-alibaba-nacos-config) 对应的是 Spring Boot 1.x 版本。

更多版本对应关系参考：[版本说明 Wiki](https://github.com/spring-cloud-incubator/spring-cloud-alibaba/wiki/版本说明)

1. 在 `bootstrap.properties` 中配置 Nacos server 的地址和应用名

```yaml
spring.cloud.nacos.config.server-addr=127.0.0.1:8848

spring.application.name=example
```

说明：之所以需要配置 `spring.application.name` ，是因为它是构成 Nacos 配置管理 `dataId`字段的一部分。

在 Nacos Spring Cloud 中，`dataId` 的完整格式如下：

```plain
${prefix}-${spring.profile.active}.${file-extension}
```

- `prefix` 默认为 `spring.application.name` 的值，也可以通过配置项 `spring.cloud.nacos.config.prefix`来配置。
- `spring.profile.active` 即为当前环境对应的 profile，详情可以参考 [Spring Boot文档](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-profiles.html#boot-features-profiles)。 **注意：当 spring.profile.active 为空时，对应的连接符 - 也将不存在，dataId 的拼接格式变成 ${prefix}.${file-extension}**
- `file-exetension` 为配置内容的数据格式，可以通过配置项 `spring.cloud.nacos.config.file-extension` 来配置。目前只支持 `properties` 和 `yaml` 类型。

1. 通过 Spring Cloud 原生注解 `@RefreshScope` 实现配置自动更新：

```java
@RestController
@RequestMapping("/config")
@RefreshScope
public class ConfigController {

    @Value("${useLocalCache:false}")
    private boolean useLocalCache;

    @RequestMapping("/get")
    public boolean get() {
        return useLocalCache;
    }
}
```

1. 首先通过调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-API.html) 向 Nacos Server 发布配置：dataId 为`example.properties`，内容为`useLocalCache=true`

```bash
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=example.properties&group=DEFAULT_GROUP&content=useLocalCache=true"
```

1. 运行 `NacosConfigApplication`，调用 `curl http://localhost:8080/config/get`，返回内容是 `true`。
2. 再次调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-API.html) 向 Nacos server 发布配置：dataId 为`example.properties`，内容为`useLocalCache=false`

```bash
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=example.properties&group=DEFAULT_GROUP&content=useLocalCache=false"
```

1. 再次访问 `http://localhost:8080/config/get`，此时返回内容为`false`，说明程序中的`useLocalCache`值已经被动态更新了。

### 启动服务发现

本节通过实现一个简单的 `echo service` 演示如何在您的 Spring Cloud 项目中启用 Nacos 的服务发现功能，如下图示:

![echo service](https://cdn.nlark.com/lark/0/2018/png/15914/1542119181336-b6dc0fc1-ed46-43a7-9e5f-68c9ca344d60.png)

完整示例代码请参考：[nacos-spring-cloud-discovery-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-cloud-example/nacos-spring-cloud-discovery-example)

1. 添加依赖：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
    <version>${latest.version}</version>
</dependency>
```

**注意**：版本 [0.2.x.RELEASE](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-alibaba-nacos-discovery) 对应的是 Spring Boot 2.x 版本，版本 [0.1.x.RELEASE](https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-starter-alibaba-nacos-discovery) 对应的是 Spring Boot 1.x 版本。

更多版本对应关系参考：[版本说明 Wiki](https://github.com/spring-cloud-incubator/spring-cloud-alibaba/wiki/版本说明)

1. 配置服务提供者，从而服务提供者可以通过 Nacos 的服务注册发现功能将其服务注册到 Nacos server 上。

i. 在 `application.properties` 中配置 Nacos server 的地址：

```yaml
server.port=8070
spring.application.name=service-provider

spring.cloud.nacos.discovery.server-addr=127.0.0.1:8848
```

ii. 通过 Spring Cloud 原生注解 `@EnableDiscoveryClient` 开启服务注册发现功能：

```java
@SpringBootApplication
@EnableDiscoveryClient
public class NacosProviderApplication {

	public static void main(String[] args) {
		SpringApplication.run(NacosProviderApplication.class, args);
	}

	@RestController
	class EchoController {
		@RequestMapping(value = "/echo/{string}", method = RequestMethod.GET)
		public String echo(@PathVariable String string) {
			return "Hello Nacos Discovery " + string;
		}
	}
}
```

1. 配置服务消费者，从而服务消费者可以通过 Nacos 的服务注册发现功能从 Nacos server 上获取到它要调用的服务。

i. 在 `application.properties` 中配置 Nacos server 的地址：

```yaml
server.port=8080
spring.application.name=service-consumer

spring.cloud.nacos.discovery.server-addr=127.0.0.1:8848
```

ii. 通过 Spring Cloud 原生注解 `@EnableDiscoveryClient` 开启服务注册发现功能。给 [RestTemplate](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-resttemplate.html) 实例添加`@LoadBalanced` 注解，开启 `@LoadBalanced` 与 [Ribbon](https://cloud.spring.io/spring-cloud-netflix/multi/multi_spring-cloud-ribbon.html) 的集成：

```java
@SpringBootApplication
@EnableDiscoveryClient
public class NacosConsumerApplication {

    @LoadBalanced
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    public static void main(String[] args) {
        SpringApplication.run(NacosConsumerApplication.class, args);
    }

    @RestController
    public class TestController {

        private final RestTemplate restTemplate;

        @Autowired
        public TestController(RestTemplate restTemplate) {this.restTemplate = restTemplate;}

        @RequestMapping(value = "/echo/{str}", method = RequestMethod.GET)
        public String echo(@PathVariable String str) {
            return restTemplate.getForObject("http://service-provider/echo/" + str, String.class);
        }
    }
}
```

1. 启动 `ProviderApplication` 和 `ConsumerApplication` ，调用 `http://localhost:8080/echo/2018`，返回内容为 `Hello Nacos Discovery 2018`。

## Nacos Docker 快速开始

### 操作步骤

- Clone 项目

  ```powershell
  git clone https://github.com/nacos-group/nacos-docker.git
  cd nacos-docker
  ```

- 单机模式

  ```powershell
  docker-compose -f example/standalone.yaml up
  ```

- 集群模式

  ```powershell
  docker-compose -f example/cluster-hostname.yaml up 
  ```

- 服务注册

  ```powershell
  curl -X POST 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
  ```

- 服务发现

  ```powershell
  curl -X GET 'http://127.0.0.1:8848/nacos/v1/ns/instances?serviceName=nacos.naming.serviceName'
  ```

- 发布配置

  ```powershell
  curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=helloWorld"
  ```

- 获取配置

  ```powershell
    curl -X GET "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
  ```

- Nacos 控制台

  link：<http://127.0.0.1:8848/nacos/>

## Dubbo 融合 Nacos 成为注册中心

Nacos 作为 Dubbo 生态系统中重要的注册中心实现，其中 [`dubbo-registry-nacos`](https://github.com/dubbo/dubbo-registry-nacos) 则是 Dubbo 融合 Nacos 注册中心的实现。

### 预备工作

当您将 [`dubbo-registry-nacos`](https://github.com/dubbo/dubbo-registry-nacos) 整合到您的 Dubbo 工程之前，请确保后台已经启动 Nacos 服务。如果您尚且不熟悉 Nacos 的基本使用的话，可先行参考 [Nacos 快速入门](https://nacos.io/en-us/docs/quick-start.html)：<https://nacos.io/en-us/docs/quick-start.html>

### 快速上手

Dubbo 融合 Nacos 成为注册中心的操作步骤非常简单，大致步骤可分为“增加 Maven 依赖”以及“配置注册中心“。

#### 增加 Maven 依赖

首先，您需要 `dubbo-registry-nacos` 的 Maven 依赖添加到您的项目中 `pom.xml` 文件中，并且强烈地推荐您使用 Dubbo `2.6.5`：

```xml
<dependencies>

    ...
        
    <!-- Dubbo Nacos registry dependency -->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>dubbo-registry-nacos</artifactId>
        <version>0.0.1</version>
    </dependency>   
    
    <!-- Dubbo dependency -->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>dubbo</artifactId>
        <version>2.6.5</version>
    </dependency>
    
    <!-- Alibaba Spring Context extension -->
    <dependency>
        <groupId>com.alibaba.spring</groupId>
        <artifactId>spring-context-support</artifactId>
        <version>1.0.2</version>
    </dependency>

    ...
    
</dependencies>
```

当项目中添加 `dubbo-registry-nacos` 后，您无需显示地编程实现服务发现和注册逻辑，实际实现由该三方包提供，接下来配置 Naocs 注册中心。

#### 配置注册中心

假设您 Dubbo 应用使用 Spring Framework 装配，将有两种配置方法可选，分别为：[Dubbo Spring 外部化配置](https://mercyblitz.github.io/2018/01/18/Dubbo-外部化配置/)以及 Spring XML 配置文件以及 ，笔者强烈推荐前者。

#### [Dubbo Spring 外部化配置](https://mercyblitz.github.io/2018/01/18/Dubbo-外部化配置/)

Dubbo Spring 外部化配置是由 Dubbo `2.5.8` 引入的新特性，可通过 Spring `Environment` 属性自动地生成并绑定 Dubbo 配置 Bean，实现配置简化，并且降低微服务开发门槛。

假设您 Dubbo 应用的使用 Zookeeper 作为注册中心，并且其服务器 IP 地址为：`10.20.153.10`，同时，该注册地址作为 Dubbo 外部化配置属性存储在 `dubbo-config.properties` 文件，如下所示：

```properties
## application
dubbo.application.name = your-dubbo-application

## Zookeeper registry address
dubbo.registry.address = zookeeper://10.20.153.10:2181
...
```

假设您的 Nacos Server 同样运行在服务器 `10.20.153.10` 上，并使用默认 Nacos 服务端口 `8848`，您只需将 `dubbo.registry.address` 属性调整如下：

```properties
## 其他属性保持不变

## Nacos registry address
dubbo.registry.address = nacos://10.20.153.10:8848
...
```

随后，重启您的 Dubbo 应用，Dubbo 的服务提供和消费信息在 Nacos 控制台中可以显示：

![image-20181213103845976-4668726.png | left | 747x284](https://img.alicdn.com/tfs/TB1n6m7zMTqK1RjSZPhXXXfOFXa-2784-1058.png)

如图所示，服务名前缀为 `providers:` 的信息为服务提供者的元信息，`consumers:` 则代表服务消费者的元信息。点击“**详情**”可查看服务状态详情：

![image-20181213104145998-4668906.png | left | 747x437](https://img.alicdn.com/tfs/TB1vZzfzQzoK1RjSZFlXXai4VXa-2714-1588.png)

如果您正在使用 Spring XML 配置文件装配 Dubbo 注册中心的话，请参考下一节。

#### Spring XML 配置文件

同样，假设您 Dubbo 应用的使用 Zookeeper 作为注册中心，并且其服务器 IP 地址为：`10.20.153.10`，并且装配 Spring Bean 在 XML 文件中，如下所示：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
    xsi:schemaLocation="http://www.springframework.org/schema/beans        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd        http://dubbo.apache.org/schema/dubbo        http://dubbo.apache.org/schema/dubbo/dubbo.xsd">
 
    <!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="dubbo-provider-xml-demo"  />
 
    <!-- 使用 Zookeeper 注册中心 -->
    <dubbo:registry address="zookeeper://10.20.153.10:2181" />
 	...
</beans>
```

与 [Dubbo Spring 外部化配置](https://mercyblitz.github.io/2018/01/18/Dubbo-外部化配置/) 配置类似，只需要调整 `address` 属性配置即可：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
    xsi:schemaLocation="http://www.springframework.org/schema/beans        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd        http://dubbo.apache.org/schema/dubbo        http://dubbo.apache.org/schema/dubbo/dubbo.xsd">
 
    <!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="dubbo-provider-xml-demo"  />
 
    <!-- 使用 Nacos 注册中心 -->
    <dubbo:registry address="nacos://10.20.153.10:8848" />
 	...
</beans>
```

重启 Dubbo 应用后，您同样也能发现服务提供方和消费方的注册元信息呈现在 Nacos 控制台中：

![image-20181213113049185-4671849.png | left | 747x274](https://img.alicdn.com/tfs/TB1zl2dzQPoK1RjSZKbXXX1IXXa-2784-1022.png)

您是否绝对配置或切换 Nacos 注册中心超级 Easy 呢？如果您仍旧意犹未尽或者不甚明白的话，可参考以下完整的示例。

### 完整示例

以上图片中的元数据源于 Dubbo Spring 注解驱动示例以及 Dubbo Spring XML 配置驱动示例，下面将分别介绍两者，您可以选择自己偏好的编程模型。在正式讨论之前，先来介绍两者的预备工作，因为它们皆依赖 Java 服务接口和实现。同时，**请确保本地（127.0.0.1）环境已启动 Nacos 服务**。

#### 示例接口与实现

首先定义示例接口，如下所示：

```java
package com.alibaba.dubbo.demo.service;

/**
 * DemoService
 *
 * @since 2.6.5
 */
public interface DemoService {

    String sayName(String name);

}
```

提供以上接口的实现类：

```java
package com.alibaba.dubbo.demo.service;

import com.alibaba.dubbo.config.annotation.Service;
import com.alibaba.dubbo.rpc.RpcContext;

import org.springframework.beans.factory.annotation.Value;

/**
 * Default {@link DemoService}
 *
 * @since 2.6.5
 */
@Service(version = "${demo.service.version}")
public class DefaultService implements DemoService {

    @Value("${demo.service.name}")
    private String serviceName;

    public String sayName(String name) {
        RpcContext rpcContext = RpcContext.getContext();
        return String.format("Service [name :%s , port : %d] %s(\"%s\") : Hello,%s",
                serviceName,
                rpcContext.getLocalPort(),
                rpcContext.getMethodName(),
                name,
                name);
    }
}
```

接口与实现准备妥当后，下面将采用注解驱动和 XML 配置驱动各自实现。

#### Spring 注解驱动示例

Dubbo `2.5.7` 重构了 Spring 注解驱动的编程模型。

##### 服务提供方注解驱动实现

- 定义 Dubbo 提供方外部化配置属性源 - `provider-config.properties`

```properties
## application
dubbo.application.name = dubbo-provider-demo

## Nacos registry address
dubbo.registry.address = nacos://127.0.0.1:8848

## Dubbo Protocol
dubbo.protocol.name = dubbo
dubbo.protocol.port = -1

# Provider @Service version
demo.service.version=1.0.0
demo.service.name = demoService
```

- 实现服务提供方引导类 - `DemoServiceProviderBootstrap`

```java
package com.alibaba.dubbo.demo.provider;

import com.alibaba.dubbo.config.spring.context.annotation.EnableDubbo;
import com.alibaba.dubbo.demo.service.DemoService;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.PropertySource;

import java.io.IOException;

/**
 * {@link DemoService} provider demo
 */
@EnableDubbo(scanBasePackages = "com.alibaba.dubbo.demo.service")
@PropertySource(value = "classpath:/provider-config.properties")
public class DemoServiceProviderBootstrap {

    public static void main(String[] args) throws IOException {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
        context.register(DemoServiceProviderBootstrap.class);
        context.refresh();
        System.out.println("DemoService provider is starting...");
        System.in.read();
    }
}
```

其中注解 `@EnableDubbo` 激活 Dubbo 注解驱动以及外部化配置，其 `scanBasePackages` 属性扫描指定 Java 包，将所有标注 `@Service` 的服务接口实现类暴露为 Spring Bean，随即被导出 Dubbo 服务。

`@PropertySource` 是 Spring Framework 3.1 引入的标准导入属性配置资源注解，它将为 Dubbo 提供外部化配置。

##### 服务消费方注解驱动实现

- 定义 Dubbo 消费方外部化配置属性源 - `consumer-config.properties`

```properties
## Dubbo Application info
dubbo.application.name = dubbo-consumer-demo

## Nacos registry address
dubbo.registry.address = nacos://127.0.0.1:8848

# @Reference version
demo.service.version= 1.0.0
```

同样地，`dubbo.registry.address` 属性指向 Nacos 注册中心，其他 Dubbo 服务相关的元信息通过 Nacos 注册中心获取。

- 实现服务消费方引导类 - `DemoServiceConsumerBootstrap`

```java
package com.alibaba.dubbo.demo.consumer;

import com.alibaba.dubbo.config.annotation.Reference;
import com.alibaba.dubbo.config.spring.context.annotation.EnableDubbo;
import com.alibaba.dubbo.demo.service.DemoService;

import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.PropertySource;

import javax.annotation.PostConstruct;
import java.io.IOException;

/**
 * {@link DemoService} consumer demo
 */
@EnableDubbo
@PropertySource(value = "classpath:/consumer-config.properties")
public class DemoServiceConsumerBootstrap {

    @Reference(version = "${demo.service.version}")
    private DemoService demoService;

    @PostConstruct
    public void init() {
        for (int i = 0; i < 10; i++) {
            System.out.println(demoService.sayName("小马哥（mercyblitz）"));
        }
    }

    public static void main(String[] args) throws IOException {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
        context.register(DemoServiceConsumerBootstrap.class);
        context.refresh();
        context.close();
    }
}
```

同样地，`@EnableDubbo` 注解激活 Dubbo 注解驱动和外部化配置，不过当前属于服务消费者，无需指定 Java 包名扫描标注 `@Service` 的服务实现。

`@Reference` 是 Dubbo 远程服务的依赖注入注解，需要服务提供方和消费端约定接口（interface）、版本（version）以及分组（group）信息。在当前服务消费示例中，`DemoService` 的服务版本来源于属性配置文件 `consumer-config.properties`。

`@PostConstruct` 部分代码则说明当 `DemoServiceConsumerBootstrap` Bean 初始化时，执行十次 Dubbo 远程方法调用。

##### 运行注解驱动示例

在本地启动两次 `DemoServiceProviderBootstrap`，注册中心将出现两个健康服务：

![image-20181213123909636-4675949.png | left | 747x38](https://img.alicdn.com/tfs/TB1s9fbzMHqK1RjSZFgXXa7JXXa-2390-122.png)

再运行 `DemoServiceConsumerBootstrap`，运行结果如下：

```
Service [name :demoService , port : 20880] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20881] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20880] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20880] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20881] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20881] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20880] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20880] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20881] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :demoService , port : 20881] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
```

运行无误，并且服务消费方使用了负载均衡策略，将十次 RPC 调用平均分摊到两个 Dubbo 服务提供方实例中。

#### Spring XML 配置驱动示例

Spring XML 配置驱动是传统 Spring 装配组件的编程模型。

##### 服务提供方 XML 配置驱动

- 定义服务提供方 XML 上下文配置文件 - `/META-INF/spring/dubbo-provider-context.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.3.xsd        http://dubbo.apache.org/schema/dubbo        http://dubbo.apache.org/schema/dubbo/dubbo.xsd">

    <!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="dubbo-provider-xml-demo"/>

    <!-- 使用 Nacos 注册中心 -->
    <dubbo:registry address="nacos://127.0.0.1:8848"/>

    <!-- 用dubbo协议在随机端口暴露服务 -->
    <dubbo:protocol name="dubbo" port="-1"/>

    <!-- 声明需要暴露的服务接口 -->
    <dubbo:service interface="com.alibaba.dubbo.demo.service.DemoService" ref="demoService" version="2.0.0"/>

    <!-- 和本地bean一样实现服务 -->
    <bean id="demoService" class="com.alibaba.dubbo.demo.service.DefaultService"/>
</beans>
```

- 实现服务提供方引导类 - `DemoServiceProviderXmlBootstrap`

```xml
package com.alibaba.dubbo.demo.provider;

import com.alibaba.dubbo.demo.service.DemoService;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.IOException;

/**
 * {@link DemoService} provider demo XML bootstrap
 */
public class DemoServiceProviderXmlBootstrap {

    public static void main(String[] args) throws IOException {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext();
        context.setConfigLocation("/META-INF/spring/dubbo-provider-context.xml");
        context.refresh();
        System.out.println("DemoService provider (XML) is starting...");
        System.in.read();
    }
}
```

##### 服务消费方 XML 配置驱动

- 定义服务消费方 XML 上下文配置文件 - `/META-INF/spring/dubbo-consumer-context.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans        http://www.springframework.org/schema/beans/spring-beans-4.3.xsd        http://dubbo.apache.org/schema/dubbo        http://dubbo.apache.org/schema/dubbo/dubbo.xsd">

    <!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="dubbo-consumer-xml-demo"/>

    <!-- 使用 Nacos 注册中心 -->
    <dubbo:registry address="nacos://127.0.0.1:8848"/>

    <!-- 引用服务接口 -->
    <dubbo:reference id="demoService" interface="com.alibaba.dubbo.demo.service.DemoService" version="2.0.0"/>

</beans>
```

- 实现服务消费方引导类 - `DemoServiceConsumerXmlBootstrap`

```java
package com.alibaba.dubbo.demo.consumer;

import com.alibaba.dubbo.demo.service.DemoService;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.IOException;

/**
 * {@link DemoService} consumer demo XML bootstrap
 */
public class DemoServiceConsumerXmlBootstrap {

    public static void main(String[] args) throws IOException {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext();
        context.setConfigLocation("/META-INF/spring/dubbo-consumer-context.xml");
        context.refresh();
        System.out.println("DemoService consumer (XML) is starting...");
        DemoService demoService = context.getBean("demoService", DemoService.class);
        for (int i = 0; i < 10; i++) {
            System.out.println(demoService.sayName("小马哥（mercyblitz）"));
        }
        context.close();
    }
}
```

##### 运行 XML 配置驱动示例

同样地，先启动两个 `DemoServiceProviderXmlBootstrap` 引导类，观察 Nacos 注册中心服务提供者变化：

![image-20181213125527201-4676927.png | left | 747x33](https://img.alicdn.com/tfs/TB1HCfbzMHqK1RjSZFgXXa7JXXa-2388-106.png)

XML 配置驱动的服务版本为 `2.0.0`，因此注册服务无误。

再运行服务消费者引导类 `DemoServiceConsumerXmlBootstrap`，观察控制台输出内容：

```
Service [name :null , port : 20882] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20882] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20883] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20882] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20882] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20883] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20882] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20883] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20883] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
Service [name :null , port : 20883] sayName("小马哥（mercyblitz）") : Hello,小马哥（mercyblitz）
```

结果同样运行和负载均衡正常，不过由于当前示例尚未添加属性 `demo.service.name` 的缘故，因此，“name”部分信息输出为 `null`。

如果您关注或喜爱 Dubbo 以及 Nacos 等开源工程，不妨为它们点 “star”，加油打气链接：

- Apache Dubbo：<https://github.com/apache/incubator-dubbo>
- Dubbo Nacos Registry：<https://github.com/apache/incubator-dubbo/tree/master/dubbo-registry/dubbo-registry-nacos>
- Alibaba Nacos：<https://github.com/alibaba/nacos>

## Kubernetes Nacos

本项目包含一个可构建的Nacos Docker Image,旨在利用StatefulSets在[Kubernetes](https://kubernetes.io/)上部署[Nacos](https://nacos.io/)

[English Document](https://github.com/nacos-group/nacos-k8s/blob/master/README.md)

### 快速开始

- **Clone 项目**

```shell
git clone https://github.com/nacos-group/nacos-k8s.git
```

- **简单例子**

> 如果你使用简单方式快速启动,请注意这是没有使用持久化卷的,可能存在数据丢失风险:

```shell
cd nacos-k8s
chmod +x quick-startup.sh
./quick-startup.sh
```

- **测试**

  - **服务注册**

  ```bash
  curl -X PUT 'http://cluster-ip:8848/nacos/v1/ns/instance?serviceName=nacos.naming.serviceName&ip=20.18.7.10&port=8080'
  ```

  - **服务发现**

  ```bash
  curl -X GET 'http://cluster-ip:8848/nacos/v1/ns/instances?serviceName=nacos.naming.serviceName'
  ```

  - **发布配置**

  ```bash
  curl -X POST "http://cluster-ip:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test&content=helloWorld"
  ```

  - **获取配置**

  ```bash
  curl -X GET "http://cluster-ip:8848/nacos/v1/cs/configs?dataId=nacos.cfg.dataId&group=test"
  ```

### 高级使用

> 在高级使用中,Nacos在K8S拥有自动扩容缩容和数据持久特性,请注意如果需要使用这部分功能请使用PVC持久卷,Nacos的自动扩容缩容需要依赖持久卷,以及数据持久化也是一样,本例中使用的是NFS来使用PVC.

部署 NFS

- 创建角色

```shell
kubectl create -f deploy/nfs/rbac.yaml
```

> 如果的K8S命名空间不是**default**,请在部署RBAC之前执行以下脚本:

```shell
# Set the subject of the RBAC objects to the current namespace where the provisioner is being deployed
$ NS=$(kubectl config get-contexts|grep -e "^\*" |awk '{print $5}')
$ NAMESPACE=${NS:-default}
$ sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/nfs/rbac.yaml
```

- 创建 `ServiceAccount` 和部署 `NFS-Client Provisioner`

```shell
kubectl create -f deploy/nfs/deployment.yaml
```

- 创建 NFS StorageClass

```shell
kubectl create -f deploy/nfs/class.yaml
```

- 验证NFS部署成功

```shell
kubectl get pod -l app=nfs-client-provisioner
```

#### 部署数据库

- 部署主库

```shell
cd nacos-k8s

kubectl create -f deploy/mysql/mysql-master-nfs.yaml
```

- 部署从库

```shell
cd nacos-k8s 

kubectl create -f deploy/mysql/mysql-slave-nfs.yaml
```

- 验证数据库是否正常工作

```shell
# master
kubectl get pod 
NAME                         READY   STATUS    RESTARTS   AGE
mysql-master-gf2vd                        1/1     Running   0          111m

# slave
kubectl get pod 
mysql-slave-kf9cb                         1/1     Running   0          110m
```

#### 部署Nacos

- 修改 **depoly/nacos/nacos-pvc-nfs.yaml**

```yaml
data:
  mysql.master.db.name: "主库名称"
  mysql.master.port: "主库端口"
  mysql.slave.port: "从库端口"
  mysql.master.user: "主库用户名"
  mysql.master.password: "主库密码"
```

- 创建 Nacos

```shell
kubectl create -f nacos-k8s/deploy/nacos/nacos-pvc-nfs.yaml
```

- 验证Nacos节点启动成功

```shell
kubectl get pod -l app=nacos


NAME      READY   STATUS    RESTARTS   AGE
nacos-0   1/1     Running   0          19h
nacos-1   1/1     Running   0          19h
nacos-2   1/1     Running   0          19h
```

#### 扩容测试

- 在扩容前,使用 [`kubectl exec`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/#exec)获取在pod中的Nacos集群配置文件信息

```powershell
for i in 0 1; do echo nacos-$i; kubectl exec nacos-$i cat conf/cluster.conf; done
```

StatefulSet控制器根据其序数索引为每个Pod提供唯一的主机名。 主机名采用 - 的形式。 因为nacos StatefulSet的副本字段设置为2，所以当前集群文件中只有两个Nacos节点地址

![k8s](https://nacos.io/images/k8s.gif)

- 使用kubectl scale 对Nacos动态扩容

```bash
kubectl scale sts nacos --replicas=3
```

![scale](https://nacos.io/images/scale.gif)

- 在扩容后,使用 [`kubectl exec`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/#exec)获取在pod中的Nacos集群配置文件信息

```bash
for i in 0 1 2; do echo nacos-$i; kubectl exec nacos-$i cat conf/cluster.conf; done
```

![get_cluster_after](https://nacos.io/images/get_cluster_after.gif)

- 使用 [`kubectl exec`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands/#exec)执行Nacos API 在每台节点上获取当前**Leader**是否一致

```bash
for i in 0 1 2; do echo nacos-$i; kubectl exec nacos-$i curl GET "http://localhost:8848/nacos/v1/ns/raft/state"; done
```

到这里你可以发现新节点已经正常加入Nacos集群当中

### 例子部署环境

- 机器配置

| 内网IP      | 主机名     | 配置                                                         |
| ----------- | ---------- | ------------------------------------------------------------ |
| 172.17.79.3 | k8s-master | CentOS Linux release 7.4.1708 (Core) Single-core processor Mem 4G Cloud disk 40G |
| 172.17.79.4 | node01     | CentOS Linux release 7.4.1708 (Core) Single-core processor Mem 4G Cloud disk 40G |
| 172.17.79.5 | node02     | CentOS Linux release 7.4.1708 (Core) Single-core processor Mem 4G Cloud disk 40G |

- Kubernetes 版本：**1.12.2** （如果你和我一样只使用了三台机器,那么记得开启master节点的部署功能）
- NFS 版本：**4.1** 在k8s-master进行安装Server端,并且指定共享目录,本项目指定的**/data/nfs-share**
- Git

限制

- 必须要使用持久卷,否则会出现数据丢失的情况

#### 项目目录

| 目录   | 描述                                          |
| ------ | --------------------------------------------- |
| plugin | 帮助Nacos集群进行动态扩容的插件Docker镜像源码 |
| deploy | K8s 部署文件                                  |

#### 配置属性

- nacos-pvc-nfs.yaml or nacos-quick-start.yaml

| 名称                                                 | 必要 | 描述                                                         |
| ---------------------------------------------------- | ---- | ------------------------------------------------------------ |
| [mysql.master.db.name](http://mysql.master.db.name/) | Y    | 主库名称                                                     |
| mysql.master.port                                    | N    | 主库端口                                                     |
| mysql.slave.port                                     | N    | 从库端口                                                     |
| mysql.master.user                                    | Y    | 主库用户名                                                   |
| mysql.master.password                                | Y    | 主库密码                                                     |
| NACOS_REPLICAS                                       | N    | 确定执行Nacos启动节点数量,如果不适用动态扩容插件,就必须配置这个属性，否则使用扩容插件后不会生效 |
| NACOS_SERVER_PORT                                    | N    | Nacos 端口                                                   |
| PREFER_HOST_MODE                                     | Y    | 启动Nacos集群按域名解析                                      |

- **nfs** deployment.yaml

| 名称       | 必要 | 描述           |
| ---------- | ---- | -------------- |
| NFS_SERVER | Y    | NFS 服务端地址 |
| NFS_PATH   | Y    | NFS 共享目录   |
| server     | Y    | NFS 服务端地址 |
| path       | Y    | NFS 共享目录   |

- mysql

| 名称                       | 必要 | 描述                                       |
| -------------------------- | ---- | ------------------------------------------ |
| MYSQL_ROOT_PASSWORD        | N    | ROOT 密码                                  |
| MYSQL_DATABASE             | Y    | 数据库名称                                 |
| MYSQL_USER                 | Y    | 数据库用户名                               |
| MYSQL_PASSWORD             | Y    | 数据库密码                                 |
| MYSQL_REPLICATION_USER     | Y    | 数据库复制用户                             |
| MYSQL_REPLICATION_PASSWORD | Y    | 数据库复制用户密码                         |
| Nfs:server                 | N    | NFS 服务端地址，如果使用本地部署不需要配置 |
| Nfs:path                   | N    | NFS 共享目录，如果使用本地部署不需要配置   |

