#!/bin/bash

# check default gateway
echo -e "\e[32mCheck default gateway...\e[0m"
haveGW=`route -n| grep UG|awk '{print $2}'`
if [ "$haveGW" != "" ];then
  echo -e "Default Gateway: \e[32m$haveGW\e[0m"
else
  echo -e "\e[31mFailure,not found default gateway.\nPlease set the default route.\nUse\e[0m [\e[33mroute add default gw route-ipaddress\e[0m] \e[31mto set.\e[0m"
  exit 1
fi

# check unnecessary service
echo -e "\e[32mCheck unnecessary service...\e[0m"
echo "disable firewalld"
systemctl stop firewalld
systemctl disable firewalld

echo "disable NetworkManager"
systemctl stop NetworkManager
systemctl disable NetworkManager
