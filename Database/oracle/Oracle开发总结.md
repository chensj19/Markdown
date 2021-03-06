# Oracle开发总结

## 1、dba_tables\all_tables\user_tables

dba_tables: dba所有的表，显示当前用户下全部的表

all_tables：当前用户可以查看的表，包含自己创建的表和其他用户赋予权限的表

user_tables：当前用户创建的表

## 2、oracle VARCHAR2和NVARCHAR2的区别

### **区别一：**

VARCHAR2（size type），size最大为4000，type可以是char也可以是byte，不标明type时默认是byte（如：name  VARCHAR2(60)）。

NVARCHAR2（size），size最大值为2000，单位是字符

### **区别二：**

VARCHAR2最多存放4000字节的数据，最多可以可以存入4000个字母，或最多存入2000个汉字（数据库字符集编码是GBK时，varchar2最多能存放2000个汉字，数据库字符集编码是UTF-8时，那就最多只能存放1333个汉字，呵呵，以为最大2000个汉字的傻了吧！）

NVARCHAR2（size），size最大值为2000，单位是字符，而且不管是汉字还是字母，每个字符的长度都是2个字节。所以nvarchar2类型的数据最多能存放2000个汉字，也最多只能存放2000个字母。并且NVARCHAR2不受数据库字符集的影响。

