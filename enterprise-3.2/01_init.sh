#!/bin/bash


function public_opt(){
  clear
  # check system
  /bin/bash $PWD/install/init/check.sh

  # config yum
  /bin/bash $PWD/install/init/config_yum.sh

  # make docker storage
  /bin/bash $PWD/install/init/make_storage.sh

  # limit container swap
  /bin/bash $PWD/install/init/limit_swap.sh
}


function manage_opt(){
  # modify hosts
  /bin/bash $PWD/install/init/modify_hosts.sh manage

  # install docker
  /bin/bash $PWD/install/init/docker_install.sh

  # setup registry
  /bin/bash $PWD/install/init/setup_registry.sh

  # prepare images
  /bin/bash $PWD/install/init/prepare_images.sh load manage
  /bin/bash $PWD/install/init/prepare_images.sh push

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
  /bin/bash $PWD/install/init/modify_hosts.sh compute

  # install docker
  /bin/bash $PWD/install/init/docker_install.sh
  systemctl restart docker

  # prepare images
  /bin/bash $PWD/install/init/prepare_images.sh load compute

  # stop docker
  echo "stop docker"
  systemctl stop docker
}

#====== main ========
case $1 in 
manage)
  public_opt
  manage_opt
  ;;
compute)
  public_opt
  compute_opt
  ;;
*)
  echo "Please input cluster role manage | compute."
  exit 1
esac
