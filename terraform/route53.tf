resource "aws_route53_zone" "gyvm_xyz" {
  name = "gyvm.xyz"
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
