output "route53_zone_id" {
  value       = aws_route53_zone.dailyge_route53.zone_id
  description = "The ID of the Route 53 hosted zone."
}

output "custom_ns_records" {
  value       = var.ns_records
  description = "Custom NS records provided for documentation purposes."
}
