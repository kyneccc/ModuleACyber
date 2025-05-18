# Краткое рукводство по работе 
### В панели администратора
1) Создать тип виртуальной машины с следущими параментами **имя тоже должно соответствовать!!!**
![image](https://github.com/kyneccc/ModuleACyber/blob/main/screenshots/flavor.png)
2) загрузить два образа с именами: alt-server-10.4-p10-cloud-x86_64.qcow2 и alt-workstation-10.4-p10-cloud-x86_64.qcow2 **имя образов должно быть точно такими же** скачать их можно [здесь](https://ftp.altlinux.org/pub/distributions/ALTLinux/p10/images/cloud/x86_64/)
![image](https://github.com/kyneccc/ModuleACyber/blob/main/screenshots/server.png) ![image](https://github.com/kyneccc/ModuleACyber/blob/main/screenshots/workstation.png)
> Важно поставить в поле "Использовать во всех проектах"
### В панеле проекта(пользователя)
1) Создать произвольную сеть с любой адресацией(помимомо тех которые будут использоваться в самом стенде включая сеть администрирования 10.100.100.0/24 
2) Создать маршрутизатор (имя произвольное) и добавить туда только что созданную сеть
3) Добавить ssh ключ с любым именем кроме MgVm
4) Создать виртуальную машину. Образ alt-server-10.4-p10-cloud-x86_64.qcow2. Расширить диск до 8гб. Тип ВМ Medium. В сетевых интерфесах добавить интерфейс из только что созданной сети(можно что бы адресация назначалась автоматически). И добавить только что созданный ssh-ключ ![image](https://github.com/kyneccc/ModuleACyber/blob/main/screenshots/vm.png)
5) После создания ВМ добавить ей плавающий ip-адрес

### Внутри машины администратора
1) ```sudo apt-get update && sudo apt-get install git -y```
2) ``` git clone https://github.com/kyneccc/ModuleACyber ```
3) Сгенерировать ssh ключи ```ssh-keygen```
4) ```cd ModuleACyber/```
5) ```sudo bash before_installation.sh```
6) ```cd bin```
7) **ОБЯЗАТЕЛЬНО** отредактируйте файл для подключения к инфраструктуре con.conf и проверьте подключения к инф-ре коммандой ```source bin/con.conf ; openstack port list --insecure``` в случае успешного выполнения команды вам будет показан список всех доступных инстансов
8) ``` bash moduleA.sh AdminVM``` AdminVM замените на имя вашей машины администратора(надо записать именно имя которое вы указывали при создании, а не hostname)
9) для получения доступа к виртуальным машинам используйте ssh + хостнейм вм. Пример ```ssh hq-rtr```
## Удаление стенда 
Для удаления просто запустите скрипт destroy.sh
``` bash destroy.sh ```
Единственный нюанс что тома от вм придеться удалять в ручную
### При возниккновения каких либо проблем обращaться в [телеграмм](https://t.me/kynecccc)
