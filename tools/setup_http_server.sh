#!/bin/bash

. $PWD/tools/common.sh

echo
read -p $'\e[32mDo you want to run the http server?\e[0m (y|n): ' isOK
if [ "$isOK" == "Y" -o "$isOK" == "y" ];then

  # set virtual ip
  ifconfig docker0:1 172.30.42.100 netmask 255.255.255.0 up

  if [ -f /usr/local/nginx ];then
     rm -rf /usr/local/nginx
  fi

  ln -s $PWD/modules/http_server /usr/local/nginx

  echo /usr/local/nginx/lib >> /etc/ld.so.conf && ldconfig

  \cp -rp $PWD/modules/http_server/conf/sites/http_server.default $PWD/modules/http_server/conf/sites/http_server.conf
  sed -i "s/__RBD_VERSION__/${ACP_VERSION}/g" $PWD/modules/http_server/conf/sites/http_server.conf
  sed -i "s#__RBD_ROOT__#$PWD#g" $PWD/modules/http_server/conf/sites/http_server.conf

  # make build dir
  [ ! -d /grdata/build/lang-env ] && mkdir -pv /grdata/build/lang-env
 
  # run http server
  isrunning=$(netstat -tulnp | grep "172.30.42.100:80")
  if [ "$isrunning" != "" ];then
    /usr/local/nginx/sbin/nginx -s stop
  fi
  /usr/local/nginx/sbin/nginx -t && /usr/local/nginx/sbin/nginx 

else
  echo "Skip setup http server."
fi
