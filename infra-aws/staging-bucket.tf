resource "aws_s3_bucket" "staging_bucket" {
  bucket = var.staging_bucket_name

  tags = {
    Project     = var.project_prefix
    Environment = var.environment
  }

  depends_on = [aws_s3_bucket.tf_state]
}

resource "aws_s3_bucket_public_access_block" "staging_block" {
  bucket = aws_s3_bucket.staging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "staging_versioning" {
  bucket = aws_s3_bucket.staging_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
