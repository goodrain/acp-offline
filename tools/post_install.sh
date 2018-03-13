#!/bin/bash

# copy lang-env
echo -ne  "\e[32mCopying build files...\e[0m"
cp -rp $PWD/grdata/build/lang-env/* /grdata/build/lang-env/ && echo OK
#cp -rp $PWD/app_publish  /grdata/build/tenant/ && echo OK 

# import sql data
echo "\e[32mImport sql data...\e[0m"
$PWD/modules/rbd_db/sql/import_sql.sh

# copy acp_proxy
echo -ne  "\e[32mCopying acp_proxy files...\e[0m"
\cp -rp $PWD/modules/http_server/conf/sites/lang.default /etc/goodrain/proxy/sites/lang && echo OK

# stop temporary service 
echo -ne "\e[32mStoping temporary service...\e[0m"
/usr/local/nginx/sbin/nginx -s stop

# remove temporary files
echo -ne "\e[32mRemoving temporary files...\e[0m"
rm -rf /usr/local/nginx

# add proxy server key
echo -ne "\e[32mAdding proxy server key...\e[0m"
\cp -rp $PWD/modules/http_server/conf/ssl/goodrain.com  /etc/goodrain/proxy/ssl/

# config proxy
echo -ne "\e[32mConfig proxy\e[0m"
\cp -rp $PWD/tools/registry /etc/goodrain/proxy/sites/registry

# adapt new config
echo -ne "\e[32mAdapting config\e[0m"
dc-compose stop
cclear
systemctl restart docker
dc-compose up -d

\cp $PWD/tools/chaos_config.json /etc/goodrain/etc/chaos/config.json 