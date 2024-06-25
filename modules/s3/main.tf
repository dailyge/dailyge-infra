resource "aws_s3_bucket" "dailyge_client_bucket" {
  bucket = "dailyge-client"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.dailyge_client_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy" {
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
            "AWS:SourceArn" : var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}
