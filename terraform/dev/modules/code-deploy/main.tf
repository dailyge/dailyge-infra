resource "aws_codedeploy_app" "dailyge_code_deploy" {
  name = var.application_name
}

resource "aws_iam_role" "dailyge_code_deploy_role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "dailyge_code_deploy_policy" {
  name = "CodeDeployPolicy"
  role = aws_iam_role.dailyge_code_deploy_role.id

  policy = file("${path.module}/codedeploy_policy.json")
}

resource "aws_codedeploy_deployment_group" "dailyge_code_deploy_group" {
  app_name              = aws_codedeploy_app.dailyge_code_deploy.name
  deployment_group_name = "dailyge-deployment-group"
  service_role_arn      = aws_iam_role.dailyge_code_deploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_REQUEST"]
  }

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
}
