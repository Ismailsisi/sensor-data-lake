#!/usr/bin/env bash
set -euo pipefail
PROFILE="${1:-training}"
REGION="$(aws configure get region --profile "$PROFILE")"
if [[ -z "$REGION" ]]; then
  echo "AWS region is not configured for profile: $PROFILE" >&2
  exit 1
fi
ACCOUNT_ID="$(aws sts get-caller-identity --profile "$PROFILE" --query Account --output text)"
BUCKET="sensor-data-lake-${ACCOUNT_ID}-${REGION}"
aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region "$REGION" \
  --profile "$PROFILE"
aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true \
  --profile "$PROFILE"
printf '%s\n' "$BUCKET" > .bucket-name
aws s3api put-bucket-lifecycle-configuration \
  --bucket "$BUCKET" \
  --lifecycle-configuration file://config/lifecycle-policy.json \
  --profile "$PROFILE"
echo "Bucket: $BUCKET"
aws s3api get-bucket-lifecycle-configuration \
  --bucket "$BUCKET" \
  --profile "$PROFILE"
echo "Verifying bucket..."
aws s3api head-bucket \
  --bucket "$BUCKET" \
  --profile "$PROFILE"
echo "Verifying public-access protection..."
aws s3api get-public-access-block \
  --bucket "$BUCKET" \
  --profile "$PROFILE"
echo
echo "S3 data lake provisioned successfully."
echo "Bucket: s3://$BUCKET"
