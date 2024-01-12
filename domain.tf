resource "aws_route53_zone" "myzone" {
  name = var.domain_zone
}

# setup the records for the cloudfront distribution
resource "aws_route53_record" "myappv4" {
  zone_id = aws_route53_zone.myzone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.myapp.domain_name
    zone_id = aws_cloudfront_distribution.myapp.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "myappv6" {
  zone_id = aws_route53_zone.myzone.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name = aws_cloudfront_distribution.myapp.domain_name
    zone_id = aws_cloudfront_distribution.myapp.hosted_zone_id
    evaluate_target_health = false
  }
}

# create all domain validation records for the ssl certifcate validation
resource "aws_route53_record" "cert_validation" {
  name = tolist(aws_acm_certificate.mycert.domain_validation_options)[0].resource_record_name
  records = [ tolist(aws_acm_certificate.mycert.domain_validation_options)[0].resource_record_value ]
  type = tolist(aws_acm_certificate.mycert.domain_validation_options)[0].resource_record_type

  zone_id = aws_route53_zone.myzone.id
  allow_overwrite = true
  ttl = 60
}
