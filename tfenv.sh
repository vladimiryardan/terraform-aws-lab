#!/usr/bin/env bash

set -e

ENV_NAME="$1"

if [[ -z "$ENV_NAME" ]]; then
  echo "Usage: ./tfenv.sh dev|staging|prod"
  exit 1
fi

BACKEND_FILE="environments/$ENV_NAME/backend.hcl"
VARS_FILE="environments/$ENV_NAME/terraform.tfvars"

if [[ ! -f "$BACKEND_FILE" ]]; then
  echo "Backend file not found: $BACKEND_FILE"
  exit 1
fi

if [[ ! -f "$VARS_FILE" ]]; then
  echo "Variables file not found: $VARS_FILE"
  exit 1
fi

echo "Switching Terraform to environment: $ENV_NAME"

terraform init \
  -reconfigure \
  -backend-config="$BACKEND_FILE"

echo
echo "Environment ready: $ENV_NAME"
echo "Use:"
echo "terraform plan -var-file=$VARS_FILE"