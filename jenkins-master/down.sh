#!/usr/bin/env bash

mv .env .env.bak

docker compose down --volumes --rmi all
