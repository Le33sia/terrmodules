output "security_group_id" {
  value = aws_security_group.ALBSecurityGroup.id
}
output "target_group_arn" {
  value = aws_lb_target_group.my_target_group.arn
}