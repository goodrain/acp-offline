#!/bin/bash
set -o errexit

if [ -z "$LOCAL_IP" ];then
	echo "Unknown LOCAL_IP"
	exit 3
fi

echo deb http://repo.goodrain.com/ubuntu/14.04 2017.03 main | tee /etc/apt/sources.list.d/goodrain.list  && \
curl http://repo.goodrain.com/gpg/goodrain-C4CDA0B7 2>/dev/null | apt-key add - && \
apt-get update

apt-get install gr-etcd < /dev/null

apt-get install -y dc-ctl dc-web < /dev/null

apt-get install -y dc-agent < /dev/null

if [ -f "/var/run/dc-agent.pid" ];then
    pid=`cat /var/run/dc-agent.pid`
    kill -0 $pid || kill -9 $pid
fi

#dc-agent -d --ip $LOCAL_IP

dc-ctl set node $LOCAL_IP --add-identity manage
dc-ctl set node $LOCAL_IP --add-identity compute

dc-ctl import dc_web --address $LOCAL_IP:8088
dc-ctl import etcd --address $LOCAL_IP:4001

dc-ctl init -y

dc-ctl install storage
dc-ctl install network
dc-ctl install manage

dc-ctl install console

dc-ctl install compute --node $LOCAL_IP
