Зависимости
perl не ниже 5.10.1 (я использовал 5.20.1)
postgreSQL (я использовал 9.4, скорее всего, допускаются и более ранние версии)
модуль HTTP::Server::Simple::CGI (я ставил из репозитория убунты, пакет libhttp-server-simple-perl)
модуль Template (я ставил из репозитория убунты, пакет libtemplate-perl)

Подготовка и запуск
1. Надо скопировать директорию проекта на рабочую машину
2. Создать БД со структурой из файла db.sql
3. Сконфигурировать приложение, конфигурационный файл - lib/NCTTest/Config.pm

Запускается приложение скриптом run.pl