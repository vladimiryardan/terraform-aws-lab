module "app_stack" {
  source = "../../modules/app-stack"

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  instance_type      = var.instance_type
  ssh_allowed_cidr   = var.ssh_allowed_cidr
  availability_zone  = var.availability_zone
  public_key         = var.public_key

  ami_id = "ami-0b5358cc8c5df0b02"
}   