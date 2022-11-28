#!/bin/bash

ONOS_NETCFG_DOCKER_NAME=${ONOS_NETCFG_DOCKER_NAME:-onos-netcfg}
ONOS_NETCFG_UTILS_DIR=$(cd "$(dirname "$0")"; pwd)/utils
ONOS_NETCFG_OCI=${ONOS_NETCFG_OCI:-127.0.0.1}
ONOS_NETCFG_IMG=${ONOS_NETCFG_IMG:-davidlor/python-ssh}
ONOS_NETCFG_MOUNT_DIR=${ONOS_NETCFG_MOUNT_DIR:-$PWD}

docker run -it --rm \
  --name $ONOS_NETCFG_DOCKER_NAME \
  --network host \
  -v "$ONOS_NETCFG_UTILS_DIR"/onos:/utils/onos \
  -v "$ONOS_NETCFG_MOUNT_DIR":/workdir -w /workdir \
  $ONOS_NETCFG_IMG /utils/onos/onos-netcfg $ONOS_NETCFG_OCI "$@"
