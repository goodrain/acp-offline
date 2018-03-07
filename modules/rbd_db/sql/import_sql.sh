#!/bin/bash
SQL_PATH="$PWD/modules/rbd_db/sql"
SQL_FILES="app_service_env_var.sql \
app_service_extend_method.sql \
app_service_group.sql \
app_service_port.sql \
app_service_relation.sql \
app_service_volume.sql \
publish_group_service_relation.sql \
service.sql"

for sql in $SQL_FILES
do
    echo "import $sql..."
    cat ${SQL_PATH}/${sql} | mysql -uroot -h127.0.0.1 console
done