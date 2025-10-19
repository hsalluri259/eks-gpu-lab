output "role_arn" {
  description = "ARN of the IAM role to assume by IAM user"
  value       = aws_iam_role.assumable_role.arn
}

output "eks_node_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes"
  value       = aws_iam_role.eks_node_role.arn
}

