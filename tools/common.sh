#!/bin/bash

# common function and envs

#======== ENVS =========
KERNEL=$(uname)
if [ "$KERNEL" == "Darwin" ];then
  JQBIN="$PWD/tools/jq-osx-amd64"
elif [ "$KERNEL" == "Linux" ];then
  JQBIN="$PWD/tools/jq-linux64"
fi

# check os-release
RELEASE_INFO=$(cat /etc/os-release | grep "^VERSION=" | awk -F '="' '{print $2}' | awk '{print $1}' | cut -b 1-5)
if [ $RELEASE_INFO == '7' ];then
    RELEASE_PATH='centos/7'
elif [[ $RELEASE_INFO =~ "14" ]];then
    RELEASE_PATH='ubuntu/trusty'
elif [[ $RELEASE_INFO =~ '16' ]];then
    RELEASE_PATH='ubuntu/xenial'
else
    echo "Release $(cat /etc/os-release | grep "PRETTY" | awk -F '"' '{print $2}') Not supported"
    exit 2
fi


CONF_FILE="config.json"

# acp version such as 3.3
ACP_VERSION=$($JQBIN .version $CONF_FILE)
REPO_VERSION=${ACP_VERSION}
IMG_DIR="$PWD/rbdimg"
REPO_PATH="$PWD/repo"
IMG_PATH="rainbond/"

ACP_MODULES=$($JQBIN .pri_img[] $CONF_FILE|sed 's/"//g')
ARCHIVER_IMG=$($JQBIN .archiver[] $CONF_FILE | sed 's/"//g')

OTHER_MODULES=$($JQBIN '.pub_img[]' $CONF_FILE | sed 's/"//g' )

COMPUTE_LOAD_IMGS="$ARCHIVER_IMG \
calico-node:v1.3.0"

COMPUTE_LOAD_MODULES=$($JQBIN .compute_load_img[] $CONF_FILE|sed 's/"//g')

DEFAULT_RPMS=$($JQBIN .default_rpms[] $CONF_FILE | sed 's/"//g' )

LVM_PROFILE=$($JQBIN .files.lvm_profile $CONF_FILE | sed 's/"//g' )
DOCKER_ENV_FILE=$($JQBIN .files.docker_env_file $CONF_FILE | sed 's/"//g' )
INSTALL_TYPE=$($JQBIN .install_type $CONF_FILE | sed 's/"//g')

# ========== functions =============

function check(){

    echo -e "\e[32minit system for rainbond...\e[0m\n"
    [ ! -d /etc/goodrain ] && mkdir -pv /etc/goodrain
    echo -e "{\n\"install_type\":\"local\",\n\"time\":\"`date +'%F %H:%M:%S'`\"\n}" > /etc/goodrain/.config.json

    # init docker config
    mkdir -pv ~/.docker
    [ ! -f ~/.docker/config.json ] && echo "{}" > ~/.docker/config.json

    echo -e "\e[32mCheck default gateway...\e[0m"
    haveGW=`route -n| grep UG|awk '{print $2}'`
    if [ "$haveGW" != "" ];then
        echo -e "Default Gateway: \e[32m$haveGW\e[0m"
    else
        echo -e "\e[31mFailure,not found default gateway.\nPlease set the default route.\nUse\e[0m [\e[33mroute add default gw route-ipaddress\e[0m] \e[31mto set.\e[0m"
        exit 2
    fi

    # check localhost in /etc/hosts
    if [ ! "$(grep localhost /etc/hosts)" ];then
        echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
    fi

    # check unnecessary service
    echo -e "\e[32mCheck unnecessary service...\e[0m"
    if [[ $RELEASE_INFO == '7' ]];then
        echo "disable firewalld"
        systemctl stop firewalld \
        && systemctl disable firewalld

        echo "disable NetworkManager"
        systemctl stop NetworkManager \
        && systemctl disable NetworkManager

        echo -e "\e[32mCheck dns...\e[0m"
        
        systemctl stop dnsmasq
        sed -i 's/^dns=dnsmasq/#&/' /etc/NetworkManager/NetworkManager.conf
    fi

    if [[ "$(lsof -i:53 | wc -l)" -ne 0 ]];then
        lsof -i:53 | grep -v 'PID' | awk '{print $2}' | uniq | xargs kill -9
        if [[ "$?" -eq 0 ]];then
            echo "stop dnsmasq"
        fi
    fi
    if [[ "$(lsof -i:5353 | wc -l)" -ne 0 ]];then
        lsof -i:5353 | grep -v 'PID' | awk '{print $2}' | uniq | xargs kill -9
        if [[ "$?" -eq 0 ]];then
            echo ""
        fi
    fi
}

