resource "aws_s3_bucket" "first-s3" {
  bucket = var.first_bucket_name
  tags = {
    Name = var.first_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "first-s3-block" {
  bucket = aws_s3_bucket.first-s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "second-s3" {
  bucket = var.second_bucket_name
  tags = {
    Name = var.second_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "second-s3-block" {
  bucket = aws_s3_bucket.second-s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.first-s3.id
  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}