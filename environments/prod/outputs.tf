output "ec2_public_ip" {
  value = module.app_stack.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.app_stack.ec2_public_dns
}

output "ec2_instance_id" {
  value = module.app_stack.ec2_instance_id
}