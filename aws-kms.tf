resource "aws_kms_key" "example" {
  description = "Example KMS key"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:*"
        ]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}

resource "aws_kms_alias" "example" {
  name          = "alias/example"
  target_key_id = aws_kms_key.example.id
}

resource "aws_kms_key_rotation" "example" {
  key_id = aws_kms_key.example.id
  rotation_enabled = true
}