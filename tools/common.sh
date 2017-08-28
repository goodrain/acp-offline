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
REPO_PATH="$PWD/repo"
IMG_PATH="hub.goodrain.com/dc-deploy/"


ACP_MODULES=$($JQBIN .acpimg[] $CONF_FILE|sed 's/"//g')
ARCHIVER_IMG=$($JQBIN .archiver[] $CONF_FILE | sed 's/"//g')

OTHER_MODULES=$($JQBIN '.other_img[]' $CONF_FILE | sed 's/"//g' )

COMPUTE_LOAD_IMGS="$ARCHIVER_IMG \
calico-node:v1.3.0"

COMPUTE_LOAD_MODULES=$($JQBIN .compute_load_img[] $CONF_FILE|sed 's/"//g')

DEFAULT_RPMS=$($JQBIN .default_rpms[] $CONF_FILE | sed 's/"//g' )

LVM_PROFILE=$($JQBIN .files.lvm_profile $CONF_FILE | sed 's/"//g' )
DOCKER_ENV_FILE=$($JQBIN .files.docker_env_file $CONF_FILE | sed 's/"//g' )
