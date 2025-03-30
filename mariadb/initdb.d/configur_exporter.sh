#! /bin/bash

echo "[CUSTOM] Run Custom init script in 5 seconds ..."
sleep 5

echo "[CUSTOM] Start script"
mariadb -h 127.0.0.1 -u root -p$(cat /run/secrets/mdb_admin_pw) \
	--execute \
       	"CREATE USER IF NOT EXISTS 'exporter'@'mariadb-mon.backbone_database' IDENTIFIED BY '$(cat /run/secrets/mdb_exporter_pw)';
	ALTER USER 'exporter'@'mariadb-mon.backbone_database' IDENTIFIED BY '$(cat /run/secrets/mdb_exporter_pw)' WITH MAX_USER_CONNECTIONS 3;
	 GRANT PROCESS, REPLICATION CLIENT, SLAVE MONITOR, SELECT ON *.* TO 'exporter'@'mariadb-mon.backbone_database';"

echo "[CUSTOM] Finish script"
