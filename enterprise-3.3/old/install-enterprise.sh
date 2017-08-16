#!/bin/bash
RELEASE_INFO=$(python -c "
import sys
import platform

if platform.system() != 'Linux':
    sys.stderr.write('Only support Linux System\n')
    sys.exit(1)

if platform.machine() != 'x86_64':
    sys.stderr.write('Only support x86_64 machine\n')
    sys.exit(1)

dist_name, dist_version, dist_id = platform.linux_distribution()

if dist_name == 'CentOS Linux':
    dist_name = 'centos'
    centos_supports = ('7',)
    if dist_version[0] not in centos_supports:
        sys.stderr.write('CentOS release support {}, current is {}\n'.format(', '.join(centos_supports), dist_version))
        sys.exit(1)
    else:
        sys.stdout.write('{} {}\n'.format(dist_name, dist_version[0]))
elif dist_name.lower() == 'ubuntu':
    dist_name = 'ubuntu'
    ubuntu_supports = ('trusty',)
    if dist_id.lower() not in ubuntu_supports:
        sys.stderr.write('Ubuntu release support {}, current is {}\n'.format(', '.join(ubuntu_supports), dist_version))
        sys.exit(1)
    else:
        sys.stdout.write('{} {}\n'.format(dist_name, dist_id.lower()))
else:
    sys.stderr.write('Release <{}> is not supported.'.format(dist_name))
    sys.exit(2)
")

if [ -n "$RELEASE_INFO" ];then
    release_items=($RELEASE_INFO)
    item_length=${#release_items[@]}
    if [ $item_length -eq 2 ];then
        dist_name=${release_items[0]}
        dist_version=${release_items[1]}
		IP_INFO=$(ip ad | grep 'inet ' | grep brd | egrep ' 10.|172.|192.168' | awk '{print $2}' | cut -d '/' -f 1)
		IP_ITEMS=($IP_INFO)
		if [ -n "$LOCAL_IP" ];then
			echo $IP_INFO | grep $LOCAL_IP || (
				echo "invalid ip $LOCAL_IP"
				exit 1
			)
			curl -I repo.goodrain.com/install/$dist_name/$dist_version/enterprise/run.sh 2>/dev/null | tee | head -1 | grep '200 OK' >/dev/null
			if [ $? -eq 0 ];then
				exec curl repo.goodrain.com/install/$dist_name/$dist_version/enterprise/run.sh 2>/dev/null | bash
			else
				echo "request install script failed"
			fi
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
			curl -I repo.goodrain.com/install/$dist_name/$dist_version/enterprise/run.sh 2>/dev/null | tee | head -1 | grep '200 OK' >/dev/null
			if [ $? -eq 0 ];then
				exec curl repo.goodrain.com/install/$dist_name/$dist_version/enterprise/run.sh 2>/dev/null | bash
			else
				echo "request install script failed"
			fi
		fi
    else
        echo "unexpect string: $RELEASE_INFO"
        exit 1
    fi
else
    exit 1
fi
