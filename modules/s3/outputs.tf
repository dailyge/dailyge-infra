output "bucket_id" {
  value = aws_s3_bucket.dailyge_client_bucket.id
}

output "bucket_name" {
  value = aws_s3_bucket.dailyge_client_bucket.bucket
}

output "domain_name" {
  value = aws_s3_bucket.dailyge_client_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.dailyge_client_bucket.bucket_regional_domain_name
}
