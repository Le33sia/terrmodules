variable "vpc_id" {}
variable "public_subnets" {}
variable "public_snet_1" {}
variable "public_snet_2" {}
variable "lb_name" {
  description = "Name of the load balancer"
  default     = "LB"
}

variable "lb_internal" {
  description = "Whether the load balancer is internal or not"
  default     = false
}

variable "lb_load_balancer_type" {
  description = "Type of load balancer"
  default     = "application"
}

variable "lb_enable_deletion_protection" {
  description = "Whether deletion protection is enabled for the load balancer"
  default     = false
}

variable "lb_target_port" {
  description = "Target port for the load balancer"
  default     = 80
}

variable "lb_protocol" {
  description = "Protocol for the load balancer"
  default     = "HTTP"
}

variable "lb_listener_port" {
  description = "Listener port for the load balancer"
  default     = 80
}

variable "lb_listener_protocol" {
  description = "Listener protocol for the load balancer"
  default     = "HTTP"
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = list(string)
}
