#!/bin/bash
. $PWD/tools/common.sh

ACTION=$1
ROLE=$2

# pull images
function pull_images(){
  if [ "$1" != "yes" ];then
    read -p $'\e[32mPull images?\e[0m (y|n): ' PULL_IMGS
  else
    PULL_IMGS=y
  fi

  if [ "$PULL_IMGS" == "Y" -o "$PULL_IMGS" == "y" ];then
    if [ $(systemctl  is-active docker) != "active" ];then
       systemctl start docker
    fi

    for img in $ACP_MODULES $OTHER_MODULES $ARCHIVER_IMG
    do
      echo "docker pull ${IMG_PATH}${img}"
      docker pull ${IMG_PATH}${img}
    done  
  fi
}
# =====================================
# save images
function save_images(){
  read -p $'\e[32mSave images?\e[0m (y|n): ' SAVE_IMGS
  if [ "$SAVE_IMGS" == "Y" -o "$SAVE_IMGS" == "y" ];then
    for img in $ACP_MODULES $OTHER_MODULES $ARCHIVER_IMG
    do
      img_tag=`echo ${img}|sed 's/:/_/'`
      echo "check image and tag package..."
      img_id=`docker images -q ${IMG_PATH}${img}`
      tgz_id=`cat ${IMG_DIR}/${img_tag}.id 2>/dev/null`
      if [ "$img_id" != "$tgz_id" ];then
        echo "docker save ${IMG_PATH}${img}"
        docker save ${IMG_PATH}${img} | gzip > ${IMG_DIR}/${img_tag}.gz \
        && md5sum rbdimg/${img_tag}.gz > ${IMG_DIR}/${img_tag}.md5 \
        && echo $img_id > ${IMG_DIR}/${img_tag}.id
      else
        echo -e "Image: \e[31m${img}\e[0m,Compressed package:\e[32m${img_tag}.gz\e[0m has been saved and skipped."
      fi
    done
  fi
}

# push images
function push_images(){
  pull_images=$1
  read -p $'\e[32mPush images?\e[0m (y|n): ' IS_PUSH_IMGS
  if [ "$IS_PUSH_IMGS" == "Y" -o "$IS_PUSH_IMGS" == "y" ];then
    for img in $pull_images
    do
      echo -e "docker push \e[32m${IMG_PATH}${img}\e[0m"
      docker push ${IMG_PATH}${img}
    done
  fi
}


# load images
function load_images(){
  role=$1
  read -p $'\e[32mLoad images?\e[0m (y|n): ' LOAD_IMGS
  if [ "$LOAD_IMGS" == "Y" -o "$LOAD_IMGS" == "y" ];then
    if [ "$role" == "manage" ];then
      # for img in $ACP_MODULES
      # do
      #   img_id=`docker images -q ${IMG_PATH}${img}:${ACP_VERSION}`
      #   tgz_id=`cat ${IMG_DIR}/${img}_${ACP_VERSION}.id 2>/dev/null`
      #   if [ "$img_id" != "$tgz_id" ];then
      #     echo "Check ${img}:${ACP_VERSION}..."
      #     md5sum -c ${IMG_DIR}/${img}_${ACP_VERSION}.md5 > /dev/null 2>&1
      #     if [ $? -eq 0 ];then
      #       echo "docker load ${IMG_PATH}${img}:${ACP_VERSION}"
      #       cat ${IMG_DIR}/${img}_${ACP_VERSION}.gz | docker load
      #     else
      #       echo -e "${IMG_DIR}/${img}_${ACP_VERSION}.gz checksum \e[31mdid NOT\e[0m match,please re-download."
      #       continue;
      #     fi
      #   else
      #     echo "${IMG_PATH}${img}:${ACP_VERSION} already loaded."
      #   fi
      # done

      for img in $ACP_MODULES $OTHER_MODULES $ARCHIVER_IMG
      do
        img_tag=`echo ${img}|sed 's/:/_/'`
        img_id=`docker images -q ${IMG_PATH}${img}`
        tgz_id=`cat ${IMG_DIR}/${img_tag}.id`
        
        if [ "$img_id" != "$tgz_id" ];then
          echo "Check ${img}..."
          md5sum -c ${IMG_DIR}/${img_tag}.md5 > /dev/null 2>&1
          if [ $? -eq 0 ];then
            echo "docker load ${IMG_PATH}${img}"
            cat ${IMG_DIR}/${img_tag}.gz | docker load
          else
            echo -e "${IMG_PATH}${img_tag}.gz checksum \e[31mdid NOT\e[0m match"
            break;
          fi
        else
          echo "${IMG_PATH}${img} already loaded."
        fi
      done
    elif [ "$role" == "compute" ];then
      for other_img in $COMPUTE_LOAD_IMGS
      do
        other_img_tag=`echo ${other_img}|sed 's/:/_/'`
        img_id=`docker images -q ${IMG_PATH}${other_img}`
        tgz_id=`cat ${IMG_DIR}/${other_img_tag}.id`
        
        if [ "$img_id" != "$tgz_id" ];then
          echo "Check ${other_img}:${ACP_VERSION}..."
          md5sum -c ${IMG_DIR}/${other_img_tag}.md5 > /dev/null 2>&1
          if [ $? -eq 0 ];then
            echo "docker load ${IMG_PATH}${other_img}"
            cat ${IMG_DIR}/${other_img_tag}.gz | docker load
          else
            echo -e "${IMG_PATH}${other_img_tag}.gz checksum \e[31mdid NOT\e[0m match"
            continue;
          fi
        else
          echo "${IMG_PATH}${other_img} already loaded."
        fi
      done
     
      for module_img in $COMPUTE_LOAD_MODULES
      do
        img_id=`docker images -q ${IMG_PATH}${module_img}:${ACP_VERSION}`
        tgz_id=`cat ${IMG_DIR}/${module_img}_${ACP_VERSION}.id 2>/dev/null`

        if [ "$img_id" != "$tgz_id" ];then
          echo "Check ${module_img}:${ACP_VERSION}..."
          md5sum -c ${IMG_DIR}/${module_img}_${ACP_VERSION}.md5 > /dev/null 2>&1
          if [ $? -eq 0 ];then
            echo "docker load ${IMG_PATH}${module_img}:${ACP_VERSION}"
            cat ${IMG_DIR}/${module_img}_${ACP_VERSION}.gz | docker load
          else
            echo -e "${IMG_DIR}/${module_img}_${ACP_VERSION}.gz checksum \e[31mdid NOT\e[0m match"
            continue;
          fi
        
        else
          echo "${IMG_PATH}${module_img}:${ACP_VERSION} already loaded."
        fi
      done
    fi
  fi
}

# ========= main ===========
case $ACTION in
pull)
  pull_images;;
save)
  save_images
  ;;
load)
  load_images $ROLE;;
push)
  push_images "$ARCHIVER_IMG"
  ;;
*)
  echo "Please specify the operation command. pull|save|load|push"
  exit 1;;
esac
