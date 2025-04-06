# cwa_mariadb

This compose configuration automaticaly adds prometheus exporter. For that a user **'exporter'@'mariadb-mon.backbone_database'** will be created. A script started after the server is boote will performe the neccesary changes.

## Manage users

You can use ```mariadb``` to perfom administative tasks. For that the mariadb-client applications have to be installed. Perfomre the install viea ```sudo apt install mariadb-client```. Alternatively use the docker exec to perform commands on the container itself. To connetc to the container runn the following command.

```bash
sudo docker exec -it mariadb /bin/bash 
mariadb -h 127.0.0.1 -u root -pChangeMeOnlyDevelopement
```

The password needs to be right after the **-p** no spacing is allowed. Mariadb checks the host from wich a user try to login. If you list all users always list the allowed host too. Passwords are hashed and not stored in plain text. I however reducted them in the following listing.

```bash
MariaDB [(none)]> SELECT host, user, password FROM mysql.user;
+-------------------------------+-------------+-------------------------------------------+
| Host                          | User        | Password                                  |
+-------------------------------+-------------+-------------------------------------------+
| localhost                     | mariadb.sys |                                           |
| localhost                     | root        | *#######################################  |
| %                             | root        | *#######################################  |
| 127.0.0.1                     | healthcheck | *#######################################  |
| ::1                           | healthcheck | *#######################################  |
| localhost                     | healthcheck | *#######################################  |
| mariadb-mon.backbone_database | metric      | *#######################################  |
| mariadb-mon.backbone_database | exporter    | *#######################################  |
+-------------------------------+-------------+-------------------------------------------+
8 rows in set (0,006 sec)

```

You can add user with the ```CREATE USER```statement. To add a user for nextcloud this would look like the following.

```bash
MariaDB [(none)]> CREATE USER 'nextcloud'@'nextcloud.backbone_database' IDENTIFIED BY 'YiIRBnjG8GSDiDWtomUeEQXz4xq3OsbB3oeZxn3x';
Query OK, 0 rows affected (0,002 sec)
``` 

## Manage Databases

Mariadb lets you create database that holds tablels. SQLite e.g. only has tables and the SQLite file itself is the database. So if I add a new application I first need to create a new database with a user that can manage the database. You can list all the databases with the ```SHOW DATABASES;``` command.

```bash
MariaDB [(none)]> SHOW DATABASE;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'DATABASE' at line 1
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| #mysql50#.config   |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0,004 sec)
```

To add a new database for the nextcloud instance do the following.

```bash
MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0,001 sec)
```

## Manage access rights

To show wich user can do what you can use the ```SHOW GRANTS``` statement. The following example list all the grants for the **exporter** user.

```bash
MariaDB [(none)]> SHOW GRANTS FOR 'exporter'@'mariadb-mon.backbone_database';
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for exporter@mariadb-mon.backbone_database                                                                                                                    |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT SELECT, PROCESS, BINLOG MONITOR, SLAVE MONITOR ON *.* TO `exporter`@`mariadb-mon.backbone_database` IDENTIFIED BY PASSWORD '#####' WITH MAX_USER_CONNECTIONS 3 |
+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0,001 sec)
```

To allow an user addition access rights you can change them with ```GRANT```. To allow the Nexloud user acces to the database I use the following statement

```bash
MariaDB [(none)]> GRANT ALL PRIVILEGES on nextcloud.* to 'nextcloud'@'nextcloud.backbone_database';
Query OK, 0 rows affected (0,002 sec)
```

