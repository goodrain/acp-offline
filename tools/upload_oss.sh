#!/bin/bash

OSS_DOMAIN="https://dl.repo.goodrain.com"
OSS_PATH="releases/offline"
REPO_DIR="$PWD/repo"
RBDIMG_DIR="$PWD/rbdimg"

REPO_LIST_FILE="$PWD/tools/repo_list.ls"
RBD_IMG_LIST_FILE="$PWD/tools/rbd_img_list.ls"


find $PWD -name '.DS_Store' -delete

function upload_rbdimg(){
    while read line
    do
        # 先下载md5文件和本地文件进行校验，如果不匹配再下载
        is_gz=$(echo $line| grep '.gz$')
        md5_file=$(echo $line| sed 's/.gz$/.md5/')
        id_file=$(echo $line| sed 's/.gz$/.id/')

        if [ $is_gz ];then
            echo "Get remote oss $md5_file file..."
            curl -s $OSS_DOMAIN/$OSS_PATH/$md5_file -o  $md5_file.remote
            
            echo "Check local $is_gz file..."
            md5sum -c $md5_file.remote > /dev/null 2>&1
            # 校验不一致再下载
            if [ $? -ne 0 ];then
                echo -n "Uploading $(basename $line)..." \
                && ossutil cp  $PWD/$line oss://rainbond-pkg/releases/offline/rbdimg/ -f \
                && ossutil cp  $PWD/$id_file oss://rainbond-pkg/releases/offline/rbdimg/ -f \
                && ossutil cp  $PWD/$md5_file oss://rainbond-pkg/releases/offline/rbdimg/ -f \
                && echo -e "\e[32mdone.\e[0m"
            else
                echo "The remote $(basename $line) is consistent with the local, skipped."
            fi
            
            # clean tmp file
            rm -rf $md5_file.remote
        fi

  done < $RBD_IMG_LIST_FILE
}

#======== 
echo "generating file list..."
$PWD/tools/generate_file_list.sh

#==== upload_rbdimg ====
echo "upload rbd module images..."
upload_rbdimg

# delete repo mata file
echo 'deleting repo meta...'
ossutil rm oss://rainbond-pkg/releases/offline/repo/repodata -r -f
# upload repo
echo 'upload repo files...'
ossutil cp  $PWD/repo oss://rainbond-pkg/releases/offline/repo -r -f -u
