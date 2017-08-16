#!/bin/bash
set -o errexit

if [ -z "$MANAGE_IP" ];then
	echo "Unknown MANAGE_IP"
	exit 3
fi

function check() {
	for service in firewalld NetworkManager
	do
		cmd="systemctl is-active $service"
		echo $cmd
		eval $cmd && exit 1
		cmd="systemctl is-enabled $service"
		echo $cmd
		eval $cmd && exit 1 || continue
	done
}

check

cat >/etc/yum.repos.d/goodrain.repo <<EOF
[goodrain]
name=goodrain CentOS-\$releasever - for x86_64
baseurl=http://repo.goodrain.com/centos/\$releasever/3.2/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://repo.goodrain.com/gpg/RPM-GPG-KEY-CentOS-goodrain

EOF

yum makecache

yum install -y dc-agent rsync

dc-agent --check -s http://$MANAGE_IP:2379

echo "DC_AGENT_OPTS='-s http://$MANAGE_IP:2379'" > /etc/goodrain/envs/dc-agent.sh
systemctl is-active dc-agent || systemctl start dc-agent
systemctl is-enabled dc-agent || systemctl enable dc-agent

echo "waiting dc-agent starting..." && sleep 3

yum install -y dc-ctl >/dev/null

agent_id=$(dc-ctl -s http://$MANAGE_IP:2379 get node --self --field id)

dc-ctl -s http://$MANAGE_IP:2379 set node $agent_id --add-identity manage
dc-ctl -s http://$MANAGE_IP:2379 install manage
