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
