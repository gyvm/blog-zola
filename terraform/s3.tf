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

resource "aws_s3_bucket_policy" "blog_zola_bucket_policy" {
  bucket = aws_s3_bucket.blog_zola_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.blog_zola_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "aws:UserAgent": "CloudFront"
          }
        }
      }
    ]
  })
}
