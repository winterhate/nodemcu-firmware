#!/bin/sh
docker run --rm -it \
    -v `pwd`:/opt/nodemcu-firmware:delegated \
    -v `pwd`/artifical-sun:/opt/lua:delegated \
    --user `id -u` --platform linux/amd64 \
    marcelstoer/nodemcu-build \
    lfs-image