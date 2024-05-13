#!/usr/bin/env bash

key_name=$1

script_dir=$(cd $(dirname $0); pwd)
script_dir_name=$(basename $script_dir)

container="${script_dir_name}-controller-1"
docker exec -it $container \
  /bin/bash -c "yes no | ssh-keygen -t ed25519 -N '' -f /var/jenkins_home/.ssh/$key_name"

echo ""

docker exec -it $container \
  cat /var/jenkins_home/.ssh/$key_name
docker exec -it $container \
  cat /var/jenkins_home/.ssh/$key_name.pub
