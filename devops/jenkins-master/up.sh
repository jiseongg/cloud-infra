#!/usr/bin/env bash

if [[ ! -d ${HOME}/jenkins_backup ]]; then
  mkdir ${HOME}/jenkins_backup
fi

docker compose up -d

