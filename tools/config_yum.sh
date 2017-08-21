#!/bin/bash


if [ ! $(grep acp-local /etc/yum.repos.d/acp.repo 2>/dev/null) ];then
    yum clean all

    rm -rf /etc/yum.repos.d/*

cat >/etc/yum.repos.d/acp.repo <<EOF
[acp-local]
name=local
baseurl=file://$PWD/repo
enabled=1
gpgcheck=0
EOF

    yum makecache
else

   echo "goodrain repo already added."
fi

echo "Install the system prerequisite package..."
yum install -y perl telnet net-tools bind-utils htop dstat mariadb lvm2 lsof
