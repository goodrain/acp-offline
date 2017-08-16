#!/bin/bash
set -o errexit

if [ -z "$MANAGE_IP" ];then
    echo "Unknown MANAGE_IP"
    exit 3
fi

echo deb http://repo.goodrain.com/ubuntu/14.04 3.2 main | tee /etc/apt/sources.list.d/goodrain.list  && \
curl http://repo.goodrain.com/gpg/goodrain-C4CDA0B7 2>/dev/null | apt-key add - && \
apt-get update

apt-get install -y dc-agent < /dev/null
echo "DC_AGENT_OPTS='-s http://$MANAGE_IP:2379'" > /etc/default/dc-agent
pgrep dc-agent || start dc-agent

echo "waiting dc-agent starting..." && sleep 3

apt-get install -y dc-ctl > /dev/null

agent_id=$(dc-ctl -s http://$MANAGE_IP:2379 get node --self --field id)

dc-ctl -s http://$MANAGE_IP:2379 set node $agent_id --add-identity compute
dc-ctl -s http://$MANAGE_IP:2379 install compute --node $agent_id

apt-get purge -y dc-ctl