function setup_domain(){
    [ ! -d /data ] && mkdir /data
    read -p "Please input apps sub domain just like ( docker.demo.com ): " SUB_DOMAIN
    if [ -z $SUB_DOMAIN ];then
        echo "docker.demo.com" > /data/.domain.log
    else
        echo $SUB_DOMAIN > /data/.domain.log
    fi
}

function config_mirrors(){
    read -p $'\e[32mReconfigure yum mirror?\e[0m (y|n): ' isOK
        if [ "$isOK" == "Y" -o "$isOK" == "y" ];then
            yum clean all \
            && rm -rf /etc/yum.repos.d/*
            cat >/etc/yum.repos.d/acp.repo <<EOF
[acp-local]
name=local
baseurl=file://$PWD/repo
enabled=1
gpgcheck=0
EOF
    yum makecache
    echo "Install the system prerequisite package..."
    yum install -y $DEFAULT_RPMS
fi
}

function make_storage(){    

    if [ ! -f /etc/lvm/profile/docker-thinpool.profile ];then

        echo -e "\e[31m Warning: Defalut Skip Device;Only support more than two disks;\e[0m"

        read -p "Make docker storage device? [Y|N] (defalut:N)" MAKE_DEVICE
        if [ "$MAKE_DEVICE" == "Y" -o "$MAKE_DEVICE" == 'y' ] ;then
            lsblk -l
            echo -e "\e[31m1st device(vda/sda/xvda)should not select,just for system.\e[0m"
            read -p $'\e[32mPlease select device(e.g:vdb/sdb/xvdb) for docker storage device: \e[0m' DOCKER_DEVICE

            if [ -b /dev/$DOCKER_DEVICE ];then
                echo -en "\n\e[32mAre you sure use \e[0m\e[31m[$DOCKER_DEVICE]\e[0m \e[32mfor docker storage?\e[0m"
                read -p " (Y=yes|N=no|C=cancel): " ARE_YOU_SURE
                ARE_YOU_SURE="$(echo ${ARE_YOU_SURE} | tr 'A-Z' 'a-z')"
            else
                echo "DEVICE $DOCKER_DEVICE IS NOT EXIST!"
            fi

            if [ "$ARE_YOU_SURE" == "y" -o "$ARE_YOU_SURE" == "" ] ;then   

                pvcreate /dev/$DOCKER_DEVICE \
                && vgcreate docker /dev/$DOCKER_DEVICE \
                && vgdisplay docker \
                \
                && lvcreate --wipesignatures y -n thinpool docker -l 95%VG \
                && lvcreate --wipesignatures y -n thinpoolmeta docker -l 1%VG \
                \
                && lvconvert -y --zero n -c 512K --thinpool docker/thinpool --poolmetadata docker/thinpoolmeta \
                && cat > /etc/lvm/profile/docker-thinpool.profile << EOF
activation {
thin_pool_autoextend_threshold=80
thin_pool_autoextend_percent=20
}
EOF
                
                lvchange --metadataprofile docker-thinpool docker/thinpool

            elif [ "$ARE_YOU_SURE" == "c" -o "$ARE_YOU_SURE" == "n" ];then
                echo "Skip make docker storage device,use defalut."
            fi
        fi
        echo "Skip make docker storage device"
    fi
}

function config_grub(){
    configured=`grep "swapaccount=1" /etc/default/grub`
    if [ "$configured" == "" ];then
      #echo "limit swap"
      echo GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1" >> /etc/default/grub 
        if [[ $RELEASE_INFO == '7' ]];then
            grub2-mkconfig -o  /boot/grub2/grub.cfg 
        else
            grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
}

function add_permission(){
    start_path="$PWD/install/$ACP_VERSION/start.sh"
    sql_path="$PWD/modules/rbd_db/sql/import_sql.sh"
    chmod +x $start_path $sql_path $PWD/tools/*
}