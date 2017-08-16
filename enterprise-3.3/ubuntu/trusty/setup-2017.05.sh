#!/bin/bash
set -o errexit

if [ -z "$LOCAL_IP" ];then
	echo "Unknown LOCAL_IP"
	exit 3
fi

echo deb http://repo.goodrain.com/ubuntu/14.04 2017.06 main | tee /etc/apt/sources.list.d/goodrain.list  && \
curl http://repo.goodrain.com/gpg/goodrain-C4CDA0B7 2>/dev/null | apt-key add - && \
apt-get update

apt-get install gr-etcd < /dev/null
pgrep etcd || start etcd

apt-get install -y dc-ctl dc-web < /dev/null

apt-get install -y dc-agent < /dev/null
echo "DC_AGENT_OPTS='-s http://$LOCAL_IP:2379'" > /etc/default/dc-agent

dc-agent --check -s http://$LOCAL_IP:2379
pgrep dc-agent || start dc-agent

echo "waiting dc-agent starting..." && sleep 3

AGENT_ID=$(dc-ctl get node --self --field id)
dc-ctl set node $AGENT_ID --add-identity manage
dc-ctl set node $AGENT_ID --add-identity compute

dc-ctl import dc_web --address $LOCAL_IP:8088
dc-ctl import etcd --address $LOCAL_IP:2379

dc-ctl init -y

dc-ctl install storage
dc-ctl install network
dc-ctl install manage

dc-ctl install console

dc-ctl install compute --node $AGENT_ID
dc-ctl show
