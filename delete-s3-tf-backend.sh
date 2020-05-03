#!/bin/bash
BUCKET_NAME="lambda-arch-tf"

OBJ_LIST=$(aws s3api list-object-versions --bucket ${BUCKET_NAME} | jq '{Objects: [.Versions[] | {Key:.Key, VersionId : .VersionId}], Quiet: false}')
if [[ ${OBJ_LIST} != "" ]] ; then
    aws s3api delete-objects --bucket ${BUCKET_NAME} --delete "${OBJ_LIST}"
fi

MARKER_LIST=$(aws s3api list-object-versions --bucket ${BUCKET_NAME} | jq '{Objects: [.DeleteMarkers[] | {Key:.Key, VersionId : .VersionId}], Quiet: false}')
if [[ ${MARKER_LIST} != "" ]] ; then
    aws s3api delete-objects --bucket ${BUCKET_NAME} --delete "${MARKER_LIST}"
fi

aws s3api delete-bucket --bucket ${BUCKET_NAME} --region us-east-1
