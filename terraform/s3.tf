resource "aws_s3_bucket" "blog_zola_bucket" {
  bucket = "blog_zola_bucket"

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
