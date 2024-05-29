resource "aws_acm_certificate" "gyvm" {
  provider          = aws.virginia
  domain_name       = "gyvm.xyz"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "blog" {
  provider          = aws.virginia
  domain_name       = "blog.gyvm.xyz"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "gyvm_validation" {
  name    = tolist(aws_acm_certificate.gyvm.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.gyvm.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.gyvm.zone_id
  records = [tolist(aws_acm_certificate.gyvm.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "blog_validation" {
  name    = tolist(aws_acm_certificate.blog.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.blog.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.gyvm.zone_id
  records = [tolist(aws_acm_certificate.blog.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "gyvm" {
  provider          = aws.virginia
  certificate_arn         = aws_acm_certificate.gyvm.arn
  validation_record_fqdns = [aws_route53_record.gyvm_validation.fqdn]
}

resource "aws_acm_certificate_validation" "blog" {
  provider          = aws.virginia
  certificate_arn         = aws_acm_certificate.blog.arn
  validation_record_fqdns = [aws_route53_record.blog_validation.fqdn]
}
