
# Домашнее задание к занятию 4 «Оркестрация группой Docker контейнеров на примере Docker Compose»

### Инструкция к выполению

1. Для выполнения заданий обязательно ознакомьтесь с [инструкцией](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD) по экономии облачных ресурсов. Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
2. Практические задачи выполняйте на личной рабочей станции или созданной вами ранее ВМ в облаке.
3. Своё решение к задачам оформите в вашем GitHub репозитории в формате markdown!!!
4. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

## Задача 1

Сценарий выполнения задачи:
- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: ```{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}```
- Зарегистрируйтесь и создайте публичный репозиторий  с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);
- скачайте образ nginx:1.21.1;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:
```
<html>cat 
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```
- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП). 
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

### Решение 1

Скачивание образа nginx:
```bash
docker pull nginx:1.21.1
```
Редактирование файла Dockerfile:

```
FROM nginx:1.21.1

WORKDIR /usr/share/nginx/html/
COPY index.html ./
```

Сборка кастомизированного образа:
```bash
docker build -t hachubra/custom_nginx:1.0.0 .
```
Вывод:
```bash
alex@ubu04:~/virtd-hw/05-virt-03-docker-intro$ docker build -t hachubra/custom_nginx:1.0.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  15.36kB
Step 1/3 : FROM nginx:1.21.1
 ---> 822b7ec2aaf2
Step 2/3 : WORKDIR /usr/share/nginx/html/
 ---> Running in 93150502b783
Removing intermediate container 93150502b783
 ---> 17755b0120a3
Step 3/3 : COPY index.html ./
 ---> df8f1f8d87d3
Successfully built df8f1f8d87d3
Successfully tagged hachubra/custom_nginx:1.0.0
```

Запуск контейнера для проверки корректности работы:
```bash
docker run -p 81:80 hachubra/custom_nginx:1.0.0
```
![screenshot1](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/1.png)
![screenshot2](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/2.png)

