#!/bin/bash

DIR_POSTGRES_RAM=/mnt/ram_postgres
LIMIT_RAM=512m
TABLESPACE_NAME=gbd_ram

DATABASE_NAME=gbd
DATABASE_OWNER=gbd
DATABASE_ENCODING="utf-8"
POSTGRES_USER=postgres
POSTGRES_GROUP=postgres

if [ ! -d $DIR_POSTGRES_RAM ]
then
        sudo mkdir $DIR_POSTGRES_RAM
elif [ `mount | grep -c $DIR_POSTGRES_RAM` -gt 0 ]
then
        sudo umount $DIR_POSTGRES_RAM
fi
sudo mount -t ramfs -o limit=$LIMIT_RAM ramfs $DIR_POSTGRES_RAM
sudo chown $POSTGRES_USER:$POSTGRES_GROUP $DIR_POSTGRES_RAM

#drop old data
sudo -u $POSTGRES_USER psql -c "DROP TABLESPACE $TABLESPACE_NAME;"
sudo -u $POSTGRES_USER psql -c "DROP DATABASE $DATABASE_NAME;"

#create new data
sudo -u $POSTGRES_USER psql -c "CREATE TABLESPACE $TABLESPACE_NAME LOCATION '$DIR_POSTGRES_RAM';"
sudo -u $POSTGRES_USER psql -c "CREATE DATABASE $DATABASE_NAME WITH OWNER = $DATABASE_OWNER TABLESPACE = $TABLESPACE_NAME ENCODING = '$DATABASE_ENCODING';"

