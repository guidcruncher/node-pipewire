#!/bin/bash

mkdir -p ./src/config
cp ../common/ ./src/common -r
cp ../config/ ./src/config -r
docker buildx build ./src/ -f ./src/Dockerfile -t guidcruncher/node-pipewire:alpine-latest --pull --push
rm -rf ./src/config
rm -rf ./src/common
