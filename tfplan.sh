#!/usr/bin/env bash

set -e

ENV_NAME="$1"

if [[ -z "$ENV_NAME" ]]; then
  echo "Usage: ./tfplan.sh dev|staging|prod"
  exit 1
fi

BACKEND_FILE="environments/$ENV_NAME/backend.hcl"
VARS_FILE="environments/$ENV_NAME/terraform.tfvars"

if [[ ! -f "$BACKEND_FILE" || ! -f "$VARS_FILE" ]]; then
  echo "Environment configuration missing for: $ENV_NAME"
  exit 1
fi

echo "Planning environment: $ENV_NAME"

terraform init \
  -reconfigure \
  -backend-config="$BACKEND_FILE"

terraform plan \
  -var-file="$VARS_FILE"