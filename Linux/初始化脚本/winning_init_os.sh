#!/bin/bash
#
local_dir=$(pwd)
curl -o win60_yum_pkgs.tar http://121.196.37.116/source/init_system/win60_yum_pkgs.tar
curl -o data.zip http://121.196.37.116/source/db/data.zip
curl -o databases.zip http://121.196.37.116/source/db/databases.zip
curl -o decople.zip http://121.196.37.116/source/db/decople.zip
curl -o fhir-register.zip http://121.196.37.116/source/db/fhir-register.zip
curl -o fhir-drug.zip http://121.196.37.116/source/db/fhir-drug.zip
curl -o win60_register.zip http://121.196.37.116/source/db/win60_register.zip
curl -o win60_dcs.zip http://121.196.37.116/source/db/win60_dcs.zip
winning_rpm_pkgs=$(find $local_dir -name 'win60_yum_pkgs*.tar')
pkgs_dir=/data

# 磁盘大小最低要求(单位GB)低于指定大小将退出
disk_min_size=100
# ssh 登录端口
ssh_port=22
# 需要安装的基础软件包
#base_pkgs='vim dos2unix unzip ntpdate htop bc rsync lrzsz crontabs iftop telnet traceroute sysstat net-tools ansible bc ntp jdk vsftpd docker-ce docker-ce-cli containerd.io mariadb'
base_pkgs='vim dos2unix unzip ntpdate htop bc rsync lrzsz crontabs iftop telnet traceroute sysstat net-tools ansible bc ntp jdk mariadb'

# 获取本机IP
local_ip=$(ip a | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/')

Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}
Echo_Purple()
{
  echo $(Color_Text "$1" "35")
}
Echo_Red()
{
  echo $(Color_Text "$1" "31")
}
Echo_Green() {
    echo $(Color_Text "$1" "32")
}

# 将本机配置为yum源
yum_source_config () {
Echo_Purple "将本机配置为yum源"
#\cp ./winning_ansible/role/public/.main.bak ./winning_ansible/role/public/main.yml
#sed -i "s/YUM_SOURCE_IP/$local_ip/" ./winning_ansible/role/public/main.yml
yum_repos_dir=/etc/yum.repos.d
yum_bakcup_dir=$yum_repos_dir/backup
[[ ! -d $yum_bakcup_dir ]] && mkdir -p $yum_bakcup_dir
[[ -f $yum_repos_dir/winning.repo ]] && rm -f $yum_repos_dir/winning.repo
find_old_repo=$(find /etc/yum.repos.d/ -maxdepth 1 -name '*.repo' | grep -v winning)
if [ ! -z "$find_old_repo" ]; then
  mv $find_old_repo $yum_bakcup_dir/
fi
cat << EOF > $yum_repos_dir/winning.repo
[localrepo]
baseurl = file://$pkgs_dir
gpgcheck = 0
name = local repository
EOF
[[ ! -d $pkgs_dir ]] && mkdir -p $pkgs_dir
# 解压yum源
tar xf $winning_rpm_pkgs -C $pkgs_dir
nginx_pkg=$(find $pkgs_dir -name 'nginx*.rpm')
# 安装nginx
yum install -y $nginx_pkg > /dev/null 2>&1
systemctl start nginx
}

# 安装基础软件包
install_base_pkgs () {
for pkg in $(echo $base_pkgs); do
  Echo_Purple "安装中... $pkg:"
  yum install -y $pkg > /dev/null 2>&1
done
echo ''
}

# 配置 ansible
config_ansible () {
# ansible 常用配置
ansible_config=/etc/ansible/ansible.cfg
cat << EOF > $ansible_config
[defaults]
roles_path    = /etc/ansible/roles:/usr/share/ansible/roles
host_key_checking = False
pipelining = True
deprecation_warnings = False
gathering = smart
sh_args = -o ControlMaster=auto -o ControlPersist=5d
[inventory]
[privilege_escalation]
[paramiko_connection]
[ssh_connection]
[persistent_connection]
[accelerate]
[selinux]
[colors]
[diff]
EOF

ansible_hosts=/etc/ansible/hosts
cat << EOF > $ansible_hosts
[middle-master1]
$local_ip
EOF
}

# 配置 ftp 服务
config_ftp_server () {
ftp_config_file=/etc/vsftpd/vsftpd.conf
## 去掉前面的注释
#chroot_local_user=YES
#ascii_upload_enable=YES
#ascii_download_enable=YES
## 文件末尾添加
#allow_writeable_chroot=YES
sed -i "/chroot_local_user=/cchroot_local_user=YES" $ftp_config_file
sed -i "/ascii_upload_enable=/cascii_upload_enable=YES" $ftp_config_file
sed -i "/ascii_download_enable=/cascii_download_enable=YES" $ftp_config_file
echo "allow_writeable_chroot=YES" >> $ftp_config_file
systemctl enable vsftpd > /dev/null 2>&1
systemctl restart vsftpd
}

