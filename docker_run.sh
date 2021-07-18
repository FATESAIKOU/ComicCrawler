#!/usr/bin/env bash

IMAGE_PREFIX="comic-crawler-medium"

project_url=$(greadlink -f $1)
command=$2

container=$(docker run \
    -u root \
    -i \
    -t \
    -d \
    --rm \
    -v $project_url:/project \
    $IMAGE_PREFIX:latest bash)

docker exec -it $container $command
docker stop $container > /dev/null
