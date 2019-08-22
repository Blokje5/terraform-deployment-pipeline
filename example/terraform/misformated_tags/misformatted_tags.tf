resource "aws_s3_bucket" "profile_picture_storage" {
  bucket_prefix = "profile-picture-storage"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Owner           = "userEngagement"
    Project         = "ProfileUploadService"
    ApplicationRole = "FileStorage"
  }
}

resource "aws_s3_bucket_public_access_block" "profile_picture_storage_access_rules" {
  bucket = aws_s3_bucket.profile_picture_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}