#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)

docker run --rm -d -p 23260:20000 --name nginx \
  -v $script_dir/configs:/etc/nginx:ro \
  -v $script_dir/nginx-log:/var/log/nginx:rw \
  nginx:1.26.0-alpine3.19-slim
