resource "aws_security_group" "ec2_instance" {
  name        = "${var.instance_name}-${var.env}-sg"
  description = var.security_group_description
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ingress_custom" {
  for_each = local.ec2_custom_ingress_rules

  security_group_id = aws_security_group.ec2_instance.id
  description       = each.value["description"]
  cidr_ipv4         = each.value["cidr"]
  from_port         = each.value["from_port"]
  ip_protocol       = each.value["ip_protocol"]
  to_port           = each.value["to_port"]
}

resource "aws_vpc_security_group_egress_rule" "ec2_egress_custom" {
  for_each = local.ec2_custom_egress_rules

  security_group_id = aws_security_group.ec2_instance.id
  description       = each.value["description"]
  cidr_ipv4         = each.value["cidr"]
  from_port         = each.value["from_port"]
  ip_protocol       = each.value["ip_protocol"]
  to_port           = each.value["to_port"]
}

