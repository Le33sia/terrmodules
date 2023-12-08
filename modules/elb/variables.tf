# Load Balancer
variable "lb_name" {}
variable "lb_internal" {}
variable "lb_load_balancer_type" {}
variable "lb_enable_deletion_protection" {}
variable "lb_target_port" {}
variable "lb_protocol" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}


variable "vpc_id" {}
variable "public_subnets" {}
variable "public_snet_1" {}
variable "public_snet_2" {}
