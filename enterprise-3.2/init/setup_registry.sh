#!/bin/bash

echo
read -p $'\e[32mDo you want to run the docker registry?\e[0m (y|n): ' isOK
if [ "$isOK" == "Y" -o "$isOK" == "y" ];then
  # copy ssl key
  [ ! -d /etc/goodrain/tengine/ssl/ ] && mkdir -pv /etc/goodrain/tengine/ssl/
  cp -rp $PWD/modules/acp_proxy/ssl/goodrain.com /etc/goodrain/tengine/ssl/

  # copy hub config
  [ ! -d /etc/goodrain/tengine/sites/ ] && mkdir -pv /etc/goodrain/tengine/sites/
  cp $PWD/modules/acp_proxy/sites/* /etc/goodrain/tengine/sites/

  # make build dir
  [ ! -d /grdata/build/lang-env ] && mkdir -pv /grdata/build/lang-env
  cat $PWD/acpimg/registry_2.3.1.gz | docker load \
  && docker run -d -v /grdata/services/registry/:/var/lib/registry -p 80:5000  hub.goodrain.com/dc-deploy/registry:2.3.1
else
  echo "Skip the docker registry."
fi