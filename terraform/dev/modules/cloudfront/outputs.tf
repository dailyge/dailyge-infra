output "oac_id" {
  value = aws_cloudfront_origin_access_control.oac.id
}
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "cloudfront_distribution_arn" {
  value     = aws_cloudfront_distribution.s3_distribution.arn
  sensitive = true
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
