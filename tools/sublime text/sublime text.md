# Sublime Text 2/3

## Package Control 无法安装插件[参考地址](https://www.jianshu.com/p/eb3924bc5708)

**1. 打开 Settings User**

打开 Sublime Text，选择 references -> Package Setting -> Package Control -> Settings User



![img](https://upload-images.jianshu.io/upload_images/3589738-115599e7e0262438.png?imageMogr2/auto-orient/strip|imageView2/2/w/654/format/webp)

![img](https://upload-images.jianshu.io/upload_images/3589738-f7440706327ae0f2.png?imageMogr2/auto-orient/strip|imageView2/2/w/1024/format/webp)

**2. 输入配置信息 打开配置文件后，输入 channels 信息**（请参考页面顶部路径说明 ，以线上地址为例）：



```bash
"channels": [
    "http://www.miaoqiyuan.cn/products/proxy.php/https://packagecontrol.io/channel_v3.json"
],
```

这里输入代码

![img](https://upload-images.jianshu.io/upload_images/3589738-a87b90d6f4284320.png?imageMogr2/auto-orient/strip|imageView2/2/w/760/format/webp)



**3. 保存后，Package Control 已经可以正常使用了**

![img](https:////upload-images.jianshu.io/upload_images/3589738-a46b5e48d8b32994.png?imageMogr2/auto-orient/strip|imageView2/2/w/736/format/webp)

项目已经在 Gitee.com 开源，可以直接去 https://gitee.com/mqycn/Proxy-for-Chinese-programmer/下载。

已经实现：

1、支持自动更新 虽然之前可以使用，但是因为 是手工保存到服务器静态文件，只能使用老的插件。现在设置的每两小时更新一次

2、在官网出现故障时仍能访问 在自动和官网同步时，会 判断 官网是否返回正确的代码

3、一套最好能支持多个代理 借用 PHP 的PATH_INFO，可以非常方面的传入任何 URL，可以对全网实现代理。当然，本程序也提供了白名单。

当然代理是有前提的：

1、对于被墙的代理，必须将域名放到 境外服务器

2、对于Sublime Text，服务器必须支持 IPv6

## 无法输入中文问题

### 命令安装

首先要确定系统已经安装 Fcitx 输入框架。

本方案来自 GitHub 项目 sublime-text-imfix ， 感谢 lyfeyaj 。

```bash
# 克隆项目到本地
git clone https://github.com/lyfeyaj/sublime-text-imfix.git1
# 进入项目文件夹
cd sublime-text-imfix
# 执行修复脚本
sudo ./sublime-imfix
# 然后静静等待即可。
# 成功
Done!
Thanks for using this script to fix CJK Input Method problem of SublimeText 2/3.
Re-login your X windows and start to use SublimeText 2/3 with Fcitx!
```

### 文件安装

```bash
# 下载文件
wget https://download.sublimetext.com/sublime_text_3_build_3126_x64.tar.bz2
# 解压
tar jxvf sublime_text_3_build_3126_x64.tar.bz2
# 修改文件夹名称
mv sublime_text_3 sublime_text
# 移动文件夹 
sudo mv sublime_text /opt/
# 显示图标
sudo mv /opt/sublime_text/sublime_text.desktop /usr/share/applications/
# 处理链接问题 在解决中文输入的时候需要使用
sudo ln -s /opt/sublime_text/sublime_text /usr/local/bin/subl
# 克隆项目到本地
git clone https://github.com/lyfeyaj/sublime-text-imfix.git1
# 进入项目文件夹
cd sublime-text-imfix
# 执行修复脚本
sudo ./sublime-imfix
# 然后静静等待即可。
# 成功结果
Done!
Thanks for using this script to fix CJK Input Method problem of SublimeText 2/3.
Re-login your X windows and start to use SublimeText 2/3 with Fcitx!
```

## sublime3 卡顿

### 启动卡顿

```json
{
"update_check": false,
"font_size": 10,
"draw_white_space": "all",
"word_wrap": false,
"spell_check": false,
"auto_indent": true,
"highlight_line": true,
"match_selection": true,
"translate_tabs_to_spaces": false,
"tab_size": 4,
"smart_indent": true,
"detect_indentation": true
}
```

### 编辑卡顿

"Sublime > Preferences > Package settings > GitGutter > Settings - User"

```json
{ "non_blocking" : "true", "live_mode" : "false" }
```

