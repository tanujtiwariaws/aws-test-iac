locals {
  nodejs_environment_variables = {
    #   "ECR_REPO_URL"      = module.ecr_nodejs_ui.ecr_repository_url
      "S3_BUCKET"         = module.s3_deploy.bucket_id
      "REPO_NAME"         = var.nodejs_ui_repo_name
      "env"               = var.env
  }
}

##### ECR, SNS Topic Subscription, Code Build and Code pipeline for rpay nodejs UI #########
module "ecr_nodejs_ui" {
  source          = "./modules/aws-ecr"
  repo_name = "${var.lob}-${var.env}-${var.ecr_repo_name_nodejs}"
}

# module "sns_nodejs_ui" {
#   source         = "./modules/aws-sns"
#   sns_topic_name = var.nodejs_ui_sns_topic_name
#   sns_endpoint   = var.nodejs_ui_sns_endpoint
# }

##### S3 Bucket to store kubernets manifest files to trigger the deploy pipeline
module "s3_deploy" {
  source                    = "./modules/aws-s3"
  env                       = var.env
  lob                       = var.lob
  bucket_name               = var.source_bucket_name
}

##### Code Build rpay nodejs UI  #########
module "codebuild_nodejs_ui" {
  source                    = "./modules/aws-codebuild"
  env                       = var.env
  lob                       = var.lob
  appid                     = var.appid
  vpc_id                    = var.webserver_vpc_id[var.env]
  subnet_id                 = var.webserver_subnet_id[var.env]
  github_location           = var.nodejs_ui_github_location
  build_project_name        = var.nodejs_ui_build_project_name
  build_project_description = var.nodejs_ui_build_project_description
  repo_name                 = var.nodejs_ui_build_script_repo_name
  buildspec                 = var.nodejs_ui_build_buildspec
  privileged_mode           = var.nodejs_ui_build_privileged_mode
  environment_variables     = local.nodejs_environment_variables
  build_custom_ingress      = var.nodejs_build_custom_ingress
  build_custom_egress       = var.nodejs_build_custom_egress 
}

## Custom policy to attach code build project
resource "aws_iam_policy" "codebuild_nodejs_ui_policy" {
  name = "${var.nodejs_ui_build_project_name}-codebuild-custom-policy"
  tags = {
    environment = var.env
    lob         = var.lob
    appid       = var.appid
  }
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
         {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_role_policy_nodejs_ui_attach" {
  role       = module.codebuild_nodejs_ui.codebuild_role_name
  policy_arn = aws_iam_policy.codebuild_nodejs_ui_policy.arn
}

#### S3 Bucket to store Artifacts of the Code pipeline
module "s3_codepipeline_artifacts" {
  source                    = "./modules/aws-s3"
  env                       = var.env
  lob                       = var.lob
  bucket_name               = "codepipeline-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
 }

# ### Angualr POC Deployemnt piepline
module "pipeline_nodejs_ui" {
  source                    = "./modules/aws-codepipeline"
  pipeline_name             = var.nodejs_ui_pipeline_name
  env                       = var.env
  lob                       = var.lob
  appid                     = var.appid
  buildspec_deploy          = var.nodejs_ui_buildspec_deploy
  pipeline_artifacts_bucket = module.s3_codepipeline_artifacts.bucket_id
  pipeline_source_bucket    = module.s3_deploy.bucket_id
  pipeline_source_filename  = "${var.nodejs_ui_repo_name}.zip"
  eks_cluster_name          = aws_eks_cluster.eks_cluster.name
  eks_service_name          = kubernetes_service.app_service.metadata[0].name
  vpc_id                    = var.webserver_vpc_id[var.env]
}

