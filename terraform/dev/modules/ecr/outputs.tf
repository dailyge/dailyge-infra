output "dailyge_api_dev_arn" {
  value       = aws_ecr_repository.dailyge_api_dev.arn
  description = "Dailyge Dev Repository ARN."
}

output "dailyge_api_prod_arn" {
  value       = aws_ecr_repository.dailyge_api_prod.arn
  description = "Dailyge Prod Repository ARN."
}

output "dailyge_api_dev_url" {
  value = aws_ecr_repository.dailyge_api_dev.repository_url
}

output "dailyge_api_prod_url" {
  value = aws_ecr_repository.dailyge_api_prod.repository_url
}
