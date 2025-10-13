variable "name" {
  type        = string
  description = "base name of the resources"
}

# variable "my_ip" {
#   description = "Your public IP address"
#   default     = ""
# }

# variable "public_key" {
#   description = "Public key for SSH access to EC2"
#   type        = string
# }

# variable "user_arn" {
#   type        = string
#   description = "ARN of the user for policy assignment"
# }

# variable "create_iam" {
#   type        = bool
#   default     = true
#   description = "whether to create IAM role or not"
# }

# variable "create_eks" {
#   type        = bool
#   default     = false
#   description = "whether to create eks cluster or not"
# }

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
# variable "vpc_cidr" {
#   type        = string
#   description = "CIDR range to create VPC"
# }
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