Вход в Docker Hub:
```bash
docker login
```
Вывод:
```bash
alex@ubu04:~/virtd-hw/05-virt-03-docker-intro$ docker login
Log in with your Docker ID or email address to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com/ to create one.
You can log in with your password or a Personal Access Token (PAT). Using a limited-scope PAT grants better security and is required for organizations using SSO. Learn more at https://docs.docker.com/go/access-tokens/

Username: solovyov_alex@mail.ru
Password: 
WARNING! Your password will be stored unencrypted in /home/alex/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
Загрузка образа в репозиторий Docker Hub:
```bash
docker push hachubra/custom_nginx:1.0.0
```
Вывод:
```bash
alex@ubu04:~/virtd-hw/05-virt-03-docker-intro$ docker push hachubra/custom_nginx:1.0.0
The push refers to repository [docker.io/hachubra/custom_nginx]
1586628c9f7e: Pushed 
d47e4d19ddec: Mounted from library/nginx 
8e58314e4a4f: Mounted from library/nginx 
ed94af62a494: Mounted from library/nginx 
875b5b50454b: Mounted from library/nginx 
63b5f2c0d071: Mounted from library/nginx 
d000633a5681: Mounted from library/nginx 
1.0.0: digest: sha256:58650a9e52d61689d694550e676eb0de4841860689c90d2c199d3aa9b57f5cbb size: 1777
```
Ссылка на образ:
[custom_nginx](https://hub.docker.com/repository/docker/hachubra/custom_nginx/general)

---

## Задача 2
1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:
- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080
2. Не удаляя, переименуйте контейнер в "custom-nginx-t2"
3. Выполните команду ```date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html```
4. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение 2

Запуск контейнера  **(порт с 8080 изменил на 8081, так как 8080 уже занят на ВМ):**

```bash
docker run -d -p 127.0.0.1:8081:80 --name "solovev-alex-nginx-t2" hachubra/custom_nginx:1.0.0  
```
```bash
alex@ubu04:~/virtd-hw$ docker run -d -p 127.0.0.1:8081:80 --name "solovev-alex-nginx-t2" hachubra/custom_nginx:1.0.0 
a614c22201e86aa16b8ea94e454055949b75f00d1b6486de9577548955f49528
```

```bash
alex@ubu04:~/virtd-hw$ docker ps
```
```bash
CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS          PORTS                                                                                                                                                 NAMES
a614c22201e8   hachubra/custom_nginx:1.0.0   "/docker-entrypoint.…"   45 seconds ago   Up 44 seconds   127.0.0.1:8081->80/tcp                                                                                                                                solovev-alex-nginx-t2
01d01d1b1b63   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago      Up 22 hours     33060/tcp, 0.0.0.0:3310->3306/tcp, :::3310->3306/tcp                                                                                                  master1
a0f3cba240ff   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago      Up 22 hours     33060/tcp, 0.0.0.0:3309->3306/tcp, :::3309->3306/tcp                                                                                                  master2
687558216a66   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago      Up 22 hours     33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp                                                                                                  mysql-slave
030d5e50f15a   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago      Up 22 hours     33060/tcp, 0.0.0.0:3308->3306/tcp, :::3308->3306/tcp                                                                                                  mysql-master
9e91c37083fc   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago     Up 22 hours     0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql
e1fdde56c212   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago     Up 22 hours     4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, :::5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq1
d6febb386f8c   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago     Up 22 hours     4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp      
```

```bash
docker ps
```
```bash
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                                                                                                                                                 NAMES
a614c22201e8   hachubra/custom_nginx:1.0.0   "/docker-entrypoint.…"   4 minutes ago   Up 4 minutes   127.0.0.1:8081->80/tcp                                                                                                                                custom-nginx-t2
01d01d1b1b63   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 22 hours    33060/tcp, 0.0.0.0:3310->3306/tcp, :::3310->3306/tcp                                                                                                  master1
a0f3cba240ff   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 22 hours    33060/tcp, 0.0.0.0:3309->3306/tcp, :::3309->3306/tcp                                                                                                  master2
687558216a66   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 22 hours    33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp                                                                                                  mysql-slave
030d5e50f15a   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 22 hours    33060/tcp, 0.0.0.0:3308->3306/tcp, :::3308->3306/tcp                                                                                                  mysql-master
9e91c37083fc   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago    Up 22 hours    0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql
e1fdde56c212   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago    Up 22 hours    4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, :::5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq1
d6febb386f8c   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago    Up 22 hours    4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp                                                                                  rabbitmq2
```
Выполнение команды:
```bash
date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8081  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html
```
```bash
10-12-2024 14:15:42.930489649 +05
CONTAINER ID   IMAGE                         COMMAND                  CREATED         STATUS         PORTS                                                                                                                                                 NAMES
a614c22201e8   hachubra/custom_nginx:1.0.0   "/docker-entrypoint.…"   8 minutes ago   Up 8 minutes   127.0.0.1:8081->80/tcp                                                                                                                                custom-nginx-t2
01d01d1b1b63   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 23 hours    33060/tcp, 0.0.0.0:3310->3306/tcp, :::3310->3306/tcp                                                                                                  master1
a0f3cba240ff   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 23 hours    33060/tcp, 0.0.0.0:3309->3306/tcp, :::3309->3306/tcp                                                                                                  master2
687558216a66   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 23 hours    33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp                                                                                                  mysql-slave
030d5e50f15a   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago     Up 23 hours    33060/tcp, 0.0.0.0:3308->3306/tcp, :::3308->3306/tcp                                                                                                  mysql-master
9e91c37083fc   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago    Up 23 hours    0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql
e1fdde56c212   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago    Up 23 hours    4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, :::5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq1
d6febb386f8c   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago    Up 23 hours    4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp                                                                                  rabbitmq2
LISTEN 0      2048       127.0.0.1:8081       0.0.0.0:*          
2024/12/10 09:06:49 [notice] 1#1: start worker process 34
PGh0bWw+Cgo8aGVhZD4KICAgIEhleSwgTmV0b2xvZ3kKPC9oZWFkPgoKPGJvZHk+CiAgICA8aDE+
SSB3aWxsIGJlIERldk9wcyBFbmdpbmVlciE8L2gxPgo8L2JvZHk+Cgo8L2h0bWw+
```
![screenshot3](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/3.png)
![screenshot4](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/4.png)

---

## Задача 3
1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
3. Выполните ```docker ps -a``` и объясните своими словами почему контейнер остановился.
4. Перезапустите контейнер
5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
8. Запомните(!) и выполните команду ```nginx -s reload```, а затем внутри контейнера ```curl http://127.0.0.1:80 ; curl http://127.0.0.1:81```.
9. Выйдите из контейнера, набрав в консоли  ```exit``` или Ctrl-D.
10. Проверьте вывод команд: ```ss -tlpn | grep 127.0.0.1:8080``` , ```docker port custom-nginx-t2```, ```curl http://127.0.0.1:8080```. Кратко объясните суть возникшей проблемы.
11. * Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)
12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение 3

