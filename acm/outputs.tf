output "arn" {
  value = aws_acm_certificate.cert.arn
}

output "validation_data" {
  value = aws_acm_certificate.cert.domain_validation_options
}