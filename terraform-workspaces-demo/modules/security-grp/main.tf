# Lookup existing SG by name and VPC
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = [var.name]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Use the existing SG ID for rules
resource "aws_security_group_rule" "ingress" {
  for_each          = var.ingress_rules
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = data.aws_security_group.existing_sg.id
}

resource "aws_security_group_rule" "egress" {
  for_each          = var.egress_rules
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = data.aws_security_group.existing_sg.id
}

