# [Centos7扩展磁盘空间](https://blog.csdn.net/liulu07/article/details/81865502)

1. 查看磁盘并创建新分区
   查看磁盘情况

   ```bash
   fdisk -l
   ```

   ```bash
   Disk /dev/sda: 85.9 GB, 85899345920 bytes, 167772160 sectors
   #磁盘大小
   Units = sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disk label type: dos
   Disk identifier: 0x000bea13
   
      Device Boot      Start         End      Blocks   Id  System
   /dev/sda1   *        2048     2099199     1048576   83  Linux
   /dev/sda2         2099200    83886079    40893440   8e  Linux LVM
   
   Disk /dev/mapper/centos-root: 39.7 GB, 39720058880 bytes, 77578240 
   #分区大小
   sectors
   Units = sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   
   
   Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
   Units = sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   ```

2. 创建新分区
   ```bash
   fdisk /dev/sda
   ```
   
   ```bash
   Welcome to fdisk (util-linux 2.23.2).
   
   Changes will remain in memory only, until you decide to write them.
   Be careful before using the write command.
   
   
   Command (m for help): n              #n创建新分区
   Partition type:
      p   primary (2 primary, 0 extended, 2 free)
      e   extended
   Select (default p): p                #p分区类型
   Partition number (3,4, default 3):   #直接回车
   First sector (83886080-167772159, default 83886080):    #直接回车
   Using default value 83886080
   Last sector, +sectors or +size{K,M,G} (83886080-167772159, default 167772159):                          #直接回车
   Using default value 167772159
   Partition 3 of type Linux and of size 40 GiB is set
   Command (m for help): w              #w保存并退出
   The partition table has been altered!
   Calling ioctl() to re-read partition table.
   ```
   
   
   > 如果 出现需要重新启动电脑
   >
   > ```ba
   > WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
   > The kernel still uses the old table. The new table will be used at
   > the next reboot or after you run partprobe(8) or kpartx(8)
   > ```
   >
   > ```bash
   > reboot
   > ```



3. 再次查看分区

   ```bash 
   fdisk -l
   ```

```bash
Disk /dev/sda: 85.9 GB, 85899345920 bytes, 167772160 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000bea13

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    83886079    40893440   8e  Linux LVM
/dev/sda3        83886080   167772159    41943040   83  Linux
#新增加磁盘分区 /dev/sda3 ,创建物理卷时使用
Disk /dev/mapper/centos-root: 39.7 GB, 39720058880 bytes, 77578240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
```

4. 创建物理卷并扩展卷组

   > 查看卷组名称及大小
   ```bash 
   vgdisplay
   ```
   
   ```bash
     --- Volume group ---
    VG Name               centos               #名称
    System ID             
    Format                lvm2
    Metadata Areas        1
    Metadata Sequence No  3
    VG Access             read/write
    VG Status             resizable
    MAX LV                0
    Cur LV                2
    Open LV               2
    Max PV                0
    Cur PV                1
    Act PV                1
    VG Size               <39.00 GiB大        #当前大小
    PE Size               4.00 MiB
    Total PE              9983
    Alloc PE / Size       9982 / 38.99 GiB    #已分配
    Free  PE / Size       1 / 4.00 MiB        #空闲大小扩展分区时使用
    VG UUID               HxuBfE-HjMo-oukD-Xx5T-g6zH-gjfE-pT48Kl
   ```


5. 创建卷
   ```bash
     pvcreate /dev/sda3
     Physical volume "/dev/sda3" successfully created.
   ```

6. 扩展卷组
   ```bash
     vgextend centos /dev/sda3
     Volume group "centos" successfully extended
   ```

7. 查看物理卷
   ```bash
   pvdisplay
     --- Physical volume ---
     PV Name               /dev/sda2
     VG Name               centos
     PV Size               <39.00 GiB / not usable 3.00 MiB
     Allocatable           yes 
     PE Size               4.00 MiB
     Total PE              9983
     Free PE               1
     Allocated PE          9982
     PV UUID               1syFwI-rpjc-O1Ws-xGql-GC3o-tAml-OQIDsb
   
     --- Physical volume ---
     PV Name               /dev/sda3
     VG Name               centos
     PV Size               40.00 GiB / not usable 4.00 MiB
     Allocatable           yes 
     PE Size               4.00 MiB
     Total PE              10239
     Free PE               10239
     Allocated PE          0
     PV UUID               wdIz6w-kwrN-BfcE-ECB1-JtdQ-PB5a-vcK0Eo
   ```

8. 扩展逻辑卷

   ```bash
   #查看磁盘分区大小
   df -h
   Filesystem               Size  Used Avail Use% Mounted on
   /dev/mapper/centos-root   37G  1.5G   36G   5% /      #需要扩展的分区
   devtmpfs                 7.8G     0  7.8G   0% /dev
   tmpfs                    7.8G     0  7.8G   0% /dev/shm
   tmpfs                    7.8G  8.8M  7.8G   1% /run
   tmpfs                    7.8G     0  7.8G   0% /sys/fs/cgroup
   /dev/sda1               1014M  265M  750M  27% /boot
   tmpfs                    1.6G     0  1.6G   0% /run/user/0
   
   #查看当前逻辑卷的名称及空间大小
   lvdisplay
     --- Logical volume ---
     LV Path                /dev/centos/swap
     LV Name                swap
     VG Name                centos
     LV UUID                4PsjOD-0ASJ-ksHY-cK0w-HScG-Kg71-oGTMF3
     LV Write Access        read/write
     LV Creation host, time localhost, 2018-05-15 05:16:38 -0400
     LV Status              available
     # open                 2
     LV Size                2.00 GiB
     Current LE             512
     Segments               1
     Allocation             inherit
     Read ahead sectors     auto
    1. currently set to     8192
     Block device           253:1
   
     --- Logical volume ---
     LV Path                /dev/centos/root    #需要扩展的逻辑卷
     LV Name                root
     VG Name                centos
     LV UUID                h2q8Cv-Whlf-3Aav-80bd-14XC-1Cfg-wviAPB
     LV Write Access        read/write
     LV Creation host, time localhost, 2018-05-15 05:16:39 -0400
     LV Status              available
     # open                 1
     LV Size                36.99 GiB
     Current LE             9470
     Segments               1
     Allocation             inherit
     Read ahead sectors     auto
    2. currently set to     8192
     Block device           253:0
   ```

   

9. 扩展分区大小
```bash
# 扩展分区
lvextend -l +10240 /dev/centos/root
# +10240本次增加的容量，数值见查看卷组名称及大小vgdisplay
Size of logical volume centos/root changed from <40.90 GiB (10470 extents) to 76.99 GiB (19710 extents).
  Logical volume centos/root successfully resized.

# 调整文件系统大小 ext2、ext3、ext4文件系统
resize2fs -f /dev/centos/root

# 调整文件系统大小 xfs文件系统
xfs_growfs /dev/centos/root

# 查询分区大小
df -h

Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root   77G  1.5G   76G   2% /      #大小已经调整到位
devtmpfs                 7.8G     0  7.8G   0% /dev
tmpfs                    7.8G     0  7.8G   0% /dev/shm
tmpfs                    7.8G  8.8M  7.8G   1% /run
tmpfs                    7.8G     0  7.8G   0% /sys/fs/cgroup
/dev/sda1               1014M  265M  750M  27% /boot
tmpfs                    1.6G     0  1.6G   0% /run/user/0
```