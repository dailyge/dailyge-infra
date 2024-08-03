output "alb_host_zone" {
  value = aws_lb.dailyge_alb.zone_id
}

output "alb_dns_name" {
  value = aws_lb.dailyge_alb.dns_name
}

output "target_group_arn_8080" {
  value = aws_lb_target_group.dailyge_alb_target_group_8080.arn
}

output "target_group_arn_8081" {
  value = aws_lb_target_group.dailyge_alb_target_group_8081.arn
}

output "target_group_arn_https" {
  value = aws_lb_target_group.dailyge_alb_target_group_443.arn
}
