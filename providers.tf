terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "terraform-state-789655958476-us-east-1"
    key          = "terraform-aws-lab/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  project_name = "terraform-lab"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = local.project_name
  }
}
