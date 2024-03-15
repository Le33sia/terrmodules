terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "us-west-2"
  
}

module "network" {
  source = "./modules/network"
}

module "autoscaling_group" {
  source         = "./modules/autoscaling_group"
  vpc_id         = module.network.vpc_id
  public_snet_1  = module.network.public_subnets.public_snet_1
  public_snet_2  = module.network.public_subnets.public_snet_2
  public_subnets = module.network.public_subnets
  # Launch Template
  image_id                          = data.aws_ami.ami.id
  target_group_arn                  = module.elb.target_group_arn
  launch_template_security_group_id = module.network.launch_template_security_group_id
  # Auto Scaling
  secrets_manager_secret_arn = module.database.secrets_manager_secret_arn
  alb_security_group_id      = module.network.alb_security_group_id
}


module "elb" {
  source = "./modules/elb"

  public_snet_1         = module.network.public_subnets.public_snet_1
  public_snet_2         = module.network.public_subnets.public_snet_2
  vpc_id                = module.network.vpc_id
  public_subnets        = module.network.public_subnets
  alb_security_group_id = module.network.alb_security_group_id

}

module "database" {
  source               = "./modules/database"
  vpc_id               = module.network.vpc_id
  private_subnets      = module.network.private_subnets
  private_snet_1       = module.network.private_subnets.private_snet_1
  private_snet_2       = module.network.private_subnets.private_snet_2
  db_security_group_id = module.network.db_security_group_id
}


# Here is ami_id that was created with packer
data "aws_ami" "ami" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}
