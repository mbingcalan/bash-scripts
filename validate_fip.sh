#!/bin/bash
#Author: Michael Bingcalan
#Created: 7.14.2015
#Purpose: Check for valid IP/CIDR for openstack floating_ip variable based on platform requirement. 

IFS=","
set -f
output=$(awk /floating_ip/ inventory_file | cut -d "=" -f2)
echo $output|grep "/" > /dev/null
ipstat=$?

if [[ $ipstat -eq 0 ]]; then
    echo "Valid"
else
    for ip in $output
    do
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 254 && ${ip[3]} -ge 1 ]]
        stat=$?
	for i in $stat ; do
		if [[ $i -eq 0 ]]; then 
			echo "Valid"
			exit 0
		fi
	done	
    fi

    done
fi
