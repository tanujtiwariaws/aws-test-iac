output "codebuild_project_id" {
  description = "Returns Code Build project id"
  value       = aws_codebuild_project.cb_project.id
}

output "codebuild_project_name" {
  description = "Returns Code Build project name"
  value       = aws_codebuild_project.cb_project.name
}

output "codebuild_project_arn" {
  description = "Returns Code Build project arn"
  value       = aws_codebuild_project.cb_project.arn
}

output "codebuild_role_name" {
  description = "Returns Code Build role name"
  value       = aws_iam_role.codebuild_role.name
}