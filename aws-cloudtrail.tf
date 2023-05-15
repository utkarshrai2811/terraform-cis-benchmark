provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "example-cloudtrail-bucket"  # Replace with your desired bucket name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "example-logging-bucket"  # Replace with the bucket where you want to store access logs for the CloudTrail bucket
    target_prefix = "cloudtrail-access-logs/"
  }
}

resource "aws_cloudtrail" "cloudtrail" {
  name                       = "ExampleCloudTrail"
  enable_logging             = true
  include_global_service_events = true
  is_multi_region_trail      = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "arn:aws:logs:<region>:<account-id>:log-group:/aws/cloudtrail"  # Replace with your desired CloudWatch Logs group ARN
  s3_bucket_name             = aws_s3_bucket.cloudtrail_bucket.id
}

# Enable CloudTrail in all regions
data "aws_regions" "all" {}

resource "aws_cloudtrail" "cloudtrail_all_regions" {
  count                      = length(data.aws_regions.all.names)
  name                       = "ExampleCloudTrail-${data.aws_regions.all.names[count.index]}"
  enable_logging             = true
  include_global_service_events = true
  is_multi_region_trail      = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "arn:aws:logs:<region>:<account-id>:log-group:/aws/cloudtrail"  # Replace with your desired CloudWatch Logs group ARN
  s3_bucket_name             = aws_s3_bucket.cloudtrail_bucket.id
  region                     = data.aws_regions.all.names[count.index]
}
