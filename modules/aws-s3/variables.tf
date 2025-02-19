variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "lob" {
  type        = string
  description = "Line of Business"
}

variable "env" {
  type        = string
  description = "Environment"
}