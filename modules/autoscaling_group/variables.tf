
variable "secrets_manager_secret_arn" {}



# Launch Template
variable "security_groups" {}
variable "instance_type" {}
variable "image_id" {}
variable "ami_name" {
  description = "Name of the AMI"
  default     = "test"
}
variable "ami_owner" {
  description = "Owner of the AMI"
  default     = "self"
}


# Auto Scaling
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "health_check_type" {}
variable "security_group_id" {}
variable "target_group_arn" {}

variable "vpc_id" {}
variable "public_subnets" {}
variable "public_snet_1" {}
variable "public_snet_2" {}
