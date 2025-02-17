variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair for EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "security_group_description" {
  description = "Security Group Description"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for EC2 instance"
  type        = string
}

variable "ec2_custom_ingress" {
  description = "Custom ingress rules for different environments"
  type = map(object({
    ingress = map(object({
      cidr        = string
      from_port   = number
      to_port     = number
      description = string
      ip_protocol = string
    }))
  }))
  default = null
}

variable "ec2_custom_egress" {
  description = "Custom egress rules for different environments"
  type = map(object({
    egress = map(object({
      cidr        = string
      from_port   = number
      to_port     = number
      description = string
      ip_protocol = string
    }))
  }))
  default = null
}

variable "env" {
  description = "Environment (prod, dev, etc.)"
  type        = string
}

variable "user_data" {
  type        = string
  description = "Provide custom userdata"
  default = null
  }
