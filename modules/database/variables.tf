variable "vpc_id" {}
variable "private_subnets" {}
variable "private_snet_1" {}
variable "private_snet_2" {}


variable "db_security_group_id" {
  description = "ID of the ALB security group"
  type        = list(string)
}
variable "db_instances" {
  type = map(object({
    engine               = string
    instance_class       = string
    allocated_storage    = number
    engine_version       = string
    identifier           = string
    parameter_group_name = string
    multi_az             = bool
    storage_type         = string
    skip_final_snapshot  = bool
    db_name              = string
    username             = string
  }))
  default = {
    example_db1 = {
      engine               = "mysql"
      allocated_storage    = 10
      engine_version       = "8.0.33"
      instance_class       = "db.t3.micro"
      identifier           = "database-1"
      parameter_group_name = "default.mysql8.0"
      multi_az             = false
      storage_type         = "gp2"
      skip_final_snapshot  = true
      username             = "admin"
      db_name              = "demodb"

    }
  }
}

#locals {
# secrets_manager_secret_arn = aws_secretsmanager_secret.secretdb.arn
#}
