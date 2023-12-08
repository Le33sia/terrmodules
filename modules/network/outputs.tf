output "vpc_id" {
  value = aws_vpc.demovpc.id
}
output "public_subnets" {
  value = { for k, v in aws_subnet.public_subnets : k => v.id }
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private_subnets : k => v.id }
}
