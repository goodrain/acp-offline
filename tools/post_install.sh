#!/bin/bash

# copy lang-env
echo -ne  "\e[32mCopying build files...\e[0m"
cp -rp $PWD/grdata/build/lang-env/* /grdata/build/lang-env/ && echo OK
#cp -rp $PWD/app_publish  /grdata/build/tenant/ && echo OK 

# import sql data
echo "import sql data..."
$PWD/modules/acp_db/sql/import_sql.sh

# copy acp_proxy
echo -ne  "\e[32mCopying acp_proxy files...\e[0m"
\cp -rp $PWD/modules/http_server/conf/sites/lang.default /etc/goodrain/proxy/sites/lang && echo OK


