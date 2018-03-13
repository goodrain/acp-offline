#!/bin/bash

OSS_DOMAIN="https://dl.repo.goodrain.com"
OSS_PATH="releases/offline"
REPO_DIR="$PWD/repo"
RBDIMG_DIR="$PWD/rbdimg"

REPO_LIST_FILE="$PWD/tools/repo_list.ls"
RBD_IMG_LIST_FILE="$PWD/tools/rbd_img_list.ls"

function download_repo(){
    [ ! -d $REPO_DIR ] && mkdir -pv $REPO_DIR
    while read line
    do
        if [ "$line" == "repo/repodata" -o "$line" == "repo" ];then
            [ ! -d $REPO_DIR/$line ] && mkdir -pv $REPO_DIR/$line
            mkdir -pv $REPO_DIR/$line
            continue
        fi
        [ ! -f $REPO_DIR/$line ] && echo -n "Downloading $(basename $line) ... " \
        && curl -s $OSS_DOMAIN/$OSS_PATH/$line -o $REPO_DIR/$line \
        && echo -e "\e[32mdone.\e[0m"
  done < $REPO_LIST_FILE
}

function download_rbdimg(){
    [ ! -d $RBDIMG_DIR ] && mkdir -pv $RBDIMG_DIR
    imgs_gz=$(cat $RBD_IMG_LIST_FILE | grep .gz)
    for img_gz in $imgs_gz
    do
    img_md5=$(echo $img_gz | sed 's/.gz/.md5/')
    img_id=$(echo $img_gz | sed 's/.gz/.id/')
        if [ -f $RBDIMG_DIR/$img_gz ];then
            curl -s $OSS_DOMAIN/$OSS_PATH/$img_md5 -o $RBDIMG_DIR/$img_md5
            md5sum -c $RBDIMG_DIR/$img_gz > /dev/null 2>&1
            if [ $? -ne 0 ];then
                curl -s $OSS_DOMAIN/$OSS_PATH/$img_gz -o $RBDIMG_DIR/$img_gz
            fi
            if [ ! -f $RBDIMG_DIR/$img_id ];then
                curl -s $OSS_DOMAIN/$OSS_PATH/$img_id -o $RBDIMG_DIR/$img_id
            fi
        else
            curl -s $OSS_DOMAIN/$OSS_PATH/$img_gz -o $RBDIMG_DIR/$img_gz
            curl -s $OSS_DOMAIN/$OSS_PATH/$img_md5 -o $RBDIMG_DIR/$img_md5
            curl -s $OSS_DOMAIN/$OSS_PATH/$img_id -o $RBDIMG_DIR/$img_id
        fi
    done
}


# --- main -------
download_repo

download_rbdimg
