variable "vpc_id" {}
variable "private_subnets" {}
variable "private_snet_1" {}
variable "private_snet_2" {}

variable "secrets_manager_secret_arn" {}
variable "security_groups" {}


variable "db_instances" {
  description = "Map of configurations for RDS instances"

  type = map(object({
    allocated_storage    = number
    engine               = string
    engine_version       = string
    instance_class       = string
    identifier           = string
    parameter_group_name = string
    multi_az             = bool
    storage_type         = string
    skip_final_snapshot  = bool
    db_name              = string
    username             = string
  }))
}
