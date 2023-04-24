resource "aws_s3_bucket" "example" {
    bucket = "example-bucket"

    versioning {
        status = "Enabled"
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                see_algorithm = "aws:kms"
            }
        }
    }

    lifecycle_configuration {
        rule {
            status = "Enabled"

            abort_incomplete_multipart_upload_days = 7
        }
    }
}

resource "aws_s3_bucket_public_access_block" "example" {
    bucket = aws_s3_bucket.example.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}