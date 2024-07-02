output "vpc_id" {
  value = aws_vpc.dailyge_vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.dailyge_public_subnets : subnet.id]
}

output "dailyge_api_private_subnet_ids" {
  value = [for subnet_id, subnet in aws_subnet.dailyge_private_subnets : subnet.id]
}

output "redis_subnet_id" {
  value = aws_subnet.dailyge_redis_subnet.id
}

output "rds_subnet_ids" {
  value = [for subnet in aws_subnet.dailyge_rds_subnet : subnet.id]
}
