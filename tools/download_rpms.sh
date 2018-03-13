#!/bin/bash

. $PWD/tools/common.sh

function download_rpm(){
  rpms=$@
  if [ "$rpms" == "" ];then
    echo "You must give me some rpm package name. For example: [$0 htop dstat net-tools]"
    exit 0
  fi

  yum makecache
  if [ "$rpms" == "default" ];then
  {
    echo -e "download [\e[32m$default_rpms\e[0m] into local repo."
    yum install -y $DEFAULT_RPMS --downloadonly --downloaddir=$PWD/repo
    
    echo "Prepare docker rpms"
    tar xzvf $PWD/packages/releases/download/docker/v1.12.6/docker.tgz -C $PWD/repo/ --strip-components=1
    rm -rf $PWD/repo/*.deb
  }
  else
  {
    echo "download [\e[32m$rpms\e[0m] into local repo."
    yum install -y $rpms --downloadonly --downloaddir=$PWD/repo
  }
  fi

  if [ ! $(which  createrepo 2>/dev/null) ];then
    yum install repo/createrepo* -y && \
    createrepo --update  -pdo $REPO_PATH $REPO_PATH
  else
    createrepo --update  -pdo $REPO_PATH $REPO_PATH
  fi
}


rpmlist=$@
case $rpmlist in
default)
  download_rpm $1
;;

*)
  download_rpm $@
  ;;
esac
