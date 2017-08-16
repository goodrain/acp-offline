#!/bin/bash
ACTION=$1
ROLE=$2

ACP_VERSION="3.3"
IMG_DIR="$PWD/acpimg"
IMG_PATH="hub.goodrain.com/dc-deploy/"

OTHER_MODULES="archiver:latest \
archiver:gr-docker-utils \
archiver:gr-docker-compose \
archiver:grctl \
calico-node:v1.3.0 \
cfssl:latest \
registry:2.3.1 \
pause-amd64:3.0"


ACP_MODULES="acp_dns \
acp_proxy \
acp_db \
acp_mq \
acp_repo \
acp_event_log \
acp_lb \
acp_api \
acp_labor \
acp_web \
acp_webcli \
acp_entrance \
cep_hbase \
cep_opentsdb \
cep_dalaran \
cep_server \
cep_logtransfer \
cep_prism \
builder \
runner \
adapter"

PUSH_IMGS="archiver:gr-docker-utils \
archiver:gr-docker-compose \
archiver:grctl"

COMPUTE_LOAD_IMGS="archiver:gr-docker-utils \
archiver:gr-docker-compose \
archiver:grctl \
archiver:latest \
calico-node:v1.3.0"

COMPUTE_LOAD_MODULES="acp_proxy \
acp_webcli \
cep_prism"

# pull images
function pull_images(){
  read -p $'\e[32mPull images?\e[0m (y|n): ' PULL_IMGS
  if [ "$PULL_IMGS" == "Y" -o "$PULL_IMGS" == "y" ];then
    for img in $ACP_MODULES
    do
      echo "docker pull ${IMG_PATH}${img}:${ACP_VERSION}"
      docker pull ${IMG_PATH}${img}:${ACP_VERSION}
    done

    for other_img in $OTHER_MODULES
    do
      echo "docker pull ${IMG_PATH}${other_img}"
      docker pull ${IMG_PATH}${other_img}
    done  
  fi
}

# save images
function save_images(){
  read -p $'\e[32mSave images?\e[0m (y|n): ' SAVE_IMGS
  if [ "$SAVE_IMGS" == "Y" -o "$SAVE_IMGS" == "y" ];then
    for img in $ACP_MODULES
      do
      echo "check image and tag package"
      img_id=`docker images -q ${IMG_PATH}${img}:${ACP_VERSION}`
      tgz_id=`cat ${IMG_DIR}/${img}_${ACP_VERSION}.id 2>/dev/null`
      if [ "$img_id" != "$tgz_id" ];then
        echo "docker save ${IMG_PATH}${img}:${ACP_VERSION}"
        docker save ${IMG_PATH}${img}:${ACP_VERSION} | gzip > ${IMG_DIR}/${img}_${ACP_VERSION}.gz \
        && echo $img_id > ${IMG_DIR}/${img}_${ACP_VERSION}.id
      else
        echo -e "Image: \e[31m${img}:${ACP_VERSION}\e[0m,Compressed package:\e[32m${img}_${ACP_VERSION}.gz\e[0m has been saved and skipped."
      fi
    done

    for other_img in $OTHER_MODULES
      do
      other_img_tag=`echo ${other_img}|sed 's/:/_/'`
      echo "check image and tag package"
      img_id=`docker images -q ${IMG_PATH}${other_img}`
      tgz_id=`cat ${IMG_DIR}/${other_img_tag}.id`
      if [ "$img_id" != "$tgz_id" ];then
        echo "docker save ${IMG_PATH}${other_img}"
        docker save ${IMG_PATH}${other_img} | gzip > ${IMG_DIR}/${other_img_tag}.gz \
        && echo $img_id > ${IMG_DIR}/${other_img_tag}.id
      else
        echo -e "Image: \e[31m${other_img}\e[0m,Compressed package:\e[32m${other_img_tag}.gz\e[0m has been saved and skipped."
      fi
    done
  fi
}

# push images
function push_images(){
  read -p $'\e[32mPush images?\e[0m (y|n): ' IS_PUSH_IMGS
  if [ "$IS_PUSH_IMGS" == "Y" -o "$IS_PUSH_IMGS" == "y" ];then
    for push_img in $PUSH_IMGS
    do
      echo -e "docker push \e[32m${IMG_PATH}${push_img}\e[0m"
      docker push ${IMG_PATH}${push_img}
    done
  fi
}


# load images
function load_images(){
  role=$1
  read -p $'\e[32mLoad images?\e[0m (y|n): ' LOAD_IMGS
  if [ "$LOAD_IMGS" == "Y" -o "$LOAD_IMGS" == "y" ];then
    if [ "$role" == "manage" ];then
      for img in $ACP_MODULES
      do
        img_id=`docker images -q ${IMG_PATH}${img}:${ACP_VERSION}`
        tgz_id=`cat ${IMG_DIR}/${img}_${ACP_VERSION}.id 2>/dev/null`
        if [ "$img_id" != "$tgz_id" ];then
          echo "docker load ${IMG_PATH}${img}:${ACP_VERSION}"
          cat ${IMG_DIR}/${img}_${ACP_VERSION}.gz | docker load
        else
          echo "${IMG_PATH}${img}:${ACP_VERSION} already loaded."
        fi
      done

      for other_img in $OTHER_MODULES
      do
        other_img_tag=`echo ${other_img}|sed 's/:/_/'`
        img_id=`docker images -q ${IMG_PATH}${other_img}`
        tgz_id=`cat ${IMG_DIR}/${other_img_tag}.id`
        
        if [ "$img_id" != "$tgz_id" ];then
          echo "docker load ${IMG_PATH}${other_img}"
          cat ${IMG_DIR}/`echo ${other_img}|sed 's/:/_/'`.gz | docker load
        else
          echo "${IMG_PATH}${other_img} already loaded."
        fi
        
      done
    elif [ "$role" == "compute" ];then
      for other_img in $COMPUTE_LOAD_IMGS
      do
        echo "docker load ${IMG_PATH}${other_img}"
        cat ${IMG_DIR}/`echo ${other_img}|sed 's/:/_/'`.gz | docker load
      done
     
      for module_img in $COMPUTE_LOAD_MODULES
      do
        img_id=`docker images -q ${IMG_PATH}${module_img}:${ACP_VERSION}`
        tgz_id=`cat ${IMG_DIR}/${module_img}_${ACP_VERSION}.id 2>/dev/null`
        if [ "$img_id" != "$tgz_id" ];then
          echo "docker load ${IMG_PATH}${module_img}:${ACP_VERSION}"
          cat ${IMG_DIR}/${module_img}_${ACP_VERSION}.gz | docker load
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
  save_images;;
load)
  load_images $ROLE;;
push)
  push_images;;
*)
  echo "Please specify the operation command. pull|save|load|push"
  exit 1;;
esac
