#!/bin/bash

GRUB_FILE="/etc/default/grub"
is_modify=`grep "swapaccount=1" $GRUB_FILE`

if [ "$is_modify" == "" ];then
  echo
  read -p $'\e[32mDo you want to restrict the use of container swap?\e[0m (Y|N) [Y]: ' isOK
  isOK="$(echo ${isOK} | tr 'A-Z' 'a-z')"
  if [ "$isOK" == "y" -o "$isOK" == "" ];then
    echo -n "Backup ${GRUB_FILE} file..."
    cp ${GRUB_FILE} ${GRUB_FILE}.`date +%Y%m%d_%H%M%S` && echo "Ok"

    echo "Modify ${GRUB_FILE} file restrict the use of container swap..."
    echo "GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"" >> ${GRUB_FILE} && \
    grub2-mkconfig -o  /boot/grub2/grub.cfg

    read -p $'The operation need to \e[31mrestart the system\e[0m, restart now? (Y|N) [Y]: ' isOK
    isOK="$(echo ${isOK} | tr 'A-Z' 'a-z')"
    if [ "$isOK" == "y" -o "$isOK" == "" ];then
      reboot
    else
      echo -e "\e[33mPlease select the appropriate time to manually restart the system.\e[0m"
    fi

  else
    echo "Does not restrict the use of container swap."
  fi
fi
