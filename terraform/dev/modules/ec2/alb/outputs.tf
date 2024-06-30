output "alb_security_group_id" {
  value       = aws_security_group.alb_sg.id
  description = "ALB Security Group Id."
}

output "alb_dns_name" {
  value = aws_lb.dailyge_alb.dns_name
}

output "listener_arn_8080" {
  value = aws_lb_listener.dailyge_alb_listener_8080.arn
}

output "target_group_arn_8080" {
  value = aws_lb_target_group.dailyge_alb_target_group_8080.arn
}

output "listener_arn_8081" {
  value = aws_lb_listener.dailyge_alb_listener_8081.arn
}

output "target_group_arn_8081" {
  value = aws_lb_target_group.dailyge_alb_target_group_8081.arn
}
