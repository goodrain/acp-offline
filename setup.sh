#!/bin/bash

# source common env and functions
. tools/common.sh

function public_opt(){
  clear
  # config repo
  config_mirrors

  # check system
  check

  # make docker storage
  make_storage

  # limit container swap
  config_grub
}


function manage_opt(){
  # Setup Wild sub domain
  setup_domain

  # modify hosts
  /bin/bash $PWD/tools/modify_hosts.sh manage

  # install docker
  /bin/bash $PWD/tools/docker_install.sh

  # prepare images
  /bin/bash $PWD/tools/prepare_images.sh load manage
  #/bin/bash $PWD/tools/prepare_images.sh push

  # setup registry
  /bin/bash $PWD/tools/setup_http_server.sh

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
  public_opt \
  && manage_opt \
  && $PWD/install/${ACP_VERSION}/start.sh \
  && $PWD/tools/post_install.sh
  ;;
compute)
  public_opt \
  && compute_opt \
  && $PWD/install/init/add-compute.sh local
  ;;
*)
  echo "Please input cluster role manage | compute."
  exit 1
esac
