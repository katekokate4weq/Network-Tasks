#!/bin/bash


set -e

# Interfaces configuration
rm /etc/sysconfig/network-scripts/ifcfg-eth1
cp /vagrant/Clientdmz1/ifcfg-eth1 /etc/sysconfig/network-scripts
if ! grep -q "DEFROUTE=no" /etc/sysconfig/network-scripts/ifcfg-eth0; 
then echo "DEFROUTE=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0; 
fi
echo "GATEWAYDEV=eth1" | tee /etc/sysconfig/network

# Restart interfaces
systemctl restart network

# Install bind-utils for host, nslookup and etc.
if ! rpm -qa | grep bind-utils; then
	yum --quiet install -y bind-utils
fi

# Install nginx
if ! rpm -qa | grep nginx; then
	yum --quiet install -y epel-release
	yum --quiet install -y nginx
	systemctl start nginx
	systemctl enable nginx
fi

# Restart interfaces
systemctl restart network