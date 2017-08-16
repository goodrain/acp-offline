#!/bin/bash

echo 
read -p $'\e[32mClear system default repo and add goodrain repo?\e[0m (y|n): ' isOK
if [ "$isOK" == "Y" -o "$isOK" == "y" ];then

  yum clean all

  rm -rf /etc/yum.repos.d/*

cat >/etc/yum.repos.d/acp.repo <<EOF
[goodrain-acp]
name=local
baseurl=file://$PWD/repo
enabled=1
gpgcheck=0
EOF

  yum makecache

  echo "Install the system prerequisite package..."
  yum install -y perl telnet bind-utils htop dstat mariadb

else
  echo "Skip modify repo file."
fi
