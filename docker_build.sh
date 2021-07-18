#!/usr/bin/env bash

IMAGE_PREFIX="comic-crawler-medium"

docker rmi $(docker images --filter=reference="$IMAGE_PREFIX:*" -q)

docker build --build-arg 'PROXY_HOST=[HOSTNAME or IP]' \
    --build-arg PROXY_PORT=[PORT] \
    --build-arg PROXY_USER=[USERNAME] \
    --build-arg PROXY_PEM=[PRIVATE_KEY_TO_LOGIN]  \
    -t $IMAGE_PREFIX:latest .
