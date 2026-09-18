#!/usr/bin/env bash

set -e

ENVIRONMENT="$1"
MODE="${2:-full}"
ENV_DIR="environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
  echo "Unknown environment: $ENVIRONMENT"
  echo "Usage: $0 <dev|staging|prod> [full|ec2-only]"
  exit 1
fi

if [ "$MODE" != "full" ] && [ "$MODE" != "ec2-only" ]; then
  echo "Unknown mode: $MODE (expected 'full' or 'ec2-only')"
  exit 1
fi

if [ "$ENVIRONMENT" = "prod" ]; then
  read -r -p "Type PROD to continue: " CONFIRM

  if [ "$CONFIRM" != "PROD" ]; then
    echo "Cancelled."
    exit 1
  fi
fi

read -r -p "This will DESTROY ($MODE) resources in '$ENVIRONMENT'. Type 'destroy $ENVIRONMENT' to continue: " DESTROY_CONFIRM

if [ "$DESTROY_CONFIRM" != "destroy $ENVIRONMENT" ]; then
  echo "Cancelled."
  exit 1
fi

cd "$ENV_DIR" || exit 1

terraform init \
  -reconfigure \
  -backend-config=backend.hcl

if [ "$MODE" = "ec2-only" ]; then
  echo "Destroying only the costly EC2 instance in $ENVIRONMENT..."
  terraform destroy -target=module.app_stack.aws_instance.lab_ec2
else
  echo "Destroying all resources in $ENVIRONMENT..."
  terraform destroy
fi
