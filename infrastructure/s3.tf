resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatarsadry" #

  tags = {
    Name        = "grocerymate-avatars"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.avatars.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "avatars_block" {
  bucket = aws_s3_bucket.avatars.id

  block_public_acls       = true #bucket privado
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


