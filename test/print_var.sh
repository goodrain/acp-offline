#!/bin/bash

. tools/common.sh

# acp_modules
echo "pull acp images..."
for img in $ACP_MODULES
do
  echo "docker pull $img:$ACP_VERSION"
done


# acp archiver images
echo -e "\npull archiver images..."
for img in $ARCHIVER_IMG
do
  echo "docker pull $img"
done

# acp other images
echo -e "\npull other images..."
for img in $OTHER_MODULES
do
  echo "docker pull $img"
done
