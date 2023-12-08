variable "public_subnets" {

  default = {
    public_snet_1 = {
      cidr_block = "172.16.0.0/26",
      az         = "us-west-2a",
      tags = {
        Project = "demo"
      }
    },
    public_snet_2 = {
      cidr_block = "172.16.0.64/26",
      az         = "us-west-2b",
      tags = {
        Project = "demo"
      }
    }
  }
}
variable "private_subnets" {

  default = {
    private_snet_1 = {
      cidr_block = "172.16.0.128/26",
      az         = "us-west-2a",
      tags = {
        Project = "demo"
      }
    },
    private_snet_2 = {
      cidr_block = "172.16.0.192/26",
      az         = "us-west-2b",
      tags = {
        Project = "demo"
      }
    }
  }
}


variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
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
    # other required parameters
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
