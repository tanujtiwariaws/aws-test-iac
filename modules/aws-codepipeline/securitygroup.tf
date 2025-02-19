locals {
  override_custom_codebuild_sg = length(var.custom_sg_egress_port[var.env]) > 0 && var.custom_codebuild_sg == false ? true : var.custom_codebuild_sg
}

resource "aws_security_group" "custom_codebuild_sg" {
  count        = local.override_custom_codebuild_sg ? 1 : 0

  name        = "${var.lob}-${var.env}-${var.pipeline_name}-pl-deploy-custom-codebuild-sg"
  description = "Custom security group and attach to the code build project"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "custom_codebuild_outbound_access" { 
  
  for_each = toset(var.custom_sg_egress_port[var.env])

  security_group_id = aws_security_group.custom_codebuild_sg[0].id
  cidr_ipv4         = var.vpc_id
  from_port         = each.key
  to_port           = each.key
  ip_protocol       = "tcp"  
}