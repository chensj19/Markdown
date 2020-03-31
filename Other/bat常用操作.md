# 1、[批处理文件 bat 后台运行](https://www.cnblogs.com/sheng-247/p/10528160.html)

```bash
if "%1"=="hide" goto CmdBegin
start mshta vbscript:createobject("wscript.shell").run("""%~0"" hide",0)(window.close)&&exit
:CmdBegin
```

