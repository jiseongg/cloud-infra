#!/usr/bin/env bash

s3_bucket_name=$1
thinbackup_directory=$2

if [[ -z $s3_bucket_name ]]; then
  echo "S3 bucket name should be passed!"
  echo "-> usage: ./s3_backup.sh <s3_bucket_name> <thinbackup_directory>"
  exit 1
fi



if [[ -z $thinbackup_directory ]]; then
  echo "ThinBackup directory should be passed!"
  echo "-> usage: ./s3_backup.sh <s3_bucket_name> <thinbackup_directory>"
  exit 1
else
  if [[ ! -d $thinbackup_directory ]]; then
    echo "$thinbackup_directory doesn't exist!"
    exit 1
  fi
fi

latest_backup=$(ls -t $thinbackup_directory | head -n 1)
latest_backup_full_path="$thinbackup_directory/$latest_backup"
latest_backup_tgz="$latest_backup.tar.gz"
tar zcvf /tmp/$latest_backup_tgz $latest_backup_full_path

s3_target_directory=$(basename $thinbackup_directory)

aws s3 mv /tmp/$latest_backup_tgz s3://$s3_bucket_name/$s3_target_directory/
