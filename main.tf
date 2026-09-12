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

#aws_route_table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "terraform-lab-public-rt"
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab_igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}