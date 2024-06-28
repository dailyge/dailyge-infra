resource "aws_ecr_repository" "dailyge_api_dev" {
  name = "dailyge-api-dev"
  tags = {
    Environment = "Dev",
    Module      = "Dailyge-Api"
  }
}

resource "aws_ecr_repository" "dailyge_api_prod" {
  name = "dailyge-api-prod"
  tags = {
    Environment = "Prod",
    Module      = "Dailyge-Api"
  }
}

resource "aws_ecr_lifecycle_policy" "dailyge_dev_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.dailyge_api_dev.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep 5 images."
        selection    = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "dailyge_prod_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.dailyge_api_prod.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep 5 images."
        selection    = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
