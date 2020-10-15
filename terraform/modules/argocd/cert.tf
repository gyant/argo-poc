data "aws_route53_zone" "zone" {
  name         = var.route53_zone
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.cert_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  domain_validation_options = element(tolist(aws_acm_certificate.cert.domain_validation_options[*]), 0)
}

resource "aws_route53_record" "cert_validation" {
  name    = local.domain_validation_options.resource_record_name
  type    = local.domain_validation_options.resource_record_type
  zone_id = data.aws_route53_zone.zone.zone_id
  records = [local.domain_validation_options.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
