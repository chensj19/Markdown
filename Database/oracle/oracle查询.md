# oracle查询

1. 死锁查询

```sql
select sess.sid,sess.serial#, lo.oracle_username,lo.os_user_name, ao.object_name,lo.locked_mode  
from v$locked_object lo,dba_objects ao,v$session sess where ao.object_id=lo.object_id and lo.session_id=sess.sid;
-- kill
alter system kill session '187,50331';
```

