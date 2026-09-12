terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "terraform-lab-vpc"
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "terraform-lab-public-subnet"
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "terraform-lab-igw"
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}