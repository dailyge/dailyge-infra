output "alb_security_group_ids" {
  value = aws_security_group.alb_security_group.id
}

output "ecs_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis_security_group.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_security_group.id
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion_security_group.id
}
