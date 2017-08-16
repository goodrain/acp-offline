#!/bin/bash

if [ ! -f /etc/lvm/profile/docker-thinpool.profile ];then
  echo
  read -p $'\e[32mMake docker storage device?\e[0m (Y|N): ' MAKE_DEVICE
  if [ "$MAKE_DEVICE" == "N" -o "$MAKE_DEVICE" == "n" ];then
    echo "Skip make docker storage device."
    exit 0
  fi

  #list device
  lsblk -l

  read -p $'\e[32mPlease select device for docker storage device: \e[0m' DOCKER_DEVICE
  if [ -b /dev/$DOCKER_DEVICE ];then
    echo -en "\n\e[32mAre you sure use \e[0m\e[31m[$DOCKER_DEVICE]\e[0m \e[32mfor docker storage?\e[0m"
    read -p " (Y|N): " ARE_YOU_SURE
  else
    echo "DEVICE $DOCKER_DEVICE IS NOT EXIST!"
  fi

  if [ "$ARE_YOU_SURE" == "Y" -o "$ARE_YOU_SURE" == "y" ] ;then

    pvcreate /dev/$DOCKER_DEVICE
    vgcreate docker /dev/$DOCKER_DEVICE
    vgdisplay docker

    lvcreate --wipesignatures y -n thinpool docker -l 95%VG
    lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG

    lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta

cat > /etc/lvm/profile/docker-thinpool.profile << EOF
activation {
    thin_pool_autoextend_threshold=80
    thin_pool_autoextend_percent=20
}
EOF

     lvchange --metadataprofile docker-thinpool docker/thinpool

  else
     echo "Noting to do,bye!"
  fi
else
  echo "docker storage device already configured."
fi
