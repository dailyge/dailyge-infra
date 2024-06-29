output "vpc_id" {
  value = aws_vpc.dailyge_vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.dailyge_public_subnets : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet_id, subnet in aws_subnet.dailyge_private_subnets : subnet.id]
}