Подключение к к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2":

```bash
alex@ubu04:~/virtd-hw$ docker attach custom-nginx-t2

^C2024/12/10 12:23:53 [notice] 1#1: signal 2 (SIGINT) received, exiting
2024/12/10 12:23:53 [notice] 29#29: exiting
2024/12/10 12:23:53 [notice] 29#29: exit
2024/12/10 12:23:53 [notice] 32#32: exiting
2024/12/10 12:23:53 [notice] 32#32: exit
2024/12/10 12:23:53 [notice] 30#30: exiting
2024/12/10 12:23:53 [notice] 30#30: exit
2024/12/10 12:23:53 [notice] 31#31: exiting
2024/12/10 12:23:53 [notice] 31#31: exit
2024/12/10 12:23:53 [notice] 1#1: signal 17 (SIGCHLD) received from 29
2024/12/10 12:23:53 [notice] 1#1: worker process 29 exited with code 0
2024/12/10 12:23:53 [notice] 1#1: worker process 32 exited with code 0
2024/12/10 12:23:53 [notice] 1#1: signal 29 (SIGIO) received
2024/12/10 12:23:53 [notice] 1#1: signal 17 (SIGCHLD) received from 30
2024/12/10 12:23:53 [notice] 1#1: worker process 30 exited with code 0
2024/12/10 12:23:53 [notice] 1#1: worker process 31 exited with code 0
2024/12/10 12:23:53 [notice] 1#1: exit
```

**ctrl+c  привел к остановке так как завершился родительский процесс, а при его завершении останавливается весь контейнер**

