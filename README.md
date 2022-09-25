# Дипломное задание по курсу «DevOps-инженер»

>Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
>Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
>Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
>Настроить кластер MySQL.
>Установить WordPress.
>Развернуть Gitlab CE и Gitlab Runner.
>Настроить CI/CD для автоматического развёртывания приложения.
>Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.
>Этапы выполнения:
>
>1. Регистрация доменного имени
>
>Подойдет любое доменное имя на ваш выбор в любой доменной зоне.
>ПРИМЕЧАНИЕ: Далее в качестве примера используется домен you.domain замените его вашим доменом.
>Рекомендуемые регистраторы:
>
>• nic.ru
>• reg.ru
>
>Цель:
>
>Получить возможность выписывать TLS сертификаты для веб-сервера.
>Ожидаемые результаты:
>
>У вас есть доступ к личному кабинету на сайте регистратора.
>Вы зарезистрировали домен и можете им управлять (редактировать dns записи в рамках этого домена).


>Создайте VPC с подсетями в разных зонах доступности.
>Убедитесь, что теперь вы можете выполнить команды terraform destroy и terraform apply без дополнительных ручных действий.
>В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений успешно проходит, используя web-интерфейс >Terraform cloud.
>Цель:
>
>Повсеместно применять IaaC подход при организации (эксплуатации) инфраструктуры.
>Иметь возможность быстро создавать (а также удалять) виртуальные машины и сети. С целью экономии денег на вашем аккаунте в YandexCloud.
>Ожидаемые результаты:
>
>Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
>Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

 У меня уже было доменное имя `simonof.info`, поэтому я добавил у того же регистратора в DNS записи:

```
netology IN A      51.250.83.227 
www.netology IN A      51.250.83.227 
proxy.netology IN A      51.250.83.227
gitlab.netology IN A      51.250.83.227 
grafana.netology IN A      51.250.83.227 
prometheus.netology IN A      51.250.83.227 
alertmanager.netology IN A      51.250.83.227 
```

Забегая вперёд, скажу, что для этого арендовал в яндекс-облаке статический IP `51.250.83.227`.
Пожалуй, это было преждевременно, т.к. на следующий этап (терраформ) у меня ушло дней 15...

>2. Создание инфраструктуры
>
>Для начала необходимо подготовить инфраструктуру в YC при помощи Terraform.
>
>Особенности выполнения:
>
>Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
>Следует использовать последнюю стабильную версию Terraform.
>Предварительная подготовка:
>
>Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными >правами. Не стоит использовать права суперпользователя
>Подготовьте backend для Terraform:
>
>а. Рекомендуемый вариант: Terraform Cloud
>
>б. Альтернативный вариант: S3 bucket в созданном YC аккаунте.

