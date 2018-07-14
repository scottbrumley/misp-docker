#!/bin/bash

source vars

case "$1" in

# Intialize
'init')
mkdir -p ${DOCKER_ROOT}/misp-db
sudo docker run -it --rm \
            -v ${DOCKER_ROOT}/misp-db:/var/lib/mysql \
            ${LOCATION} /init-db
;;

# Stop and Remove
'remove')
echo "Stopping and Removing Container ${NAME}"
sudo docker stop ${NAME};sudo docker rm ${NAME}
;;

# Build Container
'build')
echo "Bulding Container ${NAME}"
sudo docker build \
    --rm=true --force-rm=true \
    --build-arg MYSQL_MISP_PASSWORD=ChangeThisDefaultPassworda9564ebc3289b7a14551baf8ad5ec60a \
    --build-arg POSTFIX_RELAY_HOST=localhost \
    --build-arg MISP_FQDN=localhost \
    --build-arg MISP_EMAIL=admin@localhost \
    -t ${LOCATION} .
;;

# Run Container
'run')
echo "Run Container ${NAME}"
sudo docker run -it -d \
    --name ${NAME} \
    --restart=unless-stopped \
    -p 443:443 \
    -p 80:80 \
    -p 3306:3306 \
    -v ${DOCKER_ROOT}/misp-db:/var/lib/mysql \
   ${LOCATION}
;;

#-v /home/mcafee/misp/config/certs/:/etc/ssl/private \

# Purge All Containers
'purge-all')
echo "Purging All Containers ${NAME}"
sudo docker system prune -a
;;

# Purge Stopped Containers
'purge')
echo "Purge Stopped Containers ${NAME}"
sudo docker system prune
;;

*)
echo "Things you can do with this script:"
echo "Set container name and location in vars file"
echo "./container init - Initialize Database"
echo "./container build - Build Container"
echo "./container remove - Remove Container"
echo "./container run - Run Container"
echo "./container purge-all - Purge all containers and images"
echo "./container purge - Purge stopped containers and images"
;;

esac