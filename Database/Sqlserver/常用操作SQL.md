# 常用操作SQL

## 1.清理事务日志

```sql
USE[master]  
GO  
ALTER DATABASE 要清理的数据库名称 SET RECOVERY SIMPLE WITH NO_WAIT  
GO  
ALTER DATABASE 要清理的数据库名称 SET RECOVERY SIMPLE   --简单模式  
GO  
USE 要清理的数据库名称  
GO  
DBCC SHRINKFILE (N'要清理的数据库名称_log' , 2, TRUNCATEONLY)  --设置压缩后的日志大小为2M，可以自行指定  
GO  
USE[master]  
GO  
ALTER DATABASE 要清理的数据库名称 SET RECOVERY FULL WITH NO_WAIT  
GO  
ALTER DATABASE 要清理的数据库名称 SET RECOVERY FULL  --还原为完全模式  
GO
```

