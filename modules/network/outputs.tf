output "vpc_id" {
  value = aws_vpc.demovpc.id
}
output "public_subnets" {
  value = { for k, v in aws_subnet.public_subnets : k => v.id }
}
output "private_subnets" {
  value = { for k, v in aws_subnet.private_subnets : k => v.id }
}
output "alb_security_group_id" {
  value = [aws_security_group.ALBSecurityGroup.id]
}
output "launch_template_security_group_id" {
  value = [aws_security_group.SGtemplate.id]
}
output "db_security_group_id" {
  value = [aws_security_group.db_SG.id]
}
