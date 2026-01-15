### Чек-лист готовности к домашнему заданию

1. Скачайте и установите **Terraform** версии >=1.12.0 . Приложите скриншот вывода команды ```terraform --version```.
- wget https://hashicorp-releases.yandexcloud.net/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
- sudo unzip terraform_1.9.8_linux_amd64.zip -d /bin
2. Скачайте на свой ПК этот git-репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.
<img width="1614" height="836" alt="Снимок экрана 2026-01-15 194126" src="https://github.com/user-attachments/assets/9f0191fc-fee2-4f5e-a4c1-cabef7179d31" />

------
### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.
<img width="1360" height="300" alt="Снимок экрана 2026-01-15 194048" src="https://github.com/user-attachments/assets/8e42c47b-86d8-4de2-962a-81dd8ade9fb8" />

2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
> - "personal.auto.tfvars"
3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.
> - **предварительно перенес файл .terraformrc в домашнюю директорию пользователя из под которого запускается terraform**
> -             "result": "PZAYcwf34Bj8wHJm",
4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
   Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.
> Oшибки:
> - В блоке resource "docker_image", согласно документации блок resource указывается в следующем формате: resource "<TYPE>" "<LABEL>"   block, "TYPE" задан, но не задан "LABEL", исправим на resource "docker_image" "nginx"
> - в блоке resource "docker_container" "1nginx", в документации с цифр начинаться не должно
> - блок random_password.random_string_FAKE.resulT не правильно назван. Правильно random_password.random_string.result, требуется указывать имя атрибута с учетом регистра
5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.
<img width="1248" height="380" alt="Снимок экрана 2026-01-15 234153" src="https://github.com/user-attachments/assets/18dd718b-30c8-4dc8-8efd-d31a490ddfb3" />

6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```.
   Объясните своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.
> - auto-approve опасен тем, что не дает проверить правильность планируемых изменений перед, может поломать прод D:
<img width="1329" height="475" alt="Снимок экрана 2026-01-15 234516" src="https://github.com/user-attachments/assets/6f218d4a-38cc-46bc-93af-c1864a1a3688" />
7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.
```
{
  "version": 4,
  "terraform_version": "1.9.8",
  "serial": 19,
  "lineage": "977dedc6-1b68-cb52-8252-c84eaa84e251",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```
8. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://library.tf/providers/kreuzwerker/docker/latest).  (ищите в классификаторе resource docker_image )
> Причина неудаления образа в том, что когда у docker_image указан атрибут ```keep_locally=true```, то такой образ не удаляется при операциях удаления, как написано в руководстве [ссылка](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs/resources/image)
------
