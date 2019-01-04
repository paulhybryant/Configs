#!/bin/bash

DIST_LIST=(alpine ubuntu)
for dist in ${DIST_LIST[@]}; do
  echo "docker build --build-arg DIST=${dist} . -t paulhybryant/arm64v8-qemu:${dist}"
  docker build --build-arg DIST=${dist} . -t paulhybryant/arm64v8-qemu:${dist}
done
