#!/bin/bash

# 获取本机dc-agent的ip和id
HOST_UUID=$(dc-ctl get node --self --field id)
HOST_IP=$(dc-ctl get node --self --field ipaddress)

# remove old hosts
sed  -i "/$HOST_IP/d" /etc/hosts

# 清理数据库
dc-ctl clean db

# 下线节点 （停服务calico、kubelet、docker、etcd, 取消开机启动）
dc-ctl drain node $HOST_UUID

# 删除数据文件 (/grdata/tenant, /cache/build, /logs等)
dc-ctl clean files

# 设置域名为空
dc-ctl clean domain

# 清除etcd中calico和k8s元数据
dc-ctl clean metadata

# 替换配置文件中本机ip
grep $HOST_IP /etc/goodrain/ -R | awk -F : '{print $1}' | uniq | xargs sed -i "s/$HOST_IP/NEED_IP_MODIFY/"
sed -i "s/$HOST_IP/NEED_IP_MODIFY/" /etc/default/etcd /etc/default/kubelet /etc/default/dc-agent

# 重置集群配置状态
[ -f /etc/goodrain/.inited ] && rm -f /etc/goodrain/.inited
[ -f /root/ACP_VERSION ] && rm -f /root/ACP_VERSION
[ -f /root/acp_init.log ] && rm -f /root/acp_init.log
