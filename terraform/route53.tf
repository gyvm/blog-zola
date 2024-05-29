resource "aws_route53_zone" "gyvm_xyz" {
  name = "gyvm.xyz"
}

resource "aws_route53_record" "gyvm_xyz_validation" {
  for_each = {
    for dvo in aws_acm_certificate.gyvm_xyz.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.gyvm_xyz.zone_id
}

resource "aws_route53_record" "blog_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.blog_cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.gyvm_xyz.zone_id
}

resource "aws_route53_record" "blog_alias" {
  zone_id = aws_route53_zone.gyvm_xyz.zone_id
  name    = "blog"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.blog_zola_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.blog_zola_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