# 配置 ntp 服务
config_ntp_server () {
ntp_config=/etc/ntp.conf
cat << EOF > $ntp_config
driftfile /var/lib/ntp/drift
restrict default nomodify notrap nopeer noquery
restrict 127.0.0.1
restrict ::1
restrict 172.16.0.0 mask 255.255.0.0 nomodify notrap
server time1.aliyun.com
server ntp1.aliyun.com
server 0.centos.pool.ntp.org
restrict time1.aliyun.com  nomodify notrap noquery
restrict ntp1.aliyun.com  nomodify notrap noquery
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
disable monitor
# 没有联网只需添加以下两条即可
server 127.127.1.0
fudge 127.127.1.0 stratum 10
EOF
systemctl enable ntpd > /dev/null 2>&1
systemctl restart ntpd
}

# 配置 docker 
config_docker () {
docker_daemon_json=/etc/docker/daemon.json
[[ ! -d "/etc/docker" ]] && mkdir -p /etc/docker
cat  << EOF > $docker_daemon_json
{ 
    "insecure-registries": ["$local_ip:5000"], 
    "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"],
    "bip": "10.17.0.1/16"
}
EOF
cat  << EOF >  winning_ansible/role/public/files/
{ 
    "insecure-registries": ["$local_ip:5000"], 
    "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"],
    "bip": "10.17.0.1/16"
}
EOF

docker_service=/usr/lib/systemd/system/docker.service
ExecStart='ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock'
sed -i "/^ExecStart=/c$ExecStart" $docker_service

systemctl daemon-reload
systemctl enable docker > /dev/null 2>&1
systemctl restart docker
}
# 磁盘检测是否符合安装要求(需要安装bc)
check_disk_size () {
cur_disks=$(fdisk -l | grep '^Disk /dev' | grep -v '/dev/mapper' | grep 'GB,' | cut -d ' ' -f3 | awk -F 'GB,' '{print $1}')
for disk in $(echo $cur_disks); do
echo 
done
}

# 生成 ssh key
create_ssh_key () {
key_dir=~/.ssh
key_name=id_rsa
key_bits=4096
key_auth=authorized_keys
[[ ! -d $key_dir ]] && mkdir -p $key_dir
if [ ! -f $key_dir/$key_name ]; then
  ssh-keygen -b $key_bits -t rsa -f $key_dir/$key_name -P "" 
  #mv $key_dir/$key_name.pub $key_dir/$key_auth
fi
#\cp -r ./.ssh ~/
}

# 运行用户配置
config_running_user () {
echo '---' > user_info.txt
for user in winning winsupport; do
  if ! id $user > /dev/null 2>&1 ; then
    # 生成一个只用左手就能输入的8位密码
    #user_pass=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c8 ; echo)
    user_pass='Win.2021'
    case $user in
      ftpuser) 
         useradd -d /home/vsftpd -s /usr/sbin/nologin $user 
         echo "/usr/sbin/nologin" >> /etc/shells
         mkdir -p /home/vsftpd/{pro,product_list}
         chmod -R 777 /home/vsftpd
      ;; 
      *) useradd $user
    esac
    echo "$user":"$user_pass" | chpasswd
    Echo_Purple "$user创建完成 登录密码: $user_pass 如果忘记可查看文件:user_info.txt"
    echo "用户:$user 密码: $user_pass 创建完成" >> user_info.txt
    # 添加sudo权限
    case $user in
      winning)
               # 禁止winning用户使用关机重启等命令
               sed -i '/^Cmnd_Alias SHUTDOWN=/d' /etc/sudoers
               sed -i '/^winning ALL/d' /etc/sudoers
               echo -e "Cmnd_Alias SHUTDOWN=/usr/sbin/shutdown,/usr/sbin/reboot,/usr/sbin/halt,/usr/sbin/poweroff\n$user ALL=(ALL) NOPASSWD:ALL ,!SHUTDOWN" >> /etc/sudoers
      ;;
      winsupport)
               sed -i '/^winsupport ALL/d' /etc/sudoers
               echo -e "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
      ;;
    esac
  else
    Echo_Green "$user 已经创建 重新修改密码 添加sudo权限"
    # 生成一个只用左手就能输入的8位密码
    #user_pass=$(</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c8 ; echo) 
    user_pass='Win.2021'
    echo "$user":"$user_pass" | chpasswd
    echo "用户:$user 密码: $user_pass 密码修改完成" >> user_info.txt
    # 添加sudo权限
    case $user in
      winning)
               # 禁止winning用户使用关机重启等命令
               sed -i '/^Cmnd_Alias SHUTDOWN=/d' /etc/sudoers
               sed -i '/^winning ALL/d' /etc/sudoers
               echo -e "Cmnd_Alias SHUTDOWN=/usr/sbin/shutdown,/usr/sbin/reboot,/usr/sbin/halt,/usr/sbin/poweroff\n$user ALL=(ALL) NOPASSWD:ALL ,!SHUTDOWN" >> /etc/sudoers
      ;;
      winsupport)
               sed -i '/^winsupport ALL/d' /etc/sudoers
               echo -e "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
      ;;
    esac
  fi
