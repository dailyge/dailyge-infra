output "oac_id" {
  value = aws_cloudfront_origin_access_control.oac.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "cloudfront_distribution_arn" {
  value     = aws_cloudfront_distribution.s3_distribution.arn
  sensitive = true
}
