```sql
USE [master]
GO
ALTER DATABASE win60_standard_v2 SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
EXEC sp_renamedb 'win60_standard_v2', 'win60_standard_v2_20210526' 
EXEC sp_dboption 'win60_standard_v2_20210526', 'Single User', 'FALSE' 
```

