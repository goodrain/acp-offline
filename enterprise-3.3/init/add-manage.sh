#!/bin/bash

# envs
GOODRAIN_PATH="/etc/goodrain"
INITED_FILE="${GOODRAIN_PATH}/.inited"
[ ! -d $GOODRAIN_PATH ] && mkdir -p $GOODRAIN_PATH 

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

# init

function check(){
    echo -e "\e[32minit system for acp...\e[0m\n"

    echo -e "\e[32mCheck default gateway...\e[0m"
    haveGW=`route -n| grep UG|awk '{print $2}'`
    if [ "$haveGW" != "" ];then
        echo -e "Default Gateway: \e[32m$haveGW\e[0m"
    else
        echo -e "\e[31mFailure,not found default gateway.\nPlease set the default route.\nUse\e[0m [\e[33mroute add default gw route-ipaddress\e[0m] \e[31mto set.\e[0m"
        exit 2
    fi

    # check unnecessary service
    echo -e "\e[32mCheck unnecessary service...\e[0m"
    echo "disable firewalld"
    systemctl stop firewalld \
    && systemctl disable firewalld

    echo "disable NetworkManager"
    systemctl stop NetworkManager \
    && systemctl disable NetworkManager

    echo -e "\e[32mCheck dns...\e[0m"
    
    systemctl stop dnsmasq
    sed -i 's/^dns=dnsmasq/#&/' /etc/NetworkManager/NetworkManager.conf
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

# check init
function check_inited(){
    key=$1
    if [ -f $INITED_FILE ];then
        value=`grep $key $INITED_FILE`
        if [ "$value" == "" ];then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

function config_mirrors(){
    if [[ $RELEASE_INFO == '7' ]];then
        echo -e "\e[32mConfigure yum repo...\e[0m"
        cat >/etc/yum.repos.d/acp.repo <<EOF
[goodrain]
name=goodrain CentOS-\$releasever - for x86_64
baseurl=http://repo.goodrain.com/centos/\$releasever/3.3/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://repo.goodrain.com/gpg/RPM-GPG-KEY-CentOS-goodrain
EOF
        echo "repo=on" >> $INITED_FILE \
        && yum makecache \
        && yum install -y lsof htop rsync
    else
        echo -e "\e[32mConfigure apt sources.list...\e[0m"
        echo deb http://repo.goodrain.com/ubuntu/14.04 3.3 main | tee /etc/apt/sources.list.d/acp.list \
        && curl http://repo.goodrain.com/gpg/goodrain-C4CDA0B7 2>/dev/null | apt-key add - \
        && echo "repo=on" >> $INITED_FILE \
        && apt-get update
    fi
}

function make_storage(){
        read -p "Make docker storage device? [Y|N] (defalut:Y)" MAKE_DEVICE
        if [ "$MAKE_DEVICE" == "N" -o "$MAKE_DEVICE" == 'n' ] ;then
            echo "Skip make docker storage device"
            echo "devicemapper=off" >> $INITED_FILE
            return 0
        fi
        lsblk -l
        echo -e "\e[31m1st device(vda/sda)should not select,just for system.\e[0m"
        read -p $'\e[32mPlease select device for docker storage device: \e[0m' DOCKER_DEVICE

        if [ -b /dev/$DOCKER_DEVICE ];then
            echo -en "\n\e[32mAre you sure use \e[0m\e[31m[$DOCKER_DEVICE]\e[0m \e[32mfor docker storage?\e[0m"
            read -p " (Y=yes|N=no|C=cancel): " ARE_YOU_SURE
            ARE_YOU_SURE="$(echo ${ARE_YOU_SURE} | tr 'A-Z' 'a-z')"
        else
            echo "DEVICE $DOCKER_DEVICE IS NOT EXIST!"
        fi

        if [ "$ARE_YOU_SURE" == "y" -o "$ARE_YOU_SURE" == "" ] ;then

            # install lvm
            yum install -y lvm2 \
            && pvcreate /dev/$DOCKER_DEVICE \
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
            
            lvchange --metadataprofile docker-thinpool docker/thinpool \
            && echo "devicemapper=on" >> $INITED_FILE

        elif [ "$ARE_YOU_SURE" == "c" -o "$ARE_YOU_SURE" == "n" ];then
            echo "Skip make docker storage device"
            echo "devicemapper=off" >> $INITED_FILE
            return 0
        fi
}

function config_grub(){
    echo "limit swap"
    echo GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1" >> /etc/default/grub \
    && grub2-mkconfig -o  /boot/grub2/grub.cfg \
    && echo "limitswap=on" >> $INITED_FILE
}

function run_install(){
    echo -e "\e[32mstart install acp on $HOSTNAME\e[0m"

    if [ -n "$MANAGE_IP" ];then
        curl -I repo.goodrain.com/install/$RELEASE_PATH/manage.sh 2>/dev/null | tee | head -1 | grep '200 OK' >/dev/null
        if [ $? -eq 0 ];then
            exec curl repo.goodrain.com/install/$RELEASE_PATH/manage.sh 2>/dev/null | bash
        else
            echo "request install script failed"
        fi
    else
		echo "You need set MANAGE_IP,just like: export MANAGE_IP=<MANAGE_IP>"
		exit 1
    fi
}

function init(){
    if [ $MANAGE_IP ];then
        echo $MANAGE_IP >> /tmp/manage_ip
    else
        echo "You need setting manage_ip.Just like:export MANAGE_IP=<manage_ip>"
    fi
}

if [ -n "RELEASE_PATH" ];then
    
    $(check_inited repo) || config_mirrors
    check
    $(check_inited devicemapper) || make_storage
    $(check_inited limitswap) || config_grub
    init
    run_install
fi
