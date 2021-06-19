# MAC JDK 卸载方法

1. 打开终端

2. 输入 

   ```bash
    sudo rm -fr /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin 
    sudo rm -fr /Library/PreferencesPanes/JavaControlPanel.prefpane
   ```

3 . 查找当前版本 

```bash
ls /Library/Java/JavaVirtualMachines/ 
jdk-9.0.1.jdk
sudo rm -rf /Library/Java/JavaVirtualMachines/jdk-9.0.1.jdk      
```

  