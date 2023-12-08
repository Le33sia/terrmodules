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
