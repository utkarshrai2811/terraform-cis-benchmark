provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_security_group" "ec2_security_group" {
  name        = "EC2SecurityGroup"
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Add more ingress and egress rules as per your requirements to restrict traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_flow_log" "vpc_flow_log" {
  name           = "VPCFlowLog"
  traffic_type   = "ALL"
  log_destination = "arn:aws:logs:<region>:<account-id>:log-group:/aws/vpc/flow-log:<flow-log-id>"

  vpc_id = "<vpc-id>"  # Replace with your VPC ID
}

resource "aws_config_config_rule" "config_rule" {
  name        = "ConfigRule"
  description = "Enable AWS Config"
  source_identifier = "S3_BUCKET_VERSIONING_ENABLED"

  input_parameters = <<EOF
{
  "bucketName": "example-bucket"
}
EOF
}

resource "aws_cloudtrail" "cloudtrail" {
  name                      = "CloudTrail"
  s3_bucket_name            = "example-bucket"  # Replace with your S3 bucket name
  include_global_service_events = true
  is_multi_region_trail     = true
}

resource "aws_guardduty_detector" "guardduty" {
  enable = true
}
