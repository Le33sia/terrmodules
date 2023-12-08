resource "aws_db_instance" "db_instances" {
  for_each = var.db_instances

  allocated_storage      = each.value.allocated_storage
  engine                 = each.value.engine
  instance_class         = each.value.instance_class
  engine_version         = each.value.engine_version
  identifier             = each.value.identifier
  parameter_group_name   = each.value.parameter_group_name
  multi_az               = each.value.multi_az
  storage_type           = each.value.storage_type
  skip_final_snapshot    = each.value.skip_final_snapshot
  db_name                = each.value.db_name
  username               = each.value.username
  password               = random_password.password.result
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_SG.id]
  tags                   = {Name = each.key}
}
# Add other required parameters for the RDS instance

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet-group"
  description = "database subnet group"
  subnet_ids  = [var.private_snet_1, var.private_snet_2]
}

#SECRETS_MANAGER
resource "aws_secretsmanager_secret" "secretdb" {
  name = "secret6"
}
resource "aws_secretsmanager_secret_version" "secretdb" {

  for_each  = var.db_instances
  secret_id = aws_secretsmanager_secret.secretdb.id
  secret_string = jsonencode({
    username = each.value.username
    password = random_password.password.result
    host     = aws_db_instance.db_instances[each.key].endpoint
    dbname   = each.value.db_name
  })
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

#security group for database
resource "aws_security_group" "db_SG" {
  vpc_id      = var.vpc_id
  name        = "db_SG"
  description = "Allow inbound mysql traffic"
}
resource "aws_security_group_rule" "allow_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_SG.id
  source_security_group_id = var.security_groups

}
resource "aws_security_group_rule" "allow_outgoing" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.db_SG.id
  cidr_blocks       = ["0.0.0.0/0"]
}
