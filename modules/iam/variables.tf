variable "name" {
  type        = string
  description = "base name of the resources"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "user_arn" {
  type        = string
  description = "ARN of the user for policy assignment"
}