Использован рекомендуемый вариант, Terraform Cloud.
![image](https://user-images.githubusercontent.com/92223664/192099775-ee39e742-e070-4836-9d33-852e5711862f.png)
https://i.vgy.me/g0GQbT.png

>Настройте workspaces
>а. Рекомендуемый вариант: создайте два workspace: stage и prod. В случае выбора этого варианта все последующие шаги должны учитывать факт >существования нескольких workspace.
>
>б. Альтернативный вариант: используйте один workspace, назвав его stage. Пожалуйста, не используйте workspace, создаваемый Terraform-ом >по-умолчанию (default).

Использован альтернативный вариант. 

>Создайте VPC с подсетями в разных зонах доступности.
>Убедитесь, что теперь вы можете выполнить команды terraform destroy и terraform apply без дополнительных ручных действий.
>В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений успешно проходит, используя web-интерфейс >Terraform cloud.
>Цель:
>
>Повсеместно применять IaaC подход при организации (эксплуатации) инфраструктуры.
>Иметь возможность быстро создавать (а также удалять) виртуальные машины и сети. С целью экономии денег на вашем аккаунте в YandexCloud.
>Ожидаемые результаты:
>
>Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
>Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

В рамках подготовительных работ сделано следующее:
* с помощью CLI создаются бесплатные ресурсы: каталог и сервис-аккаунт (которому даются права на каталог). Их ID, плюс ID яндекс-облака и ключ к сервис-аккаунту будут использованы в `terraform.tfvars`.
```bash
#! /bin/bash
yc iam service-account create --name sa-diplom --folder-name netology
yc resource-manager folder add-access-binding netology --role admin --service-account-name sa-diplom
yc iam key create --service-account-name sa-diplom --output ../key.json
```

* Снова забегая вперёд, а точнее - возвращаясь из будущего, где я уже встретился с проблемой, чтобы ходить на ноды за прокси, заложил их подсеть и проблемы смены компьютеров при перегенерации инфраструктуры, добавив в `~/.ssh/config` директиву ProxyJump, игнорирование сообщения о новом компьютере и запись knownhosts в /dev/null:

```yaml
Host 51.250.83.227  10.0.1.*
    User ubuntu
    IdentityFile ~/.ssh/id_rsa_diplom
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null

Host 10.0.1.*
    ProxyJump 51.250.83.227
```    

Некоторое время поэкспериментировав с самостоятельной настройкой маршрутизации - решил использовать готовый образ `nat-instance`. 
Быстрый, лёгкий, отлично работает "из коробки" без настроек.

>3. Установка Nginx и LetsEncrypt
>
>Необходимо разработать Ansible роль для установки Nginx и LetsEncrypt.
>Для получения LetsEncrypt сертификатов во время тестов своего кода пользуйтесь тестовыми сертификатами, так как количество запросов к боевым >серверам LetsEncrypt лимитировано.
>
>Рекомендации:
>
>• Имя сервера: you.domain
>• Характеристики: 2vCPU, 2 RAM, External address (Public) и Internal address.
>
>Цель:
>
>Создать reverse proxy с поддержкой TLS для обеспечения безопасного доступа к веб-сервисам по HTTPS.
>Ожидаемые результаты:
>
>В вашей доменной зоне настроены все A-записи на внешний адрес этого сервера:
>https://www.you.domain (WordPress)
>https://gitlab.you.domain (Gitlab)
>https://grafana.you.domain (Grafana)
>https://prometheus.you.domain (Prometheus)
>https://alertmanager.you.domain (Alert Manager)
>Настроены все upstream для выше указанных URL, куда они сейчас ведут на этом шаге не важно, позже вы их отредактируете и укажите верные >значения.

Применена относительно единообразная схема проксирования "сайт: домен, апстрим (адрес,порт)", типа:

```yml
www.netology.simonof.info:                               
    domains:                                             
      www.netology.simonof.info
    upstreams:
      {backend_address: 10.0.1.16, backend_port: 443}
# Следующий сайт:
```
Наполнение данными - хардкодингом.
К сожалению (для меня), выяснилось, что сервисы нужно ещё и заставить работать по `https`... 

В это время я уже был в некотором цейтноте и решил, что спасением будут роли из ansible-galaxy. Не факт, что сейчас, через почти 2 месяца, я могу сказать, что они ускорили процесс. Но думаю, что изучение чужих идей по поводу того, как что-либо должно происходить - принесло тоже немало интересного опыта. 
Потенциальное время выполнения задач по ansible я оцениваю месяца в 3-3,5 (т.к. опыта не было совсем, кроме 1-2 ДЗ). 
Выполняя диплом по второму разу, делая всё с нуля и самостоятельно - думаю, что смог бы уложиться в 1,5-2 месяца.

  На прокси-машине меня впервые (а далее - на каждом этапе. Сначала кажется, что иначе не хватит времени, если сперва все действия отрабатывать вручную, а затем вписывать в таски. Но количество правок и изучение чужого кода занимают в итоги не меньше времени) жизнь наказала за использование готовой роли. К примеру, certbot в готовой роли скачивался из какого-то заброшенного места, пришлось заменять на установку snap-пакетом. И т.д.

>В браузере можно открыть любой из этих URL и увидеть ответ сервера (502 Bad Gateway). На текущем этапе выполнение задания это нормально!
>4. Установка кластера MySQL
>
>Необходимо разработать Ansible роль для установки кластера MySQL.
>
>Рекомендации:
>
>• Имена серверов: db01.you.domain и db02.you.domain
>• Характеристики: 4vCPU, 4 RAM, Internal address.
>
>Цель:
>
>Получить отказоустойчивый кластер баз данных MySQL.
>Ожидаемые результаты:
>
>MySQL работает в режиме репликации Master/Slave.
>В кластере автоматически создаётся база данных c именем wordpress.
>В кластере автоматически создаётся пользователь wordpress с полными правами на базу wordpress и паролем wordpress.
>Вы должны понимать, что в рамках обучения это допустимые значения, но в боевой среде использование подобных значений не приемлимо! Считается 
>>хорошей практикой использовать логины и пароли повышенного уровня сложности. В которых будут содержаться буквы верхнего и нижнего регистров, >цифры, а также специальные символы!

Ради ускорения процесса снова взял готовую роль из ansible-galaxy. И снова пожалел. "Из коробки" ничего не заработало. Т.е. стало работать ... но без репликацции. Отрезал побольше лишнего, всё что мешало пониманию своей громоздкостью (к примеру, варианты для разных архитектур), добился простоты, понятной для меня. Наконец-то смог разглядеть структуру задач и тогда всё исправил.
Перекомпоновал таски понятным и правильным образом, используя `community.mysql.mysql_replication` module:
  - остановить репликацию (stopreplica)
  - прочитать из мастера имя лога и позицию через (changeprimary)
  - запустить реплику (startreplica). 

И она заработала:

```
mysql> show slave status \G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for source to send event
                  Master_Host: db01
                  Master_User: repuser
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 157
               Relay_Log_File: relay-bin.000004
                Relay_Log_Pos: 326
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 157
              Relay_Log_Space: 879
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 1
                  Master_UUID: 198845a2-2781-11ed-a951-d00d3925b6d2
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Replica has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
       Master_public_key_path:
        Get_master_public_key: 0
            Network_Namespace:
1 row in set, 1 warning (0.00 sec)
```

>5. Установка WordPress
>
>Необходимо разработать Ansible роль для установки WordPress.
>
>Рекомендации:
>
>• Имя сервера: app.you.domain
>• Характеристики: 4vCPU, 4 RAM, Internal address.
>
>Цель:
>
>Установить WordPress. Это система управления содержимым сайта (CMS) с открытым исходным кодом.
>По данным W3techs, WordPress используют 64,7% всех веб-сайтов, которые сделаны на CMS. Это 41,1% всех существующих в мире сайтов. Эту >платформу для своих блогов используют The New York Times и Forbes. Такую популярность WordPress получил за удобство интерфейса и большие >возможности.
>
>Ожидаемые результаты:
>
>Виртуальная машина на которой установлен WordPress и Nginx/Apache (на ваше усмотрение).
>В вашей доменной зоне настроена A-запись на внешний адрес reverse proxy:
>https://www.you.domain (WordPress)
>На сервере you.domain отредактирован upstream для выше указанного URL и он смотрит на виртуальную машину на которой установлен WordPress.
>В браузере можно открыть URL https://www.you.domain и увидеть главную страницу WordPress.

"Из коробки" Wordpress работает по http на 80 порту. Т.е. для оптимальной работы схемы диплома нужно будет не просто перенастроить его на https, но и заложить эти изменения в тасках Ansible. А настройки Wordpress хранит в mysql базе...
21.09.2022: Разобрался с Wordpress. Раз все настройки в базе - то единожды настроил, перевёл на https, затем сохранил дамп MySQL. Ansible разворачивает дамп. Результат:

![image](https://user-images.githubusercontent.com/92223664/192100440-a039d9b5-ea75-41a3-b2ce-fd1339c7a381.png)
https://i.vgy.me/xDWKcS.png

>6. Установка Gitlab CE и Gitlab Runner
>
>Необходимо настроить CI/CD систему для автоматического развертывания приложения при изменении кода.
>
>Рекомендации:
>
>• Имена серверов: gitlab.you.domain и runner.you.domain
>• Характеристики: 4vCPU, 4 RAM, Internal address.
>
>Цель:
>
>Построить pipeline доставки кода в среду эксплуатации, то есть настроить автоматический деплой на сервер app.you.domain при коммите в >репозиторий с WordPress.
>Подробнее о Gitlab CI
>Ожидаемый результат:
>
>Интерфейс Gitlab доступен по https.
>В вашей доменной зоне настроена A-запись на внешний адрес reverse proxy:
>https://gitlab.you.domain (Gitlab)
>На сервере you.domain отредактирован upstream для выше указанного URL и он смотрит на виртуальную машину на которой установлен Gitlab.
>При любом коммите в репозиторий с WordPress и создании тега (например, v1.0.0) происходит деплой на виртуальную машину.

И снова я пытался ускорить процесс с помощью ansible-galaxy и чужих ролей. И снова пополняю копилку нелюбви к ним.

Сначала runner не подключается, ссылаясь на `certificate relies on legacy Common Name field, use SANs instead`.  

Так я узнаю, что вариант генерации сертификата выбран устаревший и добавляю к нему регистрацию для SAN по имени и по IP (на всякий случай): `-addext "subjectAltName = DNS:{{ gitlab_domain }},IP:{{ ansible_host }}"`.

На этом приключение не заканчивается. Следующая ошибка: `x509: certificate signed by unknown authority`.  Снова долго ищу решение, пока не догадываюсь заглянуть на официальный сайт ))

