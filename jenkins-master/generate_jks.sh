#!/usr/bin/env bash

GREEN="\033[0;32m"
RED="\033[0;31m"

INFO="${GREEN}[INFO]"
ERR="${RED}[ERR ]"
NC="\033[0m"

script_dir=$(cd $(dirname $0); pwd)
jenkins_certs="${script_dir}/jenkins_certs"

password=$1

if [[ -z $password ]]; then
  echo -e "${ERR} Password should be passed! ${NC}"
  echo -e "${ERR} -> ./generate_jks.sh password ${NC}"
  exit 1
fi

jks_password=$(openssl passwd -1 $password)


if [[ ! -d $jenkins_certs ]]; then
  mkdir $jenkins_certs
fi

if [[ ! -f $jenkins_certs/jenkins.jks ]]; then
  echo -e "${INFO} Generating the SSL public and private keys... ${NC}"
  openssl req -newkey rsa:2048 -nodes \
    -keyout $jenkins_certs/key.pem -x509 -days 365 \
    -out $jenkins_certs/certificate.pem
  
  echo -e "${INFO} Merging to a .p12 keystore... ${NC}"
  openssl pkcs12 -inkey $jenkins_certs/key.pem \
    -passin pass:$jks_password \
    -passout pass:$jks_password \
    -in $jenkins_certs/certificate.pem -export \
    -out $jenkins_certs/certificate.p12
  
  echo -e "${INFO} Generating a .jks keystore... ${NC}"
  keytool -importkeystore -srckeystore $jenkins_certs/certificate.p12 \
    -srcstoretype pkcs12 -srcstorepass $jks_password \
    -destkeystore $jenkins_certs/jenkins.jks -deststorepass $jks_password \
    -deststoretype JKS
else
  echo -e "${INFO} .jks exist! ${NC}"
  exit 0
fi

if [[ ! -f $jenkins_certs/jenkins.jks ]]; then
  echo -e "${ERR} Failed to generate .jks ${NC}"
  exit 1
fi

echo -e "${INFO} Succeeded to generate .jks ${NC}"
echo -e "${INFO} Save the following jks password somewhere! ${NC}"
echo -e "${INFO} $jks_password ${NC}"

echo "JKS_PASSWORD='${jks_password}'" > $script_dir/.env
