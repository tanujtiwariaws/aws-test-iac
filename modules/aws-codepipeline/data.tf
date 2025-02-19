data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "AmazonECSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# Data block to fetch the AWSCodeDeployRole policy
data "aws_iam_policy" "AWSCodeDeployRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
