#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)

docker compose down --volumes --rmi all

mv $script_dir/.env $script_dir/.env.bak

