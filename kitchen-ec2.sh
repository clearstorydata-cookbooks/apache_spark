#!/bin/bash

if [ -z "$AWS_SSH_KEY_ID" ]; then
  echo "AWS_SSH_KEY_ID not defined. The key should be located at ~/.ssh/$AWS_SSH_KEY_ID.pem." >&2
  exit 1
fi

if [ -z "$TEST_KITCHEN_AWS_SECURITY_GROUP_ID" ]; then
  echo "TEST_KITCHEN_AWS_SECURITY_GROUP_ID is not set" >&2
  exit 1
fi

export AWS_ACCESS_KEY_ID=$(
  cat ~/.aws/credentials | grep 'aws_access_key_id' | awk '{print $NF}'
)
export AWS_SECRET_ACCESS_KEY=$(
  cat ~/.aws/credentials | grep 'aws_secret_access_key' | awk '{print $NF}'
)

export KITCHEN_YAML=.kitchen-ec2.yml
export KITCHEN_SYNC_MODE=rsync

bundle exec kitchen "$@"
