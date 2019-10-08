# Mariadb

## 创建数据库

```bash
-- 删除脚本
DROP DATABASE  IF EXISTS ANT;
-- 创建脚本
CREATE DATABASE ANT  DEFAULT CHARACTER SET UTF8 COLLATE UTF8_GENERAL_CI;
```

## 创建用户

```bash
create user winning@'172.17.%.%' identified by '123456';
grant all privileges on *.* to winning@'172.17.%.%' identified by '123456';
flush privileges;
```

