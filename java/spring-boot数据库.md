# spring boot 数据库

## 1、Druid

### 1.1 `pom.xml`

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.14</version>
</dependency>
```

### 1.2 `application.yml`

```yaml
spring:
  # 数据库
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:p6spy:mysql://127.0.0.1:3306/test?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
    username: root
    password: 123456
#   druid 参数配置
    druid:
      # 配置监控统计拦截的filters，去掉后监控界面sql无法统计，'wall'用于防火墙
      filters: stat,wall,config
      # 初始化大小，最小，最大
      initial-size: 5
      max-active: 100
      min-idle: 5
      # 配置获取连接等待超时的时间
      max-wait: 60000
      # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
      time-between-eviction-runs-millis: 60000
      # 配置一个连接在池中最小生存的时间，单位是毫秒
      min-evictable-idle-time-millis: 300000
      # 数据库验证SQL
      validation-query: select 1
      test-while-idle: true
      test-on-borrow: false
      test-on-return: false
      # 打开PSCache，并且指定每个连接上PSCache的大小
      pool-prepared-statements: true
      max-pool-prepared-statement-per-connection-size: 20
      # 通过connectProperties属性来打开mergeSql功能；慢SQL记录
      connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000
      max-open-prepared-statements: 50
      # 合并多个DruidDataSource的监控数据
      useGlobalDataSourceStat: true
      # 数据库名称
      name: MBK
      # 指定数据库类型
      db-type: mysql
```



## 2、hikari

### 2.1 `pom.xml`

```xml
 <!-- p6spy打印完整SQL -->
<dependency>
    <groupId>p6spy</groupId>
    <artifactId>p6spy</artifactId>
    <version>3.8.0</version>
</dependency>
<!--Hikaricp包-->
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>3.3.1</version>
</dependency>
```

需要增加`p6spy`依赖，打印SQL

### 2.2 `application.yml`

```yaml
spring:
  datasource:
    type: com.zaxxer.hikari.HikariDataSource
    driver-class-name: com.p6spy.engine.spy.P6SpyDriver
    url: jdbc:p6spy:mysql://127.0.0.1:3306/test?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
    username: root
    password: 123456
#    hikari 参数配置
    hikari:
      # 是否自动提交
      auto-commit: true
      # 如果在没有连接可用的情况下超过此时间，则将抛出SQLException
      connection-timeout: 30000
      # 控制允许连接在池中空闲的最长时间
      idle-timeout: 600000
      # 控制池中连接的最长生命周期。使用中的连接永远不会退役，只有当它关闭时才会被删除
      max-lifetime: 1800000
      # 数据库连接名称
      pool-name: test-hikari
      # 如果您的驱动程序支持JDBC4，强烈建议不要设置此属性
#      connection-test-query: select 1
      # 控制HikariCP尝试在池中维护的最小空闲连接数。建议不要设置此值，而是允许HikariCP充当固定大小的连接池。 默认值：与maximumPoolSize相同
#      minimum-idle: 10
      # 此属性控制允许池到达的最大大小，包括空闲和正在使用的连接。
      maximum-pool-size: 10
      data-source-properties:
        cachePrepStmts: true
        prepStmtCacheSize: 250
        prepStmtCacheSqlLimit: 2048
        useServerPrepStmts: true
        useLocalSessionState: true
        rewriteBatchedStatements: true
        cacheResultSetMetadata: true
        cacheServerConfiguration: true
        elideSetAutoCommits: true
        maintainTimeStats: false
    druid:
      enable: false
```

### 2.3 `spy.properties`

```properties
#driverlist= 数据库连接使用的驱动
driverlist=com.mysql.cj.jdbc.Driver
reloadproperties=true
# 使用的是哪种日志种类
# (default is com.p6spy.engine.spy.appender.FileLogger)
#appender=com.p6spy.engine.spy.appender.Slf4JLogger
#appender=com.p6spy.engine.spy.appender.StdoutLogger
#appender=com.p6spy.engine.spy.appender.FileLogger
appender=com.p6spy.engine.spy.appender.Slf4JLogger
#自定义日志格式，在类中定义
logMessageFormat=com.winning.devops.utils.log.P6SpyLogger
#databaseDialectDateFormat=dd-MMM-yy 时间格式
databaseDialectDateFormat=yyyy-MM-dd HH:mm:ss
excludecategories=info,debug,result,resultset
```

### 2.4 `P6SpyLogger`

```java
public class P6SpyLogger implements MessageFormattingStrategy {
    private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-DD HH:mm:ss");

    public P6SpyLogger() {
    }

    /**
     *
     * @param connectionId 数据库连接ID
     * @param now 当前时间戳
     * @param elapsed 消耗时间
     * @param category 类型  statement PrepareStatement
     * @param prepared 预加载SQL
     * @param sql 执行SQL
     * @param url  数据库连接URL
     * @return
     */
    @Override
    public String formatMessage(int connectionId, String now, long elapsed, String category, String prepared, String sql,String url) {
        return !"".equals(sql.trim())?this.format.format(new Date()) + " | took " + elapsed + "ms | " + category + " | connection " + connectionId + "\n " + sql + ";":"";
    }
}

```

