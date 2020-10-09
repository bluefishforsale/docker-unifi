#!/usr/bin/env bash

SERVICE="unifi-controller"
IMAGE="linuxserver/unifi-controller"
VERSION="5.14.23-ls75"
LOCALDIR="/data01/services/${SERVICE}"

docker stop ${SERVICE}
docker rm ${SERVICE}

docker run -d  \
  --name=${SERVICE} \
  --restart=always \
  --name=${SERVICE} \
  --hostname=${HOSTNAME} \
  -e PUID=1001 -e PGID=1001 \
  -v ${LOCALDIR}/config:/config \
  -p 3478:3478/udp \
  -p 10001:10001/udp \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8443:8443 \
  -p 8843:8843 \
  -p 8880:8880 \
  -p 6789:6789 \
  ${IMAGE}:${VERSION}

