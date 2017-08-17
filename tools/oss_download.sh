#!/bin/bash

OSS_DOMAIN="http://pkg.goodrain.com"
OSS_PATH="acp/offline"
REPO_DIR="$PWD/repo"
ACPIMG_DIR="$PWD/acpimg"

REPO_LIST_FILE="$PWD/tools/repo_list.ls"
ACP_IMG_LIST_FILE="$PWD/tools/acp_img_list.ls"

function download_repo(){
    [ ! -d $REPO_DIR ] && mkdir -pv $REPO_DIR
    while read line
    do
        if [ "$line" == "repo/repodata" -o "$line" == "repo" ];then
            [ ! -d $line ] && mkdir -pv $line
            mkdir -pv $line
            continue
        fi
        [ ! -f $line ] && echo -n "Downloading $(basename $line) ... " \
        && curl -s $OSS_DOMAIN/$OSS_PATH/$line -o $line \
        && echo -e "\e[32mdone.\e[0m"
  done < $REPO_LIST_FILE
}

function download_acpimg(){
    [ ! -d $ACPIMG_DIR ] && mkdir -pv $ACPIMG_DIR
    while read line
    do
        if [ "$line" == "acpimg" ];then
            [ ! -d $line ] && mkdir -pv $line
            mkdir -pv $line
            continue
        fi

        # 先下载md5文件和本地文件进行校验，如果不匹配再下载
        is_gz=$(echo $line| grep '.gz$')
        md5_file=$(echo $line| sed 's/.gz$/.md5/')
        if [ $is_gz ];then
            curl -s $OSS_DOMAIN/$OSS_PATH/$md5_file -o  $md5_file
            md5sum -c $md5_file > /dev/null 2>&1
            # 校验不一致再下载
            if [ $? -ne 0 ];then
                echo -n "Downloading $(basename $line)..." \
                && curl -s $OSS_DOMAIN/$OSS_PATH/$line -o $line \
                && echo -e "\e[32mdone.\e[0m"
            fi
        fi

        # id file
        is_id=$(echo $line| grep '.id$')
        [ ! -f $line ] && echo -n "Downloading $(basename $line)..." \
        && curl -s $OSS_DOMAIN/$OSS_PATH/$line -o $line \
        && echo -e "\e[32mdone.\e[0m"
  done < $ACP_IMG_LIST_FILE
}

# --- main -------
#download_repo

download_acpimg