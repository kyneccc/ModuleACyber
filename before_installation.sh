#!/bin/bash

apt-get update #обновление списка пакетов
apt-get install python3-module-openstackclient  python3-module-octaviaclient python3-module-neutronclient  python3-module-novaclient -y # установка пакетов необходимых для работы openstack 
chmod 777 /etc/hosts