```bash
alex@ubu04:~/virtd-hw$ docker ps -a
```
```
alex@ubu04:~/virtd-hw$ docker ps -a
CONTAINER ID   IMAGE                         COMMAND                  CREATED        STATUS                      PORTS                                                                                                                                                 NAMES
a614c22201e8   hachubra/custom_nginx:1.0.0   "/docker-entrypoint.…"   3 hours ago    Exited (0) 33 seconds ago                                                                                                                                                         custom-nginx-t2
7aa829621fe9   postgres:latest               "docker-entrypoint.s…"   7 weeks ago    Exited (0) 6 weeks ago                                                                                                                                                            postgres_b
fe28b830ed10   postgres:latest               "docker-entrypoint.s…"   7 weeks ago    Exited (0) 6 weeks ago                                                                                                                                                            postgres_b3
cac181e19a09   postgres:latest               "docker-entrypoint.s…"   7 weeks ago    Exited (0) 6 weeks ago                                                                                                                                                            postgres_b2
8f1dfaf27995   postgres:latest               "docker-entrypoint.s…"   7 weeks ago    Exited (0) 6 weeks ago                                                                                                                                                            postgres_b1
01d01d1b1b63   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago    Up 13 minutes               33060/tcp, 0.0.0.0:3310->3306/tcp, :::3310->3306/tcp                                                                                                  master1
a0f3cba240ff   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago    Up 13 minutes               33060/tcp, 0.0.0.0:3309->3306/tcp, :::3309->3306/tcp                                                                                                  master2
687558216a66   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago   Up 13 minutes               33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp                                                                                                  mysql-slave
030d5e50f15a   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago   Up 13 minutes               33060/tcp, 0.0.0.0:3308->3306/tcp, :::3308->3306/tcp                                                                                                  mysql-master
9e91c37083fc   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago   Up 13 minutes               0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql
e1fdde56c212   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago   Up 13 minutes               4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, :::5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq1
d6febb386f8c   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago   Up 13 minutes               4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp                                                                                  rabbitmq2
1e546a72b771   redis                         "docker-entrypoint.s…"   3 months ago   Exited (0) 3 months ago                                                                                                                                                           reist
53fb48f5bba0   memcached                     "docker-entrypoint.s…"   3 months ago   Exited (0) 3 months ago                                                                                                                                                           memc
5ffe458d56b7   sonarqube:community           "/opt/sonarqube/dock…"   5 months ago   Exited (130) 5 months ago                                                                                                                                                         gitlab-sonarqube-1
b03751a146a7   postgres:12                   "docker-entrypoint.s…"   5 months ago   Exited (0) 5 months ago                                                                                                                                                           gitlab-db-1
```
Перезапуск контейнера:

```bash
alex@ubu04:~/virtd-hw$ docker ps
```
```
CONTAINER ID   IMAGE                         COMMAND                  CREATED             STATUS         PORTS                                                                                                                                                 NAMES
a614c22201e8   hachubra/custom_nginx:1.0.0   "/docker-entrypoint.…"   About an hour ago   Up 4 seconds   127.0.0.1:8081->80/tcp                                                                                                                                custom-nginx-t2
01d01d1b1b63   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago         Up 24 hours    33060/tcp, 0.0.0.0:3310->3306/tcp, :::3310->3306/tcp                                                                                                  master1
a0f3cba240ff   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago         Up 24 hours    33060/tcp, 0.0.0.0:3309->3306/tcp, :::3309->3306/tcp                                                                                                  master2
687558216a66   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago        Up 24 hours    33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp                                                                                                  mysql-slave
030d5e50f15a   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago        Up 24 hours    33060/tcp, 0.0.0.0:3308->3306/tcp, :::3308->3306/tcp                                                                                                  mysql-master
9e91c37083fc   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago        Up 24 hours    0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql
e1fdde56c212   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago        Up 24 hours    4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, :::5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq1
d6febb386f8c   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago        Up 24 hours    4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp                                                                                  rabbitmq2
```
```bash
docker exec -it custom-nginx-t2 bash
```
```bash
root@a614c22201e8:/usr/share/nginx/html#
```
Установка nano внутри контейнера:

