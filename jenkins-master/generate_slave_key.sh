#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)
script_dir_name=$(basename $script_dir)

container="${script_dir_name}-controller-1"
docker exec -it $container \
  /bin/bash -c "yes no | ssh-keygen -t ed25519 -N '' -f /var/jenkins_home/.ssh/jenkins_slave_key"

echo ""

docker exec -it $container \
  cat /var/jenkins_home/.ssh/jenkins_slave_key
docker exec -it $container \
  cat /var/jenkins_home/.ssh/jenkins_slave_key.pub
