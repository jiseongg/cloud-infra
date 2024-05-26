#!/usr/bin/env bash

key_name=$1

if [[ -z $key_name ]]; then
  echo "Pass the name of the key!"
  echo "-> ./generate_key.sh <key_name>"
  exit 1
fi

script_dir=$(cd $(dirname $0); pwd)
script_dir_name=$(basename $script_dir)

jenkins_ssh_keys="/var/jenkins_home/ssh_keys"

container="${script_dir_name}-controller-1"
docker exec --user jenkins:jenkins -it $container \
  /bin/bash -c "if [[ ! -d $jenkins_ssh_keys ]]; then mkdir -p $jenkins_ssh_keys; fi"
docker exec --user jenkins:jenkins -it $container \
  /bin/bash -c "yes no | ssh-keygen -t ed25519 -N '' -f $jenkins_ssh_keys/$key_name"

