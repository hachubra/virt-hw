# Домашнее задание к занятию 5. «Практическое применение Docker»

### Инструкция к выполнению

1. Для выполнения заданий обязательно ознакомьтесь с [инструкцией](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD) по экономии облачных ресурсов. Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
3. **Своё решение к задачам оформите в вашем GitHub репозитории.**
4. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.
5. Сопроводите ответ необходимыми скриншотами.

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0
1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```
```
Command 'docker-compose' not found, but can be installed with:

sudo snap install docker          # version 24.0.5, or
sudo apt  install docker-compose  # version 1.25.0-1

See 'snap info docker' for additional versions.
```
В случае наличия установленного в системе ```docker-compose``` - удалите его.  
2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  
###  **Своё решение к задачам оформите в вашем GitHub репозитории!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**

### Решение 0.
Проверка версии установленного docker compose:
```bash
docker-compose --version
```
```bash
Command 'docker-compose' not found, but can be installed with:
sudo snap install docker          # version 27.2.0, or
sudo apt  install docker-compose  # version 1.29.2-1
See 'snap info docker' for additional versions.
```
```bash
docker compose version
```
```
Docker Compose version v2.31.0
```

---

## Задача 1
1. Сделайте в своем github пространстве fork [репозитория](https://github.com/netology-code/shvirtd-example-python/blob/main/README.md).
   Примечание: В связи с доработкой кода python приложения. Если вы уверены что задание выполнено вами верно, а код python приложения работает с ошибкой то используйте вместо main.py файл old_main.py(просто измените CMD)
2. Создайте файл с именем ```Dockerfile.python``` для сборки данного проекта(для 3 задания изучите https://docs.docker.com/compose/compose-file/build/ ). Используйте базовый образ ```python:3.9-slim```. 
Обязательно используйте конструкцию ```COPY . .``` в Dockerfile. Не забудьте исключить ненужные в имадже файлы с помощью dockerignore. Протестируйте корректность сборки.  
3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).
4. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.

### Решение 1
**Листинг Docker.python**
```yaml
FROM python:3.9-slim AS builder
WORKDIR /app

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt ./

RUN --mount=type=cache,target=~/.cache/pip pip install -r requirements.txt

FROM python:3.9-alpine AS worker
WORKDIR /app

RUN addgroup --system python && \
    adduser --system --disabled-password  --ingroup python python && chown python:python /app
USER python

COPY --chown=python:python --from=builder /app/venv ./venv
COPY --chown=python:python . .


