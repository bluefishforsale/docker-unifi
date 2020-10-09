#!/bin/bash

BUILD=${1:-3.10.1}
SERVICE=unifi-nvr
USER=bluefishforsale

docker build --pull --tag ${USER}/${SERVICE}:${BUILD} . && docker push ${USER}/${SERVICE}:${BUILD}
