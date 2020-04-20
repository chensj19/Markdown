# SQL Server 常用操作

## 查看锁表的操作
```sql 
	create proc USP_QUERY_COMMAND
    AS 

     if exists(select 1 from tempdb..sysobjects where id = object_id('tempdb..#sp_who2'))
          drop table #sp_who2
    CREATE TABLE #sp_who2
    (
    SPID INT,
    Status VARCHAR(255),
     Login  VARCHAR(255),
    HostName  VARCHAR(255),
    BlkBy  VARCHAR(255),
    DBName  VARCHAR(255),
    Command VARCHAR(255),
    CPUTime INT,
    DiskIO INT,
    LastBatch VARCHAR(255),
    ProgramName VARCHAR(255),
    SPID2 INT,
    REQ
    UESTID INT)
    insert into #sp_who2 exec sp_who2
    --select * from #sp_who2
    select * from #sp_who2 where Command='SELECT INTO     ' 
```
## 查看进程信息
```sql 
sp_who2 
dbcc inputbuffer()
kill 
```

## 常用数据库操作

####  修改字段名称
```sql
exec sp_rename 'student.Ssex','Sex','column';
```
####  修改字段类型
```sql 
alter table 表名 alter column 字段名 type not null
ALTER TABLE ET_SOFT_HARDWARE ALTER COLUMN BRAND varchar(64);
ALTER TABLE ET_SOFT_HARDWARE ALTER COLUMN MODEL varchar(128);
ALTER TABLE SYS_SOFT_HARDWARE_INFO ALTER COLUMN SH_BRAND varchar(64);
ALTER TABLE SYS_SOFT_HARDWARE_INFO ALTER COLUMN SH_BRAND_TYPE varchar(128);
```
#### 修改默认值
```sql
alter table 表名 add default (0) for 字段名 with values
ALTER TABLE SYS_FLOW_INFO ADD DEFAULT (1) FOR DB_TYPE WITH VALUES;
```
***如果字段有默认值，则需要先删除字段的约束，在添加新的默认值***

```sql
select c.name from sysconstraints a 
inner join syscolumns b on a.colid=b.colid 
inner join sysobjects c on a.constid=c.id
where a.id=object_id('表名') 
and b.name='字段名'
```
**根据约束名称删除约束**
```sql
alter table 表名 drop constraint 约束名
```
**根据表名向字段中增加新的默认值**
```sql
alter table 表名 add default (0) for 字段名 with values
```
#### 增加字段

```sql
alter table 表名 add 字段名 type not null default 0
```

#### 删除字段

```sql
alter table 表名 drop column 字段名;
```

#### 表结构复制

```sql
SELECT * INTO dbo.SYS_DATA_INFO_BAK FROM dbo.SYS_DATA_INFO;
```

#### 数据复制

```sql
INSERT INTO SYS_DATA_INFO_BAK
SELECT * FROM dbo.SYS_DATA_INFO;
```

#### 

#### 时间戳转换到字符串

```sql
REPLACE(CONVERT(VARCHAR(32),t.CREATE_TIME,111),'/','-') as  CREATE_DATE
```

##  [常用函数、常用语句](https://www.cnblogs.com/sxxjyj/p/6180711.html)

### 常用函数
#### 字符串函数
##### 寻找一个字符在一段字符串中起始的位置
```sql
charindex(':','abc:123')  
```
##### 获取一段字符串的长度
```sql
len('zhangsan')   
```
##### 从一段字符串左边返回指定长度的字符
```sql
left('Ly,君子之耀',2)   
```
##### 返回字符串右边int_expr个字符
```sql
right(char_expr,int_expr)
```
##### 截取字符串
```sql
substring(expression,start,length)
```
##### 返回字符串包含字符数,但不包含后面的空格
```sql
datalength(Char_expr)  
```
##### 指定字符串或变量名称的长度
```sql
length(expression,variable)
```
##### 返回来自于参数连结的字符串
```sql
concat(str1,str2,...) 
```
##### 将一段小写的字符串转换为大写
```sql
upper('Yang') 
```
##### 去除一段字符左边的空格
```sql
ltrim('   zhangsan') 
```
##### 去除一段字符右边的空格
```sql
rtrim('zhang   san   ') 
```
##### 从指定的位置删除指定长度的字符串并替换为新的字符串
```sql
stuff('abcdefg',2,4,'张三') 
```
##### 将一段字符串中指定的字符串替换为另一段字符串
```sql
replace('扬子之耀','扬子','君') 
```

### 日期，时间函数

##### 获取当前系统时间
```sql
getdate() 
```
##### 指定日期字符串中指定时间段的字符串格式
```sql
datename(datepart,date_expr)
```
##### 获取指定日期部分的整数形式
```sql
datepart(datepart,date_expr) 
```
##### 两个时间段中指定的间隔部分
```sql
datediff(datepart,date_expr1.dateexpr2)
```
##### 将指定的数值添加到指定的日期段后
```sql
dateadd(datepart,number,date_expr) 
```
###  系统函数
```sql
suser_name() 用户登录名
user_name() 用户在数据库中的名字
user 用户在数据库中的名字
show_role() 对当前用户起作用的规则
db_name() 数据库名
object_name(obj_id) 数据库对象名
col_name(obj_id,col_id) 列名
col_length(objname,colname) 列长度
valid_name(char_expr) 是否是有效标识符
```


