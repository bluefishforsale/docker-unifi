#!/usr/bin/env bash
set -x

SERVICE="unifi-nvr"
IMAGE="pducharme/unifi-video-controller"
VERSION="3.10.13"
LOCALDIR="/data01/services/${SERVICE}"

docker stop "${SERVICE}"
docker rm -f "${SERVICE}"
docker images | egrep "${IMAGE}\ *${VERSION}" | awk '{print $3}' | xargs docker rmi

dirs="${LOCALDIR}/data ${LOCALDIR}/videos ${LOCALDIR}/cache"
for d in ${dirs} ; do
	test -d ${d} || mkdir -p ${d}
	# sudo chown -R 1001:1001 ${d}
done

docker run -d \
	--restart=always \
	--name=${SERVICE} \
	--hostname=${HOSTNAME} \
	--cap-add=SYS_ADMIN \
	--cap-add=DAC_READ_SEARCH \
	--cap-add=NET_BIND_SERVICE \
	--cap-add=SYS_PTRACE \
	--cap-add=SETUID \
	--cap-add=SETGID \
	--security-opt=apparmor:unconfined \
    -p 1935:1935 \
    -p 6666:6666 \
    -p 7080:7080 \
    -p 7442-7447:7442-7447 \
    -p 7442-7447:7442-7447/udp \
    -v ${LOCALDIR}/data:/var/lib/unifi-video \
    -v ${LOCALDIR}/videos:/var/lib/unifi-video/videos \
    -e TZ=America/Los_Angeles \
    -e PUID=1001 \
    -e PGID=1001 \
    -e DEBUG=1 \
    ${IMAGE}:${VERSION}
