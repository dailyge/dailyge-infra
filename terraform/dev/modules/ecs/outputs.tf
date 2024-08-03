output "ecs_cluster_id" {
  value = aws_ecs_cluster.dailyge_ecs_cluster.id
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.id
}

output "asg_target_group_arc" {
  value = aws_autoscaling_group.ecs_asg.arn
}
