resource "aws_route53_zone" "dailyge_route53" {
  name = var.domain
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.dailyge_route53.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_route53_record" "dailyge_client_record" {
  zone_id = aws_route53_zone.dailyge_route53.zone_id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = data.aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = data.aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "ns_records" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.dailyge_route53.zone_id
  name            = "dailyge.com"
  type            = "NS"
  ttl             = 300
  records         = var.ns_records
}

data "aws_cloudfront_distribution" "s3_distribution" {
  id = var.cloudfront_distribution_id
}
