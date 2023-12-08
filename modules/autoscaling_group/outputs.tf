output "SGtemplate_id" {
  value = aws_security_group.SGtemplate.id
}

output "image_id" {
  description = "ID of the selected AMI"
  value       = data.aws_ami.ami.id
}