#------------------------------------------------------------------------------
# Code Build Module common Variables
#------------------------------------------------------------------------------
variable "source_bucket_name" {
  type        = string
  default     = "pipeline-k8s-source"
  description = "S3 Bucket name for the kubernetes manifest repo to trigger pipeline"
}

variable "source_s3_bucket_versioning" {
    type    = string
    default = "Enabled"
    description = "S3 Versioning Enabled/Disabled "
}

#------------------------------------------------------------------------------
# AWS ECR module Variables
#------------------------------------------------------------------------------
variable "ecr_repo_name_nodejs" {
  type        = string
  default     = "nodejs-ui"
  description = "The ECR repository Name for nodejs UI"
}

# =============== Code Build Module rpay_nodejs_ui Variables ===============
variable "nodejs_ui_build_project_name" {
  type        = string
  description = "Name of the build project append to it."
  default     = "nodejs-ui"
}

variable "nodejs_ui_repo_name" {
  type        = string
  default     = "nodejs-ui-k8s"
  description = "The GitHub Enterprise Repository for storing the Kubernetes Manifest Files"
}

variable "nodejs_ui_build_project_description" {
  type        = string
  default     = "Build project is to deploy the nodejs UI on eks linux container."
  description = "Description of the build project"
}

variable "nodejs_ui_build_script_repo_name" {
  type        = string
  default     = "nodejs-ui"
  description = "The GitHub Enterprise Repository for storing app source Scripts"
}

variable "nodejs_ui_build_buildspec" {
  type        = string
  default     = "buildspec_for_k8s.yaml"
  description = "The Build specification to use for this build project's related builds."
}

variable "nodejs_ui_build_privileged_mode" {
  type        = bool
  default     = true
  description = "Enable this flag if you want to build Docker images or want your builds to get elevated privileges."
}

#------------------------------------------------------------------------------
# Code pipeline rpay_nodejs_pipeline Variables
#------------------------------------------------------------------------------

variable "nodejs_ui_pipeline_name" {
  type        = string
  description = "Name of the pipeline append to it."
  default     = "nodejs-ui"
}

variable "nodejs_ui_buildspec_deploy" {
  type        = string
  default     = "buildspec.yaml"
  description = "The Build specification to use for this Deploy build project's related tasks."
}

variable "nodejs_ui_sns_topic_name" {
  type        = string
  default     = "nodejs-ui-pipeline-sns"
  description = "The name of the SNS Topic of nodejs poc"
}

variable "nodejs_ui_sns_endpoint" {
  type        = string
  default     = "tanuj.tiwari.aws@gmail.com"
  description = "The address to subscribe to status of nodejs poc pipeline"
}

variable "tls_key_algorithm" {
  description = "The algorithm to use for the TLS private key"
  type        = string
  default     = "ED25519"  # Default value
}

variable "github_repo_deploy_key_read_only" {
  description = "Whether the deploy key should be read-only"
  type        = bool
  default     = false  # Default value 
}

variable "nodejs_ui_github_location" {
  type        = string
  default     = "https://github.com/tanujtiwariaws/aws-test-iac.git"
  description = "The GitHub Enterprise Hostname"
}

variable "nodejs_build_custom_ingress" {
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
          from_port   = 80
          to_port     = 80
          description = "Allow HTTP access from anywhere"
          ip_protocol = "tcp"
        }
      }
    }
  }
}

variable "nodejs_build_custom_egress" {
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