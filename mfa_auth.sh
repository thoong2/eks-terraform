#!/bin/bash

# ============================
# Script: mfa_auth.sh
# Description: Automates retrieving AWS temporary credentials using MFA.
# Author: Thông Nguyễn
# ============================

# ======== CONFIGURATION ========
MFA_ARN="arn:aws:iam::767397729986:mfa/thoong-admin-iphone11"
DURATION=14400  # Duration in seconds

# ======== DEPENDENCY CHECKS ========
if ! command -v aws &> /dev/null; then
  echo "Error: 'aws' CLI is not installed. Please install it."
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "Error: 'jq' is not installed. Please install it."
  exit 1
fi

# ======== USER INPUT ========
read -p "Enter your MFA code: " MFA_CODE
if [[ ! $MFA_CODE =~ ^[0-9]{6}$ ]]; then
  echo "Error: Invalid MFA code. Must be a 6-digit number."
  exit 1
fi

# ======== AWS STS REQUEST ========
echo "Requesting temporary credentials from AWS STS..."
CREDENTIALS=$(aws sts get-session-token \
  --serial-number $MFA_ARN \
  --token-code $MFA_CODE \
  --duration-seconds $DURATION \
  --output json 2>&1)

if [ $? -ne 0 ]; then
  echo "Error: Failed to retrieve temporary credentials. AWS CLI error:"
  echo "$CREDENTIALS"
  exit 1
fi

# ======== EXPORT CREDENTIALS ========
export AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | jq -r '.Credentials.SessionToken')

if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_SESSION_TOKEN" ]]; then
  echo "Error: Failed to parse credentials from AWS CLI response."
  exit 1
fi

echo "Temporary AWS credentials have been set successfully!"
echo "Session duration: $DURATION seconds"
echo "Run 'unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN' to clear them."
