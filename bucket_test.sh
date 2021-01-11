#!/bin/bash

PROTECTED=1

if [[ -z $1 ]]
then
  echo "This function expects a bucket name as its first and only argument. Try again."
  exit 1
else
  BUCKET=$1
  echo "Testing Bucket: $BUCKET"
fi

printf "\n-----Encryption-----\n" 
OUTPUT=$(aws s3api get-bucket-encryption --bucket $BUCKET)
if [[ $? == 0 ]]
then
  printf "\nValid encryption found!\n"
else
  printf "\nError! Your bucket may be vulnerable!\n"
fi

printf "\n-----Public-----\n"
OUTPUT=$(aws s3api get-public-access-block --bucket $BUCKET)
if [[ $? == 0 ]]; then
  printf "\nBucket found!\n\n"
  ERRMESS="Public vulnerability detected! Review status above and remediate immediately!"
  echo $OUTPUT | jq
  if [[ $(echo $OUTPUT | jq -r .PublicAccessBlockConfiguration.IgnorePublicAcls) == true ]]; then
    if [[ $(echo $OUTPUT | jq -r .PublicAccessBlockConfiguration.BlockPublicPolicy) == true ]]; then
      if [[ $(echo $OUTPUT | jq -r .PublicAccessBlockConfiguration.BlockPublicAcls) == true ]]; then
        if [[ $(echo $OUTPUT | jq -r .PublicAccessBlockConfiguration.RestrictPublicBuckets) == true ]]; then
          printf "\nBucket is protected from public access!\n"
        else
          PROTECTED=0 && echo $ERRMESS; fi
      else
        PROTECTED=0 && echo $ERRMESS; fi
    else
      PROTECTED=0 && echo $ERRMESS; fi
  else
    PROTECTED=0 && echo $ERRMESS; fi
else
  printf "\nError! Your bucket may be vulnerable!\n"
fi

if [[ $PROTECTED == 0 ]]; then
  printf "\nStatus: FAILED\n\n"
  exit 2
else
  printf "\nStatus: PASSED\n\n"
fi

