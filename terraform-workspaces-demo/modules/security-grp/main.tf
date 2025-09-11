# Lookup existing security group by name in the given VPC
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

# Manage ingress rules on the existing SG
resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = data.aws_security_group.existing_sg.id
}

# Manage egress rules on the existing SG
resource "aws_security_group_rule" "egress" {
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = data.aws_security_group.existing_sg.id
}
