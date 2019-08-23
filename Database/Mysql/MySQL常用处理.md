## 1、建库脚本

```sql
-- 删除脚本
DROP DATABASE  IF EXISTS ANT;
-- 创建脚本
CREATE DATABASE ANT  DEFAULT CHARACTER SET UTF8 COLLATE UTF8_GENERAL_CI;
CREATE DATABASE SINA DEFAULT CHARACTER SET UTF8MB4 COLLATE UTF8MB4_UNICODE_CI;
```

## 2、修改数据库编码从UTF8到UTF8MB4

1. MySQL的版本
    utf8mb4的最低mysql版本支持版本为5.5.3+，若不是，请升级到较新版本。

2. MySQL驱动
    5.1.34可用,最低不能低于5.1.13

3. 修改MySQL配置文件
修改mysql配置文件`my.cnf`（windows为`my.ini`） 
`my.cnf`一般在`etc/mysql/my.cnf`位置。找到后请在以下三部分里添加如下内容： 
```ini 
[client] 
default-character-set = utf8mb4 
[mysql] 
default-character-set = utf8mb4 
[mysqld] 
character-set-client-handshake = FALSE 
character-set-server = utf8mb4 
collation-server = utf8mb4_unicode_ci 
init_connect=’SET NAMES utf8mb4’
```

4. 重启数据库，变量检查

```bash
mysql> show variables like 'character_set%';
+--------------------------+-------------------------------------------------+
| Variable_name            | Value                                           |
+--------------------------+-------------------------------------------------+
| character_set_client     | utf8mb4                                         |
| character_set_connection | utf8mb4                                         |
| character_set_database   | utf8mb4                                         |
| character_set_filesystem | binary                                          |
| character_set_results    | utf8mb4                                         |
| character_set_server     | utf8mb4                                         |
| character_set_system     | utf8                                            |
| character_sets_dir       | D:\Database\mysql-8.0.12-winx64\share\charsets\ |
+--------------------------+-------------------------------------------------+
8 rows in set, 1 warning (0.00 sec)
```

出现上面的编码，代表修改成功

必须保证下面的参数必须是utf8mb4

系统变量	                                     描述
character_set_client	             (客户端来源数据使用的字符集)
character_set_connection	     (连接层字符集)
character_set_database	     (当前选中数据库的默认字符集)
character_set_results	             (查询结果字符集)
character_set_server	             (默认的内部操作字符集)

5. 数据库连接的配置
   数据库连接参数中: `characterEncoding=utf8`会被自动识别为utf8mb4，也可以不加这个参数，会自动检测。 而`autoReconnect=true`是必须加上的。

6. 将数据库和已经建好的表也转换成`utf8mb4`

  ```sql 
  -- 更改数据库编码
  ALTER DATABASE caitu99 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
  
  -- 更改表编码
  ALTER TABLE TABLE_NAME CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
  ```

## 3、time_zone报错

```java
 com.mysql.cj.exceptions.InvalidConnectionAttributeException: The server time zone value '?Ð¹???×¼Ê±?' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.
     上述问题主要是编码问题导致，系统编码为GBK，数据库编码为UTF8。
```

1. 设置服务器编码：

   1. 全局设置

      ```bash
      SET GLOBAL time_zone = timezone;
      ```

   2. 针对当前设置的客户端

      ```bash
       SET time_zone = timezone;
      ```

   3. 启动配置
      ```bash
      启动服务器时增加选项 --default-time-zone=timezone
      ```

   4. 配置文件

      `my.ini` 或` my.cnf `中的` [mysqld] `部分增加 

      ```ini
      default-time-zone='+8:00'
      ```

   5. JDBC:在 url 中增加 serverTimezone 属性

      ```sql
      jdbc:mysql://localhost:3306/demo?serverTimezone=Hongkong
      ```


## 自增主键设置

### 建表设置

```sql
 create table t_user(
    id int not null auto_increment primary key,
    username varchar(128) not null,
    password varchar(128),
    age int,
    sex int,
    reg_date date
 );
```

### 修改主键类型

```sql
ALTER TABLE `database`.`table` CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
```

