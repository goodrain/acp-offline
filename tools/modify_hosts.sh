#!/bin/bash

CLUSTER_RULE=$1

HOST_FILE="/etc/hosts"

function manage_opt(){
  HOST_LIST="goodrain.me"
  HTTP_SERVER="repo.goodrain.com dl.repo.goodrain.com"

  for host in $HOST_LIST
  do
    isHostSet=`grep $host /etc/hosts`
    if [ "$isHostSet" == "" ];then
      echo "172.30.42.1 $host" >> $HOST_FILE
    else
      echo -e "\e[31m$host is already set.\e[0m"
    fi
  done

  for host in $HTTP_SERVER
  do
    isHostSet=`grep $host /etc/hosts`
    if [ "$isHostSet" == "" ];then
      echo "172.30.42.100 $host" >> $HOST_FILE
    else
      echo -e "\e[31m$host is already set.\e[0m"
    fi
  done
}

function compute_opt(){
  echo
  manage_ip=$1
  HTTP_SERVER="repo.goodrain.com dl.repo.goodrain.com"

  for host in $HTTP_SERVER
  do
    isHostSet=`grep $host /etc/hosts`
    if [ "$isHostSet" == "" ];then
      echo "172.30.42.100 $host" >> $HOST_FILE
    else
      echo -e "\e[31m$host is already set.\e[0m"
    fi
  done



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
