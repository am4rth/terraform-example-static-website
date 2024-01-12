
resource "aws_acm_certificate" "mycert" {
  domain_name = var.domain_name

  validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }

  provider = aws.global
}

resource "aws_acm_certificate_validation" "mycert-validation" {
  certificate_arn = aws_acm_certificate.mycert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
  provider = aws.global
}
