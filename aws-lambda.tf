resource "aws_lambda_function" "example" {
  function_name = "example"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  role = aws_iam_role.lambda_example.arn

  filename = "lambda_function_payload.zip"

  environment {
    variables = {
      ENCRYPTED_VARIABLE = "AQICAHh..."
    }
  }
}

resource "aws_iam_role" "lambda_example" {
  name = "example"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_example" {
  name   = "example"
  role   = aws_iam_role.lambda_example.id
  policy = data.aws_iam_policy_document.lambda_example.json
}

data "aws_iam_policy_document" "lambda_example" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}