# GitHub 常见问题处理

## 无法访问，dns问题，设置hosts文件

```bash
# 通过使用http://ping.chinaz.com/ ping github.com等网站获取响应最快的ip
# Github Hosts
# domain: github.com
20.205.243.166 github.com
20.205.243.165 nodeload.github.com
20.205.243.168 api.github.com
20.205.243.165 codeload.github.com
185.199.108.133 raw.github.com
185.199.108.153 training.github.com
185.199.108.153 assets-cdn.github.com
185.199.108.153 documentcloud.github.com
140.82.114.17 help.github.com

# domain: githubstatus.com
185.199.108.153 githubstatus.com

# domain: fastly.net
#199.232.69.194 github.global.ssl.fastly.net
31.13.95.35  github.global.ssl.fastly.net

# domain: githubusercontent.com
185.199.108.133 raw.githubusercontent.com
185.199.108.154 pkg-containers.githubusercontent.com
185.199.108.133 cloud.githubusercontent.com
185.199.108.133 gist.githubusercontent.com
185.199.108.133 marketplace-screenshots.githubusercontent.com
185.199.108.133 repository-images.githubusercontent.com
185.199.108.133 user-images.githubusercontent.com
185.199.108.133 desktop.githubusercontent.com
185.199.108.133 avatars.githubusercontent.com
185.199.108.133 avatars0.githubusercontent.com
185.199.108.133 avatars1.githubusercontent.com
185.199.108.133 avatars2.githubusercontent.com
185.199.108.133 avatars3.githubusercontent.com
185.199.108.133 avatars4.githubusercontent.com
185.199.108.133 avatars5.githubusercontent.com
185.199.108.133 avatars6.githubusercontent.com
185.199.108.133 avatars7.githubusercontent.com
185.199.108.133 avatars8.githubusercontent.com
# End of the section

# windows
C:\Windows\System32\drivers\etc\hosts
# 刷新网络 DNS 缓存
ipconfig /flushdns
# mac/linux
sudo vi /etc/hosts
# 刷新网络 DNS 缓存
sudo killall -HUP mDNSResponder
```

