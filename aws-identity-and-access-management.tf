resource "aws_iam_user" "example" {
  name = "example-user"
}

resource "aws_iam_group" "example" {
  name = "example-group"
}

resource "aws_iam_group_policy" "example" {
  name  = "example-policy"
  group = aws_iam_group.example.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.example.arn,
          "${aws_s3_bucket.example.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_group_membership" "example" {
  user  = aws_iam_user.example.name
  group = aws_iam_group.example.name
}

resource "aws_iam_account_password_policy" "example" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 5
}