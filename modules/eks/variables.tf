variable "name" {
  type        = string
  description = "base name of the resources"
}

# Cluster variables
variable "cluster_version" {
  type        = string
  description = "EKS cluster version"
  default     = "1.32"
}

variable "region" {
  type        = string
  description = "AWS region to deploy to"
  default     = "us-west-2"
}
# End of Cluster variables

# VPC config variables
variable "vpc_id" {
  type        = string
  description = "VPC ID to create a cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "subnet IDs to create a cluster"
}

variable "role_arn" {
  type        = string
  description = "ROLE_ARN to create access entry"
}

variable "eks_node_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes"
  type        = string
}

variable "create_gpu_nodegroup" {
  type        = string
  description = "Whether to create a gpu node group or not"
  default     = true
}

variable "public_key" {
  description = "Public key for SSH access to EC2"
  type        = string
}

variable "additional_security_group_ids" {
  description = "List of security group IDs to add to nodes"
  type        = list(string)
}

