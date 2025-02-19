variable "aws_region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "eu-north-1"  # Set a default value or pass 
}

variable "env" {
  description = "The environment (e.g., prod, dev,qa,stage)."
  type        = string
  default     = "dev"
}

variable "appid" {
  type        = string
  default     = "APP-12794"
  description = "App ID"
}

variable "lob" {
  type        = string
  default     = "test"
  description = "Line of Business"
}

variable "webserver_vpc_id" {
  description = "Mapping of environment to VPC IDs"
  type = map(string)
  default = {
    dev   = "vpc-0bac109919eccef7b"  # Demo VPC ID for dev
    qa    = "vpc-0bac109919eccef7b"  # Demo VPC ID for qa
    stage = "vpc-0bac109919eccef7b"  # Demo VPC ID for stage
    prod  = "vpc-0bac109919eccef7b"  # Demo VPC ID for prod
  }
}

variable "webserver_subnet_id" {
  description = "Mapping of environment to subnet IDs"
  type = map(string)
  default = {
    dev   = "subnet-039fc605af13413be"  # Demo Subnet ID for dev
    qa    = "subnet-039fc605af13413be"  # Demo Subnet ID for qa
    stage = "subnet-039fc605af13413be"  # Demo Subnet ID for stage
    prod  = "subnet-039fc605af13413be"  # Demo Subnet ID for prod
  }
}

variable "webserver_ami_id" {
  description = "Mapping of environment to AMI IDs"
  type = map(string)
  default = {
    dev   = "ami-0c55b159cbfafe1f0"  # Replace with actual AMI ID for dev
    qa    = "ami-0f9f9d45a6c756789"  # Replace with actual AMI ID for qa
    stage = "ami-0293f9d8f61b23456"  # Replace with actual AMI ID for stage
    prod  = "ami-0565e7f7a1f01099d"  # Replace with actual AMI ID for prod
  }
}

variable "webserver_instance_type" {
  description = "The type of EC2 instance."
  type        = string
  default     = "t2.micro"  # Default instance type
}

variable "webserver_key_name" {
  description = "The name of the EC2 key pair."
  type        = string
  default     = "webserver-key-pair"
}

variable "webserver_instance_name" {
  description = "The name of the EC2 instance."
  type        = string
  default     = "webserver"
}

variable "webserver_security_group_description" {
  description = "A description of the security group."
  type        = string
  default     = "Security group for EC2 instances"
}


variable "webserver_user_data_script" {
  description = "Path to the user data script"
  type        = string
  default     = "./scripts/userdata_webserver.sh"  # Adjust if needed
}
variable "webserver_ec2_custom_ingress" {
  description = "Custom ingress rules for the EC2 instance's security group."
  type = map(object({
    ingress = map(object({
      cidr        = string
      from_port   = number
      to_port     = number
      description = string 
      ip_protocol = string
    }))
  }))
  default = {
    dev = {
      ingress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 22
          to_port     = 22
          description = "Allow SSH access from anywhere"
          ip_protocol = "tcp"
        },
        "rule2" = {
          cidr        = "0.0.0.0/0"
          from_port   = 80
          to_port     = 80
          description = "Allow HTTP access from anywhere"
          ip_protocol = "tcp"
        }
      }
    },
    qa = {
      ingress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 22
          to_port     = 22
          description = "Allow SSH access from anywhere"
          ip_protocol = "tcp"
        },
        "rule2" = {
          cidr        = "0.0.0.0/0"
          from_port   = 80
          to_port     = 80
          description = "Allow HTTP access from anywhere"
          ip_protocol = "tcp"
        }
      }
    },
    stage = {
      ingress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 22
          to_port     = 22
          description = "Allow SSH access from anywhere"
          ip_protocol = "tcp"
        },
        "rule2" = {
          cidr        = "0.0.0.0/0"
          from_port   = 80
          to_port     = 80
          description = "Allow HTTP access from anywhere"
          ip_protocol = "tcp"
        }
      }
    },
    prod = {
      ingress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 22
          to_port     = 22
          description = "Allow SSH access from anywhere"
          ip_protocol = "tcp"
        },
        "rule2" = {
          cidr        = "0.0.0.0/0"
          from_port   = 80
          to_port     = 80
          description = "Allow HTTP access from anywhere"
          ip_protocol = "tcp"
        }
      }
    }
  }
}

variable "webserver_ec2_custom_egress" {
  description = "Custom egress rules for the EC2 instance's security group."
  type = map(object({
    egress = map(object({
      cidr        = string
      from_port   = number
      to_port     = number
      description = string
      ip_protocol = string
    }))
  }))
  default = {
    dev = {
      egress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
          description = "Allow all outbound traffic"
          ip_protocol = "-1"  # -1 means all protocols
        }
      }
    },
    qa = {
      egress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
          description = "Allow all outbound traffic"
          ip_protocol = "-1"
        }
      }
    },
    stage = {
      egress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
          description = "Allow all outbound traffic"
          ip_protocol = "-1"
        }
      }
    },
    prod = {
      egress = {
        "rule1" = {
          cidr        = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
          description = "Allow all outbound traffic"
          ip_protocol = "-1"
        }
      }
    }
  }
}