```bash
root@a614c22201e8:/usr/share/nginx/html# apt update
```
```bash
Get:1 http://security.debian.org/debian-security buster/updates InRelease [34.8 kB]
Get:2 http://deb.debian.org/debian buster InRelease [122 kB]                       
Get:3 http://deb.debian.org/debian buster-updates InRelease [56.6 kB]
Get:4 http://security.debian.org/debian-security buster/updates/main amd64 Packages [610 kB]
Get:5 http://deb.debian.org/debian buster/main amd64 Packages [7909 kB]
Get:6 http://deb.debian.org/debian buster-updates/main amd64 Packages [8788 B]
Fetched 8741 kB in 3s (3474 kB/s)                         
Reading package lists... Done
Building dependency tree       
Reading state information... Done
56 packages can be upgraded. Run 'apt list --upgradable' to see them.
```
```bash
root@a614c22201e8:/usr/share/nginx/html# apt install nano
```
```bash
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Suggested packages:
  spell
The following NEW packages will be installed:
  nano
0 upgraded, 1 newly installed, 0 to remove and 56 not upgraded.
Need to get 545 kB of archives.
After this operation, 2269 kB of additional disk space will be used.
Get:1 http://security.debian.org/debian-security buster/updates/main amd64 nano amd64 3.2-3+deb10u1 [545 kB]
Fetched 545 kB in 0s (2220 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package nano.
(Reading database ... 7638 files and directories currently installed.)
Preparing to unpack .../nano_3.2-3+deb10u1_amd64.deb ...
Unpacking nano (3.2-3+deb10u1) ...
Setting up nano (3.2-3+deb10u1) ...
update-alternatives: using /bin/nano to provide /usr/bin/editor (editor) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/editor.1.gz because associated file /usr/share/man/man1/nano.1.gz (of link group editor) doesn't exist
update-alternatives: using /bin/nano to provide /usr/bin/pico (pico) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/pico.1.gz because associated file /usr/share/man/man1/nano.1.gz (of link group pico) doesn't exist
root@a614c22201e8:/usr/share/nginx/html# 
```
```bash
root@a614c22201e8:/usr/share/nginx/html# nano /etc/nginx/conf.d/default.conf
```
```bash
root@a614c22201e8:/usr/share/nginx/html# nginx -s reload
2024/12/10 10:44:28 [notice] 323#323: signal process started
```
```bash
curl http://127.0.0.1:80 ; curl http://127.0.0.1:81
```
```html
curl: (7) Failed to connect to 127.0.0.1 port 80: Connection refused
<html>

<head>
    Hey, Netology
</head>

<body>
    <h1>I will be DevOps Engineer!</h1>
</body>

</html>
```

```bash 
ss -tlpn | grep 127.0.0.1:8081
``` 
```
LISTEN 0      1024       127.0.0.1:8080       0.0.0.0:* 
```
```bash
docker port custom-nginx-t2
```
```
80/tcp -> 127.0.0.1:8081
```
```bash
curl http://127.0.0.1:8081
```
```
curl: (56) Recv failure: Connection reset by peer
```

Проблема с подключением связана с тем, что внутри контейнера изменился порт с 80 на 81.
Для исправления ошибки необходимо изменить порт, на который прокидывается порт хостовой маашины внутрь контейнера:

```bash
docker stop custom-nginx-t2
```
```bash
systemctl stop docker.socket
```
```bash
systemctl stop docker
```
Далее редактируем файл config.v2.json (находим него по идентификатору в каталоге /var/lib/docker/containers/):
```bash
sed 's/"ExposedPorts":{"80\/tcp":{}}/"ExposedPorts":{"81\/tcp":{}}/'  /var/lib/docker/containers/a614c22201e86aa16b8ea94e454055949b75f00d1b6486de9577548955f49528/config.v2.json
```
Запускаем сначала docker.socket, затем docker, после сам контейнер. 
```bash
systemctl start docker.socket 
```
```bash
systemctl start docker
```
```bash
docker start custom-nginx-t2
```
```bash
docker ps
```
```
CONTAINER ID   IMAGE                         COMMAND                  CREATED        STATUS          PORTS                                                                                                                                                 NAMES
a614c22201e8   hachubra/custom_nginx:1.0.0   "/docker-entrypoint.…"   3 hours ago    Up 6 seconds    81/tcp                                                                                                                                                custom-nginx-t2
01d01d1b1b63   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago    Up 35 seconds   33060/tcp, 0.0.0.0:3310->3306/tcp, :::3310->3306/tcp                                                                                                  master1
a0f3cba240ff   mysql:8.4.2                   "docker-entrypoint.s…"   8 weeks ago    Up 36 seconds   33060/tcp, 0.0.0.0:3309->3306/tcp, :::3309->3306/tcp                                                                                                  master2
687558216a66   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago   Up 36 seconds   33060/tcp, 0.0.0.0:3307->3306/tcp, :::3307->3306/tcp                                                                                                  mysql-slave
030d5e50f15a   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago   Up 36 seconds   33060/tcp, 0.0.0.0:3308->3306/tcp, :::3308->3306/tcp                                                                                                  mysql-master
9e91c37083fc   mysql:8.4.2                   "docker-entrypoint.s…"   2 months ago   Up 36 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql
e1fdde56c212   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago   Up 36 seconds   4369/tcp, 5671/tcp, 0.0.0.0:5672->5672/tcp, :::5672->5672/tcp, 15671/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   rabbitmq1
d6febb386f8c   rabbitmq:3.10.7-management    "docker-entrypoint.s…"   3 months ago   Up 36 seconds   4369/tcp, 5671-5672/tcp, 15671-15672/tcp, 15691-15692/tcp, 25672/tcp                                                                                  rabbitmq2
```

