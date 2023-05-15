provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_iam_role" "lambda_role" {
  name = "ExampleLambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "ExampleLambdaPolicy"
  description = "Policy for Lambda function"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:us-east-1:123456789012:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:us-east-1:123456789012:log-group:/aws/lambda/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": "arn:aws:kms:us-east-1:123456789012:key/<kms-key-id>"  # Replace with your desired KMS key ARN for environment variable encryption
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = "ExampleLambdaFunction"
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  memory_size      = 128
  timeout          = 10
  role             = aws_iam_role.lambda_role.arn
  publish          = true
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      MY_SECRET_KEY = "example-secret-value"
    }
    # Enable environment variable encryption
    # Requires KMS key permissions as defined in the lambda_policy
    encryption_config {
      kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/<kms-key-id>"  # Replace with your desired KMS key ARN
    }
  }

  # Add the Lambda function code ZIP file or S3 bucket ARN as appropriate
  # source_code_hash = filebase64sha256("lambda_function.zip")
  # filename         = "s3://my-bucket/lambda_function.zip"
}
