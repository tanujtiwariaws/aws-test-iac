#------------------------------------------------------------------------------
# Common Variables 
#------------------------------------------------------------------------------
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "lob" {
  type = string
  description = "Line of Business"
}

variable "env" {
  type = string
  description = "Environment"
}

variable "appid" {
  type        = string  
  description = "App ID"
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

variable "privileged_mode" {
  type        = bool
  default     = false
  description = "Enable this flag if you want to build Docker images or want your builds to get elevated privileges."
}

variable "sns_topic_arn" {
  type        = string
  description = "SNS topic ARN for to subscribe"
  default     = null
}

#------------------------------------------------------------------------------
# Code Pipeline Variables 
#------------------------------------------------------------------------------

variable "pipeline_name" {
  type        = string  
  description = "Name of the pipeline append to it."
}

variable "pipeline_artifacts_bucket" {
  type        = string
  description = "S3 Bucket Name to store the Pipeline Artifacts"
}

#------------------------------------------------------------------------------
# Code Pipeline Source Stage Variables 
#------------------------------------------------------------------------------
variable "pipeline_source_bucket" {
  type        = string
  description = "The Bucket name of the source"
}

variable "pipeline_source_filename" {
  type        = string
  description = "The file name of the source for pipeline to trigger when updated"
}

#------------------------------------------------------------------------------
# Code Pipeline Build Stage Variables 
#------------------------------------------------------------------------------

variable "buildspec_build" {
  type        = string
  default     = "buildspec_build.yaml"
  description = "The Build specification to use for this build project's related builds."
}

#------------------------------------------------------------------------------
# Code Pipeline Approval Stage sns Variables 
#------------------------------------------------------------------------------

variable "external_entity_link" {
  type        = string
  default     = "https://codepipeline-us-east-1-187604043303.s3.amazonaws.com/"
  description = "Address to review the codepipeline object"
}

#------------------------------------------------------------------------------
# Code Pipeline Deploy Stage Variables 
#------------------------------------------------------------------------------

# variable "deploy_project_name" {
#   type        = string  
#   description = "Name of the Deploy build project append to it."
# }

variable "deploy_project_description" {
  type        = string 
  default     = "Deploy Build project is to deploy the Application"
  description = "Description of the Deploy build project"
}

variable "buildspec_deploy" {
  type        = string
  default     = "buildspec_deploy.yaml"
  description = "The Build specification to use for this Deploy build project's related tasks."
}

variable "custom_codebuild_sg" {
  type        = bool
  default     = false
  description = "Enable this flag if you want to create custom security group and attach to the code build project."
}

variable "custom_sg_egress_port" {
  type = map(list(string))
  default = {    
    "dev" = []    
    "qa" = []
    "stage" = []    
    "prod" = []    
  }
  description = "Enable custom SG egress traffic to required ports. use the below format as example while passing the value."  
}

variable "custom_env_variables" {
  type        = map(string)
  description = "Additional Environment variables for build job"
  default     = null
} 

# Codedeploy Variables

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_service_name" {
  description = "The name of the EKS service"
  type        = string
}

variable "codedeploy_blue_green" {
  description = "Flag to enable blue-green deployment strategy"
  type        = bool
  default     = true
}

variable "codedeploy_rollback_on_failure" {
  description = "Whether to enable rollback on deployment failure"
  type        = bool
  default     = true
}
variable "vpc_id" {
  description = "vpc ID for build instance"
  type        = string
}