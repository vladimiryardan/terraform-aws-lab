variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ssh_allowed_cidr" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = null
}

variable "public_key" {
  description = "SSH public key used for the EC2 key pair"
  type        = string
}

variable "ami_id" {
  description = "AMI ID used for the EC2 instance"
  type        = string
}