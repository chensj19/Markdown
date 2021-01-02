-- 创建temp表空间
CREATE TEMPORARY TABLESPACE orcl_temp TEMPFILE '/data/oracle/oradata/orcl/orcl_temp.dbf' SIZE  32m AUTOEXTEND ON NEXT  32m MAXSIZE  UNLIMITED  EXTENT MANAGEMENT LOCAL;
-- 创建数据表空间
CREATE TABLESPACE orcl_data LOGGING DATAFILE '/data/oracle/oradata/orcl/orcl_data.dbf' SIZE 32m AUTOEXTEND ON NEXT  32m MAXSIZE  UNLIMITED  EXTENT MANAGEMENT LOCAL;
-- 创建用户
CREATE USER WINDBA IDENTIFIED BY WINDBA ACCOUNT UNLOCK DEFAULT TABLESPACE orcl_data TEMPORARY TABLESPACE orcl_temp;
-- 赋权
grant connect,resource,dba to WINDBA;
-- 允许用户登录
grant create session to WINDBA;
-- 允许资源
grant connect,resource,dba to WINDBA;
-- 赋予字典表权限
grant select any  dictionary to WINDBA;
-- 赋权 tablespace users
alter user WINDBA quota unlimited on orcl_data;
-- 修改游标参数
alter system set open_cursors=10000;
-- 提交
commit;
