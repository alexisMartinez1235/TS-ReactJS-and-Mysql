#!/bin/bash

init(){
  local PATH_MYSQLOUTPUT=/usr/src/TodoApp/Scripts/outputMysql 
  local codeSuccess=""
  local hasSlepped=false
  local PidEntrypoint=""

  # rm $PATH_MYSQLOUTPUT
  /entrypoint.sh mysqld &
  PidEntrypoint=$(echo "$!")

  # TODO : improve algorithm
  while [[ "$codeSuccess" != "28000" && "$hasSlepped" == "false" ]]; do
    codeSuccess=$( mysql 2>&1 | cut -d" " -f 3 | cut -c 2-6 )
    hasSlepped=$( ( ps -a $PidEntrypoint | head -2 | grep $PidEntrypoint | grep Sl )  && echo true || echo false )
    # echo "Waiting..." 
    sleep 5

  done
  # cat $PATH_MYSQLOUTPUT  
  echo "Start Mysql finished."
  
  # mysql --login-path=loginfordev
  
  while [[ "true" ]]; do 
  # while [[ "$hasSlepped" = "false" ]]; do 
  #   hasSlepped=$( ( ps -a $PidEntrypoint | head -2 | grep $PidEntrypoint | grep Sl )  && echo true || echo false )
    sleep 10  
  done
}
init

#region delete
# mysql -u "${MYSQL_USER}" --ssl-mode=VERIFY_CA \
#   --ssl-ca=/var/lib/mysql/ca.pem \
#   --ssl-cert=/var/lib/mysql/client-cert.pem \
#   --ssl-key=/var/lib/mysql/client-key.pem < "main.sql"

#endregion