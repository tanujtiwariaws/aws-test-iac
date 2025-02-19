resource "aws_security_group" "custom_codebuild_sg" {
  name        = "${var.lob}-${var.env}-${var.build_project_name}-sg"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "build_ingress_custom" {
  for_each = local.build_custom_ingress_rules

  security_group_id = aws_security_group.custom_codebuild_sg.id
  description       = each.value["description"]
  cidr_ipv4         = each.value["cidr"]
  from_port         = each.value["from_port"]
  ip_protocol       = each.value["ip_protocol"]
  to_port           = each.value["to_port"]
}

resource "aws_vpc_security_group_egress_rule" "build_egress_custom" {
  for_each = local.build_custom_egress_rules

  security_group_id = aws_security_group.custom_codebuild_sg.id
  description       = each.value["description"]
  cidr_ipv4         = each.value["cidr"]
  from_port         = each.value["from_port"]
  ip_protocol       = each.value["ip_protocol"]
  to_port           = each.value["to_port"]
}

