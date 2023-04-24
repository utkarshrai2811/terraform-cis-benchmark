resource "aws_config_configuration_recorder" "example" {
  name     = "example"
  role_arn = aws_iam_role.example.arn

  recording_group {
    all_supported = true
  }
}

resource "aws_config_delivery_channel" "example" {
  name           = "example"
  s3_bucket_name = aws_s3_bucket.config.arn

  depends_on = [aws_config_configuration_recorder.example]
}

resource "aws_s3_bucket" "config" {
  bucket = "example-config-bucket"
}

resource "aws_iam_role" "example" {
  name = "example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "example" {
  name   = "example"
  role   = aws_iam_role.example.id
  policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.config.arn}/*"]
  }
  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.config.arn]
  }
}