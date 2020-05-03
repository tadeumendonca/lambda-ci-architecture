#!/bin/bash
BUCKET_NAME="lambda-arch-tf"
aws s3api create-bucket --bucket ${BUCKET_NAME} --region us-east-1
aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} --versioning-configuration Status=Enabled