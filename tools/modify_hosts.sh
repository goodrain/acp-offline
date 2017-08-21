#!/bin/bash

CLUSTER_RULE=$1

HOST_FILE="/etc/hosts"

function manage_opt(){
  HOST_LIST="hub.goodrain.com goodrain.me"

  echo 
  read -p $'Modify \e[32m/etc/hosts\e[0m file add \e[31mgoodrain.me\e[0m and \e[31mhub.goodrain.com?\e[0m (y|n): ' isOK
  if [ "$isOK" == "Y" -o "$isOK" == "y" ];then
    for host in $HOST_LIST
    do
      isHostSet=`grep $host /etc/hosts`
      if [ "$isHostSet" == "" ];then
        echo "172.30.42.1 $host" >> $HOST_FILE
      else
        echo -e "\e[31m$host is already set.\e[0m"
      fi
    done
  else
    echo "Skip modify hosts file."
  fi
}

function compute_opt(){
  echo
  manage_ip=$1
  read -p $'Modify \e[32m/etc/hosts\e[0m file add \e[31mhub.goodrain.com?\e[0m (y|n): ' isOK
  if [ "$isOK" == "Y" -o "$isOK" == "y" ];then
     isHostSet=`grep hub.goodrain.com /etc/hosts`
     if [ "$isHostSet" == "" ];then
       echo -e "${manage_ip}\thub.goodrain.com" >> $HOST_FILE
     else
       echo -e "\e[32mhub.goodrain.com\e[0m is already set."
     fi
  else
    echo "Skip modify hosts file."
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
