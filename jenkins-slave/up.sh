#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)
script_dir_name=$(basename $script_dir)

if [[ -z $JENKINS_AGENT_SSH_PUBKEY ]]; then
  if [[ ! -f $script_dir/.env ]]; then 
    echo "JENKINS_AGENT_SSH_PUBKEY should be set!"
    exit 1
  else
    echo "$script_dir/.env exists. Use this file..."
  fi
fi

echo "JENKINS_AGENT_SSH_PUBKEY='$JENKINS_AGENT_SSH_PUBKEY'" > $script_dir/.env

docker compose up -d

while : ; do
  dind_status=$(docker inspect ${script_dir_name}-agent-1 --format "{{.State.Status}}")
  if [[ $dind_status = "running" ]]; then
    docker exec ${script_dir_name}-agent-1 chown jenkins:jenkins -R /home/jenkins/
    break
  fi
  sleep 10 
done
