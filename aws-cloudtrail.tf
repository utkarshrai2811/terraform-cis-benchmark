resource "aws_s3_bucket" "cloudtrail" {
  bucket = "example-cloudtrail-bucket"
}

resource "aws_cloudtrail" "example" {
  name           = "example-trail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type = "All"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetBucketAcl"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.cloudtrail.arn
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}