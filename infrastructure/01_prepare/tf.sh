#! /bin/bash
# Экспортируем переменные Яндекса
. ./const.txt # пока используется terraform.tfvars, надо будет понять, почему не перехватываются из переменныъх окружения
# Создание бесплатных ресурсов (сервис-аккаунта)
yc iam service-account create --name sa-diplom --folder-name netology
yc resource-manager folder add-access-binding netology --role admin --service-account-name sa-diplom
# Создание ключа
yc iam key create --service-account-name sa-diplom --output ../key.json
