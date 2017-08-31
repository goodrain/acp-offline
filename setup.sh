#!/bin/bash

function manage_opt(){
  # modify hosts
  /bin/bash $PWD/tools/modify_hosts.sh manage

  # install docker
  /bin/bash $PWD/tools/docker_install.sh

  # setup registry
  /bin/bash $PWD/tools/setup_registry.sh

  # prepare images
  /bin/bash $PWD/tools/prepare_images.sh load manage
  /bin/bash $PWD/tools/prepare_images.sh push

  # stop docker
  echo "stop docker"
  systemctl stop docker
}

function compute_opt(){
  if [ -z $MANAGE_IP ];then
    echo "Please \e[33m[export MANAGE_IP ]\e[0m environment variable."
    exit 1
  fi
  # modify hosts
  /bin/bash $PWD/tools/modify_hosts.sh compute

  # install docker
  /bin/bash $PWD/tools/docker_install.sh
  systemctl restart docker

  # prepare images
  /bin/bash $PWD/tools/prepare_images.sh load compute

  # stop docker
  echo "stop docker"
  systemctl stop docker
}

#====== main ========
case $1 in 
manage)
  manage_opt \
  && $PWD/install/init/install.sh local \
  && $PWD/tools/post_install.sh
  ;;
compute)
  compute_opt \
  && $PWD/install/init/add-compute.sh local
  ;;
*)
  echo "Please input cluster role manage | compute."
  exit 1
esac