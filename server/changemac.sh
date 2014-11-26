#!/bin/sh

echo "MAC address eth0: "
read eth0
echo "MAC address eth1: "
read eth1
echo "hostname: "
read hostname

sed -i s/HWADDR=..:..:..:..:..:../HWADDR=$eth0/g /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i s/HWADDR=..:..:..:..:..:../HWADDR=$eth1/g /etc/sysconfig/network-scripts/ifcfg-eth1
sed -i s/HOSTNAME=localhost.localdomain/HOSTNAME=$hostname/g /etc/sysconfig/network
sed -i s/127.0.0.1.*/127.0.0.1\ \ \ $hostname/g /etc/hosts
sed -i s/::1.*/::1\ \ \ \ \ \ \ \ \ $hostname/g /etc/hosts
rm -f /etc/udev/rules.d/70-persistent-net.rules
echo "Rebooting in 10s"
sleep 10;shutdown -r now
