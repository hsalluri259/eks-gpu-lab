variable "name" {
  type        = string
  description = "Name of the vpc"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR block to create vpc"
}
variable "my_ip" {
  description = "Your public IP address"
  default     = ""
}
