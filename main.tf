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

#
resource "aws_security_group" "ec2_sg" {
  name        = "terraform-lab-ec2-sg"
  description = "Allow SSH access to Terraform lab EC2"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "SSH from my current public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.60.171.224/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "terraform-lab-ec2-sg"
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}

#an AMI. Instead of hardcoding one, use a data source:
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#add the EC2 instance:  
resource "aws_instance" "lab_ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.lab_key.key_name

  tags = {
    Name        = "terraform-lab-ec2"
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}
#register the public key with AWS
resource "aws_key_pair" "lab_key" {
  key_name   = "terraform-lab-key"
  public_key = file("~/.ssh/terraform-lab.pub")

  tags = {
    Environment = "training"
    ManagedBy   = "Terraform"
  }
}