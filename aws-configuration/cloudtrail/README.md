
## Create bucket

```shell
aws s3 mb s3://my-bucket-name-12312391289
```


## Apply bucket policy

```shell
aws s3api put-bucket-policy \
  --bucket my-bucket-name-12312391289 \
  --policy file://s3-bucket-policy.json
```


## Create trail

```shell
aws cloudtrail create-trail \
  --name MyTrailHahaha \
  --s3-bucket-name my-bucket-name-12312391289 \ 
  --region ap-northeast-2
```
