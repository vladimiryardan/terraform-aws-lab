moved {
  from = aws_vpc.lab_vpc
  to   = module.app_stack.aws_vpc.lab_vpc
}

moved {
  from = aws_subnet.public_subnet
  to   = module.app_stack.aws_subnet.public_subnet
}

moved {
  from = aws_internet_gateway.lab_igw
  to   = module.app_stack.aws_internet_gateway.lab_igw
}

moved {
  from = aws_route_table.public_rt
  to   = module.app_stack.aws_route_table.public_rt
}

moved {
  from = aws_route.public_internet_access
  to   = module.app_stack.aws_route.public_internet_access
}

moved {
  from = aws_route_table_association.public_subnet_assoc
  to   = module.app_stack.aws_route_table_association.public_subnet_assoc
}

moved {
  from = aws_security_group.ec2_sg
  to   = module.app_stack.aws_security_group.ec2_sg
}

moved {
  from = aws_key_pair.lab_key
  to   = module.app_stack.aws_key_pair.lab_key
}

moved {
  from = aws_instance.lab_ec2
  to   = module.app_stack.aws_instance.lab_ec2
}