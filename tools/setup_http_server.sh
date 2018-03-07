#!/bin/bash

. $PWD/tools/common.sh

echo
read -p $'\e[32mDo you want to run the http server?\e[0m (y|n): ' isOK
if [ "$isOK" == "Y" -o "$isOK" == "y" ];then

  # set virtual ip
  ifconfig docker0:1 172.30.42.100 netmask 255.255.255.0 up

  # clear container if exist
  docker stop http_server
  docker rm http_server
  # copy ssl key
  [ ! -d /etc/goodrain/http_server/ssl/ ] && mkdir -pv /etc/goodrain/http_server/ssl/
  cp -rp $PWD/modules/http_server/ssl/goodrain.com /etc/goodrain/http_server/ssl/

  # copy hub config
  [ ! -d /etc/goodrain/http_server/sites/ ] && mkdir -pv /etc/goodrain/http_server/sites/
  cp $PWD/modules/http_server/sites/* /etc/goodrain/http_server/sites/
  sed -i "s/__RBD_VERSION__/${ACP_VERSION}/g" /etc/goodrain/http_server/sites/http_server

  # make build dir
  [ ! -d /grdata/build/lang-env ] && mkdir -pv /grdata/build/lang-env
#  cat $PWD/rbdimg/rbd-registry_2.3.1.gz | docker load \
  docker run -d --name http_server -v $PWD:/mnt \
  -v /etc/goodrain/http_server/sites:/usr/local/tengine/conf/sites \
  -v /etc/goodrain/http_server/ssl:/usr/local/tengine/conf/ssl \
  --network host rainbond/rbd-proxy:3.4
else
  echo "Skip setup http server."
fi