ENV PATH="/app/venv/bin:$PATH"
CMD ["python", "main.py"]
```
**Сборка образа**
```bash
docker build . -f Dockerfile.python -t pyth:1.0.0
```
```bash
[+] Building 53.8s (17/17) FINISHED                                                                                                                   docker:default
 => [internal] load build definition from Dockerfile.python                                                                                                     0.0s
 => => transferring dockerfile: 591B                                                                                                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.9-alpine                                                                                            2.1s
 => [internal] load metadata for docker.io/library/python:3.9-slim                                                                                              2.1s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                                   0.0s
 => [internal] load .dockerignore                                                                                                                               0.0s
 => => transferring context: 158B                                                                                                                               0.0s
 => [builder 1/5] FROM docker.io/library/python:3.9-slim@sha256:4ee0613170ac55ebc693a03b6655a5c6f387126f6bc3390e739c2e6c337880ef                                0.0s
 => [internal] load build context                                                                                                                               0.0s
 => => transferring context: 2.10kB                                                                                                                             0.0s
 => [worker 1/5] FROM docker.io/library/python:3.9-alpine@sha256:a08328c0af0464a2cf1227ab4a4a4686b90044ba36121f17ef6404e829a0d1c2                               0.0s
 => CACHED [builder 2/5] WORKDIR /app                                                                                                                           0.0s
 => [builder 3/5] RUN python -m venv /app/venv                                                                                                                  8.6s
 => [builder 4/5] COPY requirements.txt ./                                                                                                                      0.1s
 => [builder 5/5] RUN --mount=type=cache,target=~/.cache/pip pip install -r requirements.txt                                                                   40.9s
 => CACHED [worker 2/5] WORKDIR /app                                                                                                                            0.0s 
 => CACHED [worker 3/5] RUN addgroup --system python &&     adduser --system --disabled-password  --ingroup python python && chown python:python /app           0.0s 
 => [worker 4/5] COPY --chown=python:python --from=builder /app/venv ./venv                                                                                     0.7s 
 => [worker 5/5] COPY --chown=python:python . .                                                                                                                 0.1s 
 => exporting to image                                                                                                                                          0.6s 
 => => exporting layers                                                                                                                                         0.6s 
 => => writing image sha256:3c6316b7ced38b98b65168cc33dec20d3cee9b14fa34d4965b05a10a1dc19dcc                                                                    0.0s
 => => naming to docker.io/library/pyth:1.0.0  
 ```

 **.dockerignore:**
```
schema.pdf
compose.yml  
Dockerfile.python  
./haproxy/*
LICENSE
./nginx/*
proxy.yaml
README.md  
script.sh  
./venv/*
```

---
### ВНИМАНИЕ!
!!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```.dockerignore```,```bash-скрипт```. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!
---

## Задача 2 (*)
1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

### Решение 2

**Создание Registry:**
```bash
yc container registry create --name my-neto-registry
```
**Конфигурирование на использование с локальным Docker**
```bash
yc container registry configure-docker
```
```
docker configured to use yc --profile "netology-terraform" for authenticating "cr.yandex" container registries
Credential helper is configured in '/home/alex/.docker/config.json'
```
```bash
cat /home/alex/.docker/config.json
```
```json
{
  "auths": {
    "https://index.docker.io/v1/": {
      "auth": "*********************"
    }
  },
  "credHelpers": {
    "container-registry.cloud.yandex.net": "yc",
    "cr.cloud.yandex.net": "yc",
    "cr.yandex": "yc"
  }
```

``bash
docker tag pyth:1.0.0 cr.yandex/crpoe0n99c9b8hhacsdf/pyth:1.0.0
```

``bash
docker push cr.yandex/crpoe0n99c9b8hhacsdf/pyth:1.0.0
```
```bash
The push refers to repository [cr.yandex/crpoe0n99c9b8hhacsdf/pyth]
d2ed0e0547c9: Pushed 
f9a81e49a1c3: Pushed 
eb188d0af1e7: Pushed 
70fa14073653: Pushed 
a207579d5a34: Pushed 
e49ed1d40128: Pushed 
09a34c0698d8: Pushed 
3e01818d79cd: Pushed 
1.0.0: digest: sha256:df9cf23e1e4f12798b3d5e9bb47b1a1a72f4e16905c58263bef44f50a0d74f14 size: 1991
```
При сканировании выдается ошибка, так как я использовал не поддерживаемую ОС Alpine для сокращения размера образа при его создании в multistage.

![screenshot1](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/1.png)

---

## Задача 3
1. Изучите файл "proxy.yaml"
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!

4. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете ```NULL``` --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.

5. Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.

### Решение 3

![screenshot1](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/2.png)

---


## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. ПРИМЕЧАНИЕ:  приложение(old_main.py) весьма вероятно упадет под нагрузкой, но успеет обработать часть запросов - этого достаточно. Обновленная версия (main.py) не прошла достаточного тестирования временем, но должна справиться с нагрузкой.
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
6. В качестве ответа повторите  sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

### Решение 4

Проверка установки Docker на ВМ в Яндекс.
![screenshot3](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/3.png)

![screenshot4](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/4.png)

Скрипт:

```bash
#!/bin/bash
# sudo groupadd docker
# sudo usermod -aG docker $USER
# newgrp docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo rm /opt/pyth/ --force --recursive && sudo git clone https://github.com/hachubra/shvirtd-example-python.git /opt/pyth && docker compose -f /opt/pyth/compose.yml up -d
```

Cсылка на fork: https://github.com/hachubra/shvirtd-example-python.git






## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .


### Решение 6

```bash
alex@ubu04:~/virtd-hw$ docker pull hashicorp/terraform:latest
latest: Pulling from hashicorp/terraform
ff8f8c379796: Pull complete 
b25858963423: Pull complete 
ebbbc0b12cf8: Pull complete 
e443ce81d02b: Pull complete 
Digest: sha256:460267841b38628514b75c6b0eb1cebb2d2fb5d6b596087a9c277551c801e5f1
Status: Downloaded newer image for hashicorp/terraform:latest
docker.io/hashicorp/terraform:latest
```
```bash
alex@ubu04:~/virtd-hw$ docker run --rm -it \
    -v /var/run/docker.sock:/var/run/docker.sock \
    wagoodman/dive:latest hashicorp/terraform
Unable to find image 'wagoodman/dive:latest' locally
latest: Pulling from wagoodman/dive
619be1103602: Pull complete 
cf6c0733f07b: Pull complete 
a7dfad62b2da: Pull complete 
Digest: sha256:b4bbb985609f32ddfeb8a31f2cb254998fce2b95c358ad588a91a1ed138d6033
Status: Downloaded newer image for wagoodman/dive:latest
Image Source: docker://hashicorp/terraform
Fetching image... (this can take a while for large images)
Analyzing image...
Building cache...
```
![screenshot5](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/5.png)
![screenshot6](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/6.png)
![screenshot7](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/7.png)
![screenshot8](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/8.png)
![screenshot9](https://github.com/hachubra/virt-hw/blob/shvirtd-1/05-virt-04-docker-in-practice/images/9.png)


sha256:a2291ae31714cd13ae948f4cf01a5599ea46e49e3991c0a056ba3719c8d84e21

```bash
docker save hashicorp/terraform -o archive.tar
tar -xf archive.tar 
cd blobs/sha256/
```
```bash
alex@ubu04:~/virtd-hw/blobs/sha256$ tar -xf  a2291ae31714cd13ae948f4cf01a5599ea46e49e3991c0a056ba3719c8d84e21 
cp bin/terraform ~/virtd-hw/
```
**удаляем мусор:**

```bash
alex@ubu04:~/virtd-hw$ rm blobs --recursive --force 
alex@ubu04:~/virtd-hw$ rm terraform 
alex@ubu04:~/virtd-hw$ rm archive.tar 
```
----

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

## Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий .
