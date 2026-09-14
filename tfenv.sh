#!/usr/bin/env bash

set -e

ENVIRONMENT="$1"
ENV_DIR="environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
  echo "Unknown environment: $ENVIRONMENT"
  exit 1
fi

cd "$ENV_DIR" || exit 1

terraform init \
  -reconfigure \
  -backend-config=backend.hcl

echo
echo "Environment ready: $ENVIRONMENT"
echo "Directory: $ENV_DIR"
echo "Use:"
echo "terraform plan"