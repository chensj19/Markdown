echo 'TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="b8a3eb1d-b5b7-4e48-829e-ab300767e0ac"
DEVICE="ens33"
ONBOOT="yes"
IPADDR="192.168.31.61"
BROADCAST="192.168.31.255"
NETMASK=255.255.255.0
GATEWAY=192.168.31.1
DNS1=114.114.114.114' > /etc/sysconfig/network-scripts/ifcfg-ens33
systemctl restart network





