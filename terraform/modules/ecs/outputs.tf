output "ecs_cluster_id" {
  value = aws_ecs_cluster.dailyge_ecs_cluster.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.id
}
