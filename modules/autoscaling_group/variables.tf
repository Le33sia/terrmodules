
variable "secrets_manager_secret_arn" {}



# Launch Template
variable "image_id" {}
variable "target_group_arn" {}

variable "vpc_id" {}
variable "public_subnets" {}
variable "public_snet_1" {}
variable "public_snet_2" {}


#autoscaling_group
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "max_size" {
  description = "Maximum size for Auto Scaling Group"
  default     = 1
}

variable "min_size" {
  description = "Minimum size for Auto Scaling Group"
  default     = 1
}

variable "desired_capacity" {
  description = "Desired capacity for Auto Scaling Group"
  default     = 1
}

variable "health_check_type" {
  description = "Health check type for Auto Scaling Group"
  default     = "ELB"
}
variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = list(string)
  # Add any necessary validation or defaults
}

variable "launch_template_security_group_id" {
  description = "ID of the security group for the launch template"
  type        = list(string)
  # Add any necessary validation or defaults
}
