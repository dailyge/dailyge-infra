resource "aws_s3_bucket" "dailyge_client_bucket" {
  bucket = "dailyge-client"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_object" "main_folder" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id
  key    = "main/"
  etag   = filemd5("/dev/null")

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_object" "main_prod_folder" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id
  key    = "main/prod/"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_object" "tasks_dev_folder" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id
  key    = "tasks/dev/"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_object" "tasks_prod_folder" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id
  key    = "tasks/prod/"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_website_configuration" "main_page_website" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_public_access_block" "main_page_public_access_block" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_policy" "main_page_bucket_policy" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Id        = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.dailyge_client_bucket.id}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" : var.cloudfront_distribution_arns
          }
        }
      }
    ]
  })

  lifecycle {
    ignore_changes = all
  }
}
