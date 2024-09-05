resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC-${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  description                       = "Origin Access Control for ${var.bucket_name}"

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_cloudfront_cache_policy" "dailyge_cloudfront_cache_policy" {
  name        = "Dailyge-cache-policy"
  comment     = "Dailyge cache policy"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_cloudfront_origin_request_policy" "dailyge_cloudfront_origin_request_policy" {
  name    = "dailyge-request-policy"
  comment = "Dailyge origin request policy"
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "none"
  }
  query_strings_config {
    query_string_behavior = "none"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_cloudfront_distribution" "s3_distribution_main_prod" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  aliases             = ["www.dailyge.com"]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "CloudFront distribution for main prod."

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

  default_cache_behavior {
    compress                 = true
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "S3-${var.bucket_id}"
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
  }

  ordered_cache_behavior {
    path_pattern             = "main/prod/*"
    target_origin_id         = "S3-${var.bucket_id}"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    default_ttl              = 3600
    max_ttl                  = 86400
    min_ttl                  = 0
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/main/prod/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFront Distribution for main prod."
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_cloudfront_distribution" "s3_distribution_main_dev" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  aliases             = ["dev.dailyge.com"]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "CloudFront distribution for main dev."

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

  default_cache_behavior {
    compress                 = true
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "S3-${var.bucket_id}"
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
  }

  ordered_cache_behavior {
    path_pattern             = "main/dev/*"
    target_origin_id         = "S3-${var.bucket_id}"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    default_ttl              = 3600
    max_ttl                  = 86400
    min_ttl                  = 0
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/main/dev/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFront Distribution for main dev."
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_cloudfront_distribution" "s3_distribution_tasks_prod" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  aliases             = ["tasks.dailyge.com"]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "CloudFront distribution for tasks prod."

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

  default_cache_behavior {
    compress                 = true
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "S3-${var.bucket_id}"
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
  }

  ordered_cache_behavior {
    path_pattern             = "tasks/prod/*"
    target_origin_id         = "S3-${var.bucket_id}"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    default_ttl              = 3600
    max_ttl                  = 86400
    min_ttl                  = 0
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/tasks/dev/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFront Distribution for tasks prod."
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_cloudfront_distribution" "s3_distribution_tasks_dev" {
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  aliases             = ["tasks-dev.dailyge.com"]
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "CloudFront distribution for tasks dev."

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2019"
  }

  default_cache_behavior {
    compress                 = true
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "S3-${var.bucket_id}"
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
  }

  ordered_cache_behavior {
    path_pattern             = "tasks/dev/*"
    target_origin_id         = "S3-${var.bucket_id}"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    default_ttl              = 3600
    max_ttl                  = 86400
    min_ttl                  = 0
    cache_policy_id          = aws_cloudfront_cache_policy.dailyge_cloudfront_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.dailyge_cloudfront_origin_request_policy.id
  }

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 200
    response_page_path    = "/tasks/dev/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFront Distribution for tasks dev."
  }

  lifecycle {
    ignore_changes = all
  }
}
