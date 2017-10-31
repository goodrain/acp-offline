#!/bin/bash

# Info   : Save application image then load into acp
# Author : zhouyq
# CTime  : 2017.10.11

InternalImg=$1
Action=$2

if [ "$InternalImg" == "" ];then
    echo "Please input application image name."
    exit 1
elif  [[ "$InternalImg" != goodrain\.me/* ]];then
    echo "Please input correct application image name,ex: goodrain.me/redis:latest"
    exit 1
fi

PublicImg=hub.${InternalImg/.me\//.com\/goodrain\/}
PublicFile=$(echo ${PublicImg#hub.goodrain.com\/goodrain\/} | sed 's/:/_/')
PublicImgID=$(docker images -q $PublicImg)

# pull image
function PullPublicImage(){
    echo "Pull $PublicImg..."
    docker pull $PublicImg
}

# save public image
function SaveImgAndID(){
    echo "Save $PublicImg to ${PublicFile}.gz "
    docker save $PublicImg | gzip > appimg/${PublicFile}.gz \
    && md5sum appimg/${PublicFile}.gz > appimg/${PublicFile}.md5 \
    && echo $PublicImgID > appimg/${PublicFile}.id
}

# rename images
function RenameImg(){
    echo "Rename $PublicImg to $InternalImg"
    docker tag $PublicImg $InternalImg
}

# push local registry
function SaveImgToLocal(){
    echo "Push $InternalImg images to local registry..."
    docker push $InternalImg
}

case $Action in
"pull")
    PullPublicImage
    ;;
"save")
    PullPublicImage
    SaveImgAndID
    ;;
"push")
    PullPublicImage
    RenameImg
    SaveImgToLocal
    ;;
"all")
    PullPublicImage
    SaveImgAndID
    RenameImg
    SaveImgToLocal
    ;;
esac