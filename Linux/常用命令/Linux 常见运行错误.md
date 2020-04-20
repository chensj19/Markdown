# Linux常见运行错误

## 1. systemctl服务部署错误：code=exited, status=217/USER

```bash
跑服务的时候报错了：

Process: 2451 ExecStart=/home/.virtualenvs/bin/python /home/xxx.py (code=exited, status=217/USER)

仔细一看原来原来service文件的用户名没改，难怪提示217/USER错误呢，把用户名改对就好了，服务顺利跑起来了

[Unit]
Description=xxx
After=network.target

[Service]
WorkingDirectory=/home/deploy/server
User=xxx
ExecStart=/home/.virtualenvs/bin/python /home/deploy/server/xxx.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

