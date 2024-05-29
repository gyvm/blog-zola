resource "aws_s3_bucket" "blog_zola_bucket" {
  bucket = "blog-zola-bucket"

  tags = {
    Environment = "production"
  }
}

resource "aws_s3_bucket_ownership_controls" "blog_zola_bucket_oc" {
  bucket = aws_s3_bucket.blog_zola_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "blog_zola_bucket" {
  bucket = aws_s3_bucket.blog_zola_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "blog_zola_bucket_policy" {
  statement {
    sid = "AllowCloudFrontServicePrincipal"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.blog_zola_bucket.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.blog_zola_distribution.arn,
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "blog_zola_bucket" {
  bucket = aws_s3_bucket.blog_zola_bucket.id
  policy = data.aws_iam_policy_document.blog_zola_bucket_policy.json

  depends_on = [aws_cloudfront_distribution.blog_zola_distribution]
}
