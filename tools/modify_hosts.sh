#!/bin/bash

CLUSTER_RULE=$1

HOST_FILE="/etc/hosts"

function manage_opt(){
  HOST_LIST="hub.goodrain.com goodrain.me"

  for host in $HOST_LIST
  do
    isHostSet=`grep $host /etc/hosts`
    if [ "$isHostSet" == "" ];then
      echo "172.30.42.1 $host" >> $HOST_FILE
    else
      echo -e "\e[31m$host is already set.\e[0m"
    fi
  done
}

function compute_opt(){
  echo
  manage_ip=$1
  isHostSet=`grep hub.goodrain.com /etc/hosts`
  if [ "$isHostSet" == "" ];then
     echo -e "${manage_ip}\thub.goodrain.com" >> $HOST_FILE
  else
     echo -e "\e[32mhub.goodrain.com\e[0m is already set."
  fi
}

#========= main =========
case $CLUSTER_RULE in
manage)
  manage_opt
  ;;
compute)
  compute_opt $MANAGE_IP
  ;;
*)
  echo "Please input cluster role manage|(compute manage_ip). "
  ;;
esac
