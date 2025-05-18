#!/bin/bash

cd /home/altlinux/ModuleACyber/bin
source ./con.conf

openstack network create mgmt  --insecure
openstack subnet create --subnet-range 10.100.100.0/24 --dhcp --network mgmt mgmtsub --insecure
openstack port create --network mgmt --fixed-ip ip-address=10.100.100.15 adminport --insecure
openstack server add port $1 adminport --insecure

sudo chmod 666 /etc/netplan/50-cloud-init.yaml
sudo echo '        eth1:' >> /etc/netplan/50-cloud-init.yaml
sudo echo '            dhcp4: true' >> /etc/netplan/50-cloud-init.yaml
sudo chmod 600 /etc/netplan/50-cloud-init.yaml
sudo netplan  apply 2>/dev/null

sleep 20

#Добавление ssh ключа для достпа к всем инстансам стенда
openstack keypair create --public-key /home/altlinux/.ssh/id_rsa.pub MgVM --insecure
#Создание необходимых сетей
openstack network create isp-hq  --insecure
openstack network create isp-br  --insecure
openstack network create srv-net  --insecure
openstack network create cli-net  --insecure
openstack network create br-net  --insecure

#Cоздание подсетей
openstack subnet create --subnet-range 172.16.4.0/28 --dhcp --network isp-hq isphqsub --insecure
openstack subnet create --subnet-range 172.16.5.0/28 --dhcp --network isp-br ispbrsub --insecure
openstack subnet create --subnet-range 192.168.2.0/28 --dhcp --network cli-net clihqsub --insecure
openstack subnet create --subnet-range 192.168.1.0/26 --dhcp --network srv-net srvhqsub --insecure
openstack subnet create --subnet-range 192.168.3.0/27 --dhcp --network br-net brnetsub --insecure

#Cоздание  роутера isp
openstack router create --enable-snat --external-gateway public isp --insecure
openstack router add subnet isp  isphqsub --insecure
openstack router add subnet isp  ispbrsub --insecure

#Cоздание портов и роутеров обоих офисов
openstack port create --network isp-hq --no-fixed-ip isp-to-hq --insecure
openstack port create --network isp-br --no-fixed-ip isp-to-br --insecure
openstack port create --network  srv-net --no-fixed-ip srv-hqr --insecure
openstack port create --network  srv-net --no-fixed-ip srv-hq --insecure
openstack port create --network  cli-net --no-fixed-ip cli-hq --insecure
openstack port create --network  cli-net --no-fixed-ip cli-hqr --insecure
openstack port create --network  br-net --no-fixed-ip srv-br --insecure
openstack port create --network  br-net --no-fixed-ip srv-brr --insecure

#Создание mgmt портов
openstack port create --network mgmt --fixed-ip ip-address=10.100.100.101 hq-rtr --insecure 
openstack port create --network mgmt --fixed-ip ip-address=10.100.100.102 hq-srv --insecure 
openstack port create --network mgmt --fixed-ip ip-address=10.100.100.103 hq-cli --insecure 
openstack port create --network mgmt --fixed-ip ip-address=10.100.100.104 br-rtr --insecure 
openstack port create --network mgmt --fixed-ip ip-address=10.100.100.105 br-srv --insecure

#Создание hq-rtr
openstack server create --flavor start  --port hq-rtr --image alt-server-10.4-p10-cloud-x86_64.qcow2 --boot-from-volume 10 --key-name MgVM HQ-RTR --insecure

#Создание br-rtr
openstack server create --flavor start  --port br-rtr --image alt-server-10.4-p10-cloud-x86_64.qcow2 --boot-from-volume 10 --key-name MgVM BR-RTR --insecure


#Создание hq-srv
openstack server create --flavor start  --port hq-srv --image alt-server-10.4-p10-cloud-x86_64.qcow2 --boot-from-volume 10 --key-name MgVM HQ-SRV --insecure


#Создание br-srv
openstack server create --flavor start  --port br-srv --image alt-server-10.4-p10-cloud-x86_64.qcow2 --boot-from-volume 10 --key-name MgVM BR-SRV --insecure

#Создание hq-cli
openstack server create --flavor medium  --port hq-cli --image alt-workstation-10.4-p10-cloud-x86_64.qcow2 --boot-from-volume 15 --key-name MgVM HQ-CLI --insecure

sleep 70

#Добавление необходимых портов к серверам
openstack server add port HQ-RTR isp-to-hq --insecure
openstack server add port HQ-RTR srv-hqr --insecure
openstack server add port HQ-RTR cli-hqr --insecure
openstack server add port BR-RTR isp-to-br --insecure
openstack server add port BR-RTR srv-brr --insecure
openstack server add port HQ-SRV srv-hq --insecure
openstack server add port HQ-CLI cli-hq --insecure
openstack server add port BR-SRV srv-br --insecure


#Запись в файл /etc/hosts
echo '10.100.100.101	 hq-rtr' >> /etc/hosts
echo '10.100.100.102'	hq-srv  >> /etc/hosts
echo '10.100.100.103	hq-cli' >> /etc/hosts
echo '10.100.100.104	br-rtr' >> /etc/hosts
echo '10.100.100.105	br-srv' >> /etc/hosts
