provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name"  # Replace with your desired bucket name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = "example-logging-bucket"  # Replace with the bucket where you want to store logs
    target_prefix = "logs/"
  }

  lifecycle {
    rule {
      id      = "incomplete-multipart-upload"
      status  = "Enabled"

      abort_incomplete_multipart_upload {
        days_after_initiation = 7  # Modify the number of days as per your requirements
      }
    }
  }

  bucket_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSSLRequestsOnly",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::example-bucket-name/*",
        "arn:aws:s3:::example-bucket-name"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
EOF

  tags = {
    Name        = "Example Bucket"
    Environment = "Production"
  }
}
