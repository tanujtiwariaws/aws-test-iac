#------------------------------------------------------------------------------
# Common Variables across all modules
#------------------------------------------------------------------------------
variable "lob" {
  type        = string
  description = "Line of Business"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "appid" {
  type        = string  
  description = "App ID"
}

variable "path" {
  description = "Path for IAM Policies and Role"
  type        = string
  default     = "/application/"
}

variable "github_location" {
  type        = string  
  description = "The GitHub Enterprise Hostname"
}

variable "environment_variables" {
  type        = map(string)
  description = "Additional Environment variables for build job"
  default     = null
} 

#------------------------------------------------------------------------------
# Code Build, Deploy and Pipeline Variables
#------------------------------------------------------------------------------

variable "build_project_name" {
  type        = string  
  description = "Name of the build project append to it."
}

variable "repo_name" {
  type        = string  
  description = "The GitHub Enterprise Repository Name where the Source Scripts are present"
}

variable "source_branch" {
  type        = string  
  description = "The source Branch"
  default     = null
}


variable "build_project_description" {
  type        = string 
  default     = "Build project is to deploy the DB/app Scripts."
  description = "Description of the build project"
}

variable "build_timeout" {
  type        = string
  default     = "60"
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed."
}

variable "compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Information about the compute resources the build project will use. Available values for this parameter are: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM or BUILD_GENERAL1_LARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
  description = "The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g aws/codebuild/standard:2.0), Docker Hub images (e.g. hashicorp/terraform:latest), and full Docker repository URIs such as those for ECR (e.g. 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest)."
}

variable "build_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment to use for related builds. Available values are: LINUX_CONTAINER or WINDOWS_CONTAINER."
}

variable "buildspec" {
  type        = string
  default     = "buildspec.yaml"
  description = "The Build specification to use for this build project's related builds."
}

variable "custom_filepath_webhook_event" {
  type        = string
  default     = "^(.+)"
  description = "Define an event based on the filepath"
}

variable "privileged_mode" {
  type        = bool
  default     = false
  description = "Enable this flag if you want to build Docker images or want your builds to get elevated privileges."
}

variable "subnet_id" {
  description = "Subnet ID for build instance"
  type        = string
}
variable "vpc_id" {
  description = "vpc ID for build instance"
  type        = string
}
variable "build_custom_ingress" {
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

variable "build_custom_egress" {
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
