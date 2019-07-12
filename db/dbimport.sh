#!/bin/bash
mysql -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /tmp/dbcreation.sql && rm /tmp/dbcreation.sql
