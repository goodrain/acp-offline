# 云帮（ACP）离线自动化安装程序

## 零、下载离线安装包

### 0.1 下载离线安装脚本

```bash
git clone --recursive https://github.com/goodrain/acp-offline.git
```



### 0.2 下载镜像及安装包

```bash
cd acp-offline
./tools/oss_download.sh

# 下载完成后，acp-offline 会多出
# acpimg 和 repo 目录
```



## 一、安装管理节点

### 1.1 准备工作（重要）

- 设置主机名，并将本机IP与主机名的对应关系写到`/etc/hosts` 文件中
- 保证`127.0.0.1   localhost` 在 `/etc/hosts` 有记录（localhost 解析到 127.0.0.1）
- 将本机ip设置为静态IP，并添加默认路由
- 保证云帮主机时间同步

### 1.2 安装

#### 初始化环境

```bash
# 指定本机ip
export LOCAL_IP=本机ip地址

./setup.sh manage

Check default gateway...
Default Gateway: 172.16.130.1
172.16.130.132
Check unnecessary service...
disable firewalld
disable NetworkManager

# 清理当前系统的repo文件，并写入goodrain本地repo配置
Clear system default repo and add goodrain repo? (y|n): y

# 制作docker的存储磁盘
Make docker storage device? (Y|N):y

NAME HCTL       TYPE VENDOR   MODEL             REV TRAN
sda  2:0:0:0    disk VMware,  VMware Virtual S 1.0  spi
sdb  2:0:1:0    disk VMware,  VMware Virtual S 1.0  spi
sr0  1:0:0:0    rom  NECVMWar VMware IDE CDR10 1.00 ata
# 选择一块单独的磁盘，或者分区作为docker的存储
Please select device for docker storage device:sdb

# 确认选择
Are you sure use [sdb] for docker storage? (Y|N):y

# 修改内核启动参数，支持docker限制swap
Do you want to restrict the use of container swap? (Y|N) [Y]:

# 修改完后需要重启，如果这里不重启，建议安装云帮后重启系统
The operation need to restart the system, restart now? (Y|N) [Y]:n

# 修改hosts文件添加  goodrain.me 和 hub.goodrain.com 解析
Modify /etc/hosts file add goodrain.com and hub.goodrain.com? (y|n):y

# 安装docker
Install Docker? (y|n):y

# 临时运行 docker registry
Do you want to run the docker registry? (y|n):y

# 载入镜像
Load images? (y|n):y

# 推送镜像
Push images? (y|n):y

# 输入平台应用的泛解析域名
setup wild_domain for this region, like '<name>.goodrain.org' : a.b.test
```



##  二、安装计算节点

### 2.1 准备工作

- 设置主机名，并将本机IP与主机名的对应关系写到`/etc/hosts` 文件中
- 将本机ip设置为静态IP，并添加默认路由

### 2.2 安装

#### 初始化环境

```bash
./setup.sh compute

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

### 3.1 先导入镜像相关的sql数据

```bash
./modules/acp_db/sql/import_sql.sh
```

### 3.2 导入应用镜像

```bash
cd appimg

# 这个目录都是云市的应用，请根据需要载入镜像，下面演示载入 redis 镜像的方式
cat redis_2.8_latest.gz | docker load
7bd83cd74630: Loading layer [==================================================>]  89.96MB/89.96MB
c21dce5daf56: Loading layer [==================================================>]  3.072kB/3.072kB
746584cb6ef2: Loading layer [==================================================>]  840.7kB/840.7kB
8d73285dfb30: Loading layer [==================================================>]  78.85kB/78.85kB
5f70bf18a086: Loading layer [==================================================>]  1.024kB/1.024kB
adb554e8a8c3: Loading layer [==================================================>]  840.7kB/840.7kB
b98f86b543fc: Loading layer [==================================================>]   14.9MB/14.9MB
74d4af4bc485: Loading layer [==================================================>]  131.1kB/131.1kB
92d565a5ef3c: Loading layer [==================================================>]  2.703MB/2.703MB
7c51b258e593: Loading layer [==================================================>]  23.46MB/23.46MB
5e8970990afa: Loading layer [==================================================>]  3.584kB/3.584kB
a94d90ca831e: Loading layer [==================================================>]  1.536kB/1.536kB
Loaded image: goodrain.me/redis:2.8_latest    # 注意这一行

# 将镜像推送到本地docker仓库
docker push goodrain.me/redis:2.8_latest 

# 其他计算节点拉取镜像
docker pull goodrain.me/redis:2.8_latest 
```



## 四、对接Git Server