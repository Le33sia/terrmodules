output "rds_endpoints" {
  value = {
    for key, instance in aws_db_instance.db_instances :
    key => instance.endpoint
  }
}

output "secrets_manager_secret_arn" {
  value     = aws_secretsmanager_secret.secretdb.arn
  sensitive = true
}

output "db_instances_output" {
  value = var.db_instances
}

