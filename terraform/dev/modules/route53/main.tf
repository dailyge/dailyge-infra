resource "aws_route53_zone" "dailyge_route53" {
  name = var.domain
}

resource "aws_route53_record" "acm_cert_validation" {
  zone_id = aws_route53_zone.dailyge_route53.zone_id
  name    = var.acm_cert_name
  type    = "CNAME"
  records = var.acm_cert_records
  ttl     = 60
}

resource "aws_route53_record" "ns_records" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.dailyge_route53.zone_id
  name            = "dailyge.com"
  type            = "NS"
  ttl             = 300
  records         = var.ns_records
}

resource "aws_route53_record" "api_docs" {
  zone_id = aws_route53_zone.dailyge_route53.zone_id
  name    = "api-docs.dailyge.com"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.host_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dailyge_client_alias" {
  zone_id = aws_route53_zone.dailyge_route53.zone_id
  name    = "www.dailyge.com"
  type    = "A"

  alias {
    name                   = data.aws_cloudfront_distribution.s3_distribution.domain_name
    evaluate_target_health = false
    zone_id                = data.aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  }
}

resource "aws_route53_record" "root_dailyge_client_alias" {
  zone_id = aws_route53_zone.dailyge_route53.zone_id
  name    = "dailyge.com"
  type    = "A"

  alias {
    name                   = data.aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = data.aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_cloudfront_distribution" "s3_distribution" {
  id = var.cloudfront_distribution_id
}
