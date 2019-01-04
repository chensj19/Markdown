1、时间戳转换到字符串
REPLACE(CONVERT(VARCHAR(32),t.CREATE_TIME,111),'/','-') as  CREATE_DATE
时间戳转换
转换类型如下：


2、字段处理
1、修改字段名：
alter table 表名 rename column A to B
2、修改字段类型：
alter table 表名 alter column 字段名 type not null
ALTER TABLE ET_SIMULATE_RECORD ALTER COLUMN SIMULATE_RESULT INT
3、修改字段默认值
alter table 表名 add default (0) for 字段名 with values
如果字段有默认值，则需要先删除字段的约束，在添加新的默认值，
select c.name from sysconstraints a 
inner join syscolumns b on a.colid=b.colid 
inner join sysobjects c on a.constid=c.id
where a.id=object_id('表名') 
and b.name='字段名'
根据约束名称删除约束
alter table 表名 drop constraint 约束名
根据表名向字段中增加新的默认值
alter table 表名 add default (0) for 字段名 with values
4、增加字段：
alter table 表名 add 字段名 type not null default 0
5、删除字段：
alter table 表名 drop column 字段名;

sql中的Update语句为什么不能用表的别名
原创 2011年09月06日 15:34:58 标签：sql /table 8308
说来好笑,一直写简单的CRUD语句都没注意过这个问题.我们一直写Update语句都是这样的:

UPDATE [TABLE] SET TID=1,TNAME='Name',TClass=1 WHERE ID=10  
这样写很简单,也很方便,所以就一直这样用了,今天在写的时候有一个子查询,想用别名来区别,就跟着这种逻辑这样写下去了:


UPDATE [TABLE] AS T SET T.TID=1,T.TNAME='Name',T.TClass=1 WHERE T.ID=10  
在写的时候就已经提示语法错误了,还得去看看度娘是怎么解释,看了之后才恍然大悟,原来我们一直写的update语句都是简写过的,应该按照下面的规范语法来写:


UPDATE T SET T.TID=1,T.TNAME='Name',T.TClass=1 FROM [TABLE] T WHERE T.ID=10 


--表结构复制
SELECT * INTO dbo.SYS_DATA_INFO_BAK FROM dbo.SYS_DATA_INFO;

--数据复制
INSERT INTO SYS_DATA_INFO_BAK
SELECT * FROM dbo.SYS_DATA_INFO;


--字段修改
ALTER TABLE ET_SOFT_HARDWARE ALTER COLUMN BRAND varchar(64);
ALTER TABLE ET_SOFT_HARDWARE ALTER COLUMN MODEL varchar(128);
ALTER TABLE SYS_SOFT_HARDWARE_INFO ALTER COLUMN SH_BRAND varchar(64);
ALTER TABLE SYS_SOFT_HARDWARE_INFO ALTER COLUMN SH_BRAND_TYPE varchar(128);
