locals {
  s3_origin_id = "zolaBlogPrd"
}

resource "aws_cloudfront_origin_access_control" "blog_zola_cf_oac" {
  name                              = "blog_zola_cf_oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "CachingDisabled" {
  name = "Managed-CachingDisabled"
}

resource "aws_cloudfront_distribution" "blog_zola_distribution" {
  origin {
    domain_name              = aws_s3_bucket.blog_zola_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.blog_zola_cf_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["blog.gyvm.xyz"]

  default_cache_behavior {
    cache_policy_id = data.aws_cloudfront_cache_policy.CachingDisabled.id
    viewer_protocol_policy = "allow-all"
    
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
