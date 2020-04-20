# 自增长关闭开启

```sql

SET IDENTITY_INSERT SYS_MOD_POPEDOM ON  --关闭
INSERT INTO [dbo].[SYS_MOD_POPEDOM]
           ([ID],[MOD_ID]
           ,[MOD_LEVEL]
           ,[ROLE_ID]
           ,[POPEDOM_CODE]
           ,[MOD_PID]
           ,[MOD_URL])
           VALUES ( 0,0,1,2,null,null,'/home')
SET IDENTITY_INSERT SYS_MOD_POPEDOM ON  --关闭
```

### 自增长值重置

```sql
 DBCC CHECKIDENT('TableName', RESEED, 0)
```

