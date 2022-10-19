#!/bin/sh
docker run --rm -it \
    -v `pwd`:/opt/nodemcu-firmware:delegated \
    --user `id -u` --platform linux/amd64 \
    marcelstoer/nodemcu-build \
    build
