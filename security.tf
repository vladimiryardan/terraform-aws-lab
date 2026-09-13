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
  public_key = file("~/.ssh/terraform-lab.pub")

  tags = local.common_tags
}
