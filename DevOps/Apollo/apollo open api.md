# Apollo Open Api

首先引入`apollo-openapi`依赖：

```xml
<dependency>
    <groupId>com.ctrip.framework.apollo</groupId>
    <artifactId>apollo-openapi</artifactId>
    <version>1.1.0</version>
</dependency>
```

在程序中构造`ApolloOpenApiClient`：

```java
String portalUrl = "http://localhost:8070"; // portal url
String token = "e16e5cd903fd0c97a116c873b448544b9d086de9"; // 申请的token
ApolloOpenApiClient client = ApolloOpenApiClient.newBuilder()
                                                .withPortalUrl(portalUrl)
                                                .withToken(token)
                                                .build();
```

