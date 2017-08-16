#!/bin/bash

# envs
REPO_VERSION="3.3"
INSTALL_TYPE=$1
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
    if [ "$INSTALL_TYPE" == "local" ];then
        configured=`grep acp-local /etc/yum.repos.d/acp.repo`
        if [ "$configured" == "" ];then
            yum clean all \
            && rm -rf /etc/yum.repos.d/*

            cat >/etc/yum.repos.d/acp.repo <<EOF
[acp-local]
name=local
baseurl=file://$PWD/repo
enabled=1
gpgcheck=0
EOF

            echo "repo=on" >> $INITED_FILE 
            yum makecache

            echo "Install the system prerequisite package..."
            yum install -y perl telnet bind-utils htop dstat mariadb net-tools lsof
        fi
    else
        if [[ $RELEASE_INFO == '7' ]];then
            echo -e "\e[32mConfigure yum repo...\e[0m"
            cat >/etc/yum.repos.d/acp.repo <<EOF
[goodrain]
name=goodrain CentOS-\$releasever - for x86_64
baseurl=http://repo.goodrain.com/centos/\$releasever/\${REPO_VERSION}/\$basearch
enabled=1
gpgcheck=1
gpgkey=http://repo.goodrain.com/gpg/RPM-GPG-KEY-CentOS-goodrain
EOF
            echo "repo=on" >> $INITED_FILE \
            && yum makecache \
            && yum install -y lsof htop rsync net-tools
        else
            echo -e "\e[32mConfigure apt sources.list...\e[0m"
            echo deb http://repo.goodrain.com/ubuntu/14.04 ${REPO_VERSION} main | tee /etc/apt/sources.list.d/acp.list \
            && curl http://repo.goodrain.com/gpg/goodrain-C4CDA0B7 2>/dev/null | apt-key add - \
            && echo "repo=on" >> $INITED_FILE \
            && apt-get update
        fi
    fi
}

function make_storage(){

    if [ ! -f /etc/lvm/profile/docker-thinpool.profile ];then
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
    fi
}

function config_grub(){
    configured=`grep "swapaccount=1" /etc/default/grub`
    if [ "$configured" == "" ];then
      echo "limit swap"
      echo GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1" >> /etc/default/grub \
      && grub2-mkconfig -o  /boot/grub2/grub.cfg \
      && echo "limitswap=on" >> $INITED_FILE
    fi
}

function check_dns(){
    echo "configure dns"
    
}

function run_install(){
    
    if [ "$INSTALL_TYPE" == "local" ];then
        RUN_BIN="$PWD/install/$RELEASE_PATH/run.sh"
    else
        RUN_BIN="curl repo.goodrain.com/install/$RELEASE_PATH/run.sh 2>/dev/null | bash"
    fi
    
    echo -e "\e[32mstart install acp on $HOSTNAME\e[0m"
    IP_INFO=$(ip ad | grep 'inet ' | egrep ' 10.|172.|192.168' | awk '{print $2}' | cut -d '/' -f 1)
    IP_ITEMS=($IP_INFO)

    if [ -n "$LOCAL_IP" ];then
        echo $IP_INFO | grep $LOCAL_IP || (
            echo "invalid ip $LOCAL_IP"
            exit 1
        )
        mkdir -p /etc/goodrain/envs
        echo "LOCAL_IP=$LOCAL_IP" > /etc/goodrain/envs/ip.sh
        bash -c $RUN_BIN || echo "request install script failed"

    else
        if [ ${#IP_ITEMS[@]} -gt 1 ];then
            echo "multi ipaddress, you need specify one by 'export LOCAL_IP=<you_ip_address>'"
            echo "$IP_INFO"
            exit 1
        elif [ ${#IP_ITEMS[@]} -eq 0 ];then
            echo "no ipaddress found, "
            exit 1
        fi

        export LOCAL_IP=${IP_ITEMS[0]}
        mkdir -p /etc/goodrain/envs
        echo "LOCAL_IP=$LOCAL_IP" > /etc/goodrain/envs/ip.sh
        bash -c $RUN_BIN || echo "request install script failed"

    fi
}

function init(){
    if [ $LOCAL_IP ];then
        echo $LOCAL_IP >> /tmp/local_ip
    else
        echo "You need setting local_ip.Just like:export LOCAL_IP=<local_ip>"
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
