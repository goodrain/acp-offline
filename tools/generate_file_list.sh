#!/bin/bash

REPO_DIR=repo
REPO_LIST_FILE=$PWD/tools/repo_list.ls

ACPIMG_DIR=acpimg
ACPIMG_LIST_FILE=$PWD/tools/acp_img_list.ls

find ../ -name ".DS_Store" -delete
find $REPO_DIR > $REPO_LIST_FILE
find $ACPIMG_DIR >$ACPIMG_LIST_FILE

