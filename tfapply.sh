#!/usr/bin/env bash

set -e

ENVIRONMENT="$1"
ENV_DIR="environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
  echo "Unknown environment: $ENVIRONMENT"
  exit 1
fi

if [ "$ENVIRONMENT" = "prod" ]; then
  read -r -p "Type PROD to continue: " CONFIRM

  if [ "$CONFIRM" != "PROD" ]; then
    echo "Cancelled."
    exit 1
  fi
fi

cd "$ENV_DIR" || exit 1

terraform init \
  -reconfigure \
  -backend-config=backend.hcl

terraform apply