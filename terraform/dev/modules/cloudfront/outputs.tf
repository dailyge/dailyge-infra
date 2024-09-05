output "oac_id" {
  value = aws_cloudfront_origin_access_control.oac.id
}

output "main_prod_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution_main_prod.id
}

output "main_prod_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution_main_prod.arn
}

output "main_prod_cloudfront_distribution_arn" {
  value     = aws_cloudfront_distribution.s3_distribution_main_prod.arn
  sensitive = true
}

output "main_prod_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution_main_prod.domain_name
}

output "tasks_prod_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution_tasks_prod.id
}

output "tasks_prod_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution_tasks_prod.arn
}

output "tasks_prod_cloudfront_distribution_arn" {
  value     = aws_cloudfront_distribution.s3_distribution_tasks_prod.arn
  sensitive = true
}

output "tasks_prod_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution_tasks_prod.domain_name
}

output "tasks_dev_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution_tasks_dev.id
}

output "tasks_dev_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution_tasks_dev.arn
}

output "tasks_dev_cloudfront_distribution_arn" {
  value     = aws_cloudfront_distribution.s3_distribution_tasks_dev.arn
  sensitive = true
}

output "tasks_dev_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution_tasks_dev.domain_name
}
