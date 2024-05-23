#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)

docker run --rm -d -p 23260:80 --name nginx \
  -v $script_dir/configs/jenkins.conf:/etc/nginx/jenkins.conf:ro \
  -v $script_dir/configs/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v $script_dir/nginx-log:/var/log/nginx \
  nginx:1.26.0-alpine3.19-slim
