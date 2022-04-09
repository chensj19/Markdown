# pg常用脚本

## 备份

```bash
pg_dump -h 127.0.0.1 -p 5432 -U winning  win60_dcs > db_bak.sql
// -h 主机
// -p 端口
// -U 用户
```

