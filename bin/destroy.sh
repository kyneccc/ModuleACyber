#!/bin/bash

cd /home/altlinux/ModuleACyber/bin
source ./con.conf

#удаление портов
openstack port delete {br-srv,isp-to-br,adminport,isp-to-hq,srv-brr,srv-hqr,srv-hq,br-rtr,hq-rtr,cli-hqr,hq-cli,cli-hq,srv-br,hq-srv} --insecure
#удаление роутера
openstack router remove subnet isp isphqsub --insecure
openstack router remove subnet isp ispbrsub --insecure
openstack router delete  isp  --insecure

#Удаление подсетейa
openstack subnet delete {mgmtsub,clihqsub,ispbrsub,brnetsub,isphqsub,srvhqsub} --insecure

#Удаление сетей
openstack network delete {br-net,srv-net,isp-br,isp-hq,cli-net,mgmt} --insecure

#Удаление ключа ssh
openstack keypair delete MgVM --insecure

#удаление серверов
openstack server delete {HQ-CLI,BR-SRV,HQ-SRV,BR-RTR} --insecure
