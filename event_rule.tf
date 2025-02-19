resource "aws_cloudwatch_event_rule" "ecr_push_event_rule" {
  name        = "${var.lob}-${var.env}-${var.nodejs_ui_pipeline_name}-ecr-push-rule"
  description = "Event rule for ECR push events to trigger CodePipeline"
  event_pattern = jsonencode({
    source = ["aws.ecr"]
    detail-type = ["ECR Image Action"]
    detail = {
      "eventName" = ["PutImage"]
      "repositoryName" = ["${var.lob}-${var.env}-${var.ecr_repo_name_nodejs}"] # The name of your ECR repository
    }
  })

  # Optional: you can define event bus here if you're using a custom bus.
  event_bus_name = "default" # Can be omitted if you're using the default event bus
}

resource "aws_cloudwatch_event_target" "pipeline_trigger" {
  rule      = aws_cloudwatch_event_rule.ecr_push_event_rule.name
  target_id = "codepipeline-target"

  arn = module.pipeline_nodejs_ui.pipeline_arn

  # Optional: Define the role that EventBridge will use to trigger the pipeline
  role_arn = aws_iam_role.eventbridge_to_pipeline_role.arn
}

resource "aws_iam_role" "eventbridge_to_pipeline_role" {
  name               = "${var.lob}-${var.env}-${var.nodejs_ui_pipeline_name}-eventbridge-to-pipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_pipeline_policy_to_eventbridge_role" {
  role       = aws_iam_role.eventbridge_to_pipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}
