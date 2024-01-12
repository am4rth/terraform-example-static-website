
# init cloudfront distribution
resource "aws_cloudfront_distribution" "myapp" {
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"

  origin {
    origin_id = "tasko-blog-default"
    domain_name = aws_s3_bucket_website_configuration.www_bucket.website_endpoint
    
    # using the s3 website endpoint requires us to setup a custom origin
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "tasko-blog-default"

    # don't forware query strings and cookies 
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    
    # configure this to enable content caching
    min_ttl = 0 
    default_ttl = 0
    max_ttl = 0

    compress = true # set to false to disable compression
  }

  # dont restict access based on the client location
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # our custom domain name
  aliases = ["${var.domain_name}"]

  # reference our ssl certificate
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.mycert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  depends_on = [aws_acm_certificate.mycert, aws_route53_zone.myzone]
}