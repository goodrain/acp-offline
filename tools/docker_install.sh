#!/bin/bash

. $PWD/tools/common.sh

echo
read -p $'\e[32mInstall Docker?\e[0m (y|n): ' isOK
if [ "$isOK" == "Y" -o "$isOK" == "y" ];then
  
  # prepare env file
  mkdir -pv /etc/goodrain/envs
  if [ -f $LVM_PROFILE ];then
cat > $DOCKER_ENV_FILE << END
DOCKER_OPTS="-H 0.0.0.0:2376 \
-H unix:///var/run/docker.sock \
--bip=172.30.42.1/16 \
--insecure-registry goodrain.me \
--insecure-registry hub.goodrain.com \
--storage-driver=devicemapper \
--storage-opt=dm.thinpooldev=/dev/mapper/docker-thinpool \
--storage-opt=dm.use_deferred_removal=true \
--storage-opt=dm.use_deferred_deletion=true \
--userland-proxy=false"
END
  else
cat > $DOCKER_ENV_FILE << END
DOCKER_OPTS="-H 0.0.0.0:2376 \
-H unix:///var/run/docker.sock \
--bip=172.30.42.1/16 \
--insecure-registry goodrain.me \
--insecure-registry hub.goodrain.com \
--userland-proxy=false"
END
  fi

  # install docker
  yum install -y gr-docker-engine

  # boot with docker
  echo "boot with docker"
  systemctl enable docker

  # start docker
  echo "start docker service"
  systemctl start docker

else
  echo "Skip install Docker."
fi
