
resource "aws_security_group" "this" {
  name_prefix = var.name
  vpc_id      = var.vpc_id
  description = var.description

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group_rule" "cidr_rules" {
  for_each          = var.cidr_rules
  security_group_id = aws_security_group.this.id
  type              = each.value[0]
  protocol          = each.value[1]
  from_port         = each.value[2]
  to_port           = each.value[3]
  cidr_blocks       = [each.value[4]]
  description       = each.value[5]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_rules" {
  for_each                 = var.sg_rules
  security_group_id        = aws_security_group.this.id
  type                     = each.value[0]
  protocol                 = each.value[1]
  from_port                = each.value[2]
  to_port                  = each.value[3]
  source_security_group_id = each.value[4]
  description              = each.value[5]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "self_rules" {
  for_each = var.self_rules

  security_group_id = aws_security_group.this.id
  type              = each.value[0]
  protocol          = each.value[1]
  from_port         = each.value[2]
  to_port           = each.value[3]
  description       = each.value[4]
  self              = true

  lifecycle {
    create_before_destroy = true
  }
}
