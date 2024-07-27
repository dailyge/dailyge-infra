resource "aws_secretsmanager_secret" "dailyge_secret_manager" {
  name        = "dailyge-secret-manager"
  description = "Dailyge secret manager."
}
