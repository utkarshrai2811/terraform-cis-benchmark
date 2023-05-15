provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Enable AWS Config in all regions
data "aws_regions" "all" {}

resource "aws_config_configuration_recorder" "configuration_recorder" {
  name     = "ExampleConfigRecorder"
  role_arn = "arn:aws:iam::123456789012:role/AWSConfigRole"  # Replace with your desired AWS Config IAM role ARN

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "delivery_channel" {
  name         = "ExampleDeliveryChannel"
  s3_bucket_name = "example-config-bucket"  # Replace with your desired S3 bucket name
  sns_topic_arn  = "arn:aws:sns:us-east-1:123456789012:ConfigTopic"  # Replace with your desired SNS topic ARN
}

# Enable AWS Config in all regions
resource "aws_config_recorder_status" "config_recorder_status" {
  count          = length(data.aws_regions.all.names)
  name           = "ExampleConfigRecorderStatus-${data.aws_regions.all.names[count.index]}"
  is_enabled     = true
  recorder_name  = aws_config_configuration_recorder.configuration_recorder.name
  region         = data.aws_regions.all.names[count.index]
}

# Enable AWS Config rules to enforce compliance
resource "aws_config_rule" "compliance_rule1" {
  name        = "ExampleComplianceRule1"
  description = "Example compliance rule 1"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }
}

resource "aws_config_rule" "compliance_rule2" {
  name        = "ExampleComplianceRule2"
  description = "Example compliance rule 2"
  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
}
