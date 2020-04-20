# [VSCode与Deepin资源管理器冲突](https://www.cnblogs.com/jason1990/p/10161195.html)

解决方式：

```bash
xdg-mime default dde-file-manager.desktop inode/directory
```

此外，网上有较多推荐(在`deepin 15.8`版本上测试无效)：

```bash
gvfs-mime --set inode/directory dde-file-manager.desktop
```
使用上述命令即可完成更改打开文件夹选项



### 开机命令行

```bash
$ sudo systemctl disable lightdm
sudo systemctl enable lightdm
```

