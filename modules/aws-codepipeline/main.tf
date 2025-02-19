# AWS Provider Configuration
provider "aws" {
  region = var.region
}

# 1. Create CodeDeploy Application (for ECS/EKS)
resource "aws_codedeploy_app" "app" {
  name              = "${var.lob}-${var.env}-${var.pipeline_name}-deployapp"
  compute_platform  = "ECS"  # ECS compatibility for EKS

  tags = {
    Name = "${var.lob}-${var.env}-${var.pipeline_name}-app"
  }
}

# 2. Create CodeDeploy Deployment Group (Deploy to EKS)
resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name             = aws_codedeploy_app.app.name
  deployment_group_name = "${var.lob}-${var.env}-${var.pipeline_name}-deploy-group"
  service_role_arn         = aws_iam_role.codedeploy_service_role.arn

  # Blue/Green Deployment strategy
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
 
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action   = "TERMINATE"
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  ecs_service {
    cluster_name = var.eks_cluster_name
    service_name = var.eks_service_name
  }
}

# 3. Define CodePipeline
resource "aws_codepipeline" "codepipeline" {
  name       = "${var.lob}-${var.env}-${var.pipeline_name}-pipeline"
  depends_on = [aws_iam_role.codepipeline_role]
  role_arn   = aws_iam_role.codepipeline_role.arn
  artifact_store {
    type     = "S3"
    location = var.pipeline_artifacts_bucket
  }

  stage {
    name = "Source"

    action {
      name     = "SourceAction"
      category = "Source"
      owner    = "AWS"
      provider = "S3"
      version  = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        S3Bucket    = var.pipeline_source_bucket
        S3ObjectKey = var.pipeline_source_filename
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployToEKS"
      category        = "Deploy"
      provider        = "CodeDeploy"
      version         = "1"
      owner           = "AWS"
      region          = var.region
      run_order       = 3
      input_artifacts = ["SourceArtifact"]
      configuration = {
        ApplicationName      = aws_codedeploy_app.app.name
        DeploymentGroupName  = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
      }
    }
  }
}

# 4. Create CloudWatch Log Group for CodePipeline
resource "aws_cloudwatch_log_group" "code_pipeline_log_group" {
  name = "${var.lob}-${var.env}-${var.pipeline_name}-log-group"

  tags = {
    Name = "${var.lob}-${var.env}-${var.pipeline_name}-log-group"
  }
}

# 5. IAM Role for CodeDeploy (Service Role)
resource "aws_iam_role" "codedeploy_service_role" {
  name               = "${var.lob}-${var.env}-${var.pipeline_name}-codedeploy-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  
}

# Attach AmazonECSFullAccess policy to the IAM Role
resource "aws_iam_role_policy_attachment" "attach_amazon_ecs_full_access" {
  policy_arn = data.aws_iam_policy.AmazonECSFullAccess.arn
  role       = aws_iam_role.codedeploy_service_role.name
}

# Attach AWSCodeDeployRole policy to the IAM Role
resource "aws_iam_role_policy_attachment" "attach_aws_codedeploy_role" {
  policy_arn = data.aws_iam_policy.AWSCodeDeployRole.arn
  role       = aws_iam_role.codedeploy_service_role.name
}