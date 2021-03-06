#!/bin/bash
# ---------------Parameters------------------
# $1 : re-create password
# $2 : force delete mysql installation folder 
# $3 : remove everything created in the server and client (optional)
    
DOCKER_BUILDKIT=1
source ./.env

delete_all_created_in_server_and_client(){
  cd Server/w
  rm -r $( ls | grep -v script.sh )
  cd ../..
  
  cd Client/w
  rm -r $( ls | grep -v script.sh )
  cd ../..
}

reCreatePassword(){
  mkdir ./Mysql/Passwords/
  if [[ $pwCreated == 0 ]]; then
    local folderRoot="./Mysql/Passwords/$MYSQL_PW_ROOT_FILE"
    local folderUser="./Mysql/Passwords/$MYSQL_PW_FILE"
    
    openssl rand -base64 14 | awk '{print tolower($0)}' > "$folderRoot"
    openssl rand -base64 14 | awk '{print tolower($0)}' > "$folderUser"
    
    printf "Recreating password..."

    pwCreated=1
  fi
}
init(){
  # ---------------Parameters------------------
  # $1 : re-create password
  # $2 : force delete mysql installation folder 

  local ReCreatePw=$1
  local ReCreateInstallation=$1
  local idMysqlContainer=""
  local pwCreated=0
  local folderDeleted=0

  # TODO : check if it is necessary to delete installation when creating the password
  # TODO : improve algorithm logic

  if [[ ! ( -f "./Mysql/Passwords/$MYSQL_PW_ROOT_FILE" && -f "./Mysql/Passwords/$MYSQL_PW_FILE" ) || "$ReCreatePw" == "true" ]]
  then
    rm -rf ./Mysql/Installation
    reCreatePassword
    pwCreated=1
    folderDeleted=1
  fi
  if [[ $forceReCreatePw == "true" && "$pwCreated" == "0" ]]; then
    reCreatePassword
    rm -rf ./Mysql/Installation
  fi
  if [[ $forceReCreateInstallation == "true" && "$folderDeleted" == "0" ]]; then
    rm -rf ./Mysql/Installation
  fi

  docker-compose -f "docker-compose.yml" down
  docker-compose -f "docker-compose.yml" up -d --build 

  idMysqlContainer=$(docker ps | grep todoapp_react_mysql_server | cut -d" " -f1)

  if [ "$idMysqlContainer" ]; then
    docker logs --tail 1000 -f "$idMysqlContainer"
  fi
  # docker exec -ti mysql_server sh /usr/src/TodoApp/Scripts/loginPathConfig.sh
  # docker exec -i mysql_server sh -c 'sh /usr/src/database/initDB.sh' 
}
if [[ "$1" && "$2" ]]; then
  if [[ "$3" ]]; then
    delete_all_created_in_server_and_client
  fi
  init $1 $2
fi

# recommended for debug mysql
# sh reBuild.sh false true

# for daily use in development
# sh reBuild.sh false false