На https://docs.gitlab.com/runner/configuration/tls-self-signed.html однозачно сказано, что нужно сначала скачать сертификат openssl клиентом. Ок, добавляется в роль runner-а:

```ansible
command: >
        openssl s_client -showcerts -connect {{ gitlab_domain }}:443
        -servername {{ gitlab_domain }} < /dev/null 2>/dev/null | openssl x509
        -outform PEM > /etc/gitlab-runner/certs/{{ gitlab_domain }}.crt
```
Так после нескольких дней борьбы наконец-то (всего лишь) появляется gitlab+runner:

![image](https://user-images.githubusercontent.com/92223664/192100857-60e886fc-c2db-45a8-9df5-79a163acc7c6.png)
https://i.imgur.com/r3LPpov.png

>7. Установка Prometheus, Alert Manager, Node Exporter и Grafana
>
>Необходимо разработать Ansible роль для установки Prometheus, Alert Manager и Grafana.
>
>Рекомендации:
>
>• Имя сервера: monitoring.you.domain
>• Характеристики: 4vCPU, 4 RAM, Internal address.
>
>Цель:
>
>Получение метрик со всей инфраструктуры.
>Ожидаемые результаты:
>
>Интерфейсы Prometheus, Alert Manager и Grafana доступены по https.

**доступены по https**  - начинаю разбираться с этим. Незамысловатая проверка `curl`-ом показала, что все они готовы пообщаться, но снаружи прокси была ошибка 502.
Судя по тому, что все трое в логах сообщают, что `SSL routines:ssl3_get_record:wrong version number) while SSL handshaking to upstream`, на них реально работает http, а не https.
  Первой исправляю grafana и начинаю понимать, что будет странно везде заново выпускать сертификаты. Сейчас уже не успеваю, но в будущем я бы сделал такой вариант:
  - получу комплект сертификатов для всех серверов (letsencrypt)
  - создам с `ansible-vault` безопасное хранилище для сертификатов, как переменных
  - укажу хранилище через директиву `vars_files` в плейбуке 
  - появится возможность деплоить сертификаты через `ansible.builtin.copy` - `content:`.
  
Prometheus: "Prometheus supports basic authentication and TLS. This is **experimental** and might change in the future." ( https://prometheus.io/docs/prometheus/latest/configuration/https/ ). Ладно, сказано на https, значит на https...
 C Prometheus, как и с многими другими теперь связана приключенческая история. Сначала он не хотел принимать в prometheus.service опцию `--web.config.file`, выяснилось, что в роли была прописана версия, которая ещё не умела работать по https.  После исправления этого неуспехом заканчивалась проверка `promtool check config web.yml`, пока я таки не перечитал внимательно документацию и не понял, что надо указывать тип конфига, т.е. `promtool check web-config web.yml`.

 Итак: Prometheus работает: 
 
 ![image](https://user-images.githubusercontent.com/92223664/192100993-daeb93e6-0f8e-48fb-8b1a-78506b3bebff.png)
 https://i.vgy.me/fjKqlF.png 

 Grafana связана с ним:

![image](https://user-images.githubusercontent.com/92223664/192101022-6a49eee6-5cf1-43a8-aff2-04505d091325.png)
 https://i.vgy.me/ebuo8K.png

И получает данные от node_exporter-ов:

![image](https://user-images.githubusercontent.com/92223664/192101057-21272045-6a76-46c1-afde-a644903e7f00.png)
https://i.vgy.me/Kdv6f4.png  (в момент скриншота работали 3 сервера (из экономии) - они видны в дашборде).

Alertmanager - на его запуск c https ушло чрезмерное количество времени...
Из неприятных открывшихся секретов - `amtool`, в отличие от `promtool`, не умеет проверять web.config.file.
Хотя всё-таки заработал:

![image](https://user-images.githubusercontent.com/92223664/192101184-27ae181d-92bd-4426-ac47-3577a40ea122.png)
https://i.vgy.me/3rOfQO.png

Grafana видит данные из alertmanager: 

![image](https://user-images.githubusercontent.com/92223664/192101242-6f5570ad-73ab-4ff7-b63b-5e69504ac75a.png)
https://i.vgy.me/mXSpTi.png

Alertmanager отправляет алерты в Slack:

![image](https://user-images.githubusercontent.com/92223664/192102163-ea9d46e4-4bda-4296-bcb4-1e83dc8235b6.png)
https://i.vgy.me/mGwl6I.png

>В вашей доменной зоне настроены A-записи на внешний адрес reverse proxy:
>• https://grafana.you.domain (Grafana)
>• https://prometheus.you.domain (Prometheus)
>• https://alertmanager.you.domain (Alert Manager)
>На сервере you.domain отредактированы upstreams для выше указанных URL и они смотрят на виртуальную машину на которой установлены >Prometheus, Alert Manager и Grafana.
>На всех серверах установлен Node Exporter и его метрики доступны Prometheus.
>У Alert Manager есть необходимый набор правил для создания алертов.
>В Grafana есть дашборд отображающий метрики из Node Exporter по всем серверам.
>В Grafana есть дашборд отображающий метрики из MySQL (*).
>В Grafana есть дашборд отображающий метрики из WordPress (*).
>Примечание: дашборды со звёздочкой являются опциональными заданиями повышенной сложности их выполнение желательно, но не обязательно.

Необязательные пункты не сделаны.

В Гитлабе в качестве `executor` я указал `shell`.
В `.gitlab-ci.yml` указал копирование на веб-сервер артефакта - файла `info.php`.
```yaml
script:
  - rsync -avu --super --chmod 0664 info.php ubuntu@10.0.1.16:/var/www/www.netology.simonof.info/wordpress/
```
  Пришлось ради этого использовать частный ключ, поместив его в переменные окружения:
![image](https://user-images.githubusercontent.com/92223664/192102611-1623020a-91a9-45bf-a62a-7d28a9f5c821.png)

Возможно, был более красиывый вариант.

При коммите выполняется деплой:
![image](https://user-images.githubusercontent.com/92223664/192102923-d35c09cb-9340-4c57-b177-208c5ffe0861.png)
https://i.vgy.me/PqLH2V.png

В результате на веб-сервере размещён новый `info.php`:

![image](https://user-images.githubusercontent.com/92223664/192103009-d2b7b860-46b2-446e-a9ea-cafb6662e831.png)
https://i.vgy.me/ZtkK2f.png

В ходе работы с дипломом я смог совершить типовую ошибку, выложив секретные ключи от AWS (они не имели отношения к диплому, но были в комментариях, т.к. я использовал свой старый tf файл) и от Terraform Cloud, приобретя в результате ошибки неоценимый опыт ))
  Т.е. увидел, как оперативно мониторят гитхаб заинтересованные стороны, как в AWS поддержка изящно блокирует доступ для невладельца, наложив "Quarantine Policy" на пользователя (т.е. типовым способом, добавлением политики, доступной для управления мной), познакомился с сервисом GitGardian. Думаю, что единожды не сделав ошибку - я не был бы так осторожен, как после этого ))
  
Минусы: оперативно решая ошибку я просто скопировал файлы репозитория в сторону и уничтожил репозиторий (вместе с историей). Не очень-то была нужна эта история, но на будущее всё равно опыт - надо разобраться с вопросами зачистки данных в старых коммитах. 
  Поэкспериментировал с https://rtyley.github.io/bfg-repo-cleaner/ но это было с черновиками, не с чистовиком.

>Что необходимо для сдачи задания?
>
>Репозиторий со всеми Terraform манифестами и готовность продемонстрировать создание всех ресурсов с нуля.
>Репозиторий со всеми Ansible ролями и готовность продемонстрировать установку всех сервисов с нуля.
>Скриншоты веб-интерфейсов всех сервисов работающих по HTTPS на вашем доменном имени.
>https://www.you.domain (WordPress)
>https://gitlab.you.domain (Gitlab)
>https://grafana.you.domain (Grafana)
>https://prometheus.you.domain (Prometheus)
>https://alertmanager.you.domain (Alert Manager)
>Все репозитории рекомендуется хранить на одном из ресурсов (github.com или gitlab.com).>>>
