locals {
  config = jsondecode(file("terraform.tfvars.json"))
}

resource "aws_vpc" "dailyge_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "dailyge_igw" {
  vpc_id = aws_vpc.dailyge_vpc.id
  tags   = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "dailyge_public_subnets" {
  for_each = {for idx, subnet in var.public_subnets : idx => subnet}

  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.zone
  map_public_ip_on_launch = true
  tags                    = {
    Name = "${var.project_name}-public-subnets-${each.key}",
  }
}

resource "aws_subnet" "dailyge_private_subnets" {
  for_each = {for idx, subnet in var.private_subnets : idx => subnet}

  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.zone
  map_public_ip_on_launch = false
  tags                    = {
    Name = "${var.project_name}-private-${each.key}"
  }
}

resource "aws_subnet" "dailyge_redis_subnet" {
  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = var.redis_subnet.cidr
  availability_zone       = var.redis_subnet.zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-redis-subnet"
  }
}

resource "aws_subnet" "dailyge_rds_subnets" {
  for_each = {for idx, subnet in var.rds_subnets : idx => subnet}

  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.zone
  map_public_ip_on_launch = false
  tags                    = {
    Name = "${var.project_name}-rds-subnets-${each.key}"
  }
}

resource "aws_subnet" "dailyge_monitoring_subnets" {
  for_each = {for idx, subnet in var.monitoring_subnets : idx => subnet}

  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.zone
  map_public_ip_on_launch = false
  tags                    = {
    Name = "${var.project_name}-monitoring-subnets-${each.key}",
  }
}

resource "aws_route_table" "dailyge_monitoring_route_table" {
  vpc_id = aws_vpc.dailyge_vpc.id
  tags   = {
    Name = "${var.project_name}-monitoring-route-table",
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dailyge_nat.id
  }
}

resource "aws_route_table_association" "monitoring_route_table_association" {
  for_each = aws_subnet.dailyge_monitoring_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.dailyge_monitoring_route_table.id
}

resource "aws_route_table" "dailyge_redis_route_table" {
  vpc_id = aws_vpc.dailyge_vpc.id
  tags   = {
    Name = "${var.project_name}-redis-route-table",
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dailyge_nat.id
  }
}

resource "aws_route_table_association" "redis_route_table_association" {
  subnet_id      = aws_subnet.dailyge_redis_subnet.id
  route_table_id = aws_route_table.dailyge_redis_route_table.id
}

resource "aws_route_table" "dailyge_public_route_table" {
  vpc_id = aws_vpc.dailyge_vpc.id
  tags   = {
    Name = "${var.project_name}-public-route-table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dailyge_igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each = aws_subnet.dailyge_public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.dailyge_public_route_table.id
}

resource "aws_eip" "dailyge_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_nat_gateway" "dailyge_nat" {
  allocation_id = aws_eip.dailyge_eip.id
  subnet_id     = element([for subnet in aws_subnet.dailyge_public_subnets : subnet.id], 0)
  tags          = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_route_table" "dailyge_private_route_table" {
  vpc_id = aws_vpc.dailyge_vpc.id
  tags   = {
    Name = "${var.project_name}-private-route-table"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dailyge_nat.id
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each = aws_subnet.dailyge_private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.dailyge_private_route_table.id
}
