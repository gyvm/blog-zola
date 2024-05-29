resource "aws_acm_certificate" "gyvm_xyz" {
  provider        = aws.virginia
  domain_name       = "gyvm.xyz"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "blog_cert" {
  provider        = aws.virginia
  domain_name       = "blog.gyvm.xyz"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "gyvm_xyz" {
  certificate_arn         = aws_acm_certificate.gyvm_xyz.arn
  validation_record_fqdns = [for record in aws_route53_record.gyvm_xyz_validation : record.fqdn]
}

resource "aws_acm_certificate_validation" "blog_cert_validation" {
  certificate_arn         = aws_acm_certificate.blog_cert.arn
  validation_record_fqdns = [tolist(aws_acm_certificate.blog_cert.domain_validation_options)[0].resource_record_name]
}
