#!/usr/bin/env bash

if [[ -z $JENKINS_AGENT_SSH_PUBKEY ]]; then
  echo "JENKINS_AGENT_SSH_PUBKEY should be set!"
  exit 1
fi

script_dir=$(cd $(dirname $0); pwd)
script_dir_name=$(basename $script_dir)

docker compose up -d

echo "JENKINS_AGENT_SSH_PUBKEY='$JENKINS_AGENT_SSH_PUBKEY'" > $script_dir/.env

while : ; do
  dind_status=$(docker inspect ${script_dir_name}-agent-1 --format "{{.State.Status}}")
  if [[ $dind_status = "running" ]]; then
    docker exec ${script_dir_name}-agent-1 chown jenkins:jenkins -R /home/jenkins/
    break
  fi
  sleep 10 
done
