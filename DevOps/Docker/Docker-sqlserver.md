# Docker sqlserver

1. 初始化系统

   ```bash
   mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
   mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
   mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
   curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
   curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
   sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
   sudo yum clean all && yum makecache
   sudo yum install -y yum-utils device-mapper-persistent-data lvm2 unzip zip vim wget net-tools htop nmon 
   sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
   sudo sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
   sudo yum makecache fast
   sed -i '/^SELINUX=/cSELINUX=disabled' /etc/selinux/config
   sudo yum remove docker docker-common container-selinux docker-selinux docker-engine
   sudo yum -y install docker-ce
   sudo systemctl enable docker
   sudo systemctl start docker
   sudo systemctl disable firewalld
   sudo systemctl stop firewalld
   curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
   ```

2. 拉取镜像

   ```bash
   # 2017
   sudo docker pull mcr.microsoft.com/mssql/server:2017-latest
   #2019
   sudo docker pull mcr.microsoft.com/mssql/server:2019-latest
   ```

2. 启动

   ```bash
   docker run --name mssql \
      -h mssql --restart=always\
      -e ACCEPT_EULA='Y' \
      -e SA_PASSWORD='Winning2019..' \
      -e MSSQL_LCID=2052 \
      -e TZ='Asia/Shanghai' \
      -e MSSQL_COLLATION='Chinese_PRC_BIN' \
      -e MSSQL_DATA_DIR='/var/opt/mssql/data' \
      -e MSSQL_BACKUP_DIR='/var/opt/mssql/backup' \
      -e MSSQL_LOG_DIR='/var/opt/mssql/data' \
      -p 1433:1433 \
      --privileged=true \
      -v mssql_data_2019:/var/opt/mssql \
      -d mcr.microsoft.com/mssql/server:2019-latest
   ```
   > --name mssql_2019:  为容器名,自己手动指定一个 
   >
   > -h mssql-2019:  为容器内的主机名,我设置的同容器名，避免混淆
   >
   > -v mssql_data_2019:/var/opt/mssql     使用-v参数指定了mssql_data_2019目录挂载到容器的/var/opt/mssql目录
   >
   > 1. 坑点: 挂载目录要为根目录才可以, 这…,     也许是我还没有找到可以正确挂载非根目录的方法.
   > 2. 实际挂载的目录为: /var/lib/docker/volumes/mssql_data_2019, 这也是坑点
   >
   > -p 51433:1433     为容器转发端口,前者为宿主机端口，后者为Sqlserver默认端口 
   >
   > | 配置             | 说明                                                         |
   > | :--------------- | :----------------------------------------------------------- |
   > | ACCEPT_EULA      | 在设置为任何值（例如“Y”）时接受 SQL Server 许可协议。        |
   > | SA_PASSWORD      | sa用户密码                                                   |
   > | MSSQL_COLLATION  | 默认排序规则                                                 |
   > | MSSQL_LCID       | 默认语言编号，简体中文为2052（https://docs.microsoft.com/zh-cn/sql/relational-databases/system-compatibility-views/sys-syslanguages-transact-sql?view=sql-server-2017） |
   > | MSSQL_DATA_DIR   | 更改创建新 SQL Server 数据库数据文件 (.mdf) 的目录。         |
   > | MSSQL_LOG_DIR    | 更改在其中创建新的 SQL Server 数据库日志 (.ldf) 文件的目录。 |
   > | MSSQL_BACKUP_DIR | 设置默认备份目录位置。                                       |
   >
   > https://docs.microsoft.com/zh-cn/sql/linux/sql-server-linux-overview?view=sql-server-2017
   >
   > https://docs.microsoft.com/zh-cn/sql/linux/sql-server-linux-overview?view=sql-server-2019
   
4. 还原数据库

   ```bash
   sudo docker cp dev_aio_backup_2021_12_29_000045_0914493.bak mssql_2019:/var/opt/mssql/backup
   docker exec -it mssql_2019 /opt/mssql-tools/bin/sqlcmd -S localhost \
      -U sa -P 'Chenshijie1988..' \
      -Q 'RESTORE DATABASE dev_aio FROM DISK = "/var/opt/mssql/backup/dev_aio_backup_2022_03_01_000151_5341516.bak" WITH MOVE "his_dev_ipt_202011210" TO  "/var/opt/mssql/data/dev_aio_20220301.mdf", MOVE "his_dev_ipt_202011210_log" TO "/var/opt/mssql/data/dev_aio_20220301_log.mdf"'
      
      
   sudo docker cp THIS4_RC_backup_2021_12_29_000055_9638284.bak mssql_2019:/var/opt/mssql/backup
   docker exec -it mssql_2019 /opt/mssql-tools/bin/sqlcmd -S localhost \
      -U sa -P 'Chenshijie1988..' \
      -Q 'RESTORE DATABASE THIS4_RC FROM DISK = "/var/opt/mssql/backup/THIS4_RC_backup_2021_12_29_000055_9638284.bak" WITH MOVE "SAMPLE_Data" TO  "/var/opt/mssql/data/THIS4_RC.mdf", MOVE "SAMPLE_Log" TO "/var/opt/mssql/data/THIS4_RC_log.mdf"'
      
   
   sudo docker cp qa_aio_backup_2022_01_12_000128_7812236.bak mssql_2019:/var/opt/mssql/backup
   docker exec -it mssql_2019 /opt/mssql-tools/bin/sqlcmd -S localhost \
      -U sa -P 'Chenshijie1988..' \
      -Q 'RESTORE DATABASE qa_aio FROM DISK = "/var/opt/mssql/backup/qa_aio_backup_2022_01_12_000128_7812236.bak" WITH MOVE "his_dev_ipt_202011210" TO  "/var/opt/mssql/data/qa_aio.mdf", MOVE "his_dev_ipt_202011210_log" TO "/var/opt/mssql/data/qa_aio_log.mdf"'
   
   sudo docker cp THIS4_LYLT_backup_2022_01_12_000128_7806782.bak mssql_2019:/var/opt/mssql/backup
   docker exec -it mssql_2019 /opt/mssql-tools/bin/sqlcmd -S localhost \
      -U sa -P 'Chenshijie1988..' \
      -Q 'RESTORE DATABASE THIS4_LYLT FROM DISK = "/var/opt/mssql/backup/THIS4_LYLT_backup_2022_01_12_000128_7806782.bak" WITH MOVE "SAMPLE_Data" TO  "/var/opt/mssql/data/THIS4_LYLT.mdf", MOVE "SAMPLE_Log" TO "/var/opt/mssql/data/THIS4_LYLT_log.mdf"'
   ```
   
   

