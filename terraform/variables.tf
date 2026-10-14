variable "aws_region" {
  description = "AWS region for this project"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Prefix used in resource names and tags"
  type        = string
  default     = "ironhack-voting"
}

variable "instance_type" {
  description = "EC2 instance type for all three instances"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID valid in the selected region"
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name in the selected region"
  type        = string
}

variable "my_ip" {
  description = "Your current public IPv4 address in CIDR notation, e.g. 203.0.113.10/32"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.my_ip))
    error_message = "Set my_ip to a valid IPv4 CIDR block, usually your public IP followed by /32."
  }
}

variable "enable_nat_gateway" {
  description = "Create a NAT Gateway to allow private instances outbound internet access; this incurs ongoing AWS charges"
  type        = bool
  default     = true
}
