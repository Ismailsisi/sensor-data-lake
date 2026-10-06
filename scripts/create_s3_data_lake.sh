#!/usr/bin/env bash
set -euo pipefail
PROFILE="${2:-training}"
STUDENT_ID="${1:?Usage: $0 <student-id> [aws-profile]}"
REGION="$(aws configure get region --profile "$PROFILE")"
if [[ -z "$REGION" ]]; then
  echo "AWS region is not configured for profile: $PROFILE" >&2
  exit 1
fi
