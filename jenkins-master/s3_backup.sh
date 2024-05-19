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

backup_tgz_directory="/tmp/thin_backup"
if [[ ! -d $backup_tgz_directory ]]; then
  mkdir $backup_tgz_directory
fi

(
  cd $thinbackup_directory
  for backup in $(ls); do
    echo "Compressing $backup"
    backup_tgz="$backup.tar.gz"
    tar zcf $backup_tgz_directory/$backup_tgz $backup
  done
)
  

echo "Synchronizing $backup_tgz_directory with S3"
s3_target_directory=$(basename $thinbackup_directory)
aws s3 sync --delete $backup_tgz_directory s3://$s3_bucket_name/$s3_target_directory/

rm -rf $backup_tgz_directory
