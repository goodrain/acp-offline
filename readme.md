# 云帮（ACP）离线自动化安装程序

## 一、安装管理节点

### 1.1 准备工作（重要）

- 设置主机名，并将本机IP与主机名的对应关系写到`/etc/hosts` 文件中
- 将本机ip设置为静态IP，并添加默认路由
- 保证云帮主机时间同步

### 1.2 安装

#### 初始化环境

```bash
./acp_install.sh manage

Check default gateway...
Default Gateway: 172.16.130.1
172.16.130.132
Check unnecessary service...
disable firewalld
disable NetworkManager

Clear system default repo and add goodrain repo? (y|n): y
Make docker storage device? (Y|N):y

NAME HCTL       TYPE VENDOR   MODEL             REV TRAN
sda  2:0:0:0    disk VMware,  VMware Virtual S 1.0  spi
sdb  2:0:1:0    disk VMware,  VMware Virtual S 1.0  spi
sr0  1:0:0:0    rom  NECVMWar VMware IDE CDR10 1.00 ata

Are you sure use [sdb] for docker storage? (Y|N):y

Do you want to restrict the use of container swap? (Y|N) [Y]:

# 修改完后需要重启，重启后继续执行  ./01_init.sh manage 之前的步骤可以按n略过

Modify /etc/hosts file add goodrain.com and hub.goodrain.com? (y|n):y

Install Docker? (y|n):y

Do you want to run the docker registry? (y|n):y

Load images? (y|n):y
Push images? (y|n):y

# 后续都是自动安装
```



##  二、安装计算节点

### 2.1 准备工作

- 设置主机名，并将本机IP与主机名的对应关系写到`/etc/hosts` 文件中
- 将本机ip设置为静态IP，并添加默认路由

### 2.2 安装

#### 初始化环境

```bash
./acp_install.sh compute

Check default gateway...
Default Gateway: 172.16.130.1
172.16.130.132
Check unnecessary service...
disable firewalld
disable NetworkManager

Clear system default repo and add goodrain repo? (y|n): y
Make docker storage device? (Y|N):y

NAME HCTL       TYPE VENDOR   MODEL             REV TRAN
sda  2:0:0:0    disk VMware,  VMware Virtual S 1.0  spi
sdb  2:0:1:0    disk VMware,  VMware Virtual S 1.0  spi
sr0  1:0:0:0    rom  NECVMWar VMware IDE CDR10 1.00 ata

Are you sure use [sdb] for docker storage? (Y|N):y

Modify /etc/hosts file add hub.goodrain.com? (y|n):y

Install Docker? (y|n):y
Load images? (y|n):y

# 后续都是自动安装
```



## 三、导入常用应用镜像



## 四、对接Git Server