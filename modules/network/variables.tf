variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

#subnets

variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
}
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

