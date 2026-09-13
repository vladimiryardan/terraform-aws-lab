terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"

  backend "s3" {}
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
