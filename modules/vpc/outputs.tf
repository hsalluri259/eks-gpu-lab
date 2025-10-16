output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnets" {
  value = module.vpc.private_subnets
}

output "eks_ssh_sg_id" {
  value = aws_security_group.eks_ssh.id
}
