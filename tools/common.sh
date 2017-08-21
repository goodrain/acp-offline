#!/bin/bash

# common function and envs

#ENVS
KERNEL=$(uname)
if [ "$KERNEL" == "Darwin" ];then
  JQBIN="$PWD/tools/jq-osx-amd64"
elif [ "$KERNEL" == "Linux" ];then
  JQBIN="$PWD/tools/jq-linux64"
fi
CONF_FILE="config.json"

# acp version such as 3.3
ACP_VERSION=$($JQBIN .version $CONF_FILE)
IMG_DIR="$PWD/acpimg"
IMG_PATH="hub.goodrain.com/dc-deploy/"


ACP_MODULES=$($JQBIN .acpimg $CONF_FILE | sed -e 's/[",\[]//g' -e 's/\]//' )
ARCHIVER_IMG=$($JQBIN .archiver $CONF_FILE | sed -e 's/[\[,"]//g' -e 's/\]//')

OTHER_MODULES=$($JQBIN -c .other_img $CONF_FILE | sed -e 's/[{}"]//g' -e 's/,/ /g')

PUSH_IMGS="archiver:gr-docker-utils \
archiver:gr-docker-compose \
archiver:grctl"

COMPUTE_LOAD_IMGS="archiver:gr-docker-utils \
archiver:gr-docker-compose \
archiver:grctl \
archiver:latest \
calico-node:v1.3.0"

COMPUTE_LOAD_MODULES="acp_proxy \
acp_webcli \
cep_prism"
