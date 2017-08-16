#!/bin/bash

set -x

ACP_VERSION="2017.07"

export PATH=$PATH:/usr/local/bin

# not first boot
[ -f /etc/goodrain/.inited ] && exit 0

# get local ip
LOCAL_IP=$(ip ad | grep 'inet '| awk '{print $2}' | cut -d '/' -f 1 | egrep '^(10\.)|(172\.1[6-9])|(172\.2[0-9])|(192\.168)' | head -1)

# modify etcd ip
sed -i "s/NEED_IP_MODIFY/$LOCAL_IP/" /usr/share/gr-etcd/scripts/start.sh
sed -i "s/NEED_HOSTNAME_MODIFY/$(hostname -s)/" /usr/share/gr-etcd/scripts/start.sh

# change config IP
grep NEED_IP_MODIFY /etc/goodrain/ -R | awk -F : '{print $1}' | uniq | xargs sed -i "s/NEED_IP_MODIFY/$LOCAL_IP/"

# change local dns
sed -i "2 i\nameserver $LOCAL_IP" /etc/resolv.conf


# start service 
systemctl enable etcd
systemctl start etcd

systemctl enable docker
systemctl start docker


# start dc-agent，will auto update ip
systemctl enable dc-agent
systemctl start dc-agent

HOST_UUID=$(dc-ctl get node --self --field id)

# update dc-deploy matedata and *.goodrain.me

dc-ctl update node $HOST_UUID

# start container
dc-compose up -d

# update dns and calico
dc-ctl init --redo

# start calico、kubelet and set start on boot
dc-ctl enable node $HOST_UUID

echo $ACP_VERSION > /root/ACP_VERSION
echo "ACP PaaS is ready." && touch /etc/goodrain/.inited
