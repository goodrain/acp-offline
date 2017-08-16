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
		
        if [ -z "$MANAGE_IP" ];then
	    echo "Unknown MANAGE_IP.Please export MANAGE_IP=ip_address(Manage ip)"
            exit 3
	fi
          /bin/bash $PWD/install/$dist_name/$dist_version/enterprise/compute.sh
    else
        echo "unexpect string: $RELEASE_INFO"
        exit 1
    fi
else
    exit 1
fi