done
unset user
# 锁定部分用户
Echo_Purple "锁定用户如下:"
lock_users='sync halt ftp mail sshd dbus daemon adm lp operator games nobody sshd'
for user in $(echo $lock_users); do
  echo -e "|$user\c"
  passwd -l $user > /dev/null 2>&1
done
unset user
echo
}

# 防火墙配置(目前不做配置只关闭)
config_firewalld () {
#open_ports='
#80
#6379
#9200
#15672
#'
#for port in $(echo $open_ports) ; do
#  Echo_Purple "打开端口$port/tcp"
#  firewall-cmd --zone=public --add-port=$port/tcp --permanent
#done
#firewall-cmd --reload
#firewall-cmd --list-ports
Echo_Purple "关闭系统防火墙"
systemctl stop firewalld > /dev/null 2>&1
systemctl disable firewalld > /dev/null 2>&1
}

config_sys_common () {
# 时间时区设置
Echo_Purple "设置时区为东8区上海"
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 关闭selinux
Echo_Purple "关闭selinux"
sed -i '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
# 系统字符集配置
Echo_Purple "系统字符集配置为: en_US.UTF-8"
localectl set-locale LANG=en_US.UTF-8

# 历史命令加时间戳保存长度为10万
histsize_is_exists=$(cat /etc/bashrc | grep 'HISTSIZE=100000')
if [ -z "$histsize_is_exists" ]; then
Echo_Purple "历史命令加时间戳保存数量10万"
echo '
export HISTSIZE=100000
export HISTTIMEFORMAT="%F %T "
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
unset HISTCONTROL' >> /etc/bashrc
fi

# config max user processes to 123456
softfile_limit_exists=$(cat /etc/security/limits.conf | grep '808888')
if [ -z "$softfile_limit_exists" ]; then
echo '
* soft nproc 808888
* soft nofile 808888
* hard nproc 808888
* hard nofile 808888
* soft sigpending 199999
* hard sigpending 199999' >> /etc/security/limits.conf
sed -i 's/4096/808888/' /etc/security/limits.d/20-nproc.conf
fi

# config sshd_config
cat << EOF > /etc/ssh/sshd_config
#   \$OpenBSD: sshd_config,v 1.80 2008/07/02 02:24:18 djm Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/bin:/usr/bin

Port 22
Protocol 2
SyslogFacility AUTHPRIV
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication yes

ChallengeResponseAuthentication no

GSSAPIAuthentication no
GSSAPICleanupCredentials yes
UsePAM yes

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

X11Forwarding yes
PrintMotd yes
UseDNS no

# override default of no subsystems
Subsystem sftp  /usr/libexec/openssh/sftp-server
EOF
#\cp /etc/ssh/sshd_config winning_ansible/role/public/files/config_sshd
}

config_sys_kernel () {
# 内核参数配置
Echo_Purple "配置内核参数"
sys_conf_sysctl=/etc/sysctl.conf
sys_kernel_config_exists=$(cat $sys_conf_sysctl | grep 'vm.max_map_count')
if [ -z "$sys_kernel_config_exists" ]; then
echo '
kernel.pid_max = 65536
vm.max_map_count = 655300
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 15
# 下面主要是内核参数的优化，包括tcp的快速释放和重利用等。
net.ipv4.tcp_max_syn_backlog = 65536
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 32768

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800

#net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 50000  65535
# 以上信息卸载nginx后删除' >> $sys_conf_sysctl
#sysctl -p > /dev/null 2>&1
sysctl -p
fi
#\cp $sys_conf_sysctl winning_ansible/role/public/files/config_sys_kernel
}

# 重启机器
need_retart () {
read -p "重启机器,默认(yes),不需要[N/n]: " need_restart
case $need_restart in
	[Nn]|[Nn][Oo])
		exit 1
	;;
	*)
		shutdown -r now
esac
}

# -------- 脚本执行入口 --------- #
yum_source_config
install_base_pkgs
config_ansible
#config_ftp_server
config_ntp_server
#config_docker
#check_disk_size
Echo_Green "create ssh key"
create_ssh_key 1 > /dev/null
Echo_Red "请使用私钥登录 ~/.ssh/id_rsa"
config_firewalld
config_running_user
config_sys_common
config_sys_kernel
need_retart
