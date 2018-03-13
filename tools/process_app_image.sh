#!/bin/bash

LOG_FILE=$PWD/logs/process_app_img.log
APP_FILE=$PWD/modules/apps/app_list
APP_DOMAIN="goodrain.me"
BAK_PATH=/backup/tmp/appimg

[ ! -d $BAK_PATH ] && mkdir -pv $BAK_PATH

while read line
do
  read app_name app_img < <(echo $line | awk -F '|' '{print $2,$3}') 
  docker pull $APP_FILE/$app_name
  app_img_id=`docker images -q $APP_DOMAIN/$app_name`
  img_save_name=`echo $app_name|sed 's/:/_/'`
  old_img_id=`[ -f $BAK_PATH/$img_save_name.id ] && cat $BAK_PATH/$img_save_name.id`
  
  if [ "$app_img_id" != "$old_img_id" ];then
    docker save ${APP_DOMAIN}/${app_name} | gzip > ${BAK_PATH}/${img_save_name}.gz \
    && echo "$app_img_id" > $BAK_PATH/$img_save_name.id \
    && docker rmi ${APP_DOMAIN}/${app_name}
  fi
  sleep 10000
done < $APP_FILE

