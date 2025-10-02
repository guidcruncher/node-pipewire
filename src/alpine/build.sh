#!/bin/bash

docker buildx build ./src/ -f ./src/Dockerfile -t guidcruncher/node-pipewire:alpine-latest --pull --push
