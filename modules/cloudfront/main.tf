resource "aws_cloudfront_distribution" "shomotsu_development_distribution" {
  enabled = var.enabled
  
  origin {
    origin_id = var.origin_id
    domain_name = var.domain_name
    origin_access_control_id = var.origin_access_control_id
  }

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id = var.target_origin_id

    forwarded_values {
      query_string = var.forwarded_values_query_string
      cookies {
        forward = var.forwarded_values_cookies_forward
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl = var.min_ttl
    default_ttl = var.default_ttl
    max_ttl = var.max_ttl
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
    }
  }

  aliases = ["${data.aws_acm_certificate.s3_acm.domain}"]

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
    acm_certificate_arn = data.aws_acm_certificate.s3_acm.arn
    ssl_support_method = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
  }

  tags = var.tags
}