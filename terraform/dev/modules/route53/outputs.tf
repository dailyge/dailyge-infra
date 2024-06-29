output "route53_zone_id" {
  value       = aws_route53_zone.dailyge_route53.zone_id
  description = "The ID of the Route 53 hosted zone."
}

output "dns_record_name" {
  value       = aws_route53_record.dailyge_client_record.name
  description = "The DNS record name for the website."
}
