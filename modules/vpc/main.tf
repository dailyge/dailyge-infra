locals {
  config = jsondecode(file("terraform.tfvars.json"))
}

resource "aws_vpc" "dailyge_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.name}-vpc",
    Environment = var.tags["Environment"]
  }
}

resource "aws_internet_gateway" "dailyge_igw" {
  vpc_id = aws_vpc.dailyge_vpc.id
  tags = {
    Name        = "${var.name}-igw",
    Environment = var.tags["Environment"]
  }
}

resource "aws_subnet" "dailyge_public_subnet" {
  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = var.public_subnet.cidr
  availability_zone       = var.public_subnet.zone
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.name}-public-subnet",
    Environment = var.tags["Environment"]
  }
}

resource "aws_subnet" "dailyge_private_subnets" {
  for_each = var.private_subnets
  vpc_id                  = aws_vpc.dailyge_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.zone
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.name}-private-${each.key}",
    Environment = var.tags["Environment"]
  }
}

resource "aws_route_table" "dailyge_public_route_table" {
  vpc_id = aws_vpc.dailyge_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dailyge_igw.id
  }
  tags = {
    Name        = "${var.name}-public-route-table",
    Environment = var.tags["Environment"]
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.dailyge_public_subnet.id
  route_table_id = aws_route_table.dailyge_public_route_table.id
}

resource "aws_eip" "dailyge_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.name}-eip",
    Environment = var.tags["Environment"]
  }
}

resource "aws_nat_gateway" "dailyge_nat" {
  allocation_id = aws_eip.dailyge_eip.id
  subnet_id     = aws_subnet.dailyge_public_subnet.id
  tags = {
    Name        = "${var.name}-nat",
    Environment = var.tags["Environment"]
  }
}

resource "aws_route_table" "dailyge_private_route_table" {
  vpc_id = aws_vpc.dailyge_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dailyge_nat.id
  }
  tags = {
    Name        = "${var.name}-private-route-table",
    Environment = var.tags["Environment"]
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each = aws_subnet.dailyge_private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.dailyge_private_route_table.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.dailyge_nat.id
}
