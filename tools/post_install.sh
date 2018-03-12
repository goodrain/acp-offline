#!/bin/bash

# copy lang-env
echo -ne  "\e[32mCopying build files...\e[0m"
cp -rp $PWD/grdata/build/lang-env/* /grdata/build/lang-env/ && echo OK
#cp -rp $PWD/app_publish  /grdata/build/tenant/ && echo OK 

# import sql data
echo "import sql data..."
$PWD/modules/rbd_db/sql/import_sql.sh

# copy acp_proxy
echo -ne  "\e[32mCopying acp_proxy files...\e[0m"
\cp -rp $PWD/modules/http_server/conf/sites/lang.default /etc/goodrain/proxy/sites/lang && echo OK

# stop temporary service and remove temporary files
echo -ne "\e[32mStoping temporary service...\e[0m"
/usr/local/nginx/sbin/nginx -s stop
echo -ne "\e[32mRemoving temporary files...\e[0m"
rm -rf /usr/local/nginx

# add proxy server key
echo -ne "add proxy server key"
\cp -rp goodrain.com  /etc/goodrain/proxy/ssl/

# config proxy
echo -ne "config proxy"
\cp -rp $PWD/tools/registry /etc/goodrain/proxy/sites/registry

# adapt new config
echo -ne "config proxy"
dc-compose stop
cclear
systemctl restart docker
dc-compose up -d

\cp $PWD/tools/chaos_config.json /etc/goodrain/etc/chaos/config.json 