resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain
  subject_alternative_names = coalescelist(var.alt_names, ["*.${var.domain}"])
  validation_method         = var.validation_method
  tags                      = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation_route" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.validation_hz_id
}

resource "aws_acm_certificate_validation" "dns_validation" {
  count                   = var.validation_method == "DNS" ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_route : record.fqdn]
}

resource "aws_acm_certificate_validation" "email_validation" {
  count           = var.validation_method == "EMAIL" ? 1 : 0
  certificate_arn = aws_acm_certificate.cert.arn
}