![screenshot5](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/5.png)
---

## Задача 4


- Запустите первый контейнер из образа ***centos*** c любым тегом в фоновом режиме, подключив папку  текущий рабочий каталог ```$(pwd)``` на хостовой машине в ```/data``` контейнера, используя ключ -v.
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив текущий рабочий каталог ```$(pwd)``` в ```/data``` контейнера. 
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```.
- Добавьте ещё один файл в текущий каталог ```$(pwd)``` на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.


В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение 4
```bash
docker pull debian
docker pull centos
```
```bash
docker run --name centos -t -d -v $(pwd):/data/ centos:latest
```
```bash
docker run --name debian -t -d -v $(pwd):/data/ debian:latest 
```
```bash
docker exec -it centos bash
[root@a80fad1c5a7f /]# touch /data/new_file.txt
[root@a80fad1c5a7f /]# ls /data
host_file.txt  new_file.txt  somefile.txt
[root@a80fad1c5a7f /]# 
```
```bash
alex@ubu04:~/virtd-hw/volume$ touch host_file.txt
```
```bash
alex@ubu04:~/virtd-hw$ docker exec -it debian bash
root@0eb881fc8ac0:/# ls /data
host_file.txt  new_file.txt  somefile.txt
root@0eb881fc8ac0:/# 
```
![screenshot6](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/6.png)

---

## Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
"compose.yaml" с содержимым:
```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
"docker-compose.yaml" с содержимым:
```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local  окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```
6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

7. Удалите любой из манифестов компоуза(например compose.yaml).  Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

### Решение 5

**Создание файлов:**
```bash
touch compose.yaml
touch docker-compose.yaml
```
```bash
docker compose up -d
```
**Используется файл compose.yaml, так как файл docker-compose.yaml является устаревшим и поддерживается для обратной совместимости, с меньшим приоритетом.**
```
WARN[0000] Found multiple config files with supported names: /home/alex/virtd-hw/05-virt-03-docker-intro/compose/compose.yaml, /home/alex/virtd-hw/05-virt-03-docker-intro/compose/docker-compose.yaml 
WARN[0000] Using /home/alex/virtd-hw/05-virt-03-docker-intro/compose/compose.yaml 
[+] Running 12/12
 ⠿ portainer Pulled                                                                                                                                                                                                                                                                                                               9.2s
   ⠿ 2a8c27161aa3 Pull complete                                                                                                                                                                                                                                                                                                   0.7s
   ⠿ 679061c2c821 Pull complete                                                                                                                                                                                                                                                                                                   0.8s
   ⠿ d40df14c1d7a Pull complete                                                                                                                                                                                                                                                                                                   2.1s
   ⠿ 8215717c7c10 Pull complete                                                                                                                                                                                                                                                                                                   4.0s
   ⠿ 542669febe7c Pull complete                                                                                                                                                                                                                                                                                                   4.8s
   ⠿ 6c27c7f45b54 Pull complete                                                                                                                                                                                                                                                                                                   5.5s
   ⠿ 070d3bf2528e Pull complete                                                                                                                                                                                                                                                                                                   5.5s
   ⠿ 846480e9f8b0 Pull complete                                                                                                                                                                                                                                                                                                   6.2s
   ⠿ c7053d7d4c2a Pull complete                                                                                                                                                                                                                                                                                                   6.6s
   ⠿ a2ed6de7fb5f Pull complete                                                                                                                                                                                                                                                                                                   6.6s
   ⠿ 4f4fb700ef54 Pull complete                                                                                                                                                                                                                                                                                                   6.6s
[+] Running 1/1
 ⠿ Container compose-portainer-1  Started           
```
**Измененный compose.yaml:**
```yaml
version: "3"
include:
  - docker-compose.yaml
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
**Запуск объединенной конфигурации:**
```bash
docker compose up -d
```

```
WARN[0000] Found multiple config files with supported names: /home/alex/virtd-hw/05-virt-03-docker-intro/compose/compose.yaml, /home/alex/virtd-hw/05-virt-03-docker-intro/compose/docker-compose.yaml 
WARN[0000] Using /home/alex/virtd-hw/05-virt-03-docker-intro/compose/compose.yaml 
WARN[0000] /home/alex/virtd-hw/05-virt-03-docker-intro/compose/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
WARN[0000] /home/alex/virtd-hw/05-virt-03-docker-intro/compose/compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 6/6
 ✔ registry Pulled                                                                                                                                                                                                                                                                                                                4.7s 
   ✔ dc0decf4841d Pull complete                                                                                                                                                                                                                                                                                                   1.4s 
   ✔ 6cb0aa443e23 Pull complete                                                                                                                                                                                                                                                                                                   1.8s 
   ✔ 813676e291ef Pull complete                                                                                                                                                                                                                                                                                                   2.1s 
   ✔ dc2fb7dcec61 Pull complete                                                                                                                                                                                                                                                                                                   2.2s 
   ✔ 916205650bfe Pull complete                                                                                                                                                                                                                                                                                                   2.2s 
