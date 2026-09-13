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

variable "public_key_path" {
  type = string
}