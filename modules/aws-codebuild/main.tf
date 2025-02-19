#------------------------------------------------------------------------------
#  Code Build (DEV)
#------------------------------------------------------------------------------
resource "aws_codebuild_project" "cb_project" {
  name          = "${var.lob}-${var.env}-${var.build_project_name}-build"
  description   = var.build_project_description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild_role.arn
  
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.build_image
    type                        = var.build_type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode
    
    dynamic "environment_variable" {
      for_each = var.environment_variables != null ? var.environment_variables : {}
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.code_build_log_group.name
      stream_name = "${var.build_project_name}-build-log"
    }
  }

  source {
    type            = "GITHUB_ENTERPRISE"
    location        = var.github_location
    git_clone_depth = 1
    buildspec       = var.buildspec
  }
  source_version  = var.source_branch == null ? var.env : var.source_branch

  vpc_config {
    vpc_id  = var.vpc_id
    subnets = [var.subnet_id]
    security_group_ids = [
      aws_security_group.custom_codebuild_sg.id
    ]
  }

  tags = {
    Name     = "${var.lob}-${var.env}-${var.build_project_name}-build"
  }
}

resource "aws_codebuild_webhook" "git_push_event_webhook" {
  project_name = aws_codebuild_project.cb_project.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type = "HEAD_REF"
      pattern = var.source_branch == null ? "^refs/heads/${var.env}$" : "^refs/heads/${var.source_branch}$"
    }

    filter {
      type = "FILE_PATH"
      pattern = var.custom_filepath_webhook_event
    }
  }
}

resource "github_repository_webhook" "for_codebuild_webhook_event" {
  active     = true
  events     = ["push"]
  repository = var.repo_name

  configuration {
    url          = aws_codebuild_webhook.git_push_event_webhook.payload_url
    secret       = aws_codebuild_webhook.git_push_event_webhook.secret
    content_type = "json"
    insecure_ssl = false
  }
}


resource "aws_cloudwatch_log_group" "code_build_log_group" {
  name = "${var.lob}-${var.env}-${var.build_project_name}-build-log-group"

  tags = {
    Name     = "${var.lob}-${var.env}-${var.build_project_name}-build-log-group"
  }
}