#!/bin/bash

LOCAL_DOMAIN="goodrain.me"

while read line
do
img=`echo $line | awk -F '|' '{print $3}'`
tarfile=`echo $img | awk -F ':' '{print $1"_"$2}'`.gz

echo "import $tarfile"
cat $PWD/appimg/${tarfile} | docker load && \
echo "push $LOCAL_DOMAIN/$img" && \
docker push $LOCAL_DOMAIN/$img
done < $PWD/modules/apps/app_list
