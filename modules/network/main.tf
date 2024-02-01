resource "aws_vpc" "demovpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = "Demo VPC"
  }
}
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}
#public subnets 
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.demovpc.id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  tags                    = merge({ Name = each.key }, each.value.tags)
}

# Route Table
resource "aws_route_table" "route" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
  tags = {
    Name = "Route to internet"
  }
}
resource "aws_route_table_association" "rt" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.route.id
}

resource "aws_subnet" "private_subnets" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.demovpc.id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  tags                    = merge({ Name = each.key }, each.value.tags)
}

# route table for private subnets
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.demovpc.id
  tags = {
    Name = "Private Route Table"
  }
}
# Associate private subnets with the private route table
resource "aws_route_table_association" "rt_private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private_route.id
}

# LB security group
resource "aws_security_group" "ALBSecurityGroup" {
  name        = "LB-security-group"
  description = "Security group for the Application Load Balancer"

  vpc_id = aws_vpc.demovpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group that should be attached to launch template
resource "aws_security_group" "SGtemplate" {
  name        = "SGtemplate"
  description = "Allow incoming HTTP SSH traffic"
  vpc_id      = aws_vpc.demovpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] 
    security_groups = [aws_security_group.ALBSecurityGroup.id] #[var.security_group_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#security group for database
resource "aws_security_group" "db_SG" {
  vpc_id      = aws_vpc.demovpc.id
  name        = "db_SG"
  description = "Allow inbound mysql traffic"
}
resource "aws_security_group_rule" "allow_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_SG.id
  source_security_group_id = aws_security_group.SGtemplate.id #var.launch_template_security_group_id[0]

}
resource "aws_security_group_rule" "allow_outgoing" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.db_SG.id
  cidr_blocks       = ["0.0.0.0/0"]
}