[+] Running 3/3
 ✔ Network compose_default        Created                                                                                                                                                                                                                                                                                         0.2s 
 ✔ Container compose-portainer-1  Started                                                                                                                                                                                                                                                                                         0.5s 
 ✔ Container compose-registry-1   Started   
```
**Копирование образа custom-nginx в локальное registry**
```bash
docker tag hachubra/custom_nginx:1.0.0 localhost:5000/custom_nginx
```
```bash
docker push localhost:5000/custom_nginx
```
```
Using default tag: latest
The push refers to repository [localhost:5000/custom_nginx]
1586628c9f7e: Pushed 
d47e4d19ddec: Pushed 
8e58314e4a4f: Pushed 
ed94af62a494: Pushed 
875b5b50454b: Pushed 
63b5f2c0d071: Pushed 
d000633a5681: Pushed 
latest: digest: sha256:58650a9e52d61689d694550e676eb0de4841860689c90d2c199d3aa9b57f5cbb size: 1777
```
![screenshot7](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/7.png)
![screenshot8](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/8.png)
![screenshot9](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/9.png)
![screenshot10](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/10.png)
**Удаляем compose.yaml**
```bash
rm compose.yaml 
```

```bash
alex@ubu04:~/virtd-hw/05-virt-03-docker-intro/compose$ docker compose up -d
WARN[0000] /home/alex/virtd-hw/05-virt-03-docker-intro/compose/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
WARN[0000] Found orphan containers ([compose-portainer-1]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up. 
[+] Running 1/0
 ✔ Container compose-registry-1  Running                                                                                                                                                                                                                                 0.0s 
```
**Ошибка говорит о том, что обнаружен "осиротевший" контейнер (для которого отсутствует запись в compose файле).**
**Исправление ошибки c удалением "сироты":**
```bash
docker compose up -d --remove-orphans
```
```bash
WARN[0000] /home/alex/virtd-hw/05-virt-03-docker-intro/compose/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion 
[+] Running 2/1
 ✔ Container compose-portainer-1  Removed                                                                                                                                                                                                                                0.2s 
 ✔ Container compose-registry-1   Running  
```

![screenshot11](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-03-docker-intro/images/11.png)
---

### Правила приема

Домашнее задание выполните в файле readme.md в GitHub-репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.


