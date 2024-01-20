
output "id" {
  value = aws_security_group.this.id
}

output "security_group" {
  value = aws_security_group.this
}

output "cidr_rules" {
  value = aws_security_group_rule.cidr_rules
}

output "sg_rules" {
  value = aws_security_group_rule.sg_rules
}

output "self_rules" {
  value = aws_security_group_rule.self_rules
}