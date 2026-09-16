locals {
  project_name = "terraform-lab"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = local.project_name
  }
}

resource "aws_vpc" "lab_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.environment}-vpc"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.environment}-public-subnet"
    }
  )
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.environment}-igw"
    }
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.environment}-public-rt"
    }
  )
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

resource "aws_security_group" "ec2_sg" {
  name        = "terraform-lab-ec2-sg"
  description = "Allow SSH access to Terraform lab EC2"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    description = "SSH from my current public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.environment}-ec2-sg"
    }
  )
}

resource "aws_key_pair" "lab_key" {
  key_name   = var.environment == "dev" ? "${local.project_name}-key" : "${local.project_name}-${var.environment}-key"
  public_key = var.public_key

  tags = local.common_tags
}



resource "aws_instance" "lab_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name = aws_key_pair.lab_key.key_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.environment}-ec2"
    }
  )
}
