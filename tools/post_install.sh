#!/bin/bash

# copy lang-env
echo -ne  "\e[32mCopying build files...\e[0m"
cp -rp $PWD/grdata/build/lang-env/* /grdata/build/lang-env/ && echo OK
cp -rp $PWD/grdata/config /grdata/ && echo OK

# import sql data
echo "import sql data..."
$PWD/modules/acp_db/sql/import_sql.sh

# fix config.json dir error
[ -d /root/.docker/config.json ] && rm -rf /root/.docker/config.json
[ ! -f /root/.docker/config.json ] && echo "{}" > /root/.docker/config.json

# copy acp_proxy
echo -ne  "\e[32mCopying acp_proxy files...\e[0m"
cp -rp $PWD/modules/acp_proxy/* /etc/goodrain/tengine/ && echo OK

# configure git ssh-key
echo -ne "\n\e[32mConfigure git ssh-key...\e[0m"
ssh-keygen -t rsa -f /etc/goodrain/ssh/goodrain-builder
cat <<EOF >/etc/goodrain/ssh/config
Host *
  IdentityFile ~/.ssh/goodrain-builder
  StrictHostKeyChecking no
  LogLevel ERROR
  Port 20002
EOF
chown -R rain.rain /etc/goodrain/ssh
echo -e "Please set the \e[33mgit ssh port\e[0m according to the actual situation."

echo -e "{\n\"install_type\":\"local\",\n\"time\":\"`date +'%F %H:%M:%S'`\"\n}" > /etc/goodrain/.config.json
