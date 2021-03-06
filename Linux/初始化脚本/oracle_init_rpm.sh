# 依赖安装
yum install binutils-2.* compat-libstdc++-33* elfutils-libelf-0.* elfutils-libelf-devel* gcc-4.* gcc-c++-4.* glibc-2.* glibc-common-2.* glibc-devel-2.* glibc-headers-2.* ksh-2* libaio-0.* libaio-devel-0.* \
 libgcc-4.* libstdc++-4.* libstdc++-devel-4.* make-3.* sysstat.* unixODBC-2.* unixODBC-devel-2.* ksh*
# 依赖检查
rpm -qa binutils compat-libstdc++-33 elfutils-libelf elfutils-libelf-devel elfutils-libelf-devel-static gcc gcc-c++ glibc glibc-common glibc-devel glibc-headers glibc-static kernel-headers \
pdksh libaio libaio-devel libgcc libgomp libstdc++ libstdc++-devel libstdc++-static make numactl-devel sysstat unixODBC unixODBC-devel 


 yum -y install binutils compat-libstdc++-33 compat-libstdc++-33.i686 \
elfutils-libelf elfutils-libelf-devel gcc gcc-c++ glibc glibc.i686 glibc-common \
glibc-devel glibc-devel.i686 glibc-headers ksh libaio libaio.i686 libaio-devel \
libaio-devel.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel make \
sysstat unixODBC unixODBC-devel