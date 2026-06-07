resource "aws_s3_bucket" "media" {
  bucket = "fitness-app-media-jamalv-2026"
}

resource "aws_s3_bucket_cors_configuration" "media_cors" {
  bucket = aws_s3_bucket.media.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["http://localhost:5173"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}