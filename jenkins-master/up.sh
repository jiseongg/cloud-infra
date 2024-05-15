#!/usr/bin/env bash

script_dir=$(cd $(dirname $0); pwd)
jenkins_certs="${script_dir}/jenkins_certs"

if [[ ! -f $jenkins_certs/jenkins.jks ]]; then
  echo -e "$jenkins_certs/jenkins.jks doesn't exist!"
  exit 1
fi

if [[ ! -f $script_dir/.env ]]; then
  echo "JKS_PASSWORD should be set in $script_dir/.env"
  exit 1
else
  echo "$script_dir/.env exists. Use this file..."
fi

if [[ ! -d ${HOME}/jenkins_backup ]]; then
  mkdir ${HOME}/jenkins_backup
fi

echo "JENKINS_BACKUP='${HOME}/jenkins_backup'" >> $script_dir/.env

docker compose up